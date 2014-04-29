Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964915AbaD2RqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:46:10 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:41928 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933326AbaD2RqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:46:08 -0400
Message-ID: <535FE55D.40500@semaphore.gr>
Date: Tue, 29 Apr 2014 20:46:05 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: intel_pstate: Disable interrupts during MSRs reading
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Intel 64 and IA-32 Architectures SDM, Volume 3,
Chapter 14.2, "Software needs to exercise care to avoid delays
between the two RDMSRs (for example interrupts)".

So, disable interrupts during reading MSRs IA32_APERF and IA32_MPERF.
Since the TSC is also takes place in the calculation include it in
the protected section. This should increase the accuracy of the
calculations.

Tested on Intel i7-3770 CPU @ 3.40GHz.
Benchmarks (Phoronix Linux compilation) show a slightly increase
in performance by ~0.1% and a decrease in power consumption by
~0.13%.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---

I hope it's not too inappropriate to post test results in
conjunction with my previous patch about the change of calculation
method of next p-state (https://lkml.org/lkml/2014/4/27/100).
I used Phoronix benchmark - Linux Kernel Compilation 3.1.
Below the test results using turbostat (5 iterations):

Without 2 patches:

Ph. avg Time	Total time	PkgWatt		Total Energy
	79.63	266.416		57.74		15382.85984
	79.63	265.609		57.87		15370.79283
	79.57	266.994		57.54		15362.83476
	79.53	265.304		57.83		15342.53032
	79.71	265.977		57.76		15362.83152
avg	79.61	266.06		57.74		15364.36985

With change calculation patch:

Ph. avg Time	Total time	PkgWatt		Total Energy
	78.23	258.826		59.14		15306.96964
	78.41	259.110		59.15		15326.35650
	78.40	258.530		59.26		15320.48780
	78.46	258.673		59.20		15313.44160
	78.19	259.075		59.16		15326.87700
avg	78.34	258.842		59.18		15318.82650

With change calculation patch + this one

Ph. avg Time	Total time	PkgWatt		Total Energy
	78.33	259.320		59.06		15315.43920
	78.28	258.245		59.20		15288.10400
	78.08	257.523		59.32		15276.26436
	78.38	259.084		59.13		15319.63692
	78.31	258.232		59.22		15292.49904
avg	78.27	258.480		59.18		15298.38870


 drivers/cpufreq/intel_pstate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 8e309db..95b3958 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -576,10 +576,13 @@ static inline void intel_pstate_sample(struct cpudata *cpu)
 {
 	u64 aperf, mperf;
 	unsigned long long tsc;
+	unsigned long flags;
 
+	local_irq_save(flags);
 	rdmsrl(MSR_IA32_APERF, aperf);
 	rdmsrl(MSR_IA32_MPERF, mperf);
 	tsc = native_read_tsc();
+	local_irq_restore(flags);
 
 	aperf = aperf >> FRAC_BITS;
 	mperf = mperf >> FRAC_BITS;
-- 
1.9.0
