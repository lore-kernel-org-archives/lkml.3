Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab3LRDkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 22:40:22 -0500
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:29766
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751950Ab3LRDkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 22:40:16 -0500
Message-ID: <1387337985.3140.35.camel@snotra.buserror.net>
Subject: Re: [v3][PATCH 4/8] book3e/kexec/kdump: create a 1:1 TLB mapping
From: Scott Wood <scottwood@freescale.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Tue, 17 Dec 2013 21:39:45 -0600
In-Reply-To: <1373357007-30785-5-git-send-email-tiejun.chen@windriver.com>
References: <1373357007-30785-1-git-send-email-tiejun.chen@windriver.com>
	 <1373357007-30785-5-git-send-email-tiejun.chen@windriver.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.255.124.4]
X-ClientProxiedBy: BLUPR03CA002.namprd03.prod.outlook.com (10.255.124.19) To
 DM2PR03MB399.namprd03.prod.outlook.com (10.141.84.148)
X-Forefront-PRVS: 0064B3273C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009001)(57704003)(199002)(51704005)(24454002)(377424004)(189002)(76796001)(80976001)(65816001)(76786001)(80022001)(83322001)(19580405001)(74706001)(79102001)(81686001)(54316002)(81342001)(62966002)(19580395003)(23676002)(87286001)(56776001)(87976001)(74366001)(47776003)(77982001)(90146001)(63696002)(89996001)(69226001)(50466002)(81542001)(50986001)(47736001)(56816005)(47976001)(49866001)(4396001)(50226001)(88136002)(31966008)(74662001)(47446002)(74502001)(51856001)(46102001)(83072002)(85852003)(77096001)(77156001)(74876001)(87266001)(76482001)(85306002)(59766001)(42186004)(53806001)(33646001)(81816001)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB399;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];CLIP:10.255.124.4;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-09 at 16:03 +0800, Tiejun Chen wrote:
> book3e have no real MMU mode so we have to create a 1:1 TLB
> mapping to make sure we can access the real physical address.
> And correct something to support this pseudo real mode on book3e.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>

Why do we need to be able to directly access physical addresses?

> diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
> index f1a7ce7..20cbb98 100644
> --- a/arch/powerpc/kernel/misc_64.S
> +++ b/arch/powerpc/kernel/misc_64.S
> @@ -460,6 +460,49 @@ kexec_flag:
>  
> 
>  #ifdef CONFIG_KEXEC
> +#ifdef CONFIG_PPC_BOOK3E
> +/* BOOK3E have no a real MMU mode so we have to setup the initial TLB
> + * for a core to map v:0 to p:0 as 1:1. This current implementation
> + * assume that 1G is enough for kexec.
> + */
> +#include <asm/mmu.h>

#includes go at the top of the file.

> +kexec_create_tlb:
> +	/* Invalidate all TLBs to avoid any TLB conflict. */
> +	PPC_TLBILX_ALL(0,R0)
> +	sync
> +	isync
> +
> +	mfspr	r10,SPRN_TLB1CFG
> +	andi.	r10,r10,TLBnCFG_N_ENTRY	/* Extract # entries */
> +	subi	r10,r10,1		/* Often its always safe to use last */
> +	lis	r9,MAS0_TLBSEL(1)@h
> +	rlwimi	r9,r10,16,4,15		/* Setup MAS0 = TLBSEL | ESEL(r9) */

Hardcoding TLB1 makes this FSL-specific code, but you've put it in a
non-FSL-specific place.

> +/* Setup a temp mapping v:0 to p:0 as 1:1 and return to it.
> + */
> +#ifdef CONFIG_SMP
> +#define M_IF_SMP	MAS2_M
> +#else
> +#define M_IF_SMP	0
> +#endif
> +	mtspr	SPRN_MAS0,r9
> +
> +	lis	r9,(MAS1_VALID|MAS1_IPROT)@h
> +	ori	r9,r9,(MAS1_TSIZE(BOOK3E_PAGESZ_1GB))@l
> +	mtspr	SPRN_MAS1,r9

What if the machine has less than 1 GiB of RAM?  We could get
speculative accesses to non-present addresses.

Though it looks like the normal 64-bit init sequence has the same
problem...

-Scott


