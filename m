Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbaHGF24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 01:28:56 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:43647
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756755AbaHGF2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 01:28:54 -0400
From: "fugang.duan@freescale.com" <fugang.duan@freescale.com>
To: Yao Yuan <yao.yuan@freescale.com>, "wsa@the-dreams.de" <wsa@the-dreams.de>,
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
Thread-Index: AQHPsJp6xKTt7EIbSUuPcoEni/e+fJvC0RvQgABXoYCAAW7XYA==
Date: Thu, 7 Aug 2014 05:28:51 +0000
Message-ID: <31f8f5504fc24d999f5af74338602bed@BLUPR03MB373.namprd03.prod.outlook.com>
References: <1407232563-10856-1-git-send-email-yao.yuan@freescale.com>
 <1407232563-10856-2-git-send-email-yao.yuan@freescale.com>
 <41705e1e4c604240ba96333a03d5c544@BLUPR03MB373.namprd03.prod.outlook.com>
 <14d042bbcfb04308bfb3a1db18e46bec@BL2PR03MB338.namprd03.prod.outlook.com>
In-Reply-To: <14d042bbcfb04308bfb3a1db18e46bec@BL2PR03MB338.namprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 029651C7A1
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(24454002)(199002)(189002)(377454003)(51704005)(85306004)(87936001)(83072002)(85852003)(74316001)(76576001)(76482001)(93886004)(2656002)(77982001)(21056001)(46102001)(81342001)(99286002)(105586002)(64706001)(20776003)(83322001)(79102001)(19580395003)(4396001)(107046002)(19580405001)(101416001)(74662001)(95666004)(106356001)(86362001)(80022001)(92566001)(81542001)(106116001)(54356999)(31966008)(99396002)(74502001)(33646002)(76176999)(2201001)(50986999)(66066001)(2501001)(24736002)(108616003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB343;H:BLUPR03MB373.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuan Yao-B46683 Data: Wednesday, August 06, 2014 3:07 PM
>To: Duan Fugang-B38611; wsa@the-dreams.de; marex@denx.de
>Cc: LW@KARO-electronics.de; mark.rutland@arm.com; shawn.guo@linaro.org;
>linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
>i2c@vger.kernel.org; Li Frank-B20596
>Subject: RE: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c
>driver
>
>Hi Fugang,
>
>Duan Fugang wrote:
>[...]
>>+	dma_sconfig.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
>>+	dma_sconfig.dst_maxburst = 1;
>> The maxburst is 1 cause very slow efficiency for DMA copy, which
>> system performance even is slower Than cpu mode.
>
>There is no FIFO for IMX i2c, so the maxburst shoud be 1 for hardware
>request.
>
Understand. Thanks.

>
>> >+	/* Waiting for Transfer complete. */
>> >+	while (timeout--) {
>> >+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
>> >+		if (temp & I2SR_ICF)
>> >+			break;
>> >+		udelay(10);
>> >+	}
>> Whether there have better method like interrupt to avoid dead wait
>> here until timeout ?
>
>Can you give me more suggestion? We have discussed it with our team, It
>seems the short query wait is necessary.
>
At least, you can use schdule_timeout() instead of udelay() ?

>> >+
>> >+	if (!timeout)
>> >+		return -ETIMEDOUT;
>> >+	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
>> >+	temp &= ~I2CR_DMAEN;
>> >+	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
>> >+
>> >+	/* The last data byte must be transferred by the CPU. */
>> >+	imx_i2c_write_reg(msgs->buf[msgs->len-1],
>> >+				i2c_imx, IMX_I2C_I2DR);
>> >+	result = i2c_imx_trx_complete(i2c_imx);
>> >+	if (result)
>> >+		return result;
>> I don't understand why the last data need to be transmited by cpu. I
>> guess you want to get IIF interrupt ?
>
>Yes, we need the interrupt to do some mop-up.
>
>Also follow the hardware request as:
>
>The following flow diagram details exactly the operation for using a DMA
>controller to transmit "n" data bytes to a slave. The first byte (the
>slave calling address) is always transmitted by the CPU. All subsequent
>data bytes (apart from the last data byte) can be transferred by the DMA
>controller. The last data byte must be transferred by the CPU.
>
>> >+
>> >+	result = i2c_imx_acked(i2c_imx);
>> >+	if (result)
>> >+		return result;
>> >+
