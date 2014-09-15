Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaIOPEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 11:04:44 -0400
Received: from mail-bn1bn0105.outbound.protection.outlook.com ([157.56.110.105]:16410
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751847AbaIOPEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 11:04:40 -0400
Date: Mon, 15 Sep 2014 22:48:05 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
CC: Fabio Estevam <festevam@gmail.com>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V1 1/3] ARM: clk-imx6sl: refine clock tree for SSI
Message-ID: <20140915144803.GL18566@dragon>
References: <cover.1410253534.git.shengjiu.wang@freescale.com>
 <7ed21195ebff8b3ccbecaeb492504edd28deea2d.1410253534.git.shengjiu.wang@freescale.com>
 <CAOMZO5A4FLbA_+u4oMTqgAY69DaF93V=oLiy+op=tEHbagF1pg@mail.gmail.com>
 <CAOMZO5DJZHKAV4Y9aUwMNWZqhoLrKrsZdYnKqPem2ZSy=-oAYw@mail.gmail.com>
 <20140915115855.GC23877@audiosh1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140915115855.GC23877@audiosh1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(24454002)(51704005)(74502001)(97756001)(74662001)(83506001)(33716001)(81542001)(86362001)(102836001)(50466002)(106466001)(77982001)(21056001)(4396001)(90102001)(92726001)(31966008)(85852003)(64706001)(23726002)(33656002)(76482001)(104016003)(46102001)(95666004)(92566001)(79102001)(57986006)(110136001)(26826002)(83072002)(46406003)(83322001)(84676001)(81342001)(105606002)(80022001)(87936001)(68736004)(20776003)(93886004)(44976005)(47776003)(107046002)(76176999)(50986999)(6806004)(85306004)(54356999)(99396002)(97736003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB329;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03355EE97E
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 07:58:56PM +0800, Shengjiu Wang wrote:
> I add IMX6QDL_CLK_SSIx in this patch, which use share count with 
> IMX6QDL_CLK_SSIx_IPG. The SSI driver sound/soc/fsl/fsl_ssi.c will enable
> IMX6QDL_CLK_SSIx_IPG clock in probe, but don't disable it. In the end of kernel
> boot up, some one(it is not ssi driver, maybe is the clock tree) will disable
> the IMX6QDL_CLK_SSIx clock, which is not enabled. IMX6QDL_CLK_SSIx_IPG share
> the enable/disable bit with IMX6QDL_CLK_SSIx, So IMX6QDL_CLK_SSIx_IPG is 
> disabled, the aplay will fail.
> 
> Is this the issue of imx_clk_gate2_shared()? When we want to disable IMX6QDL_CLK_SSIx,
> but IMX6QDL_CLK_SSIx_IPG is enabled, can IMX6QDL_CLK_SSIx be disabled?
> 
> 
> Shawn
> 
>    How do you think about this?

Shengjiu,

Your analysis is right.  I hope the following change will get the shared
gate clock code eventually does the right thing.

Shawn

diff --git a/arch/arm/mach-imx/clk-gate2.c b/arch/arm/mach-imx/clk-gate2.c
index 84acdfd1d715..89abdf738dc9 100644
--- a/arch/arm/mach-imx/clk-gate2.c
+++ b/arch/arm/mach-imx/clk-gate2.c
@@ -97,7 +97,7 @@ static int clk_gate2_is_enabled(struct clk_hw *hw)
        struct clk_gate2 *gate = to_clk_gate2(hw);

        if (gate->share_count)
-               return !!(*gate->share_count);
+               return !!__clk_get_enable_count(hw->clk);
        else
                return clk_gate2_reg_is_enabled(gate->reg, gate->bit_idx);
 }
