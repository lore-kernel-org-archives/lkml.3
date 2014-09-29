Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbaI2SgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:36:17 -0400
Received: from mail-bn1bon0117.outbound.protection.outlook.com ([157.56.111.117]:39808
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750906AbaI2SgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:36:16 -0400
Message-ID: <1412015766.13320.253.camel@snotra.buserror.net>
Subject: Re: [PATCH] powerpc/fsl: Add support for pci(e) machine check
 exception on E500MC / E5500
From: Scott Wood <scottwood@freescale.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, "Jojy G Varghese" <jojyv@juniper.net>,
        Guenter Roeck <groeck@juniper.net>, <hongtao.jia@freescale.com>
Date: Mon, 29 Sep 2014 13:36:06 -0500
In-Reply-To: <1412009312-7400-1-git-send-email-linux@roeck-us.net>
References: <1412009312-7400-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:cc8b:f9eb:f03b:cf1d]
X-ClientProxiedBy: BLUPR08CA0063.namprd08.prod.outlook.com (10.141.200.43) To
 CY1PR0301MB0731.namprd03.prod.outlook.com (25.160.159.149)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0731;
X-Forefront-PRVS: 034902F5BC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(377424004)(51704005)(199003)(83072002)(79102003)(80022003)(74502003)(81542003)(77982003)(81342003)(89996001)(46102003)(74662003)(101416001)(15202345003)(20776003)(85852003)(15975445006)(10300001)(120916001)(23676002)(76482002)(99396003)(103116003)(50466002)(42186005)(50986999)(76176999)(64706001)(47776003)(87286001)(104166001)(102836001)(87976001)(21056001)(92566001)(19580395003)(88136002)(93916002)(86362001)(92726001)(50226001)(4396001)(19580405001)(83322001)(31966008)(33646002)(90102001)(85306004)(95666004)(106356001)(77156001)(105586002)(97736003)(62966002)(110136001)(107046002)(77096002)(7059020);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0731;H:[IPv6:2601:2:5800:3f7:cc8b:f9eb:f03b:cf1d];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-29 at 09:48 -0700, Guenter Roeck wrote:
> From: Jojy G Varghese <jojyv@juniper.net>
> 
> For E500MC and E5500, a machine check exception in pci(e) memory space
> crashes the kernel.
> 
> Testing shows that the MCAR(U) register is zero on a MC exception for the
> E5500 core. At the same time, DEAR register has been found to have the
> address of the faulty load address during an MC exception for this core.
> 
> This fix changes the current behavior to fixup the result register
> and instruction pointers in the case of a load operation on a faulty
> PCI address.
> 
> The changes are:
> - Added the hook to pci machine check handing to the e500mc machine check
>   exception handler.
> - For the E5500 core, load faulting address from SPRN_DEAR register.
>   As mentioned above, this is necessary because the E5500 core does not
>   report the fault address in the MCAR register.
> 
> Cc: Scott Wood <scottwood@freescale.com>
> Signed-off-by: Jojy G Varghese <jojyv@juniper.net>
> [Guenter Roeck: updated description]
> Signed-off-by: Guenter Roeck <groeck@juniper.net>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  arch/powerpc/kernel/traps.c   | 3 ++-
>  arch/powerpc/sysdev/fsl_pci.c | 5 +++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
> index 0dc43f9..ecb709b 100644
> --- a/arch/powerpc/kernel/traps.c
> +++ b/arch/powerpc/kernel/traps.c
> @@ -494,7 +494,8 @@ int machine_check_e500mc(struct pt_regs *regs)
>  	int recoverable = 1;
>  
>  	if (reason & MCSR_LD) {
> -		recoverable = fsl_rio_mcheck_exception(regs);
> +		recoverable = fsl_rio_mcheck_exception(regs) ||
> +			fsl_pci_mcheck_exception(regs);
>  		if (recoverable == 1)
>  			goto silent_out;
>  	}
> diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
> index c507767..bdb956b 100644
> --- a/arch/powerpc/sysdev/fsl_pci.c
> +++ b/arch/powerpc/sysdev/fsl_pci.c
> @@ -1021,6 +1021,11 @@ int fsl_pci_mcheck_exception(struct pt_regs *regs)
>  #endif
>  	addr += mfspr(SPRN_MCAR);
>  
> +#ifdef CONFIG_E5500_CPU
> +	if (mfspr(SPRN_EPCR) & SPRN_EPCR_ICM)
> +		addr = PFN_PHYS(vmalloc_to_pfn((void *)mfspr(SPRN_DEAR)));
> +#endif

Kconfig tells you what hardware is supported, not what hardware you're
actually running on.

Jia Hongtao, do you know anything about this issue?  Is there an
erratum?  What chips are affected by the the erratum covered by
<http://patchwork.ozlabs.org/patch/240239/>?

Can we rely on DEAR or is this just a side effect of likely having taken
a TLB miss for the address recently?  Perhaps we should use the
instruction emulation to determine the effective address instead.

Guenter, is this patch intended to deal with an erratum or are you
covering up legitimate errors?

-Scott


