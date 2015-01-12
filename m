Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbbALNZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:25:28 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35831 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbbALNZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:25:25 -0500
Date: Mon, 12 Jan 2015 14:25:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Andrzej Hajda <a.hajda@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 08/19] leds: Add support for max77693 mfd flash
 cell
Message-ID: <20150112132521.GA15838@amd>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-9-git-send-email-j.anaszewski@samsung.com>
 <20150109184606.GJ18076@amd>
 <54B38B55.7080503@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B38B55.7080503@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>+struct max77693_sub_led {
> >>+	/* related FLED output identifier */
> >
> >->flash LED, about 4x.
> >
> >>+/* split composite current @i into two @iout according to @imax weights */
> >>+static void __max77693_calc_iout(u32 iout[2], u32 i, u32 imax[2])
> >>+{
> >>+	u64 t = i;
> >>+
> >>+	t *= imax[1];
> >>+	do_div(t, imax[0] + imax[1]);
> >>+
> >>+	iout[1] = (u32)t / FLASH_IOUT_STEP * FLASH_IOUT_STEP;
> >>+	iout[0] = i - iout[1];
> >>+}
> >
> >Is 64-bit arithmetics neccessary here? Could we do the FLASH_IOUT_STEP
> >divisons before t *=, so that 64-bit division is not neccessary?
> 
> It is required. All these operations allow for splitting the composite
> current into both outputs according to weights given in the imax
>array.

I know.

What about this?

static void __max77693_calc_iout(u32 iout[2], u32 i, u32 imax[2])
{
	u32 t = i;

	t *= imax[1] / FLASH_IOUT_STEP;
	t = t / (imax[0] + imax[1]);
	t /= FLASH_IOUT_STEP

	iout[1] = (u32)t;
	iout[0] = i - iout[1];
}

Does it lack precision?

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
