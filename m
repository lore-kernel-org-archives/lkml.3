Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaD1JgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:36:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39145 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaD1JgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:36:23 -0400
Date: Mon, 28 Apr 2014 11:36:19 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Daniel Willmann <daniel@totalueberwachung.de>,
        Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH] mmc: mxs: fix card detection function for broken card
 detect
Message-ID: <20140428093619.GP5858@pengutronix.de>
References: <dec3cef26b7470cabfc11a83750a88db5b545a41.1397944151.git.daniel@totalueberwachung.de>
 <20140428091341.GA5918@pengutronix.de>
 <CAPDyKFqP_cDTyC38+8XDPLWN0C6wWs9e6iZD06nkb_LqqLjjnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFqP_cDTyC38+8XDPLWN0C6wWs9e6iZD06nkb_LqqLjjnw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:35:15 up 5 days,  3:06, 41 users,  load average: 0.02, 0.06, 0.09
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 11:31:03AM +0200, Ulf Hansson wrote:
> On 28 April 2014 11:13, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > On Sat, Apr 19, 2014 at 11:59:18PM +0200, Daniel Willmann wrote:
> >> Return -ENOSYS in get_cd if broken-cd is specified in the device tree.
> >>
> >> Commit a91fe279ae75 (mmc: mxs: use standard flag for broken card
> >> detection) sets MMC_CAP_NEEDS_POLL when broken-cd is specified. This
> >> driver sets this flag unconditionally as it does not support a card
> >> detect interrupt. Instead, broken-cd means that there is no card detect
> >> signal connected.
> >>
> >> The mmc core checks the get_cd function return value to determine if a
> >> card is present. Only for a non-zero return value it will attempt to
> >> initialize the card. So retuning -ENOSYS will allow the card to be
> >> initialized.
> >> For comparison, mmc_gpio_get_cd in slot-gpio.c also returns -ENOSYS if
> >> the card detect GPIO is not valid.
> >
> > Short answer for fixing this regression:
> >
> > Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> >
> > Long answer:
> >
> > This is broken in the MMC OF parser. When the parser finds the
> > 'broken-cd' property it just sets the MMC_CAP_NEEDS_POLL flag. This is
> > wrong.  broken-cd means that we cannot rely on any card detection, but
> > instead have to talk to the card to find out if it's available.
> > Currently there is no flag to signal this situation, so the host driver
> > has to handle this by returning true in the get_cd callback, just like
> > the patch below does.
> >
> > IMO the correct solution would be to add a MMC_CAP_CD_NEEDS_TALK_TO_CARD
> > flag to the core.
> >
> 
> So if I understand correct, you want the host-ops->get_cd function to
> be invoked from the mmc rescan - only when it actually can provide
> useful information?

Yes.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
