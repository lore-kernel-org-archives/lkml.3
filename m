Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbaDUXC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 19:02:28 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:48664 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754743AbaDUXCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 19:02:25 -0400
Message-ID: <5355A37E.30804@semaphore.gr>
Date: Tue, 22 Apr 2014 02:02:22 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Samuel Ortiz <samuel@sortiz.org>, netdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: [PATCH v4 7/8] irda: sh_sir: Use cpufreq_for_each_valid_entry macro
 for iteration
References: <534DB22D.3040607@semaphore.gr>
In-Reply-To: <534DB22D.3040607@semaphore.gr>
X-Forwarded-Message-Id: <534DB22D.3040607@semaphore.gr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpufreq core supports the cpufreq_for_each_valid_entry macro
helper for iteration over the cpufreq_frequency_table, so use it.

It should have no functional changes.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---

Please note that I was no able to compile test this patch due to 
lack of cross compiler.

 drivers/net/irda/sh_sir.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/irda/sh_sir.c b/drivers/net/irda/sh_sir.c
index cadf52e..e3fe9a2 100644
--- a/drivers/net/irda/sh_sir.c
+++ b/drivers/net/irda/sh_sir.c
@@ -217,21 +217,17 @@ crc_init_out:
 static u32 sh_sir_find_sclk(struct clk *irda_clk)
 {
 	struct cpufreq_frequency_table *freq_table = irda_clk->freq_table;
+	struct cpufreq_frequency_table *pos;
 	struct clk *pclk = clk_get(NULL, "peripheral_clk");
 	u32 limit, min = 0xffffffff, tmp;
-	int i, index = 0;
+	int index = 0;
 
 	limit = clk_get_rate(pclk);
 	clk_put(pclk);
 
 	/* IrDA can not set over peripheral_clk */
-	for (i = 0;
-	     freq_table[i].frequency != CPUFREQ_TABLE_END;
-	     i++) {
-		u32 freq = freq_table[i].frequency;
-
-		if (freq == CPUFREQ_ENTRY_INVALID)
-			continue;
+	cpufreq_for_each_valid_entry(pos, freq_table) {
+		u32 freq = pos->frequency;
 
 		/* IrDA should not over peripheral_clk */
 		if (freq > limit)
@@ -240,7 +236,7 @@ static u32 sh_sir_find_sclk(struct clk *irda_clk)
 		tmp = freq % SCLK_BASE;
 		if (tmp < min) {
 			min = tmp;
-			index = i;
+			index = pos - freq_table;
 		}
 	}
 
-- 
1.9.0
