Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaIJRo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:44:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39563 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750925AbaIJRo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:44:56 -0400
Date: Wed, 10 Sep 2014 19:44:52 +0200
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@free-electrons.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/8] net: pxa168_eth: fix Ethernet flow control status
Message-ID: <20140910174452.GB27983@kwain>
References: <1410273848-24663-1-git-send-email-antoine.tenart@free-electrons.com>
 <1410273848-24663-5-git-send-email-antoine.tenart@free-electrons.com>
 <20140910153902.GE13342@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140910153902.GE13342@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Wed, Sep 10, 2014 at 05:39:02PM +0200, Andrew Lunn wrote:
> On Tue, Sep 09, 2014 at 04:44:04PM +0200, Antoine Tenart wrote:
> > IEEE 802.3x Ethernet flow control is disabled when bit (1 << 2) is set
> > in the port status register. Fix the flow control detection in the link
> > event handling function which was relying on the opposite assumption.
> > 
> > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> > ---
> >  drivers/net/ethernet/marvell/pxa168_eth.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
> > index 953112f87c5f..10422f2df6cc 100644
> > --- a/drivers/net/ethernet/marvell/pxa168_eth.c
> > +++ b/drivers/net/ethernet/marvell/pxa168_eth.c
> > @@ -163,7 +163,7 @@
> >  /* Bit definitions for Port status */
> >  #define PORT_SPEED_100		(1 << 0)
> >  #define FULL_DUPLEX		(1 << 1)
> > -#define FLOW_CONTROL_ENABLED	(1 << 2)
> > +#define FLOW_CONTROL_DISABLED	(1 << 2)
> >  #define LINK_UP			(1 << 3)
> >  
> >  /* Bit definitions for work to be done */
> > @@ -885,7 +885,7 @@ static void handle_link_event(struct pxa168_eth_private *pep)
> >  		speed = 10;
> >  
> >  	duplex = (port_status & FULL_DUPLEX) ? 1 : 0;
> > -	fc = (port_status & FLOW_CONTROL_ENABLED) ? 1 : 0;
> > +	fc = (port_status & FLOW_CONTROL_DISABLED) ? 0 : 1;
> >  	netdev_info(dev, "link up, %d Mb/s, %s duplex, flow control %sabled\n",
> >  		    speed, duplex ? "full" : "half", fc ? "en" : "dis");
> >  	if (!netif_carrier_ok(dev))
> 
> Could this be a hardware bug which has been fixed in a newer version
> of the IP? It would be good to have this tested on an old platform
> using this driver.

This driver seems to be used by the pxa168 GuruPlug board, and according
to the pxa168 datasheet the flow control status is reported as above (I
checked before sending this patch). I used the software manual
referenced in Documentation/arm/Marvell/README.

This is also the case for the Ethernet controller of the Berlin SoCs.

I could only test on the Berlin BG2Q. I can't be sure this was not a
hardware bug, but at least this is consistent with the pxa168 platform
using the driver. All other registers controlling this flow control
capability also enable on 0.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
