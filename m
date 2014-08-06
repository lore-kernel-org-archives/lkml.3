Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754279AbaHFHGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 03:06:46 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:22181
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753338AbaHFHGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 03:06:44 -0400
From: Yao Yuan <yao.yuan@freescale.com>
To: "fugang.duan@freescale.com" <fugang.duan@freescale.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "marex@denx.de" <marex@denx.de>
CC: "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "Frank.Li@freescale.com" <Frank.Li@freescale.com>
Subject: RE: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c driver
Thread-Topic: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c
 driver
Thread-Index: AQHPsJpytXwYr0w2ukaT/Ol6wOf2kpvC3FmAgABGNsA=
Date: Wed, 6 Aug 2014 07:06:41 +0000
Message-ID: <14d042bbcfb04308bfb3a1db18e46bec@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1407232563-10856-1-git-send-email-yao.yuan@freescale.com>
 <1407232563-10856-2-git-send-email-yao.yuan@freescale.com>
 <41705e1e4c604240ba96333a03d5c544@BLUPR03MB373.namprd03.prod.outlook.com>
In-Reply-To: <41705e1e4c604240ba96333a03d5c544@BLUPR03MB373.namprd03.prod.outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(199002)(24454002)(51704005)(99396002)(54356999)(50986999)(76176999)(74316001)(4396001)(101416001)(31966008)(86362001)(76482001)(74662001)(66066001)(64706001)(79102001)(83322001)(77982001)(76576001)(80022001)(46102001)(20776003)(107046002)(74502001)(106116001)(106356001)(92566001)(21056001)(2656002)(83072002)(85306004)(81342001)(87936001)(105586002)(99286002)(2201001)(33646002)(81542001)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB369;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fugang,

Duan Fugang wrote:
[...]
>+	dma_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
>+	dma_sconfig.dst_maxburst = 1;
> The maxburst is 1 cause very slow efficiency for DMA copy, which system
> performance even is slower Than cpu mode.

There is no FIFO for IMX i2c, so the maxburst shoud be 1 for hardware request.

[...]

> >+	/* Waiting for Transfer complete. */
> >+	while (timeout--) {
> >+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> >+		if (temp & I2SR_ICF)
> >+			break;
> >+		udelay(10);
> >+	}
> Whether there have better method like interrupt to avoid dead wait here until
> timeout ?

Can you give me more suggestion? We have discussed it with our team, It seems the short query wait is necessary.

> >+
> >+	if (!timeout)
> >+		return -ETIMEDOUT;
> >+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
> >+	temp &= ~I2CR_DMAEN;
> >+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
> >+
> >+	/* The last data byte must be transferred by the CPU. */
> >+	imx_i2c_write_reg(msgs->buf[msgs->len-1],
> >+				i2c_imx, IMX_I2C_I2DR);
> >+	result = i2c_imx_trx_complete(i2c_imx);
> >+	if (result)
> >+		return result;
> I don't understand why the last data need to be transmited by cpu. I guess you
> want to get IIF interrupt ?

Yes, we need the interrupt to do some mop-up.

Also follow the hardware request as:

The following flow diagram details exactly the operation for using a DMA controller to
transmit "n" data bytes to a slave. The first byte (the slave calling address) is always
transmitted by the CPU. All subsequent data bytes (apart from the last data byte) can be
transferred by the DMA controller. The last data byte must be transferred by the CPU.


> >+
> >+	result = i2c_imx_acked(i2c_imx);
> >+	if (result)
> >+		return result;
> >+

