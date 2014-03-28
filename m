Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaC1Ix6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:53:58 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:61045 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaC1Ixp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:53:45 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, l.majewski@samsung.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: create another field .flags in cpufreq_frequency_table
Date: Fri, 28 Mar 2014 14:23:20 +0530
Message-Id: <b5bc276cdd34b039de2aa640ec0bb5dff195f832.1395996386.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <78187ea173460c871eef31432ec2a80ec657fe30.1395643393.git.viresh.kumar@linaro.org>
References: <78187ea173460c871eef31432ec2a80ec657fe30.1395643393.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently cpufreq frequency table has two fields: frequency and driver_data.
driver_data is only for driver's internal use and cpufreq core shouldn't use it
at all. But with the introduction of BOOST frequencies, this assumption was
broken and we started using it as a flag instead.

There are two problems due to this:
- It is against the description of this field, as driver's data is used by core
  now.
- if drivers fill it with -3 for any frequency, then those frequencies are never
  considered by cpufreq core as it is exactly same as value of
  CPUFREQ_BOOST_FREQ, i.e. ~2.

The best way to get this fixed is by creating another field flags which will be
used for such flags. This patch does that. Along with that various drivers need
modifications due to the change of struct cpufreq_frequency_table.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
I have sent following patch earlier for fixing the issues mentioned above:
https://lkml.org/lkml/2014/3/24/44

Please discard that now.

I always knew that the best way to get this fixed was to add another field but
was running away from that as I wasn't very keen on adding another field into
this struct.

But after some rethinking, it becomes more and more obvious that we are inviting
more trouble in future if we don't add another field here.

So with the pain of 150+- changes, here is a patch to get things cleaned up. I
have grepped for cpufreq_frequency_table and did all modifications here. I have
compiled it only for few ARM platforms. To make sure I haven't broken anything
else, I have pushed this for getting tested by 'kbuild test robot'..

So, by the time it get tested here it is for all of you to review.

--
viresh

 arch/mips/loongson/lemote-2f/clock.c   | 20 ++++++++++----------
 drivers/cpufreq/cris-artpec3-cpufreq.c |  6 +++---
 drivers/cpufreq/cris-etraxfs-cpufreq.c |  6 +++---
 drivers/cpufreq/elanfreq.c             | 18 +++++++++---------
 drivers/cpufreq/exynos4210-cpufreq.c   | 12 ++++++------
 drivers/cpufreq/exynos4x12-cpufreq.c   | 30 +++++++++++++++---------------
 drivers/cpufreq/exynos5250-cpufreq.c   | 34 +++++++++++++++++-----------------
 drivers/cpufreq/freq_table.c           |  4 ++--
 drivers/cpufreq/kirkwood-cpufreq.c     |  6 +++---
 drivers/cpufreq/maple-cpufreq.c        |  6 +++---
 drivers/cpufreq/p4-clockmod.c          | 20 ++++++++++----------
 drivers/cpufreq/pasemi-cpufreq.c       | 12 ++++++------
 drivers/cpufreq/pmac32-cpufreq.c       |  6 +++---
 drivers/cpufreq/pmac64-cpufreq.c       |  6 +++---
 drivers/cpufreq/powernow-k6.c          | 18 +++++++++---------
 drivers/cpufreq/ppc_cbe_cpufreq.c      | 18 +++++++++---------
 drivers/cpufreq/s3c2416-cpufreq.c      | 20 ++++++++++----------
 drivers/cpufreq/s3c64xx-cpufreq.c      | 26 +++++++++++++-------------
 drivers/cpufreq/s5pv210-cpufreq.c      | 12 ++++++------
 drivers/cpufreq/sc520_freq.c           |  6 +++---
 drivers/cpufreq/speedstep-ich.c        |  6 +++---
 drivers/cpufreq/speedstep-smi.c        |  6 +++---
 include/linux/cpufreq.h                |  9 ++++++---
 23 files changed, 155 insertions(+), 152 deletions(-)

