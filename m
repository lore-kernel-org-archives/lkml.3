Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaHOPlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:41:16 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:44388 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaHOPlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:41:15 -0400
MIME-Version: 1.0
In-Reply-To: <1408086085-16691-2-git-send-email-chuansheng.liu@intel.com>
References: <1408086085-16691-1-git-send-email-chuansheng.liu@intel.com> <1408086085-16691-2-git-send-email-chuansheng.liu@intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 15 Aug 2014 08:40:53 -0700
Message-ID: <CALCETrUQ7x+kPYewNSUeAX5=0yVmqYWca9XCXtUbM0SNZ2ou+Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] smp: re-implement the kick_all_cpus_sync() with wake_up_if_idle()
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liu, Changcheng" <changcheng.liu@intel.com>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Chakravarty, Souvik K" <souvik.k.chakravarty@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 12:01 AM, Chuansheng Liu
<chuansheng.liu@intel.com> wrote:
> Currently using smp_call_function() just woke up the corresponding
> cpu, but can not break the polling idle loop.
>
> Here using the new sched API wake_up_if_idle() to implement it.

kick_all_cpus_sync has other callers, and those other callers want the
old behavior.  I think this should be a new function.

--Andy

>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> ---
>  kernel/smp.c |   18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/smp.c b/kernel/smp.c
> index aff8aa1..0b647c3 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -13,6 +13,7 @@
>  #include <linux/gfp.h>
>  #include <linux/smp.h>
>  #include <linux/cpu.h>
> +#include <linux/sched.h>
>
>  #include "smpboot.h"
>
> @@ -677,10 +678,6 @@ void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
>  }
>  EXPORT_SYMBOL(on_each_cpu_cond);
>
> -static void do_nothing(void *unused)
> -{
> -}
> -
>  /**
>   * kick_all_cpus_sync - Force all cpus out of idle
>   *
> @@ -694,8 +691,15 @@ static void do_nothing(void *unused)
>   */
>  void kick_all_cpus_sync(void)
>  {
> -       /* Make sure the change is visible before we kick the cpus */
> -       smp_mb();
> -       smp_call_function(do_nothing, NULL, 1);
> +       int cpu;
> +
> +       preempt_disable();
> +       for_each_online_cpu(cpu) {
> +               if (cpu == smp_processor_id())
> +                       continue;
> +
> +               wake_up_if_idle(cpu);
> +       }
> +       preempt_enable();
>  }
>  EXPORT_SYMBOL_GPL(kick_all_cpus_sync);
> --
> 1.7.9.5
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
