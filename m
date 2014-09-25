Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbaIYGmF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 02:42:05 -0400
Received: from mail-by2on0132.outbound.protection.outlook.com ([207.46.100.132]:9696
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750808AbaIYGmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 02:42:03 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: =?utf-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCHv3] dmaengine: fsl-edma: fixup reg offset and hw S/G
 support in big-endian model
Thread-Topic: [PATCHv3] dmaengine: fsl-edma: fixup reg offset and hw S/G
 support in big-endian model
Thread-Index: AQHP1+C93waah0nh0EOmymprm+VjgZwQHw4AgAFGB0A=
Date: Thu, 25 Sep 2014 06:42:00 +0000
Message-ID: <7635751d171a401d88ce70f9adee88bb@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1411550642-12577-1-git-send-email-jingchang.lu@freescale.com>
 <20140924130510.62d78440@ipc1.ka-ro>
In-Reply-To: <20140924130510.62d78440@ipc1.ka-ro>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB468;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(24454002)(164054003)(377454003)(13464003)(199003)(106116001)(101416001)(108616004)(31966008)(97736003)(106356001)(74316001)(54356999)(83072002)(92566001)(105586002)(66066001)(64706001)(10300001)(95666004)(120916001)(99286002)(110136001)(76576001)(90102001)(19580405001)(81342003)(85852003)(83322001)(33646002)(77982003)(81542003)(87936001)(85306004)(46102003)(20776003)(19580395003)(76176999)(76482002)(107046002)(21056001)(50986999)(86362001)(74502003)(4396001)(80022003)(99396003)(2656002)(74662003)(79102003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB468;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8P6g9ql020931

>-----Original Message-----
>From: Lothar WaÃŸmann [mailto:LW@KARO-electronics.de]
>Sent: Wednesday, September 24, 2014 7:05 PM
>To: Lu Jingchang-B35083
>Cc: vinod.koul@intel.com; linux@arm.linux.org.uk; arnd@arndb.de; linux-
>kernel@vger.kernel.org; dmaengine@vger.kernel.org; linux-arm-
>kernel@lists.infradead.org
>Subject: Re: [PATCHv3] dmaengine: fsl-edma: fixup reg offset and hw S/G
>support in big-endian model
>
>Hi,
>
>Jingchang Lu wrote:
>> The offset of all 8-/16-bit register in big-endian eDMA model are
>s/register/registers/
>
>> swapped in a 32-bit size opposite those in the little-endian model.
>>
>> The hardware Scatter/Gather requires the subsequent TCDs in memory to
>> be auto loaded should retain little endian independent of the register
>> endian model, the dma engine will do the swap if need.
>>
>> This patch also use regular assignment for tcd variables r/w instead
>> of with io function previously that may not always be true.
>>
>> Signed-off-by: Jingchang Lu <jingchang.lu@freescale.com>
>> ---
>> changes in v3:
>>  use unsigned long instead of u32 in reg offset swap cast to avoid
>warning.
>>
>> changes in v2:
>>  simplify register offset swap calculation.
>>  use regular assignment for tcd variables r/w instead of io function.
>>
>>  drivers/dma/fsl-edma.c | 106
>> ++++++++++++++++++++++++++-----------------------
>>  1 file changed, 57 insertions(+), 49 deletions(-)
>>
>> diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c index
>> 3c5711d..9ca55ee 100644
>> --- a/drivers/dma/fsl-edma.c
>> +++ b/drivers/dma/fsl-edma.c
>> @@ -177,16 +177,10 @@ struct fsl_edma_engine {
>>  /*
>>   * R/W functions for big- or little-endian registers
>>   * the eDMA controller's endian is independent of the CPU core's endian.
>> + * for the big-endian IP module, the offset for 8-bit or 16-bit
>> + register
>s/for/For/
>
>> + * should also be swapped oposite to that in little-endian IP.
>s/oposite/opposite/
>
>[...]
>> @@ -459,20 +460,27 @@ static void fill_tcd_params(struct fsl_edma_engine
>*edma,
>>  	u16 csr = 0;
>>
>>  	/*
>> -	 * eDMA hardware SGs require the TCD parameters stored in memory
>> -	 * the same endian as the eDMA module so that they can be loaded
>> -	 * automatically by the engine
>> +	 * eDMA hardware SGs requires the TCDs to be auto loaded
>> +	 * in the little endian whenver the register endian model,
>"in little endian whatever the register endian model"
>
>> +	 * So we put the value in little endian in memory, waitting
>s/waitting/waiting/
>
>> +	 * for fsl_set_tcd_params doing the swap.
>fsl_set_tcd_params()
>
>
>
>Lothar WaÃŸmann
>--
Thanks, I will amend them in the next version patch.

Best Regards,
Jingchang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
