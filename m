Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3I1I30 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 04:29:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44504 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab3I1I3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 04:29:18 -0400
Date: Sat, 28 Sep 2013 01:28:54 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-646e29a1789a3a936871008c15199c50367bf291@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        huawei.libin@huawei.com, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        huawei.libin@huawei.com, tglx@linutronix.de, bp@suse.de
In-Reply-To: <20130927143554.GF4422@pd.tnic>
References: <20130927143554.GF4422@pd.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86:
  Improve the printout of the SMP bootup CPU table
Git-Commit-ID: 646e29a1789a3a936871008c15199c50367bf291
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 28 Sep 2013 01:29:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  646e29a1789a3a936871008c15199c50367bf291
Gitweb:     http://git.kernel.org/tip/646e29a1789a3a936871008c15199c50367bf291
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Fri, 27 Sep 2013 16:35:54 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 28 Sep 2013 10:10:26 +0200

x86: Improve the printout of the SMP bootup CPU table

As the new x86 CPU bootup printout format code maintainer, I am
taking immediate action to improve and clean (and thus indulge
my OCD) the reporting of the cores when coming up online.

Fix padding to a right-hand alignment, cleanup code and bind
reporting width to the max number of supported CPUs on the
system, like this:

 [    0.074509] smpboot: Booting Node   0, Processors:      #1  #2  #3  #4  #5  #6  #7 OK
 [    0.644008] smpboot: Booting Node   1, Processors:  #8  #9 #10 #11 #12 #13 #14 #15 OK
 [    1.245006] smpboot: Booting Node   2, Processors: #16 #17 #18 #19 #20 #21 #22 #23 OK
 [    1.864005] smpboot: Booting Node   3, Processors: #24 #25 #26 #27 #28 #29 #30 #31 OK
 [    2.489005] smpboot: Booting Node   4, Processors: #32 #33 #34 #35 #36 #37 #38 #39 OK
 [    3.093005] smpboot: Booting Node   5, Processors: #40 #41 #42 #43 #44 #45 #46 #47 OK
 [    3.698005] smpboot: Booting Node   6, Processors: #48 #49 #50 #51 #52 #53 #54 #55 OK
 [    4.304005] smpboot: Booting Node   7, Processors: #56 #57 #58 #59 #60 #61 #62 #63 OK
 [    4.961413] Brought up 64 CPUs

and this:

 [    0.072367] smpboot: Booting Node   0, Processors:    #1 #2 #3 #4 #5 #6 #7 OK
 [    0.686329] Brought up 8 CPUs

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Libin <huawei.libin@huawei.com>
Cc: wangyijing@huawei.com
Cc: fenghua.yu@intel.com
Cc: guohanjun@huawei.com
Cc: paul.gortmaker@windriver.com
Link: http://lkml.kernel.org/r/20130927143554.GF4422@pd.tnic
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/misc.h |  6 ++++++
 arch/x86/kernel/smpboot.c   | 21 +++++++++++++++------
 arch/x86/lib/Makefile       |  2 +-
 arch/x86/lib/misc.c         | 11 +++++++++++
 4 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/misc.h b/arch/x86/include/asm/misc.h
new file mode 100644
index 0000000..475f5bb
--- /dev/null
+++ b/arch/x86/include/asm/misc.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_X86_MISC_H
+#define _ASM_X86_MISC_H
+
+int num_digits(int val);
+
+#endif /* _ASM_X86_MISC_H */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6cacab6..d41f3ba 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -73,11 +73,10 @@
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
-
 #include <asm/smpboot_hooks.h>
 #include <asm/i8259.h>
-
 #include <asm/realmode.h>
+#include <asm/misc.h>
 
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
@@ -653,17 +652,27 @@ static void announce_cpu(int cpu, int apicid)
 {
 	static int current_node = -1;
 	int node = early_cpu_to_node(cpu);
-	int max_cpu_present = find_last_bit(cpumask_bits(cpu_present_mask), NR_CPUS);
+	static int width;
+
+	if (!width)
+		width = num_digits(num_possible_cpus()) + 1; /* + '#' sign */
 
 	if (system_state == SYSTEM_BOOTING) {
 		if (node != current_node) {
 			if (current_node > (-1))
 				pr_cont(" OK\n");
 			current_node = node;
-			pr_info("Booting Node %3d, Processors ", node);
+			pr_info("Booting Node %3d, Processors:", node);
 		}
-		pr_cont(" #%4d%s", cpu, cpu == max_cpu_present ? " OK\n" : "");
-		return;
+
+		/* Add padding for the BSP */
+		if (cpu == 1)
+			pr_cont("%*s", width + 1, " ");
+
+		pr_cont("%*s#%d", width - num_digits(cpu), " ", cpu);
+
+		if (cpu == num_present_cpus() - 1)
+			pr_cont(" OK\n");
 	} else
 		pr_info("Booting Node %d Processor %d APIC 0x%x\n",
 			node, cpu, apicid);
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 96b2c66..992d63b 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -16,7 +16,7 @@ clean-files := inat-tables.c
 
 obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 
-lib-y := delay.o
+lib-y := delay.o misc.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
diff --git a/arch/x86/lib/misc.c b/arch/x86/lib/misc.c
new file mode 100644
index 0000000..bc35cde
--- /dev/null
+++ b/arch/x86/lib/misc.c
@@ -0,0 +1,11 @@
+int num_digits(int val)
+{
+	int digits = 0;
+
+	while (val) {
+		val /= 10;
+		digits++;
+	}
+
+	return digits;
+}
