Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbaKQKmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:42:03 -0500
Received: from mail-by2on0106.outbound.protection.outlook.com ([207.46.100.106]:37376
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751880AbaKQKl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:41:59 -0500
From: Yao Yuan <yao.yuan@freescale.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: "marex@denx.de" <marex@denx.de>,
        "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "fugang.duan@freescale.com" <fugang.duan@freescale.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH v9 3/3] i2c: imx: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v9 3/3] i2c: imx: add DMA support for freescale i2c
 driver
Thread-Index: AQHP5UJmutB+SZP4EUmRPSL8mRUifZxXKi+AgA2c5sA=
Date: Mon, 17 Nov 2014 10:41:56 +0000
Message-ID: <BL2PR03MB33877C76779D5588D1B3E30838B0@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1413025032-14958-1-git-send-email-yao.yuan@freescale.com>
 <1413025032-14958-4-git-send-email-yao.yuan@freescale.com>
 <20141108173513.GA4900@katana>
In-Reply-To: <20141108173513.GA4900@katana>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB370;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB370;
x-forefront-prvs: 03982FDC1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(13464003)(164054003)(189002)(377454003)(51704005)(76576001)(99286002)(64706001)(31966008)(20776003)(74316001)(105586002)(54356999)(95666004)(106116001)(54606007)(107046002)(76176999)(110136001)(106356001)(46102003)(50986999)(66066001)(4396001)(92566001)(92726001)(77156002)(62966003)(122556002)(19580405001)(99396003)(120916001)(54206007)(101416001)(21056001)(19580395003)(86362001)(40100003)(97736003)(33656002)(87936001)(2656002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB370;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB131;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your review.
Your suggestions is really helpful.

I will correct them in v10.

Best Regards,
Yuan Yao

> -----Original Message-----
> From: Wolfram Sang [mailto:wsa@the-dreams.de]
> Sent: Sunday, November 09, 2014 1:35 AM
> To: Yuan Yao-B46683
> Cc: marex@denx.de; LW@KARO-electronics.de; mark.rutland@arm.com; Duan
> Fugang-B38611; shawn.guo@linaro.org; linux-kernel@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org; linux-i2c@vger.kernel.org
> Subject: Re: [PATCH v9 3/3] i2c: imx: add DMA support for freescale i2c
> driver
> 
> Hi,
> 
> mostly looking good...
> 
> > +#define IMX_I2C_DMA_THRESHOLD	16
> 
> Have you guessed or measured this value? A comment about this value would
> be nice.
> 
> >
> > +struct imx_i2c_dma {
> > +	struct dma_chan		*chan_tx;
> > +	struct dma_chan		*chan_rx;
> > +	struct dma_chan		*chan_using;
> > +	struct completion	cmd_complete;
> > +	dma_addr_t		dma_buf;
> > +	unsigned int		dma_len;
> > +	unsigned int		dma_transfer_dir;
> > +	unsigned int		dma_data_dir;
> 
> Please use proper types as there are things like 'enum
> dma_data_direction' and the likes...
> 
> > +	dmaengine_submit(txdesc);
> 
> This can fail, too. Use dma_submit_error() to check.
> 
> > +	result = wait_for_completion_interruptible_timeout(
> > +				&i2c_imx->dma->cmd_complete,
> > +				msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
> 
> Have you tested signals extensively? I can't really recommend the
> _intrruptible_ here. I don't see any cleaning up to get the bus to a
> consistent state again. Most people drop the interruptible sooner or
> later.
> 
> > +	/* Init DMA config if support*/
> > +	i2c_imx_dma_request(i2c_imx, phy_addr);
> 
> Make this function void? DMA is optional anyhow.
> 
> Thanks,
> 
>    Wolfram

