Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbaCLAKe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 20:10:34 -0400
Received: from [207.46.163.142] ([207.46.163.142]:57485 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755047AbaCLAKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 20:10:32 -0400
Message-ID: <1394582923.13761.81.camel@snotra.buserror.net>
Subject: Re: [PATCH 7/9] fsl: add EPU FSM configuration for deep sleep
From: Scott Wood <scottwood@freescale.com>
To: Chenhui Zhao <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Date: Tue, 11 Mar 2014 19:08:43 -0500
In-Reply-To: <1394168285-32275-7-git-send-email-chenhui.zhao@freescale.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
	 <1394168285-32275-7-git-send-email-chenhui.zhao@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: DM2PR06CA013.namprd06.prod.outlook.com (10.141.154.161)
 To DM2PR03MB400.namprd03.prod.outlook.com (10.141.84.153)
X-Forefront-PRVS: 01480965DA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(51704005)(24454002)(199002)(189002)(74366001)(47776003)(85852003)(79102001)(19580395003)(31966008)(88136002)(92566001)(69226001)(20776003)(51856001)(95416001)(59766001)(56816005)(81686001)(90146001)(63696002)(77096001)(74876001)(83072002)(87976001)(77982001)(46102001)(83322001)(93516002)(19580405001)(85306002)(95666003)(97336001)(33646001)(81342001)(81542001)(93136001)(87266001)(97186001)(87286001)(77156001)(42186004)(74662001)(53806001)(89996001)(50466002)(80976001)(23676002)(47736001)(74502001)(47446002)(94316002)(50226001)(49866001)(62966002)(65816001)(50986001)(80022001)(76482001)(93916002)(92726001)(94946001)(76796001)(86362001)(575784001)(76786001)(56776001)(54316002)(47976001)(81816001)(4396001)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB400;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:BC9FD676.2832966D.F1DA657E.40E73C6D.203F5;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> In the last stage of deep sleep, software will trigger a Finite
> State Machine (FSM) to control the hardware precedure, such as
> board isolation, killing PLLs, removing power, and so on.
> 
> When the system is waked up by an interrupt, the FSM controls the
> hardware to complete the early resume precedure.
> 
> This patch configure the EPU FSM preparing for deep sleep.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>

Couldn't this be part of qoriq_pm.c?

> diff --git a/arch/powerpc/sysdev/fsl_soc.h b/arch/powerpc/sysdev/fsl_soc.h
> index 9b9a34a..eb83a30 100644
> --- a/arch/powerpc/sysdev/fsl_soc.h
> +++ b/arch/powerpc/sysdev/fsl_soc.h
> @@ -69,5 +69,8 @@ extern const struct fsl_pm_ops *qoriq_pm_ops;
>  
>  extern int fsl_rcpm_init(void);
>  
> +extern void fsl_dp_fsm_setup(void *dcsr_base);
> +extern void fsl_dp_fsm_clean(void *dcsr_base);

__iomem

> +
>  #endif
>  #endif
> diff --git a/drivers/platform/Kconfig b/drivers/platform/Kconfig
> index 09fde58..6539e6d 100644
> --- a/drivers/platform/Kconfig
> +++ b/drivers/platform/Kconfig
> @@ -6,3 +6,7 @@ source "drivers/platform/goldfish/Kconfig"
>  endif
>  
>  source "drivers/platform/chrome/Kconfig"
> +
> +if FSL_SOC
> +source "drivers/platform/fsl/Kconfig"
> +endif

Chrome doesn't need an ifdef -- why does this?

> diff --git a/drivers/platform/Makefile b/drivers/platform/Makefile
> index 3656b7b..37c6f72 100644
> --- a/drivers/platform/Makefile
> +++ b/drivers/platform/Makefile
> @@ -6,3 +6,4 @@ obj-$(CONFIG_X86)		+= x86/
>  obj-$(CONFIG_OLPC)		+= olpc/
>  obj-$(CONFIG_GOLDFISH)		+= goldfish/
>  obj-$(CONFIG_CHROME_PLATFORMS)	+= chrome/
> +obj-$(CONFIG_FSL_SOC)		+= fsl/
> diff --git a/drivers/platform/fsl/Kconfig b/drivers/platform/fsl/Kconfig
> new file mode 100644
> index 0000000..72ed053
> --- /dev/null
> +++ b/drivers/platform/fsl/Kconfig
> @@ -0,0 +1,10 @@
> +#
> +# Freescale Specific Power Management Drivers
> +#
> +
> +config FSL_SLEEP_FSM
> +	bool
> +	help
> +	  This driver configures a hardware FSM (Finite State Machine) for deep sleep.
> +	  The FSM is used to finish clean-ups at the last stage of system entering deep
> +	  sleep, and also wakes up system when a wake up event happens.
> diff --git a/drivers/platform/fsl/Makefile b/drivers/platform/fsl/Makefile
> new file mode 100644
> index 0000000..d99ca0e
> --- /dev/null
> +++ b/drivers/platform/fsl/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for linux/drivers/platform/fsl
> +# Freescale Specific Power Management Drivers
> +#
> +obj-$(CONFIG_FSL_SLEEP_FSM)	+= sleep_fsm.o

Why is this here while the other stuff is in arch/powerpc/sysdev?

> +/* Block offsets */
> +#define	RCPM_BLOCK_OFFSET	0x00022000
> +#define	EPU_BLOCK_OFFSET	0x00000000
> +#define	NPC_BLOCK_OFFSET	0x00001000

Why don't these block offsets come from the device tree?

> +static void *g_dcsr_base;

__iomem

> +	/* Configure the EPU Counters */
> +	epu_write(EPCCR15, 0x92840000);
> +	epu_write(EPCCR14, 0x92840000);
> +	epu_write(EPCCR12, 0x92840000);
> +	epu_write(EPCCR11, 0x92840000);
> +	epu_write(EPCCR10, 0x92840000);
> +	epu_write(EPCCR9, 0x92840000);
> +	epu_write(EPCCR8, 0x92840000);
> +	epu_write(EPCCR5, 0x92840000);
> +	epu_write(EPCCR4, 0x92840000);
> +	epu_write(EPCCR2, 0x92840000);
> +
> +	/* Configure the SCUs Inputs */
> +	epu_write(EPSMCR15, 0x76000000);
> +	epu_write(EPSMCR14, 0x00000031);
> +	epu_write(EPSMCR13, 0x00003100);
> +	epu_write(EPSMCR12, 0x7F000000);
> +	epu_write(EPSMCR11, 0x31740000);
> +	epu_write(EPSMCR10, 0x65000030);
> +	epu_write(EPSMCR9, 0x00003000);
> +	epu_write(EPSMCR8, 0x64300000);
> +	epu_write(EPSMCR7, 0x30000000);
> +	epu_write(EPSMCR6, 0x7C000000);
> +	epu_write(EPSMCR5, 0x00002E00);
> +	epu_write(EPSMCR4, 0x002F0000);
> +	epu_write(EPSMCR3, 0x2F000000);
> +	epu_write(EPSMCR2, 0x6C700000);

Where do these magic numbers come from?  Which chips are they valid for?

> +void fsl_dp_fsm_clean(void *dcsr_base)
> +{
> +
> +	epu_write(EPEVTCR2, 0);
> +	epu_write(EPEVTCR9, 0);
> +
> +	epu_write(EPGCR, 0);
> +	epu_write(EPECR15, 0);
> +
> +	rcpm_write(CSTTACR0, 0);
> +	rcpm_write(CG1CR0, 0);
> +
> +}

Don't put blank lines at the beginning/end of a block.

-Scott


