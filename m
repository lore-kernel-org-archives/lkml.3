Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab3FXTiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:38:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:47295 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3FXTbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:31:31 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Richard Kuo <rkuo@codeaurora.org>, <linux-hexagon@vger.kernel.org>
Subject: [PATCH 18/32] hexagon: delete __cpuinit usage from all hexagon files
Date: Mon, 24 Jun 2013 15:30:23 -0400
Message-ID: <1372102237-8757-19-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

Note that some harmless section mismatch warnings may result, since
notify_cpu_starting() and cpu_up() are arch independent (kernel/cpu.c)
are flagged as __cpuinit  -- so if we remove the __cpuinit from
arch specific callers, we will also get section mismatch warnings.
As an intermediate step, we intend to turn the linux/init.h cpuinit
content into no-ops as early as possible, since that will get rid
of these warnings.  In any case, they are temporary and harmless.

This removes all the arch/hexagon uses of the __cpuinit macros from
all C files.  Currently hexagon does not have any __CPUINIT used in
assembly files.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-hexagon@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 arch/hexagon/kernel/setup.c | 2 +-
 arch/hexagon/kernel/smp.c   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/hexagon/kernel/setup.c b/arch/hexagon/kernel/setup.c
index bfe1331..29d1f1b 100644
--- a/arch/hexagon/kernel/setup.c
+++ b/arch/hexagon/kernel/setup.c
@@ -41,7 +41,7 @@ static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
 
 int on_simulator;
 
-void __cpuinit calibrate_delay(void)
+void calibrate_delay(void)
 {
 	loops_per_jiffy = thread_freq_mhz * 1000000 / HZ;
 }
diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
index 0e364ca..9faaa94 100644
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -146,7 +146,7 @@ void __init smp_prepare_boot_cpu(void)
  * to point to current thread info
  */
 
-void __cpuinit start_secondary(void)
+void start_secondary(void)
 {
 	unsigned int cpu;
 	unsigned long thread_ptr;
@@ -194,7 +194,7 @@ void __cpuinit start_secondary(void)
  * maintains control until "cpu_online(cpu)" is set.
  */
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
+int __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	struct thread_info *thread = (struct thread_info *)idle->stack;
 	void *stack_start;
-- 
1.8.1.2

