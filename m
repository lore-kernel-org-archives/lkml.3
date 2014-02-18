Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbaBRIYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 03:24:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50299 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbaBRIYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 03:24:40 -0500
Date: Tue, 18 Feb 2014 09:24:36 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: zbr@ioremap.net
Cc: "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] w1-gpio: handle of_get_gpio() returning -EPROBE_DEFER
 better
Message-ID: <20140218082436.GC32652@pengutronix.de>
References: <1392329128-6221-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <380901392686780@web3m.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <380901392686780@web3m.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 05:26:20AM +0400, zbr@ioremap.net wrote:
> Hi
> 
> 14.02.2014, 02:05, "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>:
> > of_get_gpio() might return -EPROBE_DEFER meaning that the driver
> > providing the gpio isn't ready yet. If that happens for the first gpio
> > the resulting kernel output without this patch is:
> >
> >         w1-gpio somename: Failed to parse DT
> >         platform somename: Driver w1-gpio requests probe deferral
> >
> > The first message is misleading and so is suppressed with this patch.
> >
> > Further if determining the gpio to switch the external pullup yields
> > -EPROBE_DEFER this error should be passed back to the caller instead of
> > just continuing without pullup.
> >
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> I'm ok with this patch, but I virtually do not understand what it does :)
> Since I know nothing about device trees.
The thing is that the w1-gpio device might be probed before the gpio's
controller is available. In this case of_get_gpio returns -EPROBE_DEFER
and this makes the device core retry probing the w1-gpio device later
again. So this is not a dt-parsing problem but just dependency stuff.

The 2nd issue addressed didn't happen to me, but it might occur that the
first of_get_gpio for the data pin succeeds, but the getting the pullup
gpio fails with -EPROBE_DEFER (e.g. because it sits on a different
controller). In this case you still want to retry probing later instead
of ignoring the problem.
 
Does that make it clearer?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
