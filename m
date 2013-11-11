Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3KKRGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:06:14 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:50853 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3KKRGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:06:03 -0500
Date: Mon, 11 Nov 2013 18:05:58 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/boot changes for v3.13
Message-ID: <20131111170558.GA12741@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-boot-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-boot-for-linus

   # HEAD: a17bce4d1dce8f3cf714bc2e5d8e4bac009dc077 x86/boot: Further compress CPUs bootup message

Two changes that prettify and compactify the SMP bootup output from:

 [    0.371169] smpboot: Booting Node   0, Processors  #1 #2 #3 OK
 [    0.417339] smpboot: Booting Node   1, Processors  #4 #5 #6 #7 OK
 [    0.554805] smpboot: Booting Node   2, Processors  #8 #9 #10 #11 OK
 [    0.692323] smpboot: Booting Node   3, Processors  #12 #13 #14 #15 OK
 [    0.829039] Brought up 16 CPUs

to something like:

[    0.379167] x86: Booting SMP configuration:
[    0.383506] .... node  #0, CPUs:        #1  #2  #3
[    0.429207] .... node  #1, CPUs:    #4  #5  #6  #7
[    0.565353] .... node  #2, CPUs:    #8  #9 #10 #11
[    0.701898] .... node  #3, CPUs:   #12 #13 #14 #15
[    0.837695] x86: Booted up 4 nodes, 16 CPUs

  out-of-topic modifications in x86-boot-for-linus:
  ---------------------------------------------------
  kernel/smp.c                       # a17bce4: x86/boot: Further compress CPUs b

 Thanks,

	Ingo

------------------>
Borislav Petkov (2):
      x86: Improve the printout of the SMP bootup CPU table
      x86/boot: Further compress CPUs bootup message


 arch/x86/include/asm/misc.h |  6 ++++++
 arch/x86/kernel/smpboot.c   | 37 ++++++++++++++++++++++++++++++-------
 arch/x86/lib/Makefile       |  2 +-
 arch/x86/lib/misc.c         | 21 +++++++++++++++++++++
 kernel/smp.c                |  7 ++++++-
 5 files changed, 64 insertions(+), 9 deletions(-)
 create mode 100644 arch/x86/include/asm/misc.h
 create mode 100644 arch/x86/lib/misc.c

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
index 6cacab6..2a16558 100644
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
@@ -648,22 +647,46 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 	return (send_status | accept_status);
 }
 
+void smp_announce(void)
+{
+	int num_nodes = num_online_nodes();
+
+	printk(KERN_INFO "x86: Booted up %d node%s, %d CPUs\n",
+	       num_nodes, (num_nodes > 1 ? "s" : ""), num_online_cpus());
+}
+
 /* reduce the number of lines printed when booting a large cpu count system */
 static void announce_cpu(int cpu, int apicid)
 {
 	static int current_node = -1;
 	int node = early_cpu_to_node(cpu);
-	int max_cpu_present = find_last_bit(cpumask_bits(cpu_present_mask), NR_CPUS);
+	static int width, node_width;
+
+	if (!width)
+		width = num_digits(num_possible_cpus()) + 1; /* + '#' sign */
+
+	if (!node_width)
+		node_width = num_digits(num_possible_nodes()) + 1; /* + '#' */
+
+	if (cpu == 1)
+		printk(KERN_INFO "x86: Booting SMP configuration:\n");
 
 	if (system_state == SYSTEM_BOOTING) {
 		if (node != current_node) {
 			if (current_node > (-1))
-				pr_cont(" OK\n");
+				pr_cont("\n");
 			current_node = node;
-			pr_info("Booting Node %3d, Processors ", node);
+
+			printk(KERN_INFO ".... node %*s#%d, CPUs:  ",
+			       node_width - num_digits(node), " ", node);
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
index 0000000..76b373a
--- /dev/null
+++ b/arch/x86/lib/misc.c
@@ -0,0 +1,21 @@
+/*
+ * Count the digits of @val including a possible sign.
+ *
+ * (Typed on and submitted from hpa's mobile phone.)
+ */
+int num_digits(int val)
+{
+	int m = 10;
+	int d = 1;
+
+	if (val < 0) {
+		d++;
+		val = -val;
+	}
+
+	while (val >= m) {
+		m *= 10;
+		d++;
+	}
+	return d;
+}
diff --git a/kernel/smp.c b/kernel/smp.c
index 0564571..f5768b0 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -524,6 +524,11 @@ void __init setup_nr_cpu_ids(void)
 	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
 }
 
+void __weak smp_announce(void)
+{
+	printk(KERN_INFO "Brought up %d CPUs\n", num_online_cpus());
+}
+
 /* Called by boot processor to activate the rest. */
 void __init smp_init(void)
 {
@@ -540,7 +545,7 @@ void __init smp_init(void)
 	}
 
 	/* Any cleanup work */
-	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
+	smp_announce();
 	smp_cpus_done(setup_max_cpus);
 }
 
