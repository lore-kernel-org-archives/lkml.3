Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3FDXTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:19:31 -0400
Received: from 1wt.eu ([62.212.114.60]:35318 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387Ab3FDWlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:41:50 -0400
Message-Id: <20130604172132.384099949@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Horses <stable@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Willy Tarreau <w@1wt.eu>
Subject: [ 050/184] x86/msr: Add capabilities check
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit c903f0456bc69176912dee6dd25c6a66ee1aed00 upstream

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
Cc: Horses <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[dannf: backported to Debian's 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kernel/msr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 5eaeb5e..63a053b 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -176,6 +176,9 @@ static int msr_open(struct inode *inode, struct file *file)
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	int ret = 0;
 
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
 	lock_kernel();
 	cpu = iminor(file->f_path.dentry->d_inode);
 
-- 
1.7.12.2.21.g234cd45.dirty



