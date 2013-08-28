Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab3H1BsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 21:48:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52119 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3H1BsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 21:48:10 -0400
Date: Tue, 27 Aug 2013 18:43:29 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Zoran Markovic <zoran.markovic@linaro.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Arve Hjonnevag <arve@android.com>, Todd Poynor <toddpoynor@google.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC PATCH] pm: prevent suspend until power supply events are
 processed
Message-ID: <20130828014328.GG10506@lizard>
References: <1375475882-3660-1-git-send-email-zoran.markovic@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1375475882-3660-1-git-send-email-zoran.markovic@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 01:38:02PM -0700, Zoran Markovic wrote:
> This patch, originally authored by Arve Hjonnevag and Todd Poynor,
> prevents the system from entering suspend mode until the power
> supply plug, unplug, or any other change of state event is fully
> processed. This guarantees that the screen lights up and displays
> the battery charging state. The implementation uses the power
> supply wakeup_source object.
> 
> Cc: Anton Vorontsov <anton@enomsg.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Arve Hjonnevag <arve@android.com>
> Cc: Todd Poynor <toddpoynor@google.com>
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
> ---
...
> +		kobject_uevent(&psy->dev->kobj, KOBJ_CHANGE);
> +		spin_lock_irqsave(&psy->changed_lock, flags);
> +	}
> +	/* dependent power supplies (e.g. battery) may have changed

Multi-line comments style issue...

> +	 * state as a result of this event, so poll again and hold
> +	 * the wakeup_source until all events are processed.
> +	 */
> +	if (!psy->changed)
> +		pm_relax(psy->dev);
...
> diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
> index 804b906..253d412 100644
> --- a/include/linux/power_supply.h
> +++ b/include/linux/power_supply.h
> @@ -194,6 +194,8 @@ struct power_supply {
>  	/* private */
>  	struct device *dev;
>  	struct work_struct changed_work;
> +	spinlock_t changed_lock;

#include <linux/spinlock.h> is needed.

I fixed it up and applied the patch, thanks a lot!

Anton
