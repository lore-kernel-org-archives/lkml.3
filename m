Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab3EXQr6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 12:47:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:52342 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab3EXQr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 12:47:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19h0O6gJeYqVid3XGtew2XuNUb0ji8GMv8=
Date: Fri, 24 May 2013 12:46:36 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 2/2] net: mv643xx_eth: proper initialization for
 Kirkwood SoCs
Message-ID: <20130524164636.GV31290@titan.lakedaemon.net>
References: <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369253042-15082-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369253042-15082-2-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130522201607.GA18823@obsidianresearch.com>
 <20130523160111.GP31290@titan.lakedaemon.net>
 <20130523171112.GB31281@obsidianresearch.com>
 <20130523172339.GQ31290@titan.lakedaemon.net>
 <20130523175357.GB2821@obsidianresearch.com>
 <20130523184028.GU31290@titan.lakedaemon.net>
 <20130523190140.GA4010@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523190140.GA4010@obsidianresearch.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 01:01:40PM -0600, Jason Gunthorpe wrote:
> On Thu, May 23, 2013 at 02:40:28PM -0400, Jason Cooper wrote:
> 
> > > But there is a larger problem here then just this one bit.
> > > 
> > > The PSC1 register must be set properly for the board layout, and today
> > > we rely on the bootloader to set it. In fact, even with Sebastian's
> > > change the ethernet port won't work without bootloader
> > > intervention. The PortReset bit should also be cleared by the driver
> > > (and it is only present on some variants of this IP block,
> > > apparently).
> > > 
> > > We know that some Marvell SOC's wack the ethernet registers when they
> > > clock gate, and the flip of Clk125Bypass is another symptom of this
> > > general problem.
> > > 
> > > So, long term, the PSC1 must be fully set by the driver, based on DT
> > > information describing the board (eg RGMII/MII/1000Base-X [SFP] Phy
> > > type), and the layout of this register seems to vary on a SOC by SOC
> > > basis.
> > > 
> > > Thus, I think it is appropriate to call this variant of the eth IP
> > > 'marvell,kirkwood-eth' which indicates that the register block follows
> > > the kirkwood manual and the PSC1 register specifically has the
> > > kirkwood layout.
> > 
> > Ok, so mv643xx_eth would match both "marvell,orion-eth" and
> > "marvell,kirkwood-eth", then write to PSC1 iff it sees a node matching
> > "marvell,kirkwood-eth".  I'm not too keen on that, however, the matching
> > of the machine doesn't look to good, either.
> 
> Why are you not keen on this? It seems like normal device driver
> practice, that is what the data field of of_device_id is typically
> used for..

I'm not keen on it because we don't have a document saying "All kirkwood
SoCs need PSC1 set to X after reset."  We know it, but have we tested
the 6282?

That being said, if "marvell,kirkwood-eth" is the best we can do for
now, I'm all for it.  I would just like to be reasonably certain that
the binding we are creating doesn't lock us into a difficult decision
later.

> There are more compatible strings than just kirkwood and orion in this
> driver, the whole TX_BW_CONTROL_OLD_LAYOUT/TX_BW_CONTROL_NEW_LAYOUT
> buisness (affecting PPC/MIPS) should also someday be captured with
> compatible strings rather than auto-detection too..

Agreed.

> > > The question is what other Marvell SOCs have the same PSC1 layout as
> > > kirkwood?
> > 
> > I think marvell,psc1_reset = <>; gives us the most flexibility in
> > accurately describing the hardware.
> 
> Agree, providing psc1_reset value is a good idea to setup the phy
> modes. If all 'orion' SOCs have the PSC1 value then we don't need the
> kirkwood differentiators, especially if things like the reset bit are
> in the same place.
> 
> The same trick Sebastian used to capture the mac address could be used
> to capture the PSC1 value from the bootloader.
> 
> Basically, I think any IP variants that have idential register layouts
> can share a compatible string, otherwise different layouts need
> different compatible strings, so the general format:
> 
>  compatible = "marvell,SOCNAME-eth", "marvell,<something>-eth";
> 
> Seems very sane to me. At least this way if we discover more changes
> then the driver can match on the SOCNAME compatible string to find
> them.

After glancing a LinusW's email, I'm thinking this isn't the correct
path.  I'll write more in my response to him.

thx,

Jason.
