Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaKFEN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:13:27 -0500
Received: from mail-bn1bon0082.outbound.protection.outlook.com ([157.56.111.82]:21028
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751141AbaKFENZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:13:25 -0500
Date: Wed, 5 Nov 2014 20:13:12 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Heiko Stuebner <heiko@sntech.de>, <linux-sh@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-rockchip@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Olof Johansson <olof@lixom.net>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>
Subject: Re: [PATCH 0/7] Pinctrl support for Zynq
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
 <5459BC1C.3000807@suse.de>
 <44de30f0237545c6b62871d6c0480a67@BY2FFO11FD050.protection.gbl>
 <545AF05A.1040300@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <545AF05A.1040300@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21078.002
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <149f300f05ec4a28bed74212a7b01529@BY2FFO11FD005.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(24454002)(189002)(51704005)(377424004)(21056001)(46102003)(44976005)(87936001)(54356999)(104016003)(50986999)(93886004)(83506001)(85182001)(76176999)(31966008)(107046002)(95666004)(85202003)(99396003)(62966003)(77096003)(106466001)(110136001)(120916001)(64706001)(20776003)(77156002)(4396001)(6806004)(86362001)(19580395003)(108616004)(53416004)(92566001)(74316001)(102836001)(47776003)(575784001)(50466002)(23676002)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB018;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB018;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0387D64A71
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-06 at 04:51AM +0100, Andreas Färber wrote:
> Am 05.11.2014 um 18:03 schrieb Sören Brinkmann:
> > On Wed, 2014-11-05 at 06:56AM +0100, Andreas Färber wrote:
> >> I've tracked down all 54 MIO pins of the Parallella and cooked up the
> >> equivalent DT patch. [...] For testing purposes I've configured a
> >> heartbeat trigger for the USER_LED (CR10).
> >>
> >> To my disappointment these pinctrl additions did not fix one issue:
> >> Whenever a write access to be handled by the bitstream (0x808f0f04) is
> >> performed, the board hangs and the heartbeat stops. Would a bug in the
> >> bitstream allow this to happen, or are more drivers missing to actually
> >> make use of the PL in general? With a downstream ADI/Xilinx 3.12 kernel
> >> that problem does not surface.
> > 
> > This doesn't sound like being related to pinctrl at all.
> > Devices in the PL are just memory mapped on the AXI bus. There is
> > nothing needed to access those. Hangs do in most cases indicate that the
> > IP does not respond (properly). In my experience this is mostly caused
> > by 
> >  - level shifters not enabled
> >  - IP kept in reset
> >  - IP is clock gated
> > With the clock gating being the culprit in most cases. Did you check
> > those things?
> 
> Figured it out: zynq-7000.dtsi sets fclk-enable = <0>, i.e., all PL
> clocks are disabled by default. When overriding that tiny property with
> 0xf it suddenly works as expected! I'll send a patch later in the day.
> 
> Are boards expected to use clocks = <&clkc 15>, ...; on individual nodes
> relying on the PL? Or does enabling those clocks require actually
> loading a bitstream so that it is not being done by default?

Clocks are under control of drivers. Drivers are supposed to
use the clock framework to enable the clocks they use. The fclk-enable
is just a work around to enable driver-less IP and similar.

So, if your FPGA part has proper drivers, you should add the appropriate
description in DT and the drivers would need to use the CCF to enable
the clocks. Otherwise you can work around this by specifying
fclk-enable.

	Sören
