Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaJGAQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:16:24 -0400
Received: from [207.46.100.121] ([207.46.100.121]:47870 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751098AbaJGAQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:16:22 -0400
Message-ID: <1412640953.13320.502.camel@snotra.buserror.net>
Subject: Re: [PATCH v2 1/2] spi: fsl-spi: Fix parameter ram offset setup for
 CPM1
From: Scott Wood <scottwood@freescale.com>
To: christophe leroy <christophe.leroy@c-s.fr>
CC: Mark Brown <broonie@kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-spi@vger.kernel.org>
Date: Mon, 6 Oct 2014 19:15:53 -0500
In-Reply-To: <542FE1C4.7000403@c-s.fr>
References: <20141003164916.DBD631AAFA2@localhost.localdomain>
	 <1412368198.13320.434.camel@snotra.buserror.net> <542FE1C4.7000403@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2601:2:5800:3f7:6d45:e00c:643e:3f23]
X-ClientProxiedBy: CO2PR11CA0025.namprd11.prod.outlook.com (10.141.242.163) To
 CY1PR0301MB0731.namprd03.prod.outlook.com (25.160.159.149)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0731;
X-Forefront-PRVS: 035748864E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(377424004)(199003)(189002)(51704005)(479174003)(4396001)(50226001)(23676002)(19580395003)(122386002)(19580405001)(103116003)(102836001)(76482002)(77156001)(95666004)(85306004)(50466002)(120916001)(99396003)(105586002)(106356001)(92566001)(10300001)(107046002)(21056001)(20776003)(47776003)(110136001)(33646002)(97736003)(42186005)(77096002)(93916002)(85852003)(80022003)(89996001)(104166001)(46102003)(86362001)(92726001)(101416001)(50986999)(87976001)(88136002)(87286001)(62966002)(31966008)(76176999)(40100002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0731;H:[IPv6:2601:2:5800:3f7:6d45:e00c:643e:3f23];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-04 at 14:02 +0200, christophe leroy wrote:
> Le 03/10/2014 22:29, Scott Wood a écrit :
> > On Fri, 2014-10-03 at 18:49 +0200, Christophe Leroy wrote:
> >> On CPM1, the SPI parameter RAM has a default location. In fsl_spi_cpm_get_pram()
> >> there was a confusion between the SPI_BASE register and the base of the SPI
> >> parameter RAM. Fortunatly, it was working properly with MPC866 and MPC885
> >> because they do set SPI_BASE, but on MPC860 and other old MPC8xx that doesn't
> >> set SPI_BASE, pram_ofs was not properly set. This patch fixes this confusion.
> >>
> >> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> >>
> >> ---
> >> Changes from v1 to v2: none
> >>
> >>   drivers/spi/spi-fsl-cpm.c | 9 ++++-----
> >>   1 file changed, 4 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/spi/spi-fsl-cpm.c b/drivers/spi/spi-fsl-cpm.c
> >> index 54b0637..0f3a912 100644
> >> --- a/drivers/spi/spi-fsl-cpm.c
> >> +++ b/drivers/spi/spi-fsl-cpm.c
> >> @@ -262,15 +262,14 @@ static unsigned long fsl_spi_cpm_get_pram(struct mpc8xxx_spi *mspi)
> >>   		pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
> >>   		out_be16(spi_base, pram_ofs);
> >>   	} else {
> >> -		struct spi_pram __iomem *pram = spi_base;
> >> -		u16 rpbase = in_be16(&pram->rpbase);
> >> +		u16 rpbase = in_be16(spi_base);
> >>   
> >> -		/* Microcode relocation patch applied? */
> >> +		/* Microcode relocation patch applied | rpbase set by default */
> >>   		if (rpbase) {
> >>   			pram_ofs = rpbase;
> >>   		} else {
> >> -			pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
> >> -			out_be16(spi_base, pram_ofs);
> >> +			pram_ofs = offsetof(cpm8xx_t, cp_dparam[PROFF_SPI]) -
> >> +				   offsetof(cpm8xx_t, cp_dpmem[0]);
> >>   		}
> >>   	}
> > Why is PROFF_SPI not coming from the device tree?
> That's where it starts to become tricky.
> 
> PROFF_SPI is defined in cpm1.h which is included by the driver already. 

Yes, but those values shouldn't be used.  It's a leftover from the old
way of hardcoding things and describing the hardware with kconfig rather
than the device tree.

> It provides the default offset from the start of the parameter RAM.
> Previously I had the following in my device tree, and the last part of 
> the source above (the one for rpbase == 0) could not work.
> 
>              spi: spi@a80 {
>                  cell-index = <0>;
>                  compatible = "fsl,spi", "fsl,cpm1-spi";
>                  reg = <0xa80 0x30 0x3d80 0x30>;
> 
> First reg area was the area for SPI registers. Second area was the 
> parameter RAM zone, which was just mapped to get access to the SPI_BASE 
> pointer (rpbase)
> 
> Now I have
> 
>                  compatible = "fsl,spi", "fsl,cpm1-spi-reloc";
>                  reg = <0xa80 0x30 0x3dac 0x2>;
> 
> First reg area is the area for SPI registers. Second area is the 
> SPI_BASE, as for the CPM2.
> 
> On recent 8xx (885 and 866 at least) it contains the offset (=0x1D80) of 
> the parameter RAM. But on old ones (860, ...) it contains 0. Therefore 
> we have to get the default index in another way.
> What I wanted was to keep something similar to what's done with CPM2.
> 
> What should it look like if that offset had to be in the device tree ?

If the offset is not relocatable or discoverable, it should stay in the
device tree.  If you have an old chip you wouldn't have
fsl,cpm1-spi-reloc and thus you'd still have "0x3d80 0x30" in reg.

> > Why don't I see any
> > cpm spi in any device tree nor any binding for it?
> There's one in mgcoge.dts:
> 
>              spi@11aa0 {
>                  cell-index = <0>;
>                  compatible = "fsl,spi", "fsl,cpm2-spi";
>                  reg = <0x11a80 0x40 0x89fc 0x2>;

I'm not sure why I missed that, but this patch is for cpm1-spi, not
cpm2-spi...

Even if you insist on keeping your board dts out-of-tree, there should
at least be a binding in-tree.

BTW, more specific compatibles should come first.

-Scott


