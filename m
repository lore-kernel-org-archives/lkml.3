Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaHUF5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 01:57:19 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:6018 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaHUF5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 01:57:17 -0400
Message-ID: <53F589C3.4050504@huawei.com>
Date: Thu, 21 Aug 2014 13:55:15 +0800
From: Wang Weidong <wangweidong1@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>
CC: <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH] acpi-cpufreq: get the cur_freq from acpi_processor_performance
 states
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.75]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020204.53F58A3B.0036,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 5b648fee6d7a77c203715d536e0bb3d6
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
index b0c18ed..ac93885 100644
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


