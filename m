Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbaGaGRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:17:20 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:12394
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752292AbaGaGRS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:17:18 -0400
From: Yao Yuan <yao.yuan@freescale.com>
To: Marek Vasut <marex@denx.de>,
        =?iso-8859-1?Q?Lothar_Wa=DFmann?= <LW@karo-electronics.de>
CC: Varka Bhadram <varkabhadram@gmail.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH v5 1/2] i2c: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v5 1/2] i2c: add DMA support for freescale i2c driver
Thread-Index: AQHPplZGZJt1rYr+30mdcMiYBrLa6JutadwAgAAUuKCAAANtgIAAEMcAgABNooCAC92bUA==
Date: Thu, 31 Jul 2014 06:16:55 +0000
Message-ID: <1a4d2e9ddc67421d8588305c927f3d3d@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com>
 <53CF9933.8030908@gmail.com> <20140723141502.2d726afe@ipc1.ka-ro>
 <201407231852.53893.marex@denx.de>
In-Reply-To: <201407231852.53893.marex@denx.de>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(377454003)(479174003)(189002)(199002)(24454002)(51704005)(83072002)(81342001)(31966008)(74662001)(74502001)(101416001)(50986999)(106116001)(64706001)(93886003)(66066001)(86362001)(95666004)(19580395003)(85852003)(105586002)(92566001)(76176999)(20776003)(81542001)(99286002)(19580405001)(80022001)(85306003)(83322001)(106356001)(76482001)(21056001)(99396002)(87936001)(46102001)(33646002)(77982001)(74316001)(54356999)(107046002)(76576001)(79102001)(2656002)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB337;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:3;LANG:en;
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Vasut wrote:
> On Wednesday, July 23, 2014 at 02:15:02 PM, Lothar Waßmann wrote:
> > Hi,
> >
> > Varka Bhadram wrote:
> > > On 07/23/2014 04:41 PM, Yao Yuan wrote:
> > > > Hi,
> > > >
> > > > Thanks for your review.
> > > >
> > > > Lothar Waßmann wrote:
> > > >> Yuan Yao wrote:
> > > >>> Add dma support for i2c. This function depend on DMA driver.
> > > >>> You can turn on it by write both the dmas and dma-name
> > > >>> properties in dts node.
> > > >>>
> > > >>> Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> > > >>> ---
> > > >>>
> > > >>>   drivers/i2c/busses/i2c-imx.c | 377
> > > >
> > > > [...]
> > > >
> > > >>> +
> > > >>> +fail_rx:
> > > >>> +	dma_release_channel(dma->chan_rx);
> > > >>> +fail_tx:
> > > >>> +	dma_release_channel(dma->chan_tx);
> > > >>> +fail_al:
> > > >>> +	devm_kfree(dev, dma);
> > > >>
> > > >> No need for this one (that's the whole point of using devm_kzalloc())!
> > > >
> > > > When DMA request failed, I2C will switch to PIO mode. So if the
> > > > failed reason is just like DMA channel request failed. At this
> > > > time the DMA should free by devm_kfree(). Is it?
> > >
> > > If probe failed the memory will be freed automatically because we
> > > are using devm_kzalloc()...
> > >
> > > If we use devm_kzalloc() ,no need to free manually on fail...
> >
> > Yes, but as Yuan Yao stated, the driver will still work without DMA
> > but carry around the unecessary allocated imx_i2c_dma struct.
> > The devm_kfree() is not in the failure path of the driver's probe()
> > function, but in the function that tries to initialize the optional
> > DMA support.
> 
> If the DMA fails, I'd just make the entire probe fail. In case you cannot probe
> DMA for your hardware, which is exected to be DMA capable, it means
> something is wrong anyway.

Yes, but if there is something wrong in dma, I think the i2c is innocent. So I think the error message is necessary but i2c can continue work.


Best regards,
Yuan Yao