diff --git a/arch/mips/loongson/lemote-2f/clock.c b/arch/mips/loongson/lemote-2f/clock.c
index aed32b8..e1f427f 100644
--- a/arch/mips/loongson/lemote-2f/clock.c
+++ b/arch/mips/loongson/lemote-2f/clock.c
@@ -28,16 +28,16 @@ enum {
 };
 
 struct cpufreq_frequency_table loongson2_clockmod_table[] = {
-	{DC_RESV, CPUFREQ_ENTRY_INVALID},
-	{DC_ZERO, CPUFREQ_ENTRY_INVALID},
-	{DC_25PT, 0},
-	{DC_37PT, 0},
-	{DC_50PT, 0},
-	{DC_62PT, 0},
-	{DC_75PT, 0},
-	{DC_87PT, 0},
-	{DC_DISABLE, 0},
-	{DC_RESV, CPUFREQ_TABLE_END},
+	{0, DC_RESV, CPUFREQ_ENTRY_INVALID},
+	{0, DC_ZERO, CPUFREQ_ENTRY_INVALID},
+	{0, DC_25PT, 0},
+	{0, DC_37PT, 0},
+	{0, DC_50PT, 0},
+	{0, DC_62PT, 0},
+	{0, DC_75PT, 0},
+	{0, DC_87PT, 0},
+	{0, DC_DISABLE, 0},
+	{0, DC_RESV, CPUFREQ_TABLE_END},
 };
 EXPORT_SYMBOL_GPL(loongson2_clockmod_table);
 
diff --git a/drivers/cpufreq/cris-artpec3-cpufreq.c b/drivers/cpufreq/cris-artpec3-cpufreq.c
index d457303..601b88c 100644
--- a/drivers/cpufreq/cris-artpec3-cpufreq.c
+++ b/drivers/cpufreq/cris-artpec3-cpufreq.c
@@ -15,9 +15,9 @@ static struct notifier_block cris_sdram_freq_notifier_block = {
 };
 
 static struct cpufreq_frequency_table cris_freq_table[] = {
-	{0x01,	6000},
-	{0x02,	200000},
-	{0,	CPUFREQ_TABLE_END},
+	{0, 0x01, 6000},
+	{0, 0x02, 200000},
+	{0, 0, CPUFREQ_TABLE_END},
 };
 
 static unsigned int cris_freq_get_cpu_frequency(unsigned int cpu)
diff --git a/drivers/cpufreq/cris-etraxfs-cpufreq.c b/drivers/cpufreq/cris-etraxfs-cpufreq.c
index 13c3361..22b2cdd 100644
--- a/drivers/cpufreq/cris-etraxfs-cpufreq.c
+++ b/drivers/cpufreq/cris-etraxfs-cpufreq.c
@@ -15,9 +15,9 @@ static struct notifier_block cris_sdram_freq_notifier_block = {
 };
 
 static struct cpufreq_frequency_table cris_freq_table[] = {
-	{0x01, 6000},
-	{0x02, 200000},
-	{0, CPUFREQ_TABLE_END},
+	{0, 0x01, 6000},
+	{0, 0x02, 200000},
+	{0, 0, CPUFREQ_TABLE_END},
 };
 
 static unsigned int cris_freq_get_cpu_frequency(unsigned int cpu)
diff --git a/drivers/cpufreq/elanfreq.c b/drivers/cpufreq/elanfreq.c
index c987e94..7f5d2a6 100644
--- a/drivers/cpufreq/elanfreq.c
+++ b/drivers/cpufreq/elanfreq.c
@@ -56,15 +56,15 @@ static struct s_elan_multiplier elan_multiplier[] = {
 };
 
 static struct cpufreq_frequency_table elanfreq_table[] = {
-	{0,	1000},
-	{1,	2000},
-	{2,	4000},
-	{3,	8000},
-	{4,	16000},
-	{5,	33000},
-	{6,	66000},
-	{7,	99000},
-	{0,	CPUFREQ_TABLE_END},
+	{0, 0,	1000},
+	{0, 1,	2000},
+	{0, 2,	4000},
+	{0, 3,	8000},
+	{0, 4,	16000},
+	{0, 5,	33000},
+	{0, 6,	66000},
+	{0, 7,	99000},
+	{0, 0,	CPUFREQ_TABLE_END},
 };
 
 
