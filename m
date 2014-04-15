Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaDOW0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:26:21 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:57981 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751744AbaDOW0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:26:18 -0400
Message-ID: <534DB206.1080004@semaphore.gr>
Date: Wed, 16 Apr 2014 01:26:14 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC: John Crispin <blogic@openwrt.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 4/8] mips: lemote 2f: Use cpufreq_for_each_entry macro
 for iteration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq core now supports the cpufreq_for_each_entry macro helper
for iteration over the cpufreq_frequency_table, so use it.

It should have no functional changes.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 arch/mips/loongson/lemote-2f/clock.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/mips/loongson/lemote-2f/clock.c b/arch/mips/loongson/lemote-2f/clock.c
index e1f427f..1eed38e 100644
--- a/arch/mips/loongson/lemote-2f/clock.c
+++ b/arch/mips/loongson/lemote-2f/clock.c
@@ -91,9 +91,9 @@ EXPORT_SYMBOL(clk_put);
 
 int clk_set_rate(struct clk *clk, unsigned long rate)
 {
+	struct cpufreq_frequency_table *pos;
 	int ret = 0;
 	int regval;
-	int i;
 
 	if (likely(clk->ops && clk->ops->set_rate)) {
 		unsigned long flags;
@@ -106,22 +106,16 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	if (unlikely(clk->flags & CLK_RATE_PROPAGATES))
 		propagate_rate(clk);
 
-	for (i = 0; loongson2_clockmod_table[i].frequency != CPUFREQ_TABLE_END;
-	     i++) {
-		if (loongson2_clockmod_table[i].frequency ==
-		    CPUFREQ_ENTRY_INVALID)
-			continue;
-		if (rate == loongson2_clockmod_table[i].frequency)
+	cpufreq_for_each_valid_entry(pos, loongson2_clockmod_table)
+		if (rate == pos->frequency)
 			break;
-	}
-	if (rate != loongson2_clockmod_table[i].frequency)
+	if (rate != pos->frequency)
 		return -ENOTSUPP;
 
 	clk->rate = rate;
 
 	regval = LOONGSON_CHIPCFG0;
-	regval = (regval & ~0x7) |
-		(loongson2_clockmod_table[i].driver_data - 1);
+	regval = (regval & ~0x7) | (pos->driver_data - 1);
 	LOONGSON_CHIPCFG0 = regval;
 
 	return ret;
-- 
1.9.0
