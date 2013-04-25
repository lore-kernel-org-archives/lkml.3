Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab3DYL71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:59:27 -0400
Received: from intranet.asianux.com ([58.214.24.6]:1322 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab3DYL70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:59:26 -0400
X-Spam-Score: -100.8
Message-ID: <51791A6E.80504@asianux.com>
Date: Thu, 25 Apr 2013 19:58:38 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>, Paul Mackerras <paulus@samba.org>,
        Michael Neuling <mikey@neuling.org>
CC: Michael Ellerman <michael@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        sfr@canb.auug.org.au, matt@ozlabs.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] PowerPC: kernel: compiling issue, make additional
 room in exception vector area
References: <5177965D.9090406@linux.vnet.ibm.com> <20130424083142.GB26834@concordia> <51779941.8080403@linux.vnet.ibm.com> <30651.1366799858@ale.ozlabs.ibm.com> <1366807638.5911.2.camel@localhost> <5178816D.3000309@asianux.com> <5178ABA2.4030109@linux.vnet.ibm.com> <20130425062539.GA421@iris.ozlabs.ibm.com> <517918AB.4020508@asianux.com>
In-Reply-To: <517918AB.4020508@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mike:

This patch can pass compiling with Mike's config file, under my
cross-compiling environments, but does not run under the real machine,
please try it.

Welcome other members to help check this patch whether valid.

Thanks.


On 2013年04月25日 19:51, Chen Gang wrote:
> 
> When CONFIG_KVM_BOOK3S_64_PR is enabled,
> MASKABLE_EXCEPTION_PSERIES(0x900 ...) will includes __KVMTEST, it will
> exceed 0x980 which STD_EXCEPTION_HV(0x980 ...) will use, it will cause
> compiling issue.
> 
> The related errors:
> arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
> arch/powerpc/kernel/exceptions-64s.S:258: Error: attempt to move .org backwards
> make[1]: *** [arch/powerpc/kernel/head_64.o] Error 1
> 
> The position 0x900 and 0x980 are solid, so can not move the position
> to make room larger. The final solution is to jump to another area to
> execute the related code.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/powerpc/kernel/exceptions-64s.S |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
> index e789ee7..8997de2 100644
> --- a/arch/powerpc/kernel/exceptions-64s.S
> +++ b/arch/powerpc/kernel/exceptions-64s.S
> @@ -254,7 +254,11 @@ hardware_interrupt_hv:
>  	STD_EXCEPTION_PSERIES(0x800, 0x800, fp_unavailable)
>  	KVM_HANDLER_PR(PACA_EXGEN, EXC_STD, 0x800)
>  
> -	MASKABLE_EXCEPTION_PSERIES(0x900, 0x900, decrementer)
> +	. = 0x900
> +	.globl decrementer_pSeries
> +decrementer_pSeries:
> +	b	decrementer_pSeries_0
> +
>  	STD_EXCEPTION_HV(0x980, 0x982, hdecrementer)
>  
>  	MASKABLE_EXCEPTION_PSERIES(0xa00, 0xa00, doorbell_super)
> @@ -536,6 +540,12 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_ARCH_206)
>  #endif
>  
>  	.align	7
> +	/* moved from 0x900 */
> +decrementer_pSeries_0:
> +	_MASKABLE_EXCEPTION_PSERIES(0x900, decrementer,
> +				    EXC_STD, SOFTEN_TEST_PR)
> +
> +	.align	7
>  	/* moved from 0xe00 */
>  	STD_EXCEPTION_HV_OOL(0xe02, h_data_storage)
>  	KVM_HANDLER_SKIP(PACA_EXGEN, EXC_HV, 0xe02)
> 


-- 
Chen Gang

Asianux Corporation
