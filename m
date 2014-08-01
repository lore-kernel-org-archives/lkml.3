Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaHAJxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 05:53:02 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:25505 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbaHAJxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 05:53:00 -0400
Message-ID: <53DB6369.8070907@huawei.com>
Date: Fri, 1 Aug 2014 17:52:41 +0800
From: Wang Weidong <wangweidong1@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>
CC: <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        wangweidong <wangweidong1@huawei.com>
Subject: [PATCH] cpufreq: get the cur_freq from acpi_processor_performance
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.75]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the initialized freq_tables maybe different from the p-states
values, so the array index is different as well.

p-states value: [2400 2400 2000 ...], while the freq_tables:
[2400 2000 ... CPUFREQ_TABLE_END]. After setted the freqs 2000,
the perf->state is 3 while the freqs_table's index should be 2.
So when call the get_cur_freq_on_cpu, the freqs value we get
is 2400.

So, fix the problem with the correct tables.

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 drivers/cpufreq/acpi-cpufreq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index b0c18ed..2b934cb 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -365,6 +365,7 @@ static u32 get_cur_val(const struct cpumask *mask)
 static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 {
 	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, cpu);
+	struct acpi_processor_performance *perf;
 	unsigned int freq;
 	unsigned int cached_freq;
 
@@ -375,7 +376,8 @@ static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 		return 0;
 	}
 
-	cached_freq = data->freq_table[data->acpi_data->state].frequency;
+	perf = data->acpi_data;
+	cached_freq = perf->states[perf->state].core_frequency * 1000;
 	freq = extract_freq(get_cur_val(cpumask_of(cpu)), data);
 	if (freq != cached_freq) {
 		/*
-- 
1.7.12


