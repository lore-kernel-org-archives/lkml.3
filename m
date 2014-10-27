Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaJ0WNn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:13:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:40871 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaJ0WNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:13:41 -0400
Date: Mon, 27 Oct 2014 23:13:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "pang.xunlei" <pang.xunlei@linaro.org>
cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH RFC 05/12] time: Convert rtc_tm_to_time_unsafe() to
 rtc_tm_to_time() in rtc_hctosys()
In-Reply-To: <alpine.DEB.2.11.1410272244270.5308@nanos>
Message-ID: <alpine.DEB.2.11.1410272312000.5308@nanos>
References: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org> <1414388802-5866-4-git-send-email-pang.xunlei@linaro.org> <alpine.DEB.2.11.1410272244270.5308@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2014, Thomas Gleixner wrote:

> On Mon, 27 Oct 2014, pang.xunlei wrote:
> > The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, so it
> > will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.
> 
> We really know that by now. No need to repeat that for every patch. 
>  
> > As part of addressing 2038 saftey for in-kernel uses, this patch creates no functional change
> > in existing users, and converts rtc_tm_to_time_unsafe() to rtc_tm_to_time() in rtc_hctosys().
> 
> Please line break your changelogs properly. That's how it should look
> like:
> 
> > As part of addressing 2038 saftey for in-kernel uses, this patch
> > creates no functional change in existing users, and converts
> > rtc_tm_to_time_unsafe() to rtc_tm_to_time() in rtc_hctosys().
>  
> Can you spot the difference?
> 
> > @@ -26,9 +26,10 @@ static int __init rtc_hctosys(void)
> >  {
> >  	int err = -ENODEV;
> >  	struct rtc_time tm;
> > -	struct timespec tv = {
> > +	struct timespec64 tv = {
> >  		.tv_nsec = NSEC_PER_SEC >> 1,
> >  	};
> > +	struct timespec ts32;
> 
> So this is exactly why I dislike this whole flag day conversion
> thing. If you add
> 
>        rtc_tm_to_time64()
>        do_settimeofday64()
> 
> in the first place, you can convert the whole function in one go
> without introducing intermediate variables which then need to be
> undone later again.

Aside of that ts32 is a complete misnomer because on 64 bit struct
timespec already has a 64bit seconds representation.

Thanks,

	tglx
