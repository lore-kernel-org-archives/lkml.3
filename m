Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaH2Sl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:41:26 -0400
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:48495
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753154AbaH2SlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:41:25 -0400
Message-ID: <1409337669.24184.0.camel@snotra.buserror.net>
Subject: Re: [PATCH v2 17/19] powerpc/8xx: set PTE bit 22 off TLBmiss
From: Scott Wood <scottwood@freescale.com>
To: Christophe Leroy <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Fri, 29 Aug 2014 13:41:09 -0500
In-Reply-To: <20140829091440.6DAD91ABD66@localhost.localdomain>
References: <20140829091440.6DAD91ABD66@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:6853:5536:db43:a2c7]
X-ClientProxiedBy: CO2PR11CA0024.namprd11.prod.outlook.com (10.141.242.162) To
 CY1PR0301MB0732.namprd03.prod.outlook.com (25.160.159.150)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0318501FAE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(6009001)(189002)(51704005)(24454002)(199003)(377424004)(50986999)(74502001)(74662001)(77156001)(87286001)(90102001)(92566001)(19580405001)(92726001)(83322001)(99396002)(31966008)(86362001)(575784001)(89996001)(33646002)(93916002)(76176999)(87976001)(23676002)(50226001)(4396001)(81342001)(88136002)(62966002)(81542001)(47776003)(20776003)(21056001)(64706001)(85306004)(80022001)(79102001)(105586002)(76482001)(95666004)(110136001)(106356001)(101416001)(104166001)(85852003)(50466002)(103116003)(77096002)(102836001)(42186005)(46102001)(77982001)(107046002)(3826002);DIR:OUT;SFP:;SCL:1;SRVR:CY1PR0301MB0732;H:[IPv6:2601:2:5800:3f7:6853:5536:db43:a2c7];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-29 at 11:14 +0200, Christophe Leroy wrote:
> No need to re-set this bit at each TLB miss. Let's set it in the PTE.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> 
> ---
>  arch/powerpc/include/asm/pgtable-ppc32.h |   21 +++++++++++++++++++++
>  arch/powerpc/include/asm/pte-8xx.h       |    7 +++++--
>  arch/powerpc/kernel/head_8xx.S           |   10 ++--------
>  3 files changed, 28 insertions(+), 10 deletions(-)
> 

When you post a vN+1 please indicate below the --- what changed sinced
vN.

-Scott

> diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
> index 47edde8..c261792 100644
> --- a/arch/powerpc/include/asm/pgtable-ppc32.h
> +++ b/arch/powerpc/include/asm/pgtable-ppc32.h
> @@ -172,6 +172,26 @@ static inline unsigned long pte_update(pte_t *p,
>  #ifdef PTE_ATOMIC_UPDATES
>  	unsigned long old, tmp;
>  
> +#ifdef CONFIG_PPC_8xx
> +	unsigned long tmp2;
> +
> +	__asm__ __volatile__("\
> +1:	lwarx	%0,0,%4\n\
> +	andc	%1,%0,%5\n\
> +	or	%1,%1,%6\n\
> +	/* 0x200 == Extended encoding, bit 22 */ \
> +	/* Bit 22 has to be 1 if neither _PAGE_USER nor _PAGE_RW are set */ \
> +	rlwimi	%1,%1,32-2,0x200\n /* get _PAGE_USER */ \
> +	rlwinm	%3,%1,32-1,0x200\n /* get _PAGE_RW */ \
> +	or	%1,%3,%1\n\
> +	xori	%1,%1,0x200\n"
> +	PPC405_ERR77(0,%4)
> +"	stwcx.	%1,0,%4\n\
> +	bne-	1b"
> +	: "=&r" (old), "=&r" (tmp), "=m" (*p), "=&r" (tmp2)
> +	: "r" (p), "r" (clr), "r" (set), "m" (*p)
> +	: "cc" );
> +#else /* CONFIG_PPC_8xx */
>  	__asm__ __volatile__("\
>  1:	lwarx	%0,0,%3\n\
>  	andc	%1,%0,%4\n\
> @@ -182,6 +202,7 @@ static inline unsigned long pte_update(pte_t *p,
>  	: "=&r" (old), "=&r" (tmp), "=m" (*p)
>  	: "r" (p), "r" (clr), "r" (set), "m" (*p)
>  	: "cc" );
> +#endif /* CONFIG_PPC_8xx */
>  #else /* PTE_ATOMIC_UPDATES */
>  	unsigned long old = pte_val(*p);
>  	*p = __pte((old & ~clr) | set);
> diff --git a/arch/powerpc/include/asm/pte-8xx.h b/arch/powerpc/include/asm/pte-8xx.h
> index d44826e..dede1e7 100644
> --- a/arch/powerpc/include/asm/pte-8xx.h
> +++ b/arch/powerpc/include/asm/pte-8xx.h
> @@ -48,19 +48,22 @@
>   */
>  #define _PAGE_RW	0x0400	/* lsb PP bits, inverted in HW */
>  #define _PAGE_USER	0x0800	/* msb PP bits */
> +/* set when neither _PAGE_USER nor _PAGE_RW are set */
> +#define _PAGE_KNLRO	0x0200
>  
>  #define _PMD_PRESENT	0x0001
>  #define _PMD_BAD	0x0ff0
>  #define _PMD_PAGE_MASK	0x000c
>  #define _PMD_PAGE_8M	0x000c
>  
> -#define _PTE_NONE_MASK _PAGE_ACCESSED
> +#define _PTE_NONE_MASK (_PAGE_ACCESSED | _PAGE_KNLRO)
>  
>  /* Until my rework is finished, 8xx still needs atomic PTE updates */
>  #define PTE_ATOMIC_UPDATES	1
>  
>  /* We need to add _PAGE_SHARED to kernel pages */
> -#define _PAGE_KERNEL_RO	(_PAGE_SHARED)
> +#define _PAGE_KERNEL_RO	(_PAGE_SHARED | _PAGE_KNLRO)
> +#define _PAGE_KERNEL_ROX	(_PAGE_EXEC | _PAGE_KNLRO)
>  #define _PAGE_KERNEL_RW	(_PAGE_DIRTY | _PAGE_RW | _PAGE_HWWRITE)
>  
>  #endif /* __KERNEL__ */
> diff --git a/arch/powerpc/kernel/head_8xx.S b/arch/powerpc/kernel/head_8xx.S
> index a7af26e..48d3de8 100644
> --- a/arch/powerpc/kernel/head_8xx.S
> +++ b/arch/powerpc/kernel/head_8xx.S
> @@ -445,14 +445,8 @@ DataStoreTLBMiss:
>  	and	r11, r11, r10
>  	rlwimi	r10, r11, 0, _PAGE_PRESENT
>  #endif
> -	/* Honour kernel RO, User NA */
> -	/* 0x200 == Extended encoding, bit 22 */
> -	rlwimi	r10, r10, 32-2, 0x200 /* Copy USER to bit 22, 0x200 */
> -	/* r11 =  (r10 & _PAGE_RW) >> 1 */
> -	rlwinm	r11, r10, 32-1, 0x200
> -	or	r10, r11, r10
> -	/* invert RW and 0x200 bits */
> -	xori	r10, r10, _PAGE_RW | 0x200
> +	/* invert RW */
> +	xori	r10, r10, _PAGE_RW
>  
>  	/* The Linux PTE won't go exactly into the MMU TLB.
>  	 * Software indicator bits 22 and 28 must be clear.


