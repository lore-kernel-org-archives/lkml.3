Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab3BFVM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:12:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758462Ab3BFVM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:12:27 -0500
Date: Wed, 6 Feb 2013 13:12:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH] rtc: core: Prevent repeated calling of
 alarm_irq_enable().
Message-Id: <20130206131225.83a118fe.akpm@linux-foundation.org>
In-Reply-To: <1360149765-19565-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1360149765-19565-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Feb 2013 20:22:45 +0900
Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:

> This patch removes repeated execution of disabling alarm in
> rtc_alarm_irq_enable() of rtc core interface. It made useless
> call even all alarm had been disabled from rtc_timer_remove().
> We'd better to skip disabling alarm when timer queue is empty.
> 

I fear that patch does more than that.

> --- a/drivers/rtc/interface.c
> +++ b/drivers/rtc/interface.c
> @@ -428,7 +428,7 @@ int rtc_alarm_irq_enable(struct rtc_device *rtc, unsigned int enabled)
>  			rtc_timer_remove(rtc, &rtc->aie_timer);
>  	}
>  
> -	if (err)
> +	if (err || !rtc->timerqueue.next)
>  		/* nothing */;
>  	else if (!rtc->ops)
>  		err = -ENODEV;

This will prevent the irq from being *enabled*, as well as disabled.

To match your description, we'd need to also check that enabled==0?
