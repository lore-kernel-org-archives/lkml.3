Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594AbaAOEtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 23:49:01 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34247 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaAOEs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 23:48:59 -0500
Message-ID: <52D61333.8060705@linaro.org>
Date: Wed, 15 Jan 2014 12:48:51 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Michael wang <wangyun@linux.vnet.ibm.com>, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, daniel.lezcano@linaro.org,
        vincent.guittot@linaro.org, morten.rasmussen@arm.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH] sched: find the latest idle cpu
References: <1389758879-19951-1-git-send-email-alex.shi@linaro.org> <52D60F11.3070005@linux.vnet.ibm.com>
In-Reply-To: <52D60F11.3070005@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 12:31 PM, Michael wang wrote:
> Hi, Alex
> 
> On 01/15/2014 12:07 PM, Alex Shi wrote:
> [snip] 		}
>> +#ifdef CONFIG_NO_HZ_COMMON
>> +		/*
>> +		 * Coarsely to get the latest idle cpu for shorter latency and
>> +		 * possible power benefit.
>> +		 */
>> +		if (!min_load) {

here should be !load.
>> +			struct tick_sched *ts = &per_cpu(tick_cpu_sched, i);
>> +
>> +			s64 latest_wake = 0;
> 
> I guess we missed some code for latest_wake here?

Yes, thanks for reminder!

so updated patch:

====

>From c3a88e73fed3da96549b5a922076e996832685f8 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@linaro.org>
Date: Tue, 14 Jan 2014 23:07:42 +0800
Subject: [PATCH] sched: find the latest idle cpu

Currently we just try to find least load cpu. If some cpus idled,
we just pick the first cpu in cpu mask.

In fact we can get the interrupted idle cpu or the latest idled cpu,
then we may get the benefit from both latency and power.
The selected cpu maybe not the best, since other cpu may be interrupted
during our selecting. But be captious costs too much.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/fair.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c7395d9..73a2a07 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4167,6 +4167,31 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 			min_load = load;
 			idlest = i;
 		}
+#ifdef CONFIG_NO_HZ_COMMON
+		/*
+		 * Coarsely to get the latest idle cpu for shorter latency and
+		 * possible power benefit.
+		 */
+		if (!load) {
+			struct tick_sched *ts = &per_cpu(tick_cpu_sched, i);
+
+			s64 latest_wake = 0;
+			/* idle cpu doing irq */
+			if (ts->inidle && !ts->idle_active)
+				idlest = i;
+			/* the cpu resched */
+			else if (!ts->inidle)
+				idlest = i;
+			/* find latest idle cpu */
+			else {
+				s64 temp = ktime_to_us(ts->idle_entrytime);
+				if (temp > latest_wake) {
+					latest_wake = temp;
+					idlest = i;
+				}
+			}
+		}
+#endif
 	}
 
 	return idlest;
-- 
1.8.1.2

-- 
Thanks
    Alex
