Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab3DZLe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 07:34:27 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:31452
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755034Ab3DZLeY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 07:34:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z551biz9371I542I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz17326ah8275bh8275dhz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0chbe9i1155h)
From: Garg Vakul-B16394 <B16394@freescale.com>
To: Gupta Ruchika-R66431 <R66431@freescale.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
        Porosanu Alexandru-B06830 <B06830@freescale.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] crypto: caam - FIX RNG init for RNG greater than equal
 to 4
Thread-Topic: [PATCH] crypto: caam - FIX RNG init for RNG greater than equal
 to 4
Thread-Index: AQHOQmeBwnFVeN/b5EeXUS5JcNjTG5joWuGg
Date: Fri, 26 Apr 2013 11:34:19 +0000
Message-ID: <065BBB7616BCE543832A2EF096986B941D616B@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1366971294-10673-1-git-send-email-ruchika.gupta@freescale.com>
In-Reply-To: <1366971294-10673-1-git-send-email-ruchika.gupta@freescale.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.232.14.28]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reviewed-by: Vakul Garg <vakul@freescale.com>

> -----Original Message-----
> From: Gupta Ruchika-R66431
> Sent: Friday, April 26, 2013 3:45 PM
> To: linux-crypto@vger.kernel.org
> Cc: Herbert Xu; David S. Miller; Phillips Kim-R1AAHA; Gupta Ruchika-
> R66431; Porosanu Alexandru-B06830; Greg Kroah-Hartman; Garg Vakul-B16394;
> linux-kernel@vger.kernel.org
> Subject: [PATCH] crypto: caam - FIX RNG init for RNG greater than equal
> to 4
> 
> For SEC including a RNG block version >= 4, special initialization must
> occur before any descriptor that uses RNG block can be submitted. This
> initialization is required not only for SEC with version greater than
> 5.0, but for SEC with RNG version >=4.
> There may be a case where RNG has already been instantiated by u-boot or
> boot ROM code.In such SoCs, if RNG is initialized again SEC would returns
> "Instantiation error". Hence, the initialization status of RNG4 should be
> also checked before doing RNG init.
> 
> Signed-off-by: Ruchika Gupta <ruchika.gupta@freescale.com>
> Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
> Signed-off-by: Andy Fleming <afleming@freescale.com>
> ---
> This patch supersedes the patchset submitted earlier http://www.mail-
> archive.com/linux-crypto@vger.kernel.org/msg08348.html
> crypto: caam - support for RNG version retrieval
> crypto: caam - fix RNG init for SEC with RNG version greater than 4
> 
>  drivers/crypto/caam/ctrl.c |   10 +++++++---
>  drivers/crypto/caam/regs.h |   42
> +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 48 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 19faea2..644d145 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -202,6 +202,7 @@ static int caam_probe(struct platform_device *pdev)
> #ifdef CONFIG_DEBUG_FS
>  	struct caam_perfmon *perfmon;
>  #endif
> +	u64 cha_vid;
> 
>  	ctrlpriv = kzalloc(sizeof(struct caam_drv_private), GFP_KERNEL);
>  	if (!ctrlpriv)
> @@ -293,11 +294,14 @@ static int caam_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
> 
> +	cha_vid = rd_reg64(&topregs->ctrl.perfmon.cha_id);
> +
>  	/*
> -	 * RNG4 based SECs (v5+) need special initialization prior
> -	 * to executing any descriptors
> +	 * If SEC has RNG version >= 4 and RNG state handle has not been
> +	 * already instantiated ,do RNG instantiation
>  	 */
> -	if (of_device_is_compatible(nprop, "fsl,sec-v5.0")) {
> +	if ((cha_vid & CHA_ID_RNG_MASK) >> CHA_ID_RNG_SHIFT >= 4 &&
> +	    !(rd_reg32(&topregs->ctrl.r4tst[0].rdsta) & RDSTA_IF0)) {
>  		kick_trng(pdev);
>  		ret = instantiate_rng(ctrlpriv->jrdev[0]);
>  		if (ret) {
> diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
> index cd6feda..c09142f 100644
> --- a/drivers/crypto/caam/regs.h
> +++ b/drivers/crypto/caam/regs.h
> @@ -117,6 +117,43 @@ struct jr_outentry {
>  #define CHA_NUM_DECONUM_SHIFT	56
>  #define CHA_NUM_DECONUM_MASK	(0xfull << CHA_NUM_DECONUM_SHIFT)
> 
> +/* CHA Version IDs */
> +#define CHA_ID_AES_SHIFT	0
> +#define CHA_ID_AES_MASK		(0xfull << CHA_ID_AES_SHIFT)
> +
> +#define CHA_ID_DES_SHIFT	4
> +#define CHA_ID_DES_MASK		(0xfull << CHA_ID_DES_SHIFT)
> +
> +#define CHA_ID_ARC4_SHIFT	8
> +#define CHA_ID_ARC4_MASK	(0xfull << CHA_ID_ARC4_SHIFT)
> +
> +#define CHA_ID_MD_SHIFT		12
> +#define CHA_ID_MD_MASK		(0xfull << CHA_ID_MD_SHIFT)
> +
> +#define CHA_ID_RNG_SHIFT	16
> +#define CHA_ID_RNG_MASK		(0xfull << CHA_ID_RNG_SHIFT)
> +
> +#define CHA_ID_SNW8_SHIFT	20
> +#define CHA_ID_SNW8_MASK	(0xfull << CHA_ID_SNW8_SHIFT)
> +
> +#define CHA_ID_KAS_SHIFT	24
> +#define CHA_ID_KAS_MASK		(0xfull << CHA_ID_KAS_SHIFT)
> +
> +#define CHA_ID_PK_SHIFT		28
> +#define CHA_ID_PK_MASK		(0xfull << CHA_ID_PK_SHIFT)
> +
> +#define CHA_ID_CRC_SHIFT	32
> +#define CHA_ID_CRC_MASK		(0xfull << CHA_ID_CRC_SHIFT)
> +
> +#define CHA_ID_SNW9_SHIFT	36
> +#define CHA_ID_SNW9_MASK	(0xfull << CHA_ID_SNW9_SHIFT)
> +
> +#define CHA_ID_DECO_SHIFT	56
> +#define CHA_ID_DECO_MASK	(0xfull << CHA_ID_DECO_SHIFT)
> +
> +#define CHA_ID_JR_SHIFT		60
> +#define CHA_ID_JR_MASK		(0xfull << CHA_ID_JR_SHIFT)
> +
>  struct sec_vid {
>  	u16 ip_id;
>  	u8 maj_rev;
> @@ -228,7 +265,10 @@ struct rng4tst {
>  		u32 rtfrqmax;	/* PRGM=1: freq. count max. limit register
> */
>  		u32 rtfrqcnt;	/* PRGM=0: freq. count register */
>  	};
> -	u32 rsvd1[56];
> +	u32 rsvd1[40];
> +#define RDSTA_IF0 0x00000001
> +	u32 rdsta;
> +	u32 rsvd2[15];
>  };
> 
>  /*
> --
> 1.7.7.6


