Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3I0Of7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:35:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40637 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab3I0Of6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:35:58 -0400
Date: Fri, 27 Sep 2013 16:35:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: [PATCH 2/2] x86: Cleanup boot CPUs table
Message-ID: <20130927143554.GF4422@pd.tnic>
References: <1378378676-18276-1-git-send-email-huawei.libin@huawei.com>
 <tip-52239484bf8aec031afa84ae08aa88224d819b93@git.kernel.org>
 <20130925100722.GB3433@nazgul.tnic>
 <20130925182936.GD16693@gmail.com>
 <20130926231545.GD10123@pd.tnic>
 <20130927065115.GA6852@gmail.com>
 <20130927103802.GA4422@pd.tnic>
 <20130927143249.GD4422@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130927143249.GD4422@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

As the new x86 CPU bootup printout format code maintainer, I am taking
immediate action to improve and clean (and thus indulge my OCD) the
reporting of the cores when coming up online.

Fix padding to a right-hand alignment, cleanup code and bind reporting
width to the max number of supported CPUs on the system, like this:

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

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Libin <huawei.libin@huawei.com>
Link: http://lkml.kernel.org/r/20130927065115.GA6852@gmail.com
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/misc.h |  6 ++++++
 arch/x86/kernel/smpboot.c   | 21 +++++++++++++++------
 arch/x86/lib/Makefile       |  2 +-
 arch/x86/lib/misc.c         | 11 +++++++++++
 4 files changed, 33 insertions(+), 7 deletions(-)
 create mode 100644 arch/x86/include/asm/misc.h
 create mode 100644 arch/x86/lib/misc.c

diff --git a/arch/x86/include/asm/misc.h b/arch/x86/include/asm/misc.h
new file mode 100644
index 000000000000..475f5bbc7f53
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
index 6cacab671f9b..d41f3ba26ced 100644
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
index 96b2c6697c9d..992d63bb154f 100644
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
index 000000000000..bc35cde9769f
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
-- 
1.8.4

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
