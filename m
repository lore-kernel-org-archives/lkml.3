Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbbAVD60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:58:26 -0500
Received: from mail-by2on0124.outbound.protection.outlook.com ([207.46.100.124]:7328
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750796AbbAVD6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:58:16 -0500
X-Greylist: delayed 1066 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Jan 2015 22:58:15 EST
Date: Thu, 22 Jan 2015 11:32:05 +0800
From: Robin Gong <b38343@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] dma: imx-sdma: switch to dynamic context mode after
 script loaded
Message-ID: <20150122033204.GA6133@Robin-OptiPlex-780>
References: <1421125757-10794-1-git-send-email-b38343@freescale.com>
 <20150120071614.GI18220@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150120071614.GI18220@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(51704005)(24454002)(199003)(243025005)(189002)(23726002)(19580405001)(97736003)(33656002)(105606002)(104016003)(77156002)(46406003)(83506001)(50986999)(97756001)(85426001)(19580395003)(87936001)(6806004)(110136001)(575784001)(2950100001)(92566002)(54356999)(76176999)(33716001)(68736005)(106466001)(47776003)(46102003)(64706001)(15975445007)(50466002)(77096005)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB326;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BLUPR03MB326;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR03MB326;
X-Forefront-PRVS: 0464DBBBC4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB326;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2015 03:24:32.8052
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR03MB326
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 08:16:14AM +0100, Sascha Hauer wrote:
> On Tue, Jan 13, 2015 at 01:09:17PM +0800, Robin Gong wrote:
> > Below comments got from Page4724 of Reference Manual of i.mx6q:
> > http://cache.freescale.com/files/32bit/doc/ref_manual/IMX6DQRM.pdf
> > 
> > --"Static context mode should be used for the first channel called
> > after reset to ensure that the all context RAM for that channel is
> > initialized during the context SAVE phase when the channel is
> > done or yields. Subsequent calls to the same channel or
> > different channels may use any of the dynamic context modes.
> > This will ensure that all context locations for the bootload
> > channel are initialized, and prevent undefined values in context
> > RAM from being loaded during the context restore if the
> > channel is re-started later"
> > 
> > Unfortunately, the rule was broken by commit(5b28aa319bba96987316425a1131813d87cbab35)
> > .This patch just take them back.
> > 
> > Signed-off-by: Robin Gong <b38343@freescale.com>
> > ---
> >  drivers/dma/imx-sdma.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> > index d0df198..510e463 100644
> > --- a/drivers/dma/imx-sdma.c
> > +++ b/drivers/dma/imx-sdma.c
> > @@ -1323,6 +1323,10 @@ static void sdma_load_firmware(const struct firmware *fw, void *context)
> >  	sdma_load_script(sdma, ram_code,
> >  			header->ram_code_size,
> >  			addr->ram_code_start_addr);
> > +
> > +	/* Set bits of CONFIG register with given context switching mode */
> > +	writel_relaxed(SDMA_H_CONFIG_CSM, sdma->regs + SDMA_H_CONFIG);
> > +
> 
> You move the CONFIG register initialization to a place which may never
> be called. Look at the top of sdma_load_firmware:
> 
> 	if (!fw) {
> 		dev_info(sdma->dev, "external firmware not found, using ROM firmware\n");
> 		/* In this case we just use the ROM firmware. */
> 		return;
> 	}
> 
> Sascha
>
Yes. I'll move it into sdma_run_channel0.
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
