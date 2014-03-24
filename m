Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaCXEpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 00:45:08 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:64980 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaCXEpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 00:45:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140323150754.272874059@linutronix.de>
References: <20140323150557.288925975@linutronix.de>
	<20140323150754.272874059@linutronix.de>
Date: Mon, 24 Mar 2014 10:15:02 +0530
X-Google-Sender-Auth: igX7NszJvOrrh-cc2BIhUBN3dDw
Message-ID: <CAOh2x==n-TW4DizybTA5Y_b4Xfc_bX5ArnNjg4HhtaBBT2P98g@mail.gmail.com>
Subject: Re: [patch 15/16] cpufreq: intel-pstate: Use del_timer_sync in intel_pstate_cpu_exit()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        cpufreq <cpufreq@vger.kernel.org>, pm <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 8:39 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> We are about to free the data structure. Make sure no timer callback
> is running. I might be paranoid, but the ->exit callback can be
> invoked from so many places, that it is not entirely clear whether
> del_timer is always called on the cpu on which it is enqueued.

In normal cases it will be called only when CPU goes offline and I
hope that isn't called on the dying CPU.

> While looking through the call sites I noticed, that
> cpufreq_init_policy() can fail and invoke cpufreq_driver->exit() but
> it does not return the failure and the callsite happily proceeds.

Thanks for reporting this, will get it fixed.

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: cpufreq <cpufreq@vger.kernel.org>
> Cc: pm <linux-pm@vger.kernel.org>
> ---
>
>  drivers/cpufreq/intel_pstate.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: tip/drivers/cpufreq/intel_pstate.c
> ===================================================================
> --- tip.orig/drivers/cpufreq/intel_pstate.c
> +++ tip/drivers/cpufreq/intel_pstate.c
> @@ -777,7 +777,7 @@ static int intel_pstate_cpu_exit(struct
>  {
>         int cpu = policy->cpu;
>
> -       del_timer(&all_cpu_data[cpu]->timer);
> +       del_timer_sync(&all_cpu_data[cpu]->timer);

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
