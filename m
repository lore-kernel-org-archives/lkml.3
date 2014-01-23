Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbaAWCH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 21:07:28 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:47264
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752734AbaAWCH1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 21:07:27 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dIc89bhe0eah1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz17326ah1de097h186068hz2dh2a8h839h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h1155h)
Date: Thu, 23 Jan 2014 09:22:41 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Chris Ruehl <chris.ruehl@gtsys.com.hk>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: Regression on next-20140116 [Was: [PATCH 3/3 v4] usb:
 chipidea: hw_phymode_configure moved before ci_usb_phy_init]
Message-ID: <20140123012240.GA8679@shlinux1.ap.freescale.net>
References: <1386057710-3848-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <1386057710-3848-3-git-send-email-chris.ruehl@gtsys.com.hk>
 <20140122094951.GO26766@pengutronix.de>
 <20140122214133.GP26766@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20140122214133.GP26766@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 10:41:33PM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Wed, Jan 22, 2014 at 10:49:51AM +0100, Uwe Kleine-König wrote:
> > On Tue, Dec 03, 2013 at 04:01:50PM +0800, Chris Ruehl wrote:
> > > usb: chipidea: hw_phymode_configure moved before ci_usb_phy_init
> > > hw_phymode_configure configures the PORTSC registers and allow the
> > > following phy_inits to operate on the right parameters. This fix a problem
> > > where the UPLI (ISP1504) could not detected, because the Viewport was not
> > > available and read the viewport return 0's only.
> > This patch (or a later revision of it to be more exact) made it into
> > mainline as cd0b42c2a6d2.
> > 
> > On an i.MX27 based machine I'm hitting an oops (see below) on
> > next-20140116 + a few patches. (I didn't switch to 3.13+ yet, as I think
> > not everything I need has landed there.) The oops goes away (and still
> > better, lsusb reports my connected devices instead of "unable to
> > initialize libusb: -99") when I do at least one of the following:
> > 
> >  - set CONFIG_USB_CHIPIDEA=y instead of =m
> >  - revert commit
> >       cd0b42c2a6d2 (usb: chipidea: put hw_phymode_configure before ci_usb_phy_init)
> I debugged that a bit further and the problem is that
> hw_phymode_configure depends on the phy's clk being enabled (i.e.
> usb_ipg_gate) and this is only enforced in ci_usb_phy_init (via
> usb_phy_init -> usb_gen_phy_init). When CONFIG_USB_CHIPIDEA=y the init
> call to disable all unused clocks wasn't run yet and so the clock is
> still on as this is the boot default.

Hi Uwe,
I am a little puzzled at your platform

- Which phy you have used? ulpi phy ,internal phy or other external phy?
- If you use ulpi phy, why you still need to use nop phy driver?
 Besides, according to chris patch, the ulpi can only be visited after
hw_phymode_configure?
- Do you have some hardware related operation at phy's probe? If it exists,
why not move it to phy->init?

Peter

> 
> Considering that it's already late today and that I don't know the
> chipidea driver I'm sure there are people who can come up with a better
> patch with less effort than me. Any volunteers?
> 
> Best regards
> Uwe
> 
> -- 
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> 
> 

-- 

Best Regards,
Peter Chen

