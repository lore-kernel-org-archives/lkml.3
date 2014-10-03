Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaJCTv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 15:51:58 -0400
Received: from mail-bn1bon0137.outbound.protection.outlook.com ([157.56.111.137]:27808
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753042AbaJCTv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 15:51:56 -0400
Message-ID: <1412365908.13320.429.camel@snotra.buserror.net>
Subject: Re: [PATCH v2 2/2] spi: fsl-spi: Allow dynamic allocation of CPM1
 parameter RAM
From: Scott Wood <scottwood@freescale.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Mark Brown <broonie@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-spi@vger.kernel.org>
Date: Fri, 3 Oct 2014 14:51:48 -0500
In-Reply-To: <20141003164917.397871AB276@localhost.localdomain>
References: <20141003164917.397871AB276@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:2d08:4497:b38c:aeed]
X-ClientProxiedBy: DM2PR11CA0011.namprd11.prod.outlook.com (25.160.91.21) To
 BN1PR0301MB0724.namprd03.prod.outlook.com (25.160.78.143)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0724;
X-Forefront-PRVS: 0353563E2B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(189002)(377424004)(199003)(51704005)(107046002)(104166001)(77156001)(62966002)(87976001)(89996001)(88136002)(50466002)(87286001)(99396003)(80022003)(46102003)(21056001)(50226001)(19580405001)(4396001)(23676002)(97736003)(77096002)(31966008)(33646002)(40100001)(47776003)(42186005)(20776003)(122386001)(102836001)(64706001)(101416001)(50986999)(76176999)(103116003)(105586002)(95666004)(85852003)(85306004)(76482002)(92566001)(93916002)(86362001)(110136001)(92726001)(10300001)(106356001)(120916001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0724;H:[IPv6:2601:2:5800:3f7:2d08:4497:b38c:aeed];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 18:49 +0200, Christophe Leroy wrote:
> On CPM1, the SPI parameter RAM has a default location. In order to use SPI while
> using SCC2 with features like QMC or Ethernet, it is necessary to relocate SPI
> parameter RAM in a free location in the CPM dual port RAM.

Please explain in more detail why it's necessary.

>  With this patch,
> when "fsl,cpm1-spi-reloc" instead of "fsl,cpm1-spi" compatible is set in the
> device tree, the parameter RAM for SPI is dynamically allocated
> with cpm_muram_alloc().
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> ---
> Changes from v1 to v2: using OF compatible instead of compile time option
> 
>  drivers/spi/spi-fsl-cpm.c   | 3 +++
>  drivers/spi/spi-fsl-lib.c   | 2 ++
>  include/linux/fsl_devices.h | 1 +
>  3 files changed, 6 insertions(+)
> 
> diff --git a/drivers/spi/spi-fsl-cpm.c b/drivers/spi/spi-fsl-cpm.c
> index 0f3a912..048ca5f 100644
> --- a/drivers/spi/spi-fsl-cpm.c
> +++ b/drivers/spi/spi-fsl-cpm.c
> @@ -261,6 +261,9 @@ static unsigned long fsl_spi_cpm_get_pram(struct mpc8xxx_spi *mspi)
>  	if (mspi->flags & SPI_CPM2) {
>  		pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
>  		out_be16(spi_base, pram_ofs);
> +	} else if (mspi->flags & SPI_CPM1_RELOC) {
> +		pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 32);
> +		out_be16(spi_base, pram_ofs);
>  	} else {
>  		u16 rpbase = in_be16(spi_base);
>  
> diff --git a/drivers/spi/spi-fsl-lib.c b/drivers/spi/spi-fsl-lib.c
> index c3f7802..e9db4c5 100644
> --- a/drivers/spi/spi-fsl-lib.c
> +++ b/drivers/spi/spi-fsl-lib.c
> @@ -227,6 +227,8 @@ int of_mpc8xxx_spi_probe(struct platform_device *ofdev)
>  		pdata->flags = SPI_CPM_MODE | SPI_CPM2;
>  	else if (of_device_is_compatible(np, "fsl,cpm1-spi"))
>  		pdata->flags = SPI_CPM_MODE | SPI_CPM1;
> +	else if (of_device_is_compatible(np, "fsl,cpm1-spi-reloc"))
> +		pdata->flags = SPI_CPM_MODE | SPI_CPM1 | SPI_CPM1_RELOC;

Where's the binding and device tree update for this?  What specific
aspect of hardware does it describe?

-Scott


