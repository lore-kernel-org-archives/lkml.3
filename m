Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbbATLNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:13:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:47963 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbbATLNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:13:52 -0500
Date: Tue, 20 Jan 2015 12:13:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
cc: John Stultz <john.stultz@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] clocksource: don't suspend/resume when unused
In-Reply-To: <1421427439-11699-3-git-send-email-alexandre.belloni@free-electrons.com>
Message-ID: <alpine.DEB.2.11.1501201153140.5526@nanos>
References: <1421427439-11699-1-git-send-email-alexandre.belloni@free-electrons.com> <1421427439-11699-3-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015, Alexandre Belloni wrote:

> There is no point in calling suspend/resume for unused
> clocksources.

That's true, but ....
 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  kernel/time/clocksource.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index 03cfc5a08e3b..da65b3b73a86 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -493,7 +493,7 @@ void clocksource_suspend(void)
>  	struct clocksource *cs;
>  
>  	list_for_each_entry_reverse(cs, &clocksource_list, list)
> -		if (cs->suspend)
> +		if (cs->suspend && (cs->flags & CLOCK_SOURCE_USED))
>  			cs->suspend(cs);
>  }
>  
> @@ -505,7 +505,7 @@ void clocksource_resume(void)
>  	struct clocksource *cs;
>  
>  	list_for_each_entry(cs, &clocksource_list, list)
> -		if (cs->resume)
> +		if (cs->resume && (cs->flags & CLOCK_SOURCE_USED))
>  			cs->resume(cs);

I had a deeper look at the clocksources which have a resume
callback. We have implementations, which rely on the resume callback
being called unconditionally. e.g.: arch/x86/kernel/hpet.c. And there
are a few others which have extra PM code in the suspend/resume path
independent of the fact whether the clocksource is enabled or not.

So we really need to make this opt-in with a per clocksource flag.

Thanks,

	tglx
