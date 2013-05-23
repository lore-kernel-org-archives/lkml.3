Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab3EWSli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 14:41:38 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:46847 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757245Ab3EWSlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 14:41:37 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/01N8q9jmNSJ0GspWvwHAMvBprEiYq6/4=
Date: Thu, 23 May 2013 14:40:28 -0400
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
Message-ID: <20130523184028.GU31290@titan.lakedaemon.net>
References: <1369154510-4927-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369253042-15082-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1369253042-15082-2-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130522201607.GA18823@obsidianresearch.com>
 <20130523160111.GP31290@titan.lakedaemon.net>
 <20130523171112.GB31281@obsidianresearch.com>
 <20130523172339.GQ31290@titan.lakedaemon.net>
 <20130523175357.GB2821@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523175357.GB2821@obsidianresearch.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 11:53:57AM -0600, Jason Gunthorpe wrote:
> On Thu, May 23, 2013 at 01:23:39PM -0400, Jason Cooper wrote:
> 
> > Shouldn't it rather be
> > 
> > 	compatible = "marvell,kirkwood-eth", "marvell,orion-eth";
> 
> Not sure about orion-eth?
>  
> > I'm inclined to go with of_machine_is_compatible() since the only
> > concrete difference we know is that the tweak is needed on kirkwood and
> > nowhere else.
> 
> But there is a larger problem here then just this one bit.
> 
> The PSC1 register must be set properly for the board layout, and today
> we rely on the bootloader to set it. In fact, even with Sebastian's
> change the ethernet port won't work without bootloader
> intervention. The PortReset bit should also be cleared by the driver
> (and it is only present on some variants of this IP block,
> apparently).
> 
> We know that some Marvell SOC's wack the ethernet registers when they
> clock gate, and the flip of Clk125Bypass is another symptom of this
> general problem.
> 
> So, long term, the PSC1 must be fully set by the driver, based on DT
> information describing the board (eg RGMII/MII/1000Base-X [SFP] Phy
> type), and the layout of this register seems to vary on a SOC by SOC
> basis.
> 
> Thus, I think it is appropriate to call this variant of the eth IP
> 'marvell,kirkwood-eth' which indicates that the register block follows
> the kirkwood manual and the PSC1 register specifically has the
> kirkwood layout.

Ok, so mv643xx_eth would match both "marvell,orion-eth" and
"marvell,kirkwood-eth", then write to PSC1 iff it sees a node matching
"marvell,kirkwood-eth".  I'm not too keen on that, however, the matching
of the machine doesn't look to good, either.

Perhaps a better answer is to add a boolean, "marvell,kirkwood_psc1" and
check for that?

Or, marvell,psc1_reset = <0xWWXXYYZZ>;

> The question is what other Marvell SOCs have the same PSC1 layout as
> kirkwood?

I think marvell,psc1_reset = <>; gives us the most flexibility in
accurately describing the hardware.

thx,

Jason.
