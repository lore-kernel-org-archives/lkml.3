Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbaIWReI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:34:08 -0400
Received: from mail-by2on0128.outbound.protection.outlook.com ([207.46.100.128]:3200
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932168AbaIWReF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:34:05 -0400
From: Jingchang Lu <jingchang.lu@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dmaengine: fsl-edma: fixup reg offset and hw S/G support
 in big-endian model
Thread-Topic: [PATCH] dmaengine: fsl-edma: fixup reg offset and hw S/G support
 in big-endian model
Thread-Index: AQHP1xZXLAOdFf74/ECppYBeIJz7V5wOpiYAgABOjnQ=
Date: Tue, 23 Sep 2014 17:18:43 +0000
Message-ID: <1411492720444.3205@freescale.com>
References: <1411463719-7728-1-git-send-email-jingchang.lu@freescale.com>,<45444544.Xl4NeUiTm0@wuerfel>
In-Reply-To: <45444544.Xl4NeUiTm0@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.125.191.37]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB468;
x-forefront-prvs: 0343AC1D30
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(377454003)(189002)(24454002)(51704005)(83322001)(90102001)(117636001)(81342003)(87936001)(81542003)(77982003)(83072002)(20776003)(85852003)(85306004)(86362001)(46102003)(74662003)(74502003)(19580405001)(79102003)(4396001)(80022003)(2656002)(19580395003)(76482002)(107046002)(21056001)(76176999)(50986999)(54356999)(92726001)(106356001)(92566001)(101416001)(97736003)(31966008)(66066001)(64706001)(105586002)(106116001)(95666004)(36756003)(99286002)(120916001)(99396002)(10300001)(586874001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB468;H:BL2PR03MB467.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

________________________________________
From: Arnd Bergmann <arnd@arndb.de>
Sent: Tuesday, September 23, 2014 8:30 PM
To: linux-arm-kernel@lists.infradead.org
Cc: Lu Jingchang-B35083; vinod.koul@intel.com; dmaengine@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: fsl-edma: fixup reg offset and hw S/G support in big-endian model

On Tuesday 23 September 2014 17:15:19 Jingchang Lu wrote:
> @@ -459,20 +480,27 @@ static void fill_tcd_params(struct fsl_edma_engine *edma,
>         u16 csr = 0;
>
>         /*
> -        * eDMA hardware SGs require the TCD parameters stored in memory
> -        * the same endian as the eDMA module so that they can be loaded
> -        * automatically by the engine
> +        * eDMA hardware SGs requires the TCDs to be auto loaded
> +        * in the same endian as the core whenver the eDAM engine's
> +        * register endian. So we don't swap the value, waitting
> +        * for fsl_set_tcd_params doing the swap.
>          */

This makes no sense: how would the eDMA hardware know what endianess
the CPU is using to write this data? Have you tried this running on
the same hardware with both big-endian and little-endian kernels?

Also, you access this as little-endian data unconditionally rather
than cpu-endian as the comment suggests, maybe that is what you meant
here?

I will rewrite this comment, thanks.

> -       edma_writel(edma, src, &(tcd->saddr));
> -       edma_writel(edma, dst, &(tcd->daddr));
> -       edma_writew(edma, attr, &(tcd->attr));
> -       edma_writew(edma, EDMA_TCD_SOFF_SOFF(soff), &(tcd->soff));
> -       edma_writel(edma, EDMA_TCD_NBYTES_NBYTES(nbytes), &(tcd->nbytes));
> -       edma_writel(edma, EDMA_TCD_SLAST_SLAST(slast), &(tcd->slast));
> -       edma_writew(edma, EDMA_TCD_CITER_CITER(citer), &(tcd->citer));
> -       edma_writew(edma, EDMA_TCD_DOFF_DOFF(doff), &(tcd->doff));
> -       edma_writel(edma, EDMA_TCD_DLAST_SGA_DLAST_SGA(dlast_sga), &(tcd->dlast_sga));
> -       edma_writew(edma, EDMA_TCD_BITER_BITER(biter), &(tcd->biter));
> +       writel(src, &(tcd->saddr));
> +       writel(dst, &(tcd->daddr));
> +
> +       writew(attr, &(tcd->attr));

You seem to have another preexisting bug: The tcd pointer actually does not
point to mmio registers here at all, but instead points to memory that
has been returned from dma_pool_alloc. It is not valid to use writel()
on such memory, that is only meant to work on real MMIO registers.

You should use regular assignments to the registers here, e.g.

        tcd->saddr = cpu_to_le32(src);
        tcd->daddr = cpu_to_le32(dst);
        ...

        Arnd

I will reconsider this setting. BTW, why writel() can't be used for memory location since it's still mapped and registers space is
also memory mapped? Thanks.

Best Regards,
Jingchang