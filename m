Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaLaMNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 07:13:42 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:49484 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaLaMNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 07:13:41 -0500
Date: Wed, 31 Dec 2014 13:13:26 +0100
From: Olivier Sobrie <olivier@sobrie.be>
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] can: kvaser_usb: Add support for the Usbcan-II family
Message-ID: <20141231121307.GA32553@hposo>
Reply-To: Olivier Sobrie <olivier@sobrie.be>
References: <20141223154654.GB6460@vivalin-002>
 <20141223155311.GA5997@vivalin-002>
 <CAEM=fMqNnq9QYLiR8WXJ0wN2V=1B1TouxaLB_JLrYOtKvwxBkA@mail.gmail.com>
 <20141224150417.GB5707@vivalin-002>
 <20141228215134.GA2548@thinkoso.home>
 <20141230153326.GA3798@linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141230153326.GA3798@linux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 10:33:26AM -0500, Ahmed S. Darwish wrote:
> On Sun, Dec 28, 2014 at 10:51:34PM +0100, Olivier Sobrie wrote:
> [...]
> > > > >  
> > > > > +	if (LEAF_PRODUCT_ID(id->idProduct)) {
> > > > > +		dev->family = KVASER_LEAF;
> > > > > +		dev->max_channels = LEAF_MAX_NET_DEVICES;
> > > > > +	} else if (USBCAN_PRODUCT_ID(id->idProduct)) {
> > > > > +		dev->family = KVASER_USBCAN;
> > > > > +		dev->max_channels = USBCAN_MAX_NET_DEVICES;
> > > > > +	} else {
> > > > > +		dev_err(&intf->dev, "Product ID (%d) does not belong to any "
> > > > > +				    "known Kvaser USB family", id->idProduct);
> > > > > +		return -ENODEV;
> > > > > +	}
> > > > > +
> > > > 
> > > > Is it really required to keep max_channels in the kvaser_usb structure?
> > > > If I looked correctly, you use this variable as a replacement for
> > > > MAX_NET_DEVICES in the code and MAX_NET_DEVICES is only used in probe
> > > > and disconnect functions. I think it can even be replaced by nchannels
> > > > in the disconnect path. So I also think that it don't need to be in the
> > > > kvaser_usb structure.
> > > > 
> > > 
> > > hmmm.. given the current state of error arbitration explained
> > > above, where I cannot accept a dev->nchannels > 2, I guess we
> > > have two options:
> > > 
> > > a) Remove max_channels, and hardcode the channels count
> > > correctness logic as follows:
> > > 
> > >         dev->nchannels = msg.u.cardinfo.nchannels;
> > >         if ((dev->family == USBCAN && dev->nchannels > USBCAN_MAX_NET_DEVICES)
> > >             || (dev->family == LEAF && dev->nchannels > LEAF_MAX_NET_DEVICES))
> > >                 return -EINVAL
> > > 
> > > b) Leave max_channels in 'struct kvaser_usb' as is.
> > > 
> > > I personally prefer the solution at 'b)' but I can do it as
> > > in 'a)' if you prefer :-)
> > 
> > Keeping max_channels in the kvaser_usb structure is useless because it
> > is only used in one function that is called in the probe function.
> > 
> > I would prefer to have:
> > 	if (dev->nchannels > MAX_NET_DEVICES)
> > 		return -EINVAL
> > 
> > 	if ((dev->family == USBCAN) &&
> > 	    (dev->nchannels > MAX_USBCAN_NET_DEVICES))
> > 		return -EINVAL
> > 
> > You can remove LEAF_MAX_NET_DEVICES which is not used, keep
> > MAX_NET_DEVICES equals to 3 and remove the MAX() macro.
> > The test specific to the USBCAN family can eventually be moved in the
> > kvaser_usb_probe() function.
> > 
> 
> Quite nice, will do it that way in v3.
> 

Thank you.
Please also check your patches with scripts/checkpatch.pl.
I see several warnings when I run it. Please fix them.

All the best for New Year's Eve,

-- 
Olivier
