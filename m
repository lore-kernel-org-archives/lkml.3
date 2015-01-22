Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbbAVLBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:01:52 -0500
Received: from www.linutronix.de ([62.245.132.108]:59088 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbbAVLBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:01:46 -0500
Date: Thu, 22 Jan 2015 12:01:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Olliver Schinagl <o.schinagl@ultimaker.com>
cc: linux-kernel@vger.kernel.org, Olliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH] hrtimer: add hrtimer_start_now()
In-Reply-To: <1421907161-5744-1-git-send-email-o.schinagl@ultimaker.com>
Message-ID: <alpine.DEB.2.11.1501221153320.5526@nanos>
References: <1421907161-5744-1-git-send-email-o.schinagl@ultimaker.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015, Olliver Schinagl wrote:

> From: Olliver Schinagl <oliver@schinagl.nl>
> 
> When using a hrtimer for repeating periodic ticks, hrtimer_forward_now()
> is often used. Quite possibly the timer loop is thus probably fully
> controlled by hrtimer_forward_now() and we don't really care when the
> timer is started. With hrtimer_start() we need to define exactly when a
> event has to start. By introducing hrtimer_start_now() we do the same as
> what hrtimer_forward_now() does, start as soon as possible and get into
> the timer loop.
 
> Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
> ---
>  include/linux/hrtimer.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> index a036d05..080a5f5 100644
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -353,6 +353,12 @@ static inline void destroy_hrtimer_on_stack(struct hrtimer *timer) { }
>  /* Basic timer operations: */
>  extern int hrtimer_start(struct hrtimer *timer, ktime_t tim,
>  			 const enum hrtimer_mode mode);
> +
> +static inline int hrtimer_start_now(struct hrtimer *timer,
> +				    const enum hrtimer_mode mode)
> +{
> +	return hrtimer_start(timer, timer->base->get_time(), mode);
> +}

What's the mode argument for? How is this supposed to do what you
want:

       hrtimer_start_now(timer, HRTIMER_MODE_REL);

Aside of that, what's wrong with doing:

      static const ktime_t ktime_zero = { .tv64 = 0 };

      hrtimer_start(timer, ktime_zero, HRTIMER_MODE_REL);

Thanks,

	tglx
