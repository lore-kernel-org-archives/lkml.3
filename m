Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaEGQdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:33:38 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:53678 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751634AbaEGQdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:33:36 -0400
Message-ID: <536A605D.6030009@semaphore.gr>
Date: Wed, 07 May 2014 19:33:33 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: Fix build error on some platforms that use cpufreq_for_each_*
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On platforms that use cpufreq_for_each_* macros, build fails if
CONFIG_CPU_FREQ=n, e.g. ARM/shmobile/koelsch/non-multiplatform:

drivers/built-in.o: In function `clk_round_parent':
clkdev.c:(.text+0xcf168): undefined reference to `cpufreq_next_valid'
drivers/built-in.o: In function `clk_rate_table_find':
clkdev.c:(.text+0xcf820): undefined reference to `cpufreq_next_valid'
make[3]: *** [vmlinux] Error 1

Fix this making cpufreq_next_valid function inline and move it to
cpufreq.h.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq.c | 11 -----------
 include/linux/cpufreq.h   | 11 +++++++++--
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index bfe82b6..a05c921 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -237,17 +237,6 @@ void cpufreq_cpu_put(struct cpufreq_policy *policy)
 }
 EXPORT_SYMBOL_GPL(cpufreq_cpu_put);
 
-bool cpufreq_next_valid(struct cpufreq_frequency_table **pos)
-{
-	while ((*pos)->frequency != CPUFREQ_TABLE_END)
-		if ((*pos)->frequency != CPUFREQ_ENTRY_INVALID)
-			return true;
-		else
-			(*pos)++;
-	return false;
-}
-EXPORT_SYMBOL_GPL(cpufreq_next_valid);
-
 /*********************************************************************
  *            EXTERNALLY AFFECTING FREQUENCY CHANGES                 *
  *********************************************************************/
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 9d803b5..3f45889 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -489,8 +489,15 @@ static inline void dev_pm_opp_free_cpufreq_table(struct device *dev,
 }
 #endif
 
-
-bool cpufreq_next_valid(struct cpufreq_frequency_table **pos);
+static inline bool cpufreq_next_valid(struct cpufreq_frequency_table **pos)
+{
+	while ((*pos)->frequency != CPUFREQ_TABLE_END)
+		if ((*pos)->frequency != CPUFREQ_ENTRY_INVALID)
+			return true;
+		else
+			(*pos)++;
+	return false;
+}
 
 /*
  * cpufreq_for_each_entry -	iterate over a cpufreq_frequency_table
-- 
1.9.0
