Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057Ab3HNTEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:04:23 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:52947 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab3HNTEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:04:21 -0400
Message-ID: <520BD4BD.3010300@cogentembedded.com>
Date: Wed, 14 Aug 2013 23:04:29 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Fan Du <fan.du@windriver.com>
CC: tglx@linutronix.de, Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Daniel Borkmann <dborkman@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCHv3 linux-next] hrtimer: Add notifier when clock_was_set
 was called
References: <1375866296-15079-1-git-send-email-fan.du@windriver.com> <1375866296-15079-2-git-send-email-fan.du@windriver.com> <52021177.6020306@redhat.com> <520213F2.5090401@windriver.com> <520214C6.6000307@redhat.com> <520B4552.2000607@windriver.com>
In-Reply-To: <520B4552.2000607@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/14/2013 12:52 PM, Fan Du wrote:

>  From e3929d4fdfad5b40fd8cad0e217597670d1aef54 Mon Sep 17 00:00:00 2001
> From: Fan Du <fan.du@windriver.com>
> Date: Wed, 14 Aug 2013 16:39:23 +0800
> Subject: [PATCHv3 linux-next] hrtimer: Add notifier when clock_was_set was called

    This header is not needed.

> When clock_was_set is called in case of system wall time change
> or host resume from suspend state, use this notifier for places
> where interested in this action, e.g Ipsec SA lifetime management.

> Signed-off-by: Fan Du <fan.du@windriver.com>

> v3:
>    -Beautify notifier with register/unregister API exported for other subsystem.

[...]

> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> index d19a5c2..f0404e4 100644
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -461,4 +461,7 @@ extern u64 ktime_divns(const ktime_t kt, s64 div);
>   /* Show pending timers: */
>   extern void sysrq_timer_list_show(void);
>
> +extern int register_clock_change_notifier(struct notifier_block *nb);
> +extern int unregister_clock_change_notifier(struct notifier_block *nb);
> +
>   #endif
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 383319b..c6e6405 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -755,6 +755,24 @@ static inline void retrigger_next_event(void *arg) { }
>
>   #endif /* CONFIG_HIGH_RES_TIMERS */
>
> +static ATOMIC_NOTIFIER_HEAD(clock_change_notifier_list);
> +static int call_clock_change_notifiers(void)
> +{
> +    return atomic_notifier_call_chain(&clock_change_notifier_list, 0, 0);
> +}
> +
> +int register_clock_change_notifier(struct notifier_block *nb)
> +{
> +    return atomic_notifier_chain_register(&clock_change_notifier_list, nb);
> +}
> +EXPORT_SYMBOL_GPL(register_clock_change_notifier);
> +
> +int unregister_clock_change_notifier(struct notifier_block *nb)
> +{
> +    return atomic_notifier_chain_unregister(&clock_change_notifier_list, nb);
> +}
> +EXPORT_SYMBOL_GPL(unregister_clock_change_notifier);
> +
>   /*
>    * Clock realtime was set
>    *
> @@ -773,6 +791,7 @@ void clock_was_set(void)
>       on_each_cpu(retrigger_next_event, NULL, 1);
>   #endif
>       timerfd_clock_was_set();
> +    call_clock_change_notifiers();
>   }

    Your patch seems whitepsace damaged, i.e. a space is added before each 
line starting with space.

WBR, Sergei

