Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937209Ab3DJX6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:58:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934950Ab3DJX6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:58:02 -0400
Date: Wed, 10 Apr 2013 16:58:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Derek Basehore <dbasehore@chromium.org>
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Don't disable hpet emulation on suspend
Message-Id: <20130410165801.ec54e0fdb27e11724f5646bc@linux-foundation.org>
In-Reply-To: <1365554173-24475-1-git-send-email-dbasehore@chromium.org>
References: <1365554173-24475-1-git-send-email-dbasehore@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Apr 2013 17:36:13 -0700 Derek Basehore <dbasehore@chromium.org> wrote:

> There's a bug where rtc alarms are ignored after the rtc cmos suspends but
> before the system finishes suspend. Since hpet emulation is disabled and it
> still handles the interrupts, a wake event is never registered which is done
> from the rtc layer. This reverts an earlier commit which disables hpet
> emulation. To fix the problem mentioned in that commit, the hpet_rtc_timer_init
> function is called directly on resume.
> 
> This reverts commit d1b2efa83fbf7b33919238fa29ef6ab935820103.
> 
> ...
>
> --- a/drivers/rtc/rtc-cmos.c
> +++ b/drivers/rtc/rtc-cmos.c
> @@ -804,9 +804,8 @@ static int cmos_suspend(struct device *dev)
>  			mask = RTC_IRQMASK;
>  		tmp &= ~mask;
>  		CMOS_WRITE(tmp, RTC_CONTROL);
> +		hpet_mask_rtc_irq_bit(mask);
>  
> -		/* shut down hpet emulation - we don't need it for alarm */
> -		hpet_mask_rtc_irq_bit(RTC_PIE|RTC_AIE|RTC_UIE);
>  		cmos_checkintr(cmos, tmp);
>  	}
>  	spin_unlock_irq(&rtc_lock);
> @@ -870,6 +869,7 @@ static int cmos_resume(struct device *dev)
>  			rtc_update_irq(cmos->rtc, 1, mask);
>  			tmp &= ~RTC_AIE;
>  			hpet_mask_rtc_irq_bit(RTC_AIE);
> +			hpet_rtc_timer_init();
>  		} while (mask & RTC_AIE);
>  		spin_unlock_irq(&rtc_lock);
>  	}

huh, so it's been broken for three years.

This calls hpet_rtc_timer_init() under spin_lock_irq() which is OK with
the current implementation.  And things should be OK when
CONFIG_HPET_EMULATE_RTC=n.

Maxim, can you please review/test/etc?
