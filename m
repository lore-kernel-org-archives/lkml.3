Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbaIWSdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:33:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:49408 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaIWSdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:33:40 -0400
Date: Tue, 23 Sep 2014 20:33:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Joonwoo Park <joonwoop@codeaurora.org>
cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 RESEND/RFC] timer: make deferrable cpu unbound timers
 really not bound to a cpu
In-Reply-To: <1410836376-27267-1-git-send-email-joonwoop@codeaurora.org>
Message-ID: <alpine.DEB.2.10.1409231808110.4604@nanos>
References: <1410836376-27267-1-git-send-email-joonwoop@codeaurora.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2014, Joonwoo Park wrote:
> +#ifdef CONFIG_SMP
> +static struct tvec_base *tvec_base_deferral = &boot_tvec_bases;
> +#endif

In principle I like the idea of a deferrable wheel, but this
implementation is going to go nowhere.

First of all making it SMP only is silly. The deferrable stuff is a
pain in other places as well.

But whats way worse is:

> +static inline void __run_timers(struct tvec_base *base, bool try)
>  {
>  	struct timer_list *timer;
>  
> -	spin_lock_irq(&base->lock);
> +	if (!try)
> +		spin_lock_irq(&base->lock);
> +	else if (!spin_trylock_irq(&base->lock))
> +		return;

Yuck. All cpus fighting about a single spinlock roughly at the same
time? You just created a proper thundering herd cacheline bouncing
issue. 

No way. We have already mechanisms in place to deal with such
problems, you just have to use them.

Thanks,

	tglx
