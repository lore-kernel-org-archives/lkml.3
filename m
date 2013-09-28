Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3I1RsA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:48:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35581 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab3I1Rrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:47:55 -0400
Date: Sat, 28 Sep 2013 19:47:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: [PATCH] x86, boot: Further compress CPUs bootup message
Message-ID: <20130928174749.GE5956@pd.tnic>
References: <20130925100722.GB3433@nazgul.tnic>
 <20130925182936.GD16693@gmail.com>
 <20130926231545.GD10123@pd.tnic>
 <20130927065115.GA6852@gmail.com>
 <20130927103802.GA4422@pd.tnic>
 <20130927143249.GD4422@pd.tnic>
 <20130927143554.GF4422@pd.tnic>
 <20130928082542.GA18198@gmail.com>
 <20130928102305.GA5956@pd.tnic>
 <20130928134449.GB26931@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130928134449.GB26931@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Turn it into:

[    0.066391] x86: Booting SMP configuration:
[    0.067008] .... node #  0, CPUs:        #1  #2  #3  #4  #5  #6  #7
[    0.595005] .... node #  1, CPUs:    #8  #9 #10 #11 #12 #13 #14 #15
[    1.193005] .... node #  2, CPUs:   #16 #17 #18 #19 #20 #21 #22 #23
[    1.789010] .... node #  3, CPUs:   #24 #25 #26 #27 #28 #29 #30 #31
[    2.395005] .... node #  4, CPUs:   #32 #33 #34 #35 #36 #37 #38 #39
[    2.996005] .... node #  5, CPUs:   #40 #41 #42 #43 #44 #45 #46 #47
[    3.594005] .... node #  6, CPUs:   #48 #49 #50 #51 #52 #53 #54 #55
[    4.209005] .... node #  7, CPUs:   #56 #57 #58 #59 #60 #61 #62 #63
[    4.819594] x86: Booted up 8 nodes, 64 CPUs

and

[    0.065309] x86: Booting SMP configuration:
[    0.066007] .... node #  0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.590281] x86: Booted up 1 node, 8 CPUs

and drop useless elements.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/smpboot.c | 17 +++++++++++++----
 kernel/smp.c              |  7 ++++++-
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index d41f3ba26ced..a383b285ad1d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -647,6 +647,14 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 	return (send_status | accept_status);
 }
 
+void smp_announce(void)
+{
+	int num_nodes = num_online_nodes();
+
+	printk(KERN_INFO "x86: Booted up %d node%s, %ld CPUs\n",
+	       num_nodes, (num_nodes > 1 ? "s" : ""), (long)num_online_cpus());
+}
+
 /* reduce the number of lines printed when booting a large cpu count system */
 static void announce_cpu(int cpu, int apicid)
 {
@@ -657,12 +665,15 @@ static void announce_cpu(int cpu, int apicid)
 	if (!width)
 		width = num_digits(num_possible_cpus()) + 1; /* + '#' sign */
 
+	if (cpu == 1)
+		printk(KERN_INFO "x86: Booting SMP configuration:\n");
+
 	if (system_state == SYSTEM_BOOTING) {
 		if (node != current_node) {
 			if (current_node > (-1))
-				pr_cont(" OK\n");
+				pr_cont("\n");
 			current_node = node;
-			pr_info("Booting Node %3d, Processors:", node);
+			printk(KERN_INFO ".... node #%3d, CPUs:  ", node);
 		}
 
 		/* Add padding for the BSP */
@@ -671,8 +682,6 @@ static void announce_cpu(int cpu, int apicid)
 
 		pr_cont("%*s#%d", width - num_digits(cpu), " ", cpu);
 
-		if (cpu == num_present_cpus() - 1)
-			pr_cont(" OK\n");
 	} else
 		pr_info("Booting Node %d Processor %d APIC 0x%x\n",
 			node, cpu, apicid);
diff --git a/kernel/smp.c b/kernel/smp.c
index 0564571dcdf7..685f11781cbc 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -524,6 +524,11 @@ void __init setup_nr_cpu_ids(void)
 	nr_cpu_ids = find_last_bit(cpumask_bits(cpu_possible_mask),NR_CPUS) + 1;
 }
 
+void __weak smp_announce(void)
+{
+	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
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
 
-- 
1.8.4

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
