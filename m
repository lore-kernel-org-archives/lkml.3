Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaAXKSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 05:18:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41076 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaAXKSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 05:18:48 -0500
Date: Fri, 24 Jan 2014 11:18:39 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Peter Chen <peter.chen@freescale.com>
Cc: Chris Ruehl <chris.ruehl@gtsys.com.hk>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: Regression on next-20140116 [Was: [PATCH 3/3 v4] usb: chipidea:
 hw_phymode_configure moved before ci_usb_phy_init]
Message-ID: <20140124101839.GA26766@pengutronix.de>
References: <1386057710-3848-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <1386057710-3848-3-git-send-email-chris.ruehl@gtsys.com.hk>
 <20140122094951.GO26766@pengutronix.de>
 <20140122214133.GP26766@pengutronix.de>
 <20140123012240.GA8679@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140123012240.GA8679@shlinux1.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter,

On Thu, Jan 23, 2014 at 09:22:41AM +0800, Peter Chen wrote:
> On Wed, Jan 22, 2014 at 10:41:33PM +0100, Uwe Kleine-König wrote:
> > On Wed, Jan 22, 2014 at 10:49:51AM +0100, Uwe Kleine-König wrote:
> > > On Tue, Dec 03, 2013 at 04:01:50PM +0800, Chris Ruehl wrote:
> > > > usb: chipidea: hw_phymode_configure moved before ci_usb_phy_init
> > > > hw_phymode_configure configures the PORTSC registers and allow the
> > > > following phy_inits to operate on the right parameters. This fix a problem
> > > > where the UPLI (ISP1504) could not detected, because the Viewport was not
> > > > available and read the viewport return 0's only.
> > > This patch (or a later revision of it to be more exact) made it into
> > > mainline as cd0b42c2a6d2.
> > > 
> > > On an i.MX27 based machine I'm hitting an oops (see below) on
> > > next-20140116 + a few patches. (I didn't switch to 3.13+ yet, as I think
> > > not everything I need has landed there.) The oops goes away (and still
> > > better, lsusb reports my connected devices instead of "unable to
> > > initialize libusb: -99") when I do at least one of the following:
> > > 
> > >  - set CONFIG_USB_CHIPIDEA=y instead of =m
> > >  - revert commit
> > >       cd0b42c2a6d2 (usb: chipidea: put hw_phymode_configure before ci_usb_phy_init)
> > I debugged that a bit further and the problem is that
> > hw_phymode_configure depends on the phy's clk being enabled (i.e.
> > usb_ipg_gate) and this is only enforced in ci_usb_phy_init (via
> > usb_phy_init -> usb_gen_phy_init). When CONFIG_USB_CHIPIDEA=y the init
> > call to disable all unused clocks wasn't run yet and so the clock is
> > still on as this is the boot default.
> 
> I am a little puzzled at your platform
> 
> - Which phy you have used? ulpi phy ,internal phy or other external phy?
I'm using an ISP1504 (i.e. ULPI) phy.

> - If you use ulpi phy, why you still need to use nop phy driver?
I don't need to, that's just how I made it running. If you have a better
suggestion, don't hesitate to tell me. :-)

>  Besides, according to chris patch, the ulpi can only be visited after
> hw_phymode_configure?
It seems so, yes. For writing the PORTSC register the usb_ipg_gate clock
must be on. hw_phymode_configure writes the register and ci_usb_phy_init
enables the clock.

> - Do you have some hardware related operation at phy's probe? If it exists,
> why not move it to phy->init?
I guess that would work and the culprit is that I just took Chris' patch
because I don't have a clue about USB.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
