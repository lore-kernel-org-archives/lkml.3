Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161015Ab3BANNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:13:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:45341 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1160996Ab3BANNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:13:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 61/89] x86/msr: Add capabilities check
Date: Fri,  1 Feb 2013 14:08:16 +0100
Message-Id: <20130201130211.878618007@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit c903f0456bc69176912dee6dd25c6a66ee1aed00 upstream.

At the moment the MSR driver only relies upon file system
checks. This means that anything as root with any capability set
can write to MSRs. Historically that wasn't very interesting but
on modern processors the MSRs are such that writing to them
provides several ways to execute arbitary code in kernel space.
Sample code and documentation on doing this is circulating and
MSR attacks are used on Windows 64bit rootkits already.

In the Linux case you still need to be able to open the device
file so the impact is fairly limited and reduces the security of
some capability and security model based systems down towards
that of a generic "root owns the box" setup.

Therefore they should require CAP_SYS_RAWIO to prevent an
elevation of capabilities. The impact of this is fairly minimal
on most setups because they don't have heavy use of
capabilities. Those using SELinux, SMACK or AppArmor rules might
want to consider if their rulesets on the MSR driver could be
tighter.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/msr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -174,6 +174,9 @@ static int msr_open(struct inode *inode,
 	unsigned int cpu;
 	struct cpuinfo_x86 *c;
 
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
 	cpu = iminor(file->f_path.dentry->d_inode);
 	if (cpu >= nr_cpu_ids || !cpu_online(cpu))
 		return -ENXIO;	/* No such CPU */


