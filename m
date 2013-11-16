Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3KPAVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 19:21:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56302 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487Ab3KPAVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 19:21:10 -0500
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ceh@ti.com>,
        Nishanth Menon <nm@ti.com>, Tobias Diedrich <ranma+xen@tdiedrich.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dave Jones <davej@redhat.com>
Subject: [PATCH] cpufreq: stats: Do not populate stats when policy->cur has no exact match
Date: Fri, 15 Nov 2013 18:20:43 -0600
Message-ID: <1384561243-30391-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 46a310b ([CPUFREQ] Don't set stat->last_index to -1 if the
pol->cur has incorrect value.) tries to handle case where policy->cur
does not match any entry in freq_table.

As indicated in the above commit, the exact match search of
freq_table_get index will return a -1 which is stored in
stat->last_index. However, as a result of the above commit,
cpufreq_stat_notifier_trans which updates the statistics, fails
to update any *further* valid transitions that take place as
stat->last_index is -1 as the condition occurs at boot and never
solved.

So, instead of having a statistics information that never ever
reflects valid data in the mentioned case and scratching our heads, we
instead, refuse to populate any of the statistics entries and note in
kernel log the error condition for developers to fix. The only useable
information are the available frequencies which is already available
in other cpufreq sysfs entries.

Cc: Tobias Diedrich <ranma+xen@tdiedrich.de>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dave Jones <davej@redhat.com>
Reported-by: Carlos Hernandez <ceh@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---

Patch based on v3.12 tag

Reported by Carlos on TI vendor kernel (v3.12tag based):

OMAP5uEVM: http://pastebin.mozilla.org/3612196
AM335x-evm: http://pastebin.mozilla.org/3612220

As can be seen, the translation table are present, however none of the
transition information is ever updated.
With the current patch, this becomes: http://pastebin.mozilla.org/3612256

Original commit thread seems to be:
https://lkml.org/lkml/2011/6/16/760 but I dont see much information if
this was discussed further.

An alternate approach possible is to try and recover from this case by
using an 'atmost' match to find a closest match and then giveup when
we cant find one, but that does not really indicate a proper statistic
(if freq1 < cur_freq < freq2, was the intent to be at freq1 or freq2?
stats should not make that policy decision)
	http://pastebin.mozilla.org/3612179 (alternate approach 1)

Yet another option might be to update last_index using the first
transition into a valid index, but then, we wont have statistics
information 100% correct as we did not store the very first frequency
stat.
	 http://pastebin.mozilla.org/3612241 (alternate approach 2)

 drivers/cpufreq/cpufreq_stats.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 4cf0d28..4c8a501 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -251,6 +251,14 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
 	stat->last_time = get_jiffies_64();
 	stat->last_index = freq_table_get_index(stat, policy->cur);
 	spin_unlock(&cpufreq_stats_lock);
+
+	if (stat->last_index == -1) {
+		pr_err("%s: No match for current freq %u in table. Disabled!\n",
+		       __func__, policy->cur);
+		ret = -EINVAL;
+		goto error_out;
+	}
+
 	cpufreq_cpu_put(current_policy);
 	return 0;
 error_out:
-- 
1.7.9.5

