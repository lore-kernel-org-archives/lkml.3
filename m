Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbbANWxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 17:53:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43203 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbbANWxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 17:53:09 -0500
Date: Wed, 14 Jan 2015 14:53:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Doug Anderson <dianders@chromium.org>, Chris Zhong <zyw@rock-chips.com>,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RTC: RK808: fix the rtc time reading issue
Message-Id: <20150114145307.380c86a83c65760a046382e4@linux-foundation.org>
In-Reply-To: <CAPz6YkWe9tkn7BehGOurbq6omvTpYi170G0z6T+OijngOADRQQ@mail.gmail.com>
References: <1421203412-5159-1-git-send-email-zyw@rock-chips.com>
	<CAPz6YkW4icehT6P9EicP1Eww_Ny0hNaeS53WXaFei+HrYbPQ3A@mail.gmail.com>
	<CAD=FV=UDj08jkOCDVJ1Q+EanrBHwP_-88XMXojPjY8iB3i-AQA@mail.gmail.com>
	<CAPz6YkWe9tkn7BehGOurbq6omvTpYi170G0z6T+OijngOADRQQ@mail.gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015 11:44:02 -0800 Sonny Rao <sonnyrao@chromium.org> wrote:

> On Wed, Jan 14, 2015 at 10:36 AM, Doug Anderson <dianders@chromium.org> wrote:
> > Sonny,
> >
> >> Chris, it looks like you swapped the set and the clear of this bit,
> >> and you're relying on the fact that the i2c transaction takes a
> >> certain amount of time after the RTC_GET_TIME BIT is set.   I'm not
> >> sure how long it actually takes, but why not just put in a usleep()
> >> for the minimum wait time?
> >
> > I think we are safe.
> >
> > At 400kHz (the max speed of this part) each bit can be transferred no
> > faster than 2.5us.  In order to do a valid i2c transaction we need to
> > _at least_ write the address of the device and the data onto the bus,
> > which is 16 bits.  16 * 2.5us = 40us.  That's above the 31.25us
> >
> > Personally I think what Chris has is fine, with the comment.
> 
> Ok, I'm fine with that if we're sure it's slow enough.  Comment
> explaining would certainly help.

Thanks, all.  I did this:

--- a/drivers/rtc/rtc-rk808.c~rtc-rk808-fix-the-rtc-time-reading-issue-fix
+++ a/drivers/rtc/rtc-rk808.c
@@ -73,10 +73,11 @@ static int rk808_rtc_readtime(struct dev
 		return ret;
 	}
 
-	/* After we set the GET_TIME bit, the rtc time couldn't be read
-	 * immediately, we should wait up to 31.25 us, about one cycle of
+	/*
+	 * After we set the GET_TIME bit, the rtc time can't be read
+	 * immediately. So we should wait up to 31.25 us, about one cycle of
 	 * 32khz. If we clear the GET_TIME bit here, the time of i2c transfer
-	 * certainly more than 31.25us.
+	 * certainly more than 31.25us: 16 * 2.5us at 400kHz bus frequency.
 	 */
 	ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
 				 BIT_RTC_CTRL_REG_RTC_GET_TIME,
_

