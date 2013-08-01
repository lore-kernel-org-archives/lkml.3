Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab3HAICp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:02:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166Ab3HAICm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:02:42 -0400
Date: Thu, 1 Aug 2013 10:02:40 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kbuild test robot <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, kbuild-all@01.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [mmotm:master 69/312] kernel/watchdog.c:518:2: error: implicit
 declaration of function '__smp_call_function_single'
Message-ID: <20130801080240.GA1534@dhcp22.suse.cz>
References: <51f9aee9.oN9jdesofL65t+iX%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51f9aee9.oN9jdesofL65t+iX%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-08-13 08:42:17, Wu Fengguang wrote:
> tree:   git://git.cmpxchg.org/linux-mmotm.git master
> head:   01db8fe7b3c8461274e4c9257789514987e7abc8
> commit: 5701031ddea61c051fb8309cbf372dd94e540f22 [69/312] watchdog: update watchdog_tresh properly
> config: i386-randconfig-c00-0801 (attached as .config)
> 
> All error/warnings:
> 
>    kernel/watchdog.c: In function 'update_timers':
> >> kernel/watchdog.c:518:2: error: implicit declaration of function '__smp_call_function_single' [-Werror=implicit-function-declaration]
>      __smp_call_function_single(cpu, &data, 1);
>      ^
>    cc1: some warnings being treated as errors
> 
> vim +/__smp_call_function_single +518 kernel/watchdog.c
> 
>    512		 * be much nicer but we do not have an API for that now so
>    513		 * let's use a big hammer.
>    514		 * Hrtimer will adopt the new period on the next tick but this
>    515		 * might be late already so we have to restart the timer as well.
>    516		 */
>    517		watchdog_nmi_disable(cpu);
>  > 518		__smp_call_function_single(cpu, &data, 1);
>    519		watchdog_nmi_enable(cpu);
>    520	}
>    521	

Ohh, !CONFIG_SMP

The patch below should fix up the mess. Sorry about that. I have added
this UP config to my testing configs.

Andrew, could you pick up the following patch, please?
---
>From 94048cdb5f8370987a08ea07289854a4eb41d57b Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 1 Aug 2013 09:50:28 +0200
Subject: [PATCH] include/linux/smp.h: define __smp_call_function_single for
 !CONFIG_SMP

This function was not needed until (watchdog: update watchdog_tresh
properly) which cannot use on_each_cpu unfortunately as
watchdog_nmi_enable relies on perf_event_alloc which is might sleep.

Export it as an alias to on_each_cpu for !CONFIG_SMP.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/smp.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index c848876..3d12d72 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -151,6 +151,12 @@ static inline int on_each_cpu(smp_call_func_t func, void *info, int wait)
 	return 0;
 }
 
+static inline void __smp_call_function_single(int cpuid,
+		struct call_single_data *data, int wait)
+{
+	on_each_cpu(data->func, data->info, wait);
+}
+
 /*
  * Note we still need to test the mask even for UP
  * because we actually can get an empty mask from
-- 
1.8.3.2

-- 
Michal Hocko
SUSE Labs
