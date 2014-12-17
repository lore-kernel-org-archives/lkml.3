Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaLQVvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 16:51:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaLQVvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 16:51:51 -0500
Date: Wed, 17 Dec 2014 13:51:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hyogi Gim <hyogi.gim@lge.com>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/rtc/interface.c: check the error after
 __rtc_read_time()
Message-Id: <20141217135150.b02a4581cebd819f0f8f078a@linux-foundation.org>
In-Reply-To: <20141217031524.GA22361@lge.com>
References: <20141217031524.GA22361@lge.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014 12:15:24 +0900 Hyogi Gim <hyogi.gim@lge.com> wrote:

> Add the verification code for returned __rtc_read_time() error in
> rtc_update_irq_enable() and rtc_timer_do_work().
> 
> ...
L
> --- a/drivers/rtc/interface.c
> +++ b/drivers/rtc/interface.c
> @@ -489,7 +489,10 @@ int rtc_update_irq_enable(struct rtc_device *rtc, unsigned int enabled)
>  		struct rtc_time tm;
>  		ktime_t now, onesec;
>  
> -		__rtc_read_time(rtc, &tm);
> +		err = __rtc_read_time(rtc, &tm);
> +		if (err < 0)
> +			goto out;
> +
>  		onesec = ktime_set(1, 0);
>  		now = rtc_tm_to_ktime(tm);
>  		rtc->uie_rtctimer.node.expires = ktime_add(now, onesec);

I'm not sure about this part.  If __rtc_read_time() returns -EINVAL
(due to !rtc->ops->read_time) then rtc_update_irq_enable() will go and
call rtc_dev_update_irq_enable_emul(), inappropriately.

On the other hand, if __rtc_read_time() returns -EINVAL because that's
what rtc->ops->read_time() returned then perhaps
rtc_update_irq_enable() *should* call rtc_dev_update_irq_enable_emul().

Messy.

