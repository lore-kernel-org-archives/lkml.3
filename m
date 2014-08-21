Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaHUBxG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 21:53:06 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:8853
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750844AbaHUBxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 21:53:04 -0400
Message-ID: <1408585972.4058.95.camel@snotra.buserror.net>
Subject: Re: [PATCH] mtd: fsl_ifc_nand: Recover corrupted empty page for
 preventing read-only mount in UBIFS
From: Scott Wood <scottwood@freescale.com>
To: <eunb.song@samsung.com>
CC: <computersforpeace@gmail.com>, <artem.bityutskiy@linux.intel.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Wed, 20 Aug 2014 20:52:52 -0500
In-Reply-To: <26017351.61791396316965998.JavaMail.weblogic@epv6ml06>
References: <26017351.61791396316965998.JavaMail.weblogic@epv6ml06>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:800:984d:d5d4:4421]
X-ClientProxiedBy: BLUPR08CA0058.namprd08.prod.outlook.com (10.141.200.38) To
 DM2PR0301MB0734.namprd03.prod.outlook.com (25.160.97.142)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(199003)(24454002)(377424004)(189002)(51704005)(85306004)(77096002)(88136002)(103116003)(64706001)(23676002)(102836001)(99396002)(47776003)(104166001)(20776003)(105586002)(95666004)(50466002)(106356001)(21056001)(42186005)(87286001)(87976001)(50226001)(80022001)(77156001)(4396001)(86362001)(46102001)(81542001)(83072002)(89996001)(2351001)(19580395003)(81342001)(83322001)(19580405001)(110136001)(77982001)(107046002)(76176999)(79102001)(92566001)(74502001)(92726001)(50986999)(76482001)(101416001)(93916002)(62966002)(33646002)(31966008)(74662001)(99106002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0301MB0734;H:[IPv6:2601:2:5800:3f7:800:984d:d5d4:4421];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 01:49 +0000, Eunbong Song wrote:
> Even if the meaning of EUCLEAN was changed by commit edbc4540.
> There is still possibility of read-only mount in UBIFS with ubifs_scan() "corrupt empty space at LEB".
> So i made this patch for fix that problem.

Please elaborate on the nature of the problem.

> This patch do as follow.
>  - If there are ecc errors which is equal to or less than chip->ecc.strength in page.
>  - Check that page has how many zero bits, and if zero bits are equal to or less than
>    chip->ecc.strength then overwrite 1 to zero bits in buf.

This is difficult to parse, with no mention in this sentence that you're
talking about corrupted empty pages.

> ubifs_scan() cannot detect corrupted empty space because buf is recovered by this patch.
> And this is safe because ecc controller can correct up to chip->ecc.strength bits.

So the concern is that is_blank is failing to report a page that has not
been written to but has errors that would have been correctable if the
page had been written?

Do most drivers handle this?

> Signed-off-by: Eunbong Song <eunb.song@samsung.com>
> ---
>  drivers/mtd/nand/fsl_ifc_nand.c |   41 +++++++++++++++++++++++++++++++++++++++
>  1 files changed, 41 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mtd/nand/fsl_ifc_nand.c b/drivers/mtd/nand/fsl_ifc_nand.c
> index 90ca7e7..2129c39 100644
> --- a/drivers/mtd/nand/fsl_ifc_nand.c
> +++ b/drivers/mtd/nand/fsl_ifc_nand.c
> @@ -277,6 +277,42 @@ static int is_blank(struct mtd_info *mtd, unsigned int bufnum)
>  	return 1;
>  }
>  
> +static int num_zero_bits(uint8_t val)
> +{
> +	int i, ret=0;
> +
> +	for(i=7; i>=0 ; i--)
> +		if(!(0x1 & (val >> i)))
> +			ret++;

Whitespace (here and elsewhere)

Also, use hweight8(~val) instead of reimplementing it.  Or better, use
hweight64() and process the data in larger chunks.

> +	return ret;
> +}
> +
> +static int is_corrupted_blank(struct mtd_info *mtd, uint8_t * buf)
> +{
> +	struct nand_chip *chip = mtd->priv;
> +	int i;
> +	int zero_bits = 0;
> +
> +	for (i = 0; i < mtd->writesize ; i++) {
> +		if(buf[i] != 0xff) {
> +			zero_bits += num_zero_bits(buf[i]);	
> +		}
> +	}
> +
> +	if(zero_bits && (zero_bits <= chip->ecc.strength)){
> +		return 1;
> +	}
> +
> +	return 0;
> +}

What if it's a page that legitimately has only a handful of zero bits?
You need to count zero bits in the ECC as well.

Also, this could be combined with is_blank().

> +static void recover_corrupted_blank(struct mtd_info *mtd, uint8_t * buf)
> +{
> +	memset(buf, 0xff, mtd->writesize);
> +	return;
> +}
> +
>  /* returns nonzero if entire page is blank */
>  static int check_read_ecc(struct mtd_info *mtd, struct fsl_ifc_ctrl *ctrl,
>  			  u32 *eccstat, unsigned int bufnum)
> @@ -760,6 +796,11 @@ static int fsl_ifc_read_page(struct mtd_info *mtd, struct nand_chip *chip,
>  	if (ctrl->nand_stat != IFC_NAND_EVTER_STAT_OPC)
>  		mtd->ecc_stats.failed++;
>  
> +	if(nctrl->max_bitflips && (nctrl->max_bitflips <= chip->ecc.strength)){
> +		if(is_corrupted_blank(mtd, buf))
> +			recover_corrupted_blank(mtd, buf);
> +	}

If the page is blank except for errors, most likely max_bitflips will be
zero because fsl_ifc_run_command() already considered it an
uncorrectable error and set ECCER instead.  Moving corrupted blank page
detection into is_blank() wouldn't have this problem.

How did you test this patch?

-Scott


