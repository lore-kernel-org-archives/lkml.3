Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaAVVlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 16:41:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39753 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaAVVlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 16:41:44 -0500
Date: Wed, 22 Jan 2014 22:41:33 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: peter.chen@freescale.com, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: Regression on next-20140116 [Was: [PATCH 3/3 v4] usb: chipidea:
 hw_phymode_configure moved before ci_usb_phy_init]
Message-ID: <20140122214133.GP26766@pengutronix.de>
References: <1386057710-3848-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <1386057710-3848-3-git-send-email-chris.ruehl@gtsys.com.hk>
 <20140122094951.GO26766@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140122094951.GO26766@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 22, 2014 at 10:49:51AM +0100, Uwe Kleine-König wrote:
> On Tue, Dec 03, 2013 at 04:01:50PM +0800, Chris Ruehl wrote:
> > usb: chipidea: hw_phymode_configure moved before ci_usb_phy_init
> > hw_phymode_configure configures the PORTSC registers and allow the
> > following phy_inits to operate on the right parameters. This fix a problem
> > where the UPLI (ISP1504) could not detected, because the Viewport was not
> > available and read the viewport return 0's only.
> This patch (or a later revision of it to be more exact) made it into
> mainline as cd0b42c2a6d2.
> 
> On an i.MX27 based machine I'm hitting an oops (see below) on
> next-20140116 + a few patches. (I didn't switch to 3.13+ yet, as I think
> not everything I need has landed there.) The oops goes away (and still
> better, lsusb reports my connected devices instead of "unable to
> initialize libusb: -99") when I do at least one of the following:
> 
>  - set CONFIG_USB_CHIPIDEA=y instead of =m
>  - revert commit
>       cd0b42c2a6d2 (usb: chipidea: put hw_phymode_configure before ci_usb_phy_init)
I debugged that a bit further and the problem is that
hw_phymode_configure depends on the phy's clk being enabled (i.e.
usb_ipg_gate) and this is only enforced in ci_usb_phy_init (via
usb_phy_init -> usb_gen_phy_init). When CONFIG_USB_CHIPIDEA=y the init
call to disable all unused clocks wasn't run yet and so the clock is
still on as this is the boot default.

Considering that it's already late today and that I don't know the
chipidea driver I'm sure there are people who can come up with a better
patch with less effort than me. Any volunteers?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