diff --git a/drivers/cpufreq/exynos4210-cpufreq.c b/drivers/cpufreq/exynos4210-cpufreq.c
index 40d84c4..6384e5b 100644
--- a/drivers/cpufreq/exynos4210-cpufreq.c
+++ b/drivers/cpufreq/exynos4210-cpufreq.c
@@ -29,12 +29,12 @@ static unsigned int exynos4210_volt_table[] = {
 };
 
 static struct cpufreq_frequency_table exynos4210_freq_table[] = {
-	{L0, 1200 * 1000},
-	{L1, 1000 * 1000},
-	{L2,  800 * 1000},
-	{L3,  500 * 1000},
-	{L4,  200 * 1000},
-	{0, CPUFREQ_TABLE_END},
+	{0, L0, 1200 * 1000},
+	{0, L1, 1000 * 1000},
+	{0, L2,  800 * 1000},
+	{0, L3,  500 * 1000},
+	{0, L4,  200 * 1000},
+	{0, 0, CPUFREQ_TABLE_END},
 };
 
 static struct apll_freq apll_freq_4210[] = {
diff --git a/drivers/cpufreq/exynos4x12-cpufreq.c b/drivers/cpufreq/exynos4x12-cpufreq.c
index 7c11ace..8c4c6a5 100644
--- a/drivers/cpufreq/exynos4x12-cpufreq.c
+++ b/drivers/cpufreq/exynos4x12-cpufreq.c
@@ -30,21 +30,21 @@ static unsigned int exynos4x12_volt_table[] = {
 };
 
 static struct cpufreq_frequency_table exynos4x12_freq_table[] = {
-	{CPUFREQ_BOOST_FREQ, 1500 * 1000},
-	{L1, 1400 * 1000},
-	{L2, 1300 * 1000},
-	{L3, 1200 * 1000},
-	{L4, 1100 * 1000},
-	{L5, 1000 * 1000},
-	{L6,  900 * 1000},
-	{L7,  800 * 1000},
-	{L8,  700 * 1000},
-	{L9,  600 * 1000},
-	{L10, 500 * 1000},
-	{L11, 400 * 1000},
-	{L12, 300 * 1000},
-	{L13, 200 * 1000},
-	{0, CPUFREQ_TABLE_END},
+	{CPUFREQ_BOOST_FREQ, 0, 1500 * 1000},
+	{0, L1, 1400 * 1000},
+	{0, L2, 1300 * 1000},
+	{0, L3, 1200 * 1000},
+	{0, L4, 1100 * 1000},
+	{0, L5, 1000 * 1000},
+	{0, L6,  900 * 1000},
+	{0, L7,  800 * 1000},
+	{0, L8,  700 * 1000},
+	{0, L9,  600 * 1000},
+	{0, L10, 500 * 1000},
+	{0, L11, 400 * 1000},
+	{0, L12, 300 * 1000},
+	{0, L13, 200 * 1000},
+	{0, 0, CPUFREQ_TABLE_END},
 };
 
 static struct apll_freq *apll_freq_4x12;
diff --git a/drivers/cpufreq/exynos5250-cpufreq.c b/drivers/cpufreq/exynos5250-cpufreq.c
index 5f90b82..363a0b3 100644
--- a/drivers/cpufreq/exynos5250-cpufreq.c
+++ b/drivers/cpufreq/exynos5250-cpufreq.c
@@ -34,23 +34,23 @@ static unsigned int exynos5250_volt_table[] = {
 };
 
 static struct cpufreq_frequency_table exynos5250_freq_table[] = {
-	{L0, 1700 * 1000},
-	{L1, 1600 * 1000},
-	{L2, 1500 * 1000},
-	{L3, 1400 * 1000},
-	{L4, 1300 * 1000},
-	{L5, 1200 * 1000},
-	{L6, 1100 * 1000},
-	{L7, 1000 * 1000},
-	{L8,  900 * 1000},
-	{L9,  800 * 1000},
-	{L10, 700 * 1000},
-	{L11, 600 * 1000},
-	{L12, 500 * 1000},
-	{L13, 400 * 1000},
-	{L14, 300 * 1000},
-	{L15, 200 * 1000},
-	{0, CPUFREQ_TABLE_END},
+	{0, L0, 1700 * 1000},
+	{0, L1, 1600 * 1000},
+	{0, L2, 1500 * 1000},
+	{0, L3, 1400 * 1000},
+	{0, L4, 1300 * 1000},
+	{0, L5, 1200 * 1000},
+	{0, L6, 1100 * 1000},
+	{0, L7, 1000 * 1000},
+	{0, L8,  900 * 1000},
+	{0, L9,  800 * 1000},
+	{0, L10, 700 * 1000},
+	{0, L11, 600 * 1000},
+	{0, L12, 500 * 1000},
+	{0, L13, 400 * 1000},
+	{0, L14, 300 * 1000},
+	{0, L15, 200 * 1000},
+	{0, 0, CPUFREQ_TABLE_END},
 };
 
 static struct apll_freq apll_freq_5250[] = {
diff --git a/drivers/cpufreq/freq_table.c b/drivers/cpufreq/freq_table.c
index 53ff3c2..08e7bbc 100644
--- a/drivers/cpufreq/freq_table.c
+++ b/drivers/cpufreq/freq_table.c
@@ -33,7 +33,7 @@ int cpufreq_frequency_table_cpuinfo(struct cpufreq_policy *policy,
 			continue;
 		}
 		if (!cpufreq_boost_enabled()
-		    && table[i].driver_data == CPUFREQ_BOOST_FREQ)
+		    && (table[i].flags & CPUFREQ_BOOST_FREQ))
 			continue;
 
 		pr_debug("table entry %u: %u kHz\n", i, freq);
@@ -229,7 +229,7 @@ static ssize_t show_available_freqs(struct cpufreq_policy *policy, char *buf,
 		 * show_boost = false and driver_data != BOOST freq
 		 * display NON BOOST freqs
 		 */
-		if (show_boost ^ (table[i].driver_data == CPUFREQ_BOOST_FREQ))
+		if (show_boost ^ (table[i].flags & CPUFREQ_BOOST_FREQ))
 			continue;
 
 		count += sprintf(&buf[count], "%d ", table[i].frequency);
diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index 3d114bc..37a4806 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -43,9 +43,9 @@ static struct priv
  * table.
  */
 static struct cpufreq_frequency_table kirkwood_freq_table[] = {
-	{STATE_CPU_FREQ,	0}, /* CPU uses cpuclk */
-	{STATE_DDR_FREQ,	0}, /* CPU uses ddrclk */
-	{0,			CPUFREQ_TABLE_END},
+	{0, STATE_CPU_FREQ,	0}, /* CPU uses cpuclk */
+	{0, STATE_DDR_FREQ,	0}, /* CPU uses ddrclk */
+	{0, 0,			CPUFREQ_TABLE_END},
 };
 
 static unsigned int kirkwood_cpufreq_get_cpu_frequency(unsigned int cpu)
diff --git a/drivers/cpufreq/maple-cpufreq.c b/drivers/cpufreq/maple-cpufreq.c
index c4dfa42..cc3408f 100644
--- a/drivers/cpufreq/maple-cpufreq.c
+++ b/drivers/cpufreq/maple-cpufreq.c
@@ -59,9 +59,9 @@
 #define CPUFREQ_LOW                   1
 
 static struct cpufreq_frequency_table maple_cpu_freqs[] = {
-	{CPUFREQ_HIGH,		0},
-	{CPUFREQ_LOW,		0},
-	{0,			CPUFREQ_TABLE_END},
+	{0, CPUFREQ_HIGH,		0},
+	{0, CPUFREQ_LOW,		0},
+	{0, 0,				CPUFREQ_TABLE_END},
 };
 
 /* Power mode data is an array of the 32 bits PCR values to use for
diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 74f593e..529cfd9 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -92,16 +92,16 @@ static int cpufreq_p4_setdc(unsigned int cpu, unsigned int newstate)
 
 
 static struct cpufreq_frequency_table p4clockmod_table[] = {
-	{DC_RESV, CPUFREQ_ENTRY_INVALID},
-	{DC_DFLT, 0},
-	{DC_25PT, 0},
-	{DC_38PT, 0},
-	{DC_50PT, 0},
-	{DC_64PT, 0},
-	{DC_75PT, 0},
-	{DC_88PT, 0},
-	{DC_DISABLE, 0},
-	{DC_RESV, CPUFREQ_TABLE_END},
+	{0, DC_RESV, CPUFREQ_ENTRY_INVALID},
+	{0, DC_DFLT, 0},
+	{0, DC_25PT, 0},
+	{0, DC_38PT, 0},
+	{0, DC_50PT, 0},
+	{0, DC_64PT, 0},
+	{0, DC_75PT, 0},
+	{0, DC_88PT, 0},
+	{0, DC_DISABLE, 0},
+	{0, DC_RESV, CPUFREQ_TABLE_END},
 };
 
 
diff --git a/drivers/cpufreq/pasemi-cpufreq.c b/drivers/cpufreq/pasemi-cpufreq.c
index 6a2b7d3..84c84b5 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -60,12 +60,12 @@ static int current_astate;
 
 /* We support 5(A0-A4) power states excluding turbo(A5-A6) modes */
 static struct cpufreq_frequency_table pas_freqs[] = {
-	{0,	0},
-	{1,	0},
-	{2,	0},
-	{3,	0},
-	{4,	0},
-	{0,	CPUFREQ_TABLE_END},
+	{0, 0,	0},
+	{0, 1,	0},
+	{0, 2,	0},
+	{0, 3,	0},
+	{0, 4,	0},
+	{0, 0,	CPUFREQ_TABLE_END},
 };
 
 /*
diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index cf55d20..80ee398 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -81,9 +81,9 @@ static int is_pmu_based;
 #define CPUFREQ_LOW                   1
 
 static struct cpufreq_frequency_table pmac_cpu_freqs[] = {
-	{CPUFREQ_HIGH, 		0},
-	{CPUFREQ_LOW,		0},
-	{0,			CPUFREQ_TABLE_END},
+	{0, CPUFREQ_HIGH, 		0},
+	{0, CPUFREQ_LOW,		0},
+	{0, 0,				CPUFREQ_TABLE_END},
 };
 
 static inline void local_delay(unsigned long ms)
diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index 6a338f8..290efe7 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -65,9 +65,9 @@
 #define CPUFREQ_LOW                   1
 
 static struct cpufreq_frequency_table g5_cpu_freqs[] = {
-	{CPUFREQ_HIGH, 		0},
-	{CPUFREQ_LOW,		0},
-	{0,			CPUFREQ_TABLE_END},
+	{0, CPUFREQ_HIGH, 		0},
+	{0, CPUFREQ_LOW,		0},
+	{0, 0,				CPUFREQ_TABLE_END},
 };
 
 /* Power mode data is an array of the 32 bits PCR values to use for
diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index 62c6f2e..49f120e 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -37,15 +37,15 @@ MODULE_PARM_DESC(bus_frequency, "Bus frequency in kHz");
 
 /* Clock ratio multiplied by 10 - see table 27 in AMD#23446 */
 static struct cpufreq_frequency_table clock_ratio[] = {
-	{60,  /* 110 -> 6.0x */ 0},
-	{55,  /* 011 -> 5.5x */ 0},
-	{50,  /* 001 -> 5.0x */ 0},
-	{45,  /* 000 -> 4.5x */ 0},
-	{40,  /* 010 -> 4.0x */ 0},
-	{35,  /* 111 -> 3.5x */ 0},
-	{30,  /* 101 -> 3.0x */ 0},
-	{20,  /* 100 -> 2.0x */ 0},
-	{0, CPUFREQ_TABLE_END}
+	{0, 60,  /* 110 -> 6.0x */ 0},
+	{0, 55,  /* 011 -> 5.5x */ 0},
+	{0, 50,  /* 001 -> 5.0x */ 0},
+	{0, 45,  /* 000 -> 4.5x */ 0},
+	{0, 40,  /* 010 -> 4.0x */ 0},
+	{0, 35,  /* 111 -> 3.5x */ 0},
+	{0, 30,  /* 101 -> 3.0x */ 0},
+	{0, 20,  /* 100 -> 2.0x */ 0},
+	{0, 0, CPUFREQ_TABLE_END}
 };
 
 static const u8 index_to_register[8] = { 6, 3, 1, 0, 2, 7, 5, 4 };
diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index af7b1ca..5be8a48 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -32,15 +32,15 @@
 
 /* the CBE supports an 8 step frequency scaling */
 static struct cpufreq_frequency_table cbe_freqs[] = {
-	{1,	0},
-	{2,	0},
-	{3,	0},
-	{4,	0},
-	{5,	0},
-	{6,	0},
-	{8,	0},
-	{10,	0},
-	{0,	CPUFREQ_TABLE_END},
+	{0, 1,	0},
+	{0, 2,	0},
+	{0, 3,	0},
+	{0, 4,	0},
+	{0, 5,	0},
+	{0, 6,	0},
+	{0, 8,	0},
+	{0, 10,	0},
+	{0, 0,	CPUFREQ_TABLE_END},
 };
 
 /*
diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 826b8be..4626f90 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -72,19 +72,19 @@ static struct s3c2416_dvfs s3c2416_dvfs_table[] = {
 #endif
 
 static struct cpufreq_frequency_table s3c2416_freq_table[] = {
-	{ SOURCE_HCLK, FREQ_DVS },
-	{ SOURCE_ARMDIV, 133333 },
-	{ SOURCE_ARMDIV, 266666 },
-	{ SOURCE_ARMDIV, 400000 },
-	{ 0, CPUFREQ_TABLE_END },
+	{ 0, SOURCE_HCLK, FREQ_DVS },
+	{ 0, SOURCE_ARMDIV, 133333 },
+	{ 0, SOURCE_ARMDIV, 266666 },
+	{ 0, SOURCE_ARMDIV, 400000 },
+	{ 0, 0, CPUFREQ_TABLE_END },
 };
 
 static struct cpufreq_frequency_table s3c2450_freq_table[] = {
-	{ SOURCE_HCLK, FREQ_DVS },
-	{ SOURCE_ARMDIV, 133500 },
-	{ SOURCE_ARMDIV, 267000 },
-	{ SOURCE_ARMDIV, 534000 },
-	{ 0, CPUFREQ_TABLE_END },
+	{ 0, SOURCE_HCLK, FREQ_DVS },
+	{ 0, SOURCE_ARMDIV, 133500 },
+	{ 0, SOURCE_ARMDIV, 267000 },
+	{ 0, SOURCE_ARMDIV, 534000 },
+	{ 0, 0, CPUFREQ_TABLE_END },
 };
 
 static unsigned int s3c2416_cpufreq_get_speed(unsigned int cpu)
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index c4226de..ff7d3ec 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -37,19 +37,19 @@ static struct s3c64xx_dvfs s3c64xx_dvfs_table[] = {
 };
 
 static struct cpufreq_frequency_table s3c64xx_freq_table[] = {
-	{ 0,  66000 },
-	{ 0, 100000 },
-	{ 0, 133000 },
-	{ 1, 200000 },
-	{ 1, 222000 },
-	{ 1, 266000 },
-	{ 2, 333000 },
-	{ 2, 400000 },
-	{ 2, 532000 },
-	{ 2, 533000 },
-	{ 3, 667000 },
-	{ 4, 800000 },
-	{ 0, CPUFREQ_TABLE_END },
+	{ 0, 0,  66000 },
+	{ 0, 0, 100000 },
+	{ 0, 0, 133000 },
+	{ 0, 1, 200000 },
+	{ 0, 1, 222000 },
+	{ 0, 1, 266000 },
+	{ 0, 2, 333000 },
+	{ 0, 2, 400000 },
+	{ 0, 2, 532000 },
+	{ 0, 2, 533000 },
+	{ 0, 3, 667000 },
+	{ 0, 4, 800000 },
+	{ 0, 0, CPUFREQ_TABLE_END },
 };
 #endif
 
diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index 7242153..ab2c1a4 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -64,12 +64,12 @@ enum s5pv210_dmc_port {
 };
 
 static struct cpufreq_frequency_table s5pv210_freq_table[] = {
-	{L0, 1000*1000},
-	{L1, 800*1000},
-	{L2, 400*1000},
-	{L3, 200*1000},
-	{L4, 100*1000},
-	{0, CPUFREQ_TABLE_END},
+	{0, L0, 1000*1000},
+	{0, L1, 800*1000},
+	{0, L2, 400*1000},
+	{0, L3, 200*1000},
+	{0, L4, 100*1000},
+	{0, 0, CPUFREQ_TABLE_END},
 };
 
 static struct regulator *arm_regulator;
diff --git a/drivers/cpufreq/sc520_freq.c b/drivers/cpufreq/sc520_freq.c
index 69371bf..ac84e48 100644
--- a/drivers/cpufreq/sc520_freq.c
+++ b/drivers/cpufreq/sc520_freq.c
@@ -33,9 +33,9 @@ static __u8 __iomem *cpuctl;
 #define PFX "sc520_freq: "
 
 static struct cpufreq_frequency_table sc520_freq_table[] = {
-	{0x01,	100000},
-	{0x02,	133000},
-	{0,	CPUFREQ_TABLE_END},
+	{0, 0x01,	100000},
+	{0, 0x02,	133000},
+	{0, 0,	CPUFREQ_TABLE_END},
 };
 
 static unsigned int sc520_freq_get_cpu_frequency(unsigned int cpu)
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index 394ac15..1a07b59 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -49,9 +49,9 @@ static u32 pmbase;
  * are in kHz for the time being.
  */
 static struct cpufreq_frequency_table speedstep_freqs[] = {
-	{SPEEDSTEP_HIGH,	0},
-	{SPEEDSTEP_LOW,		0},
-	{0,			CPUFREQ_TABLE_END},
+	{0, SPEEDSTEP_HIGH,	0},
+	{0, SPEEDSTEP_LOW,	0},
+	{0, 0,			CPUFREQ_TABLE_END},
 };
 
 
diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index db5d274..8635eec 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -42,9 +42,9 @@ static enum speedstep_processor speedstep_processor;
  * are in kHz for the time being.
  */
 static struct cpufreq_frequency_table speedstep_freqs[] = {
-	{SPEEDSTEP_HIGH,	0},
-	{SPEEDSTEP_LOW,		0},
-	{0,			CPUFREQ_TABLE_END},
+	{0, SPEEDSTEP_HIGH,	0},
+	{0, SPEEDSTEP_LOW,	0},
+	{0, 0,			CPUFREQ_TABLE_END},
 };
 
 #define GET_SPEEDSTEP_OWNER 0
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index c48e595..1e8f07d 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -455,11 +455,14 @@ extern struct cpufreq_governor cpufreq_gov_conservative;
  *                     FREQUENCY TABLE HELPERS                       *
  *********************************************************************/
 
-#define CPUFREQ_ENTRY_INVALID ~0
-#define CPUFREQ_TABLE_END     ~1
-#define CPUFREQ_BOOST_FREQ    ~2
+/* Special Values of .frequency field */
+#define CPUFREQ_ENTRY_INVALID	~0
+#define CPUFREQ_TABLE_END	~1
+/* Special Values of .flags field */
+#define CPUFREQ_BOOST_FREQ	0x1
 
 struct cpufreq_frequency_table {
+	unsigned int	flags;
 	unsigned int	driver_data; /* driver specific data, not used by core */
 	unsigned int	frequency; /* kHz - doesn't need to be in ascending
 				    * order */
-- 
1.7.12.rc2.18.g61b472e

