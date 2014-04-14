Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbaDNVMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:12:53 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:54782 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755781AbaDNVKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:10:36 -0400
Message-ID: <534C4EC9.4010708@semaphore.gr>
Date: Tue, 15 Apr 2014 00:10:33 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Gautham R Shenoy <ego@linux.vnet.ibm.com>
CC: linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/20] mips: lemote 2f: se cpufreq_for_each_entry macro for
 iteration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq core supports the cpufreq_for_each_entry macro helper
for iteration over the cpufreq_frequency_table, so use it.

It should have no functional changes.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 arch/mips/loongson/lemote-2f/clock.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/mips/loongson/lemote-2f/clock.c b/arch/mips/loongson/lemote-2f/clock.c
index e1f427f..24e4a26 100644
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
@@ -106,22 +106,17 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	if (unlikely(clk->flags & CLK_RATE_PROPAGATES))
 		propagate_rate(clk);
 
-	for (i = 0; loongson2_clockmod_table[i].frequency != CPUFREQ_TABLE_END;
-	     i++) {
-		if (loongson2_clockmod_table[i].frequency ==
-		    CPUFREQ_ENTRY_INVALID)
-			continue;
-		if (rate == loongson2_clockmod_table[i].frequency)
+	cpufreq_for_each_valid_entry(pos, loongson2_clockmod_table) {
+		if (rate == pos->frequency)
 			break;
 	}
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
