Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaIYHjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:39:24 -0400
Received: from mail-bn1on0115.outbound.protection.outlook.com ([157.56.110.115]:27219
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751031AbaIYHjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:39:23 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?utf-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCHv3] dmaengine: fsl-edma: fixup reg offset and hw S/G
	support in big-endian model
Thread-Topic: [PATCHv3] dmaengine: fsl-edma: fixup reg offset and hw S/G
	support in big-endian model
Thread-Index: AQHP1++agYzHIrQXJkuRVmhA3RepU5wRbafw
Date: Thu, 25 Sep 2014 07:39:20 +0000
Message-ID: <6ea38c0b0b584d5ea759afca45a49a02@BL2PR03MB467.namprd03.prod.outlook.com>
References: <1411550642-12577-1-git-send-email-jingchang.lu@freescale.com>
 <20140924130510.62d78440@ipc1.ka-ro>
 <20140924120338.GW5182@n2100.arm.linux.org.uk>
In-Reply-To: <20140924120338.GW5182@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB468;
x-forefront-prvs: 0345CFD558
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(24454002)(164054003)(51444003)(377454003)(13464003)(199003)(106116001)(101416001)(108616004)(97736003)(31966008)(106356001)(74316001)(54356999)(83072002)(92566001)(105586002)(66066001)(10300001)(64706001)(95666004)(120916001)(99286002)(76576001)(90102001)(19580405001)(81342003)(85852003)(83322001)(33646002)(77982003)(81542003)(87936001)(85306004)(46102003)(76176999)(20776003)(19580395003)(76482002)(107046002)(21056001)(50986999)(86362001)(74502003)(4396001)(80022003)(99396003)(2656002)(74662003)(79102003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB468;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8P7dTBu021196

>-----Original Message-----
>From: Russell King - ARM Linux [mailto:linux@arm.linux.org.uk]
>Sent: Wednesday, September 24, 2014 8:04 PM
>To: Lothar WaÃŸmann
>Cc: Lu Jingchang-B35083; vinod.koul@intel.com; arnd@arndb.de; linux-
>kernel@vger.kernel.org; dmaengine@vger.kernel.org; linux-arm-
>kernel@lists.infradead.org
>Subject: Re: [PATCHv3] dmaengine: fsl-edma: fixup reg offset and hw S/G
>support in big-endian model
>
>On Wed, Sep 24, 2014 at 01:05:10PM +0200, Lothar WaÃŸmann wrote:
>> Hi,
>>
>> Jingchang Lu wrote:
>> > +	 * eDMA hardware SGs requires the TCDs to be auto loaded
>> > +	 * in the little endian whenver the register endian model,
>> "in little endian whatever the register endian model"
>
>Even that took several reads to work it out.
>
>	eDMA hardware SGs require the TCDs to be stored in little endian
>	format irrespective of the register endian model.
>
>and I think that's all that needs to be said here.
>
>However, as I realdy suggested, running this ruddy thing through sparse
>would be a /very/ good idea, because it'll warn with:
>
>+       tcd->daddr = cpu_to_le32(dst);
>
>The reason it'll warn on that is because daddr is not declared with __le32,
>etc - the types used in struct fsl_edma_hw_tcd tell sparse that the values
>to be stored there are in _host_ endian format, but they're being assigned
>little endian formatted data.
>
I didn't realize the type warning, they indeed exist. I will use __le32 and
__le16 for fsl_edma_hw_tcd struct members as below:
struct fsl_edma_hw_tcd {
        __le32  saddr;
        __le16  soff;
        __le16  attr;
        __le32  nbytes;
        __le32  slast;
        __le32  daddr;
        __le16  doff;
        __le16  citer;
        __le32  dlast_sga;
        __le16  csr;
        __le16  biter;
};

>> > +	 * for fsl_set_tcd_params doing the swap.
>> fsl_set_tcd_params()
>
>That's the wrong function name anyway.  It's fsl_edma_set_tcd_params().
>
>However, let's look at this a little more:
>
>        fsl_edma_set_tcd_params(fsl_chan, tcd->saddr, tcd->daddr, tcd-
>>attr,
>                        tcd->soff, tcd->nbytes, tcd->slast, tcd->citer,
>                        tcd->biter, tcd->doff, tcd->dlast_sga, tcd->csr);
>
>Is it /really/ a good idea to read all that data out of the structure,
>only to then have most of it saved into the stack, which
>fsl_edma_set_tcd_params() then has to read back off the stack again?
>With stuff like this, one has to wonder if there is much clue how to write
>optimal C code in this driver.
>
>This should be passing the tcd structure into fsl_edma_set_tcd_params().
>
>Now, this function contains this comment:
>
>        /*
>         * TCD parameters have been swapped in fill_tcd_params(),
>         * so just write them to registers in the cpu endian here
>         */
>
>Which is almost reasonable, but let's update it:
>
>	TCD parameters are stored in struct fsl_edma_hw_tcd in little
>	endian format.  However, we need to load the registers in
>	<insert appropriate endianness - big|little|cpu> endian.
>
>Now, remember that writel() and friends expect native CPU endian formatted
>data (and yes, sparse checks this too) so that needs to be considered more.
>
>Lastly, the driver seems to be a total mess of accessors.  In some places
>it uses io{read,write}*, in other places, it uses plain {read,write}*.  It
>should use either one set or the other set, and not mix these two.
>
>I just spotted this badly formatted code too:
>
>        for (i = 0; i < fsl_desc->n_tcds; i++)
>                        dma_pool_free(fsl_desc->echan->tcd_pool,
>                                        fsl_desc->tcd[i].vtcd,
>                                        fsl_desc->tcd[i].ptcd); ...
>                edma_writeb(fsl_chan->edma,
>                                EDMAMUX_CHCFG_ENBL |
>EDMAMUX_CHCFG_SOURCE(slot),
>                                muxaddr + ch_off);
>
>--
Thanks, I will use the tcd pointer instead. And I will use one r/w set.

Best Regards,
Jingchang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
