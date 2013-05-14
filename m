Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab3ENGOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 02:14:25 -0400
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:46139 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751177Ab3ENGOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 02:14:23 -0400
Date: Tue, 14 May 2013 07:52:56 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, michal.simek@xilinx.com,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        s.trumtrar@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH] net/macb: fix ISR clear-on-write behavior only for
 some SoC
Message-ID: <20130514055256.GD22508@game.jcrosoft.org>
References: <1368461105-23128-1-git-send-email-nicolas.ferre@atmel.com>
 <FE065E51-1EAA-47ED-8C7B-0F2E6418F349@jcrosoft.com>
 <51918C23.7040106@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51918C23.7040106@yahoo.es>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 15153768321699392502
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:58 Tue 14 May     , Hein Tibosch wrote:
> On 5/14/2013 12:05 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On May 14, 2013, at 12:05 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> >
> >> Commit 749a2b6 (net/macb: clear tx/rx completion flags in ISR)
> >> introduces clear-on-write on ISR register. This behavior is not always
> >> implemented when using Cadence MACB/GEM and is breaking other platforms.
> >> We are using a new Device Tree compatibility string and a capability
> >> property to actually activate this clear-on-write behavior on ISR.
> >>
> >> Reported-by: Hein Tibosch <hein_tibosch@yahoo.es>
> >> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > can we detect it via the IP?
> 
> This was my first proposal, have it based on the value of MACB's
> register 'MID' (offset 0x00fc, lower 16 bits).
> On avr32 it reads: 0x0000010D, on Zynq it reports 0x00000119
> 
> So for the moment, CAPS_ISR_CLEAR_ON_WRITE could be set if the revision
> equals to 0x00000119?
so no it will not work

as the gem on sama5 is 00020119

so version 0x119 too

nico 
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
> 
> >> ---
> >> Documentation/devicetree/bindings/net/macb.txt |  2 ++
> >> drivers/net/ethernet/cadence/macb.c            | 15 +++++++++++++--
> >> drivers/net/ethernet/cadence/macb.h            |  5 +++++
> >> 3 files changed, 20 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
> >> index 44afa0e..13ec4f6 100644
> >>
> >> <snip>
> >>
> >> @@ -1474,6 +1476,10 @@ static const struct of_device_id macb_dt_ids[] = {
> >> 	{ .compatible = "cdns,macb" },
> >> 	{ .compatible = "cdns,pc302-gem" },
> >> 	{ .compatible = "cdns,gem" },
> >> +	{
> >> +		.compatible = "cdns,zynq-7000-gem",
> >> +		.data = (void *)MACB_CAPS_ISR_CLEAR_ON_WRITE,
> >> +	},
> >> 	{ /* sentinel */ }
> >> };
> >> MODULE_DEVICE_TABLE(of, macb_dt_ids);
> >> @@ -1484,6 +1490,7 @@ static int __init macb_probe(struct platform_device *pdev)
> >> 	struct macb_platform_data *pdata;
> >> 	struct resource *regs;
> >> 	struct net_device *dev;
> >> +	const struct of_device_id *dev_id;
> >> 	struct macb *bp;
> >> 	struct phy_device *phydev;
> >> 	u32 config;
> >> @@ -1558,6 +1565,10 @@ static int __init macb_probe(struct platform_device *pdev)
> >>
> >> 	dev->base_addr = regs->start;
> >>
> >> +	dev_id = of_match_device(macb_dt_ids, &pdev->dev);
> As avr32 doesn't yet define CONFIG_OF:
>     macb.c:1601: error:  'macb_dt_ids' undeclared
> 
> Hein
