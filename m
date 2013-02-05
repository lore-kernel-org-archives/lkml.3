Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759Ab3BEWLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:11:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48105 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728Ab3BEWLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:11:15 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Cox <alan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 57/93] x86/msr: Add capabilities check
Date: Tue,  5 Feb 2013 20:06:46 -0200
Message-Id: <1360102042-10732-58-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/kernel/msr.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index eb11369..8563b64 100644
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
-- 
1.7.9.5

