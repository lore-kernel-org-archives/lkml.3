Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783Ab3DOHDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 03:03:03 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40900 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000Ab3DOHDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 03:03:00 -0400
MIME-Version: 1.0
In-Reply-To: <5169BC86.7010905@gmail.com>
References: <1f864ec505cae7c5daea3810a3c26e0f5cda38ea.1364290815.git.viresh.kumar@linaro.org>
	<5169BC86.7010905@gmail.com>
Date: Mon, 15 Apr 2013 12:32:59 +0530
Message-ID: <CAKohpo=zGZzE7Fvj6zhdwNcnLGX0LN0jbpo+1goJz586N20cXw@mail.gmail.com>
Subject: Re: [PATCH V2] cpufreq: ARM big LITTLE: Add generic cpufreq driver
 and its DT glue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Francesco Lavra <francescolavra.fl@gmail.com>
Cc: rjw@sisk.pl, nicolas.pitre@linaro.org, robin.randhawa@arm.com,
        linux@arm.linux.org.uk, mark.hambleton@broadcom.com,
        linux-pm@vger.kernel.org,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>,
        devicetree-discuss@lists.ozlabs.org, Liviu.Dudau@arm.com,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Steve.Bannister@arm.com,
        arvind.chauhan@arm.com, linux-arm-kernel@lists.infradead.org,
        charles.garcia-tobin@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 April 2013 01:43, Francesco Lavra <francescolavra.fl@gmail.com> wrote:

>> +     for_each_child_of_node(of_find_node_by_path("/cpus"), np) {
>
> If of_find_node_by_path() returns NULL, there will be a NULL pointer
> dereference.
>
>> +             if (count++ != cpu_dev->id)
>> +                     continue;
>> +             if (!of_get_property(np, "operating-points", NULL))
>> +                     return -ENODATA;
>> +
>> +             cpu_dev->of_node = np;
>> +
>> +             ret = of_init_opp_table(cpu_dev);
>> +             if (ret)
>> +                     return ret;
>> +
>> +             return 0;
>
> of_node_put() should be called on np before returning.
> Also, the reference count of the parent node should be decremented as well.
>
> These comments apply to the below function dt_get_transition_latency() too.

Thanks Francesco.

Below fixes this (I will send it separately to Rafael):

Subject: [PATCH 1/2] cpufreq: ARM big LITTLE: put DT nodes after using them

DT nodes should be put using of_node_put() to balance their usage counts. This
is not done properly in ARM's big LITTLE driver. Fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/arm_big_little_dt.c | 43 +++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little_dt.c
b/drivers/cpufreq/arm_big_little_dt.c
index 452ff46..44be311 100644
--- a/drivers/cpufreq/arm_big_little_dt.c
+++ b/drivers/cpufreq/arm_big_little_dt.c
@@ -31,22 +31,28 @@

 static int dt_init_opp_table(struct device *cpu_dev)
 {
-	struct device_node *np = NULL;
+	struct device_node *np, *parent;
 	int count = 0, ret;

-	for_each_child_of_node(of_find_node_by_path("/cpus"), np) {
+	parent = of_find_node_by_path("/cpus");
+	if (!parent) {
+		pr_err("failed to find OF /cpus\n");
+		return -ENOENT;
+	}
+
+	for_each_child_of_node(parent, np) {
 		if (count++ != cpu_dev->id)
 			continue;
-		if (!of_get_property(np, "operating-points", NULL))
-			return -ENODATA;
-
-		cpu_dev->of_node = np;
-
-		ret = of_init_opp_table(cpu_dev);
-		if (ret)
-			return ret;
-
-		return 0;
+		if (!of_get_property(np, "operating-points", NULL)) {
+			ret = -ENODATA;
+		} else {
+			cpu_dev->of_node = np;
+			ret = of_init_opp_table(cpu_dev);
+		}
+		of_node_put(np);
+		of_node_put(parent);
+
+		return ret;
 	}

 	return -ENODEV;
@@ -54,15 +60,24 @@ static int dt_init_opp_table(struct device *cpu_dev)

 static int dt_get_transition_latency(struct device *cpu_dev)
 {
-	struct device_node *np = NULL;
+	struct device_node *np, *parent;
 	u32 transition_latency = CPUFREQ_ETERNAL;
 	int count = 0;

-	for_each_child_of_node(of_find_node_by_path("/cpus"), np) {
+	parent = of_find_node_by_path("/cpus");
+	if (!parent) {
+		pr_err("failed to find OF /cpus\n");
+		return -ENOENT;
+	}
+
+	for_each_child_of_node(parent, np) {
 		if (count++ != cpu_dev->id)
 			continue;

 		of_property_read_u32(np, "clock-latency", &transition_latency);
+		of_node_put(np);
+		of_node_put(parent);
+
 		return 0;
 	}
