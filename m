Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaJCUaN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:30:13 -0400
Received: from mail-by2on0124.outbound.protection.outlook.com ([207.46.100.124]:61408
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750944AbaJCUaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:30:10 -0400
Message-ID: <1412368198.13320.434.camel@snotra.buserror.net>
Subject: Re: [PATCH v2 1/2] spi: fsl-spi: Fix parameter ram offset setup for
 CPM1
From: Scott Wood <scottwood@freescale.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Mark Brown <broonie@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-spi@vger.kernel.org>
Date: Fri, 3 Oct 2014 15:29:58 -0500
In-Reply-To: <20141003164916.DBD631AAFA2@localhost.localdomain>
References: <20141003164916.DBD631AAFA2@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:2d08:4497:b38c:aeed]
X-ClientProxiedBy: CO2PR11CA0017.namprd11.prod.outlook.com (10.141.242.155) To
 BN1PR0301MB0722.namprd03.prod.outlook.com (25.160.78.141)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0722;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(189002)(24454002)(377424004)(95666004)(105586002)(106356001)(50466002)(107046002)(76176999)(33646002)(122386001)(23676002)(46102003)(80022003)(62966002)(31966008)(86362001)(93916002)(42186005)(104166001)(64706001)(20776003)(47776003)(92726001)(92566001)(97736003)(85306004)(77096002)(40100001)(87286001)(103116003)(120916001)(21056001)(77156001)(50226001)(88136002)(101416001)(4396001)(87976001)(10300001)(50986999)(102836001)(85852003)(19580405001)(110136001)(89996001)(76482002)(99396003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0722;H:[IPv6:2601:2:5800:3f7:2d08:4497:b38c:aeed];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 18:49 +0200, Christophe Leroy wrote:
> On CPM1, the SPI parameter RAM has a default location. In fsl_spi_cpm_get_pram()
> there was a confusion between the SPI_BASE register and the base of the SPI
> parameter RAM. Fortunatly, it was working properly with MPC866 and MPC885
> because they do set SPI_BASE, but on MPC860 and other old MPC8xx that doesn't
> set SPI_BASE, pram_ofs was not properly set. This patch fixes this confusion.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> ---
> Changes from v1 to v2: none
> 
>  drivers/spi/spi-fsl-cpm.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/spi/spi-fsl-cpm.c b/drivers/spi/spi-fsl-cpm.c
> index 54b0637..0f3a912 100644
> --- a/drivers/spi/spi-fsl-cpm.c
> +++ b/drivers/spi/spi-fsl-cpm.c
> @@ -262,15 +262,14 @@ static unsigned long fsl_spi_cpm_get_pram(struct mpc8xxx_spi *mspi)
>  		pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
>  		out_be16(spi_base, pram_ofs);
>  	} else {
> -		struct spi_pram __iomem *pram = spi_base;
> -		u16 rpbase = in_be16(&pram->rpbase);
> +		u16 rpbase = in_be16(spi_base);
>  
> -		/* Microcode relocation patch applied? */
> +		/* Microcode relocation patch applied | rpbase set by default */
>  		if (rpbase) {
>  			pram_ofs = rpbase;
>  		} else {
> -			pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
> -			out_be16(spi_base, pram_ofs);
> +			pram_ofs = offsetof(cpm8xx_t, cp_dparam[PROFF_SPI]) -
> +				   offsetof(cpm8xx_t, cp_dpmem[0]);
>  		}
>  	}

Why is PROFF_SPI not coming from the device tree?  Why don't I see any
cpm spi in any device tree nor any binding for it?

-Scott


