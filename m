Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3IZXQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 19:16:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40413 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588Ab3IZXQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 19:16:00 -0400
Date: Fri, 27 Sep 2013 01:15:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, huawei.libin@huawei.com,
        wangyijing@huawei.com, fenghua.yu@intel.com, tglx@linutronix.de,
        guohanjun@huawei.com, paul.gortmaker@windriver.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/smpboot: Fix announce_cpu() to printk() the
 last "OK" properly
Message-ID: <20130926231545.GD10123@pd.tnic>
References: <1378378676-18276-1-git-send-email-huawei.libin@huawei.com>
 <tip-52239484bf8aec031afa84ae08aa88224d819b93@git.kernel.org>
 <20130925100722.GB3433@nazgul.tnic>
 <20130925182936.GD16693@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130925182936.GD16693@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 08:29:36PM +0200, Ingo Molnar wrote:
> Indeed, that should be fixed.

Ok, how does a right alighment look like:

[    0.072399] smpboot: Booting Node   0, Processors   #1   #2   #3   #4   #5   #6   #7 OK
[    0.617005] smpboot: Booting Node   1, Processors   #8   #9  #10  #11  #12  #13  #14  #15 OK
[    1.230005] smpboot: Booting Node   2, Processors  #16  #17  #18  #19  #20  #21  #22  #23 OK
[    1.835005] smpboot: Booting Node   3, Processors  #24  #25  #26  #27  #28  #29  #30  #31 OK
[    2.437005] smpboot: Booting Node   4, Processors  #32  #33  #34  #35  #36  #37  #38  #39 OK
[    3.053005] smpboot: Booting Node   5, Processors  #40  #41  #42  #43  #44  #45  #46  #47 OK
[    3.657009] smpboot: Booting Node   6, Processors  #48  #49  #50  #51  #52  #53  #54  #55 OK
[    4.256005] smpboot: Booting Node   7, Processors  #56  #57  #58  #59  #60  #61  #62  #63 OK

?

With lockdep butting in-between it is still readable:

[    0.063330] SMP alternatives: lockdep: fixing up alternatives
[    0.064032] smpboot: Booting Node   0, Processors   #1
[    0.141231] SMP alternatives: lockdep: fixing up alternatives
[    0.142007]    #2
[    0.230210] SMP alternatives: lockdep: fixing up alternatives
[    0.231007]    #3
[    0.307237] SMP alternatives: lockdep: fixing up alternatives
[    0.308007]    #4
[    0.384231] SMP alternatives: lockdep: fixing up alternatives
[    0.385006]    #5
[    0.468237] SMP alternatives: lockdep: fixing up alternatives
[    0.469007]    #6
[    0.545230] SMP alternatives: lockdep: fixing up alternatives
[    0.546006]    #7 OK
[    0.626323] Brought up 8 CPUs
[    0.627004] smpboot: Total of 8 processors activated (64217.00 BogoMIPS)


I admit the digits calculation is a bit clumsy but I didn't want to do
any log_10 crazy jumps through hoops and besides, it should be faster
this way:

--
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6cacab671f9b..1cf5957b1035 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -653,16 +653,22 @@ static void announce_cpu(int cpu, int apicid)
 {
 	static int current_node = -1;
 	int node = early_cpu_to_node(cpu);
-	int max_cpu_present = find_last_bit(cpumask_bits(cpu_present_mask), NR_CPUS);
+	int num_digits;
 
 	if (system_state == SYSTEM_BOOTING) {
 		if (node != current_node) {
 			if (current_node > (-1))
 				pr_cont(" OK\n");
 			current_node = node;
-			pr_info("Booting Node %3d, Processors ", node);
+			pr_info("Booting Node %3d, Processors", node);
 		}
-		pr_cont(" #%4d%s", cpu, cpu == max_cpu_present ? " OK\n" : "");
+		num_digits = 1 + 1 * (cpu > 9) + 1 * (cpu > 99);
+
+		pr_cont("%*s#%d", 4 - num_digits, " ", cpu);
+
+		if (cpu == num_present_cpus() - 1)
+			pr_cont(" OK\n");
+
 		return;
 	} else
 		pr_info("Booting Node %d Processor %d APIC 0x%x\n",
--

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
