Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaIDWrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 18:47:03 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:32754
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755358AbaIDWrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 18:47:01 -0400
Message-ID: <1409870809.24184.163.camel@snotra.buserror.net>
Subject: Re: [PATCH v2] QE: move qe code from arch/powerpc to drivers/soc
From: Scott Wood <scottwood@freescale.com>
To: Zhao Qiang <B45475@freescale.com>
CC: <leoli@freescale.com>, <linuxppc-dev@lists.ozlabs.org>,
        <B07421@freescale.com>, <R63061@freescale.com>,
        <linux-kernel@vger.kernel.org>
Date: Thu, 4 Sep 2014 17:46:49 -0500
In-Reply-To: <1409807186-45816-1-git-send-email-B45475@freescale.com>
References: <1409807186-45816-1-git-send-email-B45475@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:7941:f206:1e28:f0a]
X-ClientProxiedBy: BN1PR02CA0017.namprd02.prod.outlook.com (10.141.56.17) To
 BN1PR0301MB0724.namprd03.prod.outlook.com (25.160.78.143)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 0324C2C0E2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(189002)(199003)(377424004)(24454002)(51704005)(81542001)(81342001)(4396001)(104166001)(103116003)(102836001)(105586002)(106356001)(93916002)(86362001)(74502001)(76482001)(74662001)(92566001)(31966008)(92726001)(80022001)(46102001)(62966002)(50466002)(23676002)(85852003)(85306004)(50226001)(64706001)(110136001)(20776003)(107046002)(50986999)(76176999)(95666004)(33646002)(77096002)(77982001)(89996001)(88136002)(87286001)(42186005)(79102001)(90102001)(87976001)(21056001)(19580395003)(77156001)(19580405001)(83322001)(101416001)(3826002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0724;H:[IPv6:2601:2:5800:3f7:7941:f206:1e28:f0a];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-04 at 13:06 +0800, Zhao Qiang wrote:
> LS1 is arm cpu and it has qe ip block.
> move qe code from platform directory to public directory.
> 
> QE is an IP block integrates several comunications peripheral
> controllers. It can implement a variety of applications, such
> as uart, usb and tdm and so on.
> 
> Signed-off-by: Zhao Qiang <B45475@freescale.com>
> ---
> Changes for v2:
> 	- mv code to drivers/soc

Who will be the maintainer of this code once it lives in drivers/soc,
especially once it is no longer used only by PPC?

>  44 files changed, 113 insertions(+), 113 deletions(-)
>  delete mode 100644 arch/powerpc/sysdev/qe_lib/Kconfig
>  create mode 100644 drivers/soc/qe/Kconfig
>  rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/Makefile (100%)
>  rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/gpio.c (99%)
>  rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/qe.c (99%)
>  rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/qe_ic.c (99%)
>  rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/qe_ic.h (98%)
>  rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/qe_io.c (99%)
>  rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/ucc.c (98%)
>  rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/ucc_fast.c (98%)
>  rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/ucc_slow.c (98%)
>  rename {arch/powerpc/sysdev/qe_lib => drivers/soc/qe}/usb.c (96%)

drivers/soc/fsl-qe

> diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
> index 0f7c447..5da1a482 100644
> --- a/drivers/soc/Makefile
> +++ b/drivers/soc/Makefile
> @@ -3,3 +3,5 @@
>  #
>  
>  obj-$(CONFIG_ARCH_QCOM)		+= qcom/
> +
> +obj-$(CONFIG_QUICC_ENGINE)     += qe/

Please keep the file consistent regarding tabs versus spaces.

Plus, why do you need a newline between them?

> diff --git a/drivers/soc/qe/Kconfig b/drivers/soc/qe/Kconfig
> new file mode 100644
> index 0000000..8b03ca2
> --- /dev/null
> +++ b/drivers/soc/qe/Kconfig
> @@ -0,0 +1,45 @@
> +#
> +# QE Communication options
> +#
> +config QUICC_ENGINE
> +	bool "Freescale QUICC Engine (QE) Support"
> +	depends on FSL_SOC && PPC32
> +	select PPC_LIB_RHEAP
> +	select CRC32
> +	help
> +	  The QUICC Engine (QE) is a new generation of communications
> +	  coprocessors on Freescale embedded CPUs (akin to CPM in older chips).
> +	  Selecting this option means that you wish to build a kernel
> +	  for a machine with a QE coprocessor.
> +
> +config QE_GPIO
> +	bool "QE GPIO support"
> +	depends on QUICC_ENGINE
> +	select ARCH_REQUIRE_GPIOLIB
> +	help
> +	  Say Y here if you're going to use hardware that connects to the
> +	  QE GPIOs.
> +
> +config UCC_SLOW
> +	bool
> +	default y if SERIAL_QE
> +	help
> +	  This option provides qe_lib support to UCC slow
> +	  protocols: UART, BISYNC, QMC
> +
> +config UCC_FAST
> +	bool
> +	default y if UCC_GETH
> +	help
> +	  This option provides qe_lib support to UCC fast
> +	  protocols: HDLC, Ethernet, ATM, transparent
> +
> +config UCC
> +	bool
> +	default y if UCC_FAST || UCC_SLOW
> +
> +config QE_USB
> +	bool
> +	default y if USB_FSL_QE
> +	help
> +	  QE USB Controller support

First could we give these names better namespacing?

-Scott


