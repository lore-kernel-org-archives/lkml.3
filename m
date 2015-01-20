Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbbATL1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:27:08 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48715 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbbATL1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:27:05 -0500
Message-ID: <54BE3B79.9070004@linux.vnet.ibm.com>
Date: Tue, 20 Jan 2015 16:56:49 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>, rafael.j.wysocki@intel.com
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: cpuidle/powernv: Read target_residency value of idle states from
 DT if available
References: <20150120054506.F13591402E0@ozlabs.org>
In-Reply-To: <20150120054506.F13591402E0@ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012011-0037-0000-0000-000000661586
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 11:15 AM, Michael Ellerman wrote:
> On Mon, 2015-19-01 at 11:32:51 UTC, Preeti U Murthy wrote:
>> The device tree now exposes the residency values for different idle states. Read
>> these values instead of calculating residency from the latency values. The values
>> exposed in the DT are validated for optimal power efficiency. However to maintain
>> compatibility with the older firmware code which does not expose residency
>> values, use default values as a fallback mechanism. While at it, clump
>> the common parts of device tree parsing into one chunk.
>>
>> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/cpuidle/cpuidle-powernv.c |   39 ++++++++++++++++++++++++-------------
>>  1 file changed, 25 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
>> index 2726663..9e732e1 100644
>> --- a/drivers/cpuidle/cpuidle-powernv.c
>> +++ b/drivers/cpuidle/cpuidle-powernv.c
>> @@ -162,7 +162,8 @@ static int powernv_add_idle_states(void)
>>  	int dt_idle_states;
>>  	const __be32 *idle_state_flags;
>>  	const __be32 *idle_state_latency;
>> -	u32 len_flags, flags, latency_ns;
>> +	const __be32 *idle_state_residency;
>> +	u32 len_flags, flags, latency_ns, residency_ns;
>>  	int i;
>>  
>>  	/* Currently we have snooze statically defined */
>> @@ -186,14 +187,21 @@ static int powernv_add_idle_states(void)
>>  		return nr_idle_states;
>>  	}
>>  
>> +	idle_state_residency = of_get_property(power_mgt,
>> +			"ibm,cpu-idle-state-residency-ns", NULL);
>> +	if (!idle_state_residency) {
>> +		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-residency-ns\n");
>> +		pr_warn("Falling back to default values\n");
>> +	}
> 
> This would be better done with something like:
> 
> 	rc = of_read_property_u32(power_mgt, "ibm,cpu-idle-state-residency-ns", &residency_ns);
> 	if (!rc) {
> 		pr_info("cpuidle-powernv: missing ibm,cpu-idle-state-residency-ns\n");
> 		residency_ns = 300000;
> 	}

This looks like a better API, but the default residency values are different
for each idle state. So perhaps a patch like the below ?

--------------------------Start Patch------------------------------------------

From: Preeti U Murthy <preeti@linux.vnet.ibm.com>


---
 drivers/cpuidle/cpuidle-powernv.c |   54 +++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 21 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index aedec09..2031560 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -13,6 +13,7 @@
 #include <linux/notifier.h>
 #include <linux/clockchips.h>
 #include <linux/of.h>
+#include <linux/slab.h>
 
 #include <asm/machdep.h>
 #include <asm/firmware.h>
@@ -159,9 +160,9 @@ static int powernv_add_idle_states(void)
 	int nr_idle_states = 1; /* Snooze */
 	int dt_idle_states;
 	const __be32 *idle_state_flags;
-	const __be32 *idle_state_latency;
-	u32 len_flags, flags, latency_ns;
-	int i;
+	u32 len_flags, flags;
+	u32 *latency_ns, *residency_ns;
+	int i, rc;
 
 	/* Currently we have snooze statically defined */
 
@@ -177,34 +178,39 @@ static int powernv_add_idle_states(void)
 		return nr_idle_states;
 	}
 
-	idle_state_latency = of_get_property(power_mgt,
-			"ibm,cpu-idle-state-latencies-ns", NULL);
-	if (!idle_state_latency) {
+	dt_idle_states = len_flags / sizeof(u32);
+
+	latency_ns = kzalloc(sizeof(*latency_ns) * dt_idle_states, GFP_KERNEL);
+	rc = of_property_read_u32(power_mgt,
+			"ibm,cpu-idle-state-latencies-ns", latency_ns);
+	if (rc) {
 		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-latencies-ns\n");
 		return nr_idle_states;
 	}
 
-	dt_idle_states = len_flags / sizeof(u32);
+	residency_ns = kzalloc(sizeof(*residency_ns) * dt_idle_states, GFP_KERNEL);
+	rc = of_property_read_u32(power_mgt,
+			"ibm,cpu-idle-state-residency-ns", residency_ns);
+	if (rc) {
+		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-residency-ns\n");
+		pr_warn("Falling back to default values\n");
+	}
+
 
 	for (i = 0; i < dt_idle_states; i++) {
 
 		flags = be32_to_cpu(idle_state_flags[i]);
-
-		/* Cpuidle accepts exit_latency in us and we estimate
-		 * target residency to be 10x exit_latency
+		/*
+		 * Cpuidle accepts exit_latency and target_residency in us.
+		 * Use default target_residency values if f/w does not expose it.
 		 */
-		latency_ns = be32_to_cpu(idle_state_latency[i]);
 		if (flags & OPAL_PM_NAP_ENABLED) {
 			/* Add NAP state */
 			strcpy(powernv_states[nr_idle_states].name, "Nap");
 			strcpy(powernv_states[nr_idle_states].desc, "Nap");
 			powernv_states[nr_idle_states].flags = 0;
-			powernv_states[nr_idle_states].exit_latency =
-					((unsigned int)latency_ns) / 1000;
-			powernv_states[nr_idle_states].target_residency =
-					((unsigned int)latency_ns / 100);
+			powernv_states[nr_idle_states].target_residency = 100;
 			powernv_states[nr_idle_states].enter = &nap_loop;
-			nr_idle_states++;
 		}
 
 		if (flags & OPAL_PM_SLEEP_ENABLED ||
@@ -213,13 +219,19 @@ static int powernv_add_idle_states(void)
 			strcpy(powernv_states[nr_idle_states].name, "FastSleep");
 			strcpy(powernv_states[nr_idle_states].desc, "FastSleep");
 			powernv_states[nr_idle_states].flags = CPUIDLE_FLAG_TIMER_STOP;
-			powernv_states[nr_idle_states].exit_latency =
-					((unsigned int)latency_ns) / 1000;
-			powernv_states[nr_idle_states].target_residency =
-					((unsigned int)latency_ns / 100);
+			powernv_states[nr_idle_states].target_residency = 300000;
 			powernv_states[nr_idle_states].enter = &fastsleep_loop;
-			nr_idle_states++;
 		}
+
+		powernv_states[nr_idle_states].exit_latency =
+				((unsigned int)latency_ns[i]) / 1000;
+
+		if (!rc) {
+			powernv_states[nr_idle_states].target_residency =
+				((unsigned int)residency_ns[i]) / 1000;
+		}
+
+		nr_idle_states++;
 	}
 
 	return nr_idle_states;

Regards
Preeti U Murthy

> 
> cheers
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 

