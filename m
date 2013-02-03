Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3BCO6D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:58:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34523 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099Ab3BCO5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:55 -0500
Message-Id: <20130203144652.451455680@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:19 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alan Cox <alan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 095/128] x86/msr: Add capabilities check
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/msr.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index a7c5661..4929502 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -174,6 +174,9 @@ static int msr_open(struct inode *inode, struct file *file)
 	unsigned int cpu;
 	struct cpuinfo_x86 *c;
 
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
 	cpu = iminor(file->f_path.dentry->d_inode);
 	if (cpu >= nr_cpu_ids || !cpu_online(cpu))
 		return -ENXIO;	/* No such CPU */


