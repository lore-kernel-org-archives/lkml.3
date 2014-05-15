Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbaEOIz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:55:59 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:6150
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752673AbaEOIz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:55:56 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Richard Lee <superlibj8301@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "robherring2@gmail.com" <robherring2@gmail.com>
CC: "lauraa@codeaurora.org" <lauraa@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ARM: ioremap: Fix static vm area boundary checking.
Thread-Topic: [PATCH] ARM: ioremap: Fix static vm area boundary checking.
Thread-Index: AQHPcAmh9FEH4l+knUOpi0O5NT2h4ZtBVhOQ
Date: Thu, 15 May 2014 08:55:52 +0000
Message-ID: <623d49a4a07f4e5a956ccc8c2725e557@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1400133427-5653-1-git-send-email-superlibj8301@gmail.com>
In-Reply-To: <1400133427-5653-1-git-send-email-superlibj8301@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(164054003)(189002)(199002)(51704005)(99396002)(74662001)(21056001)(99286001)(76482001)(2656002)(74502001)(54356999)(77096999)(87936001)(50986999)(33646001)(83072002)(31966008)(76176999)(74316001)(77982001)(4396001)(76576001)(46102001)(2201001)(81542001)(81342001)(64706001)(19580405001)(20776003)(19580395003)(83322001)(85852003)(80022001)(15975445006)(79102001)(92566001)(101416001)(86362001)(15202345003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB507;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH] ARM: ioremap: Fix static vm area boundary checking.
> 
> Static vm area boundary check:
> 
>       paddr1 --->|       |
>                  |       |
>                  |-------| <-\--- svm->vm->addr(is page aligned)
>       paddr2 --->|       |    |
>                  |     --| <--|-- svm->vm->phys_addr
>                  |       |    |
>       paddr3 --->|       |    |
>                  |       |    |
>                  |-------| <--|-- next page boundary
>                  |       |    |
>       paddr4 --->|       |    | <----- svm->vm->size(including guard page)
>                  |       |    |
>                  |       |    |
> max paddr_end -->|-------| <--|-- svm->vm's phys_addr_end
>                  | ///// |    |
>       paddr5 --->| guard |    |
>                  | page  |    |
>                  | ///// |    |
>                   -------  <-/--- svm->vm->addr + svm->vm_size
> 
> <1> If the paddr == paddr1, then continue;
> <2> If the paddr == paddr2~paddr4 and paddr_end > phys_addr_end,
>     then continue;
> <3> if the paddr >= paddr5 then continue;
> 
> Signed-off-by: Richard Lee <superlibj8301@gmail.com>
> ---
>  arch/arm/mm/ioremap.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
> index be69333..2fa41f4 100644
> --- a/arch/arm/mm/ioremap.c
> +++ b/arch/arm/mm/ioremap.c
> @@ -47,16 +47,56 @@ static struct static_vm *find_static_vm_paddr(phys_addr_t
> paddr,
>  {
>  	struct static_vm *svm;
>  	struct vm_struct *vm;
> +	size_t offset;
> +
> +	/*
> +	 * Make sure the size the mapping size is page aligned.
> +	 */
> +	size = PAGE_ALIGN((paddr & ~PAGE_SIZE) + size);
> +	offset = paddr & ~PAGE_SIZE;
> 

Shouldn't it be PAGE_MASK ?


>  	list_for_each_entry(svm, &static_vmlist, list) {
> +		phys_addr_t paddr_end, phys_addr_end;
> +		size_t vmoff;
> +
>  		vm = &svm->vm;
>  		if (!(vm->flags & VM_ARM_STATIC_MAPPING))
>  			continue;
>  		if ((vm->flags & VM_ARM_MTYPE_MASK) != VM_ARM_MTYPE(mtype))
>  			continue;
> 
> -		if (vm->phys_addr > paddr ||
> -			paddr + size - 1 > vm->phys_addr + vm->size - 1)
> +		/* Static vm area boundary check:
> +		 *
> +		 *       paddr1 --->|       |
> +		 *                  |       |
> +		 *                  |-------| <-\--- svm->vm->addr(page aligned)
> +		 *       paddr2 --->|       |    |
> +		 *                  |     --| <--|-- svm->vm->phys_addr
> +		 *                  |       |    |
> +		 *       paddr3 --->|       |    |
> +		 *                  |       |    |
> +		 *                  |-------| <--|-- next page boundary
> +		 *                  |       |    |
> +		 *       paddr4 --->|       |    | <----- svm->vm->size,
> +		 *                  |       |    |         including guard page
> +		 *                  |       |    |
> +		 * max paddr_end -->|-------| <--|-- svm->vm's phys_addr_end
> +		 *                  | ///// |    |
> +		 *       paddr5 --->| guard |    |
> +		 *                  | page  |    |
> +		 *                  | ///// |    |
> +		 *                   -------  <-/-- svm->vm->addr + svm->vm_size
> +		 *
> +		 * <1> If paddr == paddr1, then continue;
> +		 * <2> If paddr == paddr2~paddr4 and paddr_end > phys_addr_end,
> +		 *     then continue;
> +		 * <3> if paddr >= paddr5 then continue;
> +		 */
> +		vmoff = vm->phys_addr & ~PAGE_SIZE;

And here.

Thanks,
BRs
Xiubo

> +		phys_addr_end = vm->phys_addr + vm->size - PAGE_SIZE - vmoff;
> +		paddr_end = paddr + size - offset;
> +		if (__phys_to_pfn(vm->phys_addr) > __phys_to_pfn(paddr) ||
> +			paddr_end - 1 > phys_addr_end - 1)
>  			continue;
> 
>  		return svm;
> --
> 1.8.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
