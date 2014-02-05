Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbaBEUpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:45:33 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48298 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871AbaBEUGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:20 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Alan Cox <alan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 109/213] x86/msr: Add capabilities check
Date: Wed, 5 Feb 2014 15:01:04 -0500
Message-ID: <1391630568-49251-110-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/msr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 4d4468e9f47c..56b77410a9fe 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -176,6 +176,9 @@ static int msr_open(struct inode *inode, struct file *file)
 	unsigned int cpu;
 	struct cpuinfo_x86 *c;
 
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
 	cpu = iminor(file->f_path.dentry->d_inode);
 	if (cpu >= nr_cpu_ids || !cpu_online(cpu))
 		return -ENXIO;	/* No such CPU */
-- 
1.8.5.2

