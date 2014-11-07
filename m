Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaKGDh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 22:37:57 -0500
Received: from mail-bl2on0120.outbound.protection.outlook.com ([65.55.169.120]:25766
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751216AbaKGDh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 22:37:56 -0500
Date: Thu, 6 Nov 2014 21:37:45 -0600
From: Scott Wood <scottwood@freescale.com>
To: LEROY Christophe <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [v4,17/21] powerpc/8xx: set PTE bit 22 off TLBmiss
Message-ID: <20141107033745.GA23796@home.buserror.net>
References: <20140919083609.A92871AB040@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140919083609.A92871AB040@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [2601:2:5800:3f7:5c04:72f8:a6ec:82b5]
X-ClientProxiedBy: DM2PR10CA0053.namprd10.prod.outlook.com (10.141.241.21) To
 BY2PR0301MB0727.namprd03.prod.outlook.com (25.160.63.17)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0727;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(189002)(24454002)(95666004)(50466002)(33656002)(92566001)(50986999)(575784001)(97756001)(46406003)(4396001)(101416001)(102836001)(106356001)(107046002)(54356999)(105586002)(87976001)(21056001)(110136001)(31966008)(53416004)(69596002)(64706001)(19580405001)(20776003)(77156002)(83506001)(99396003)(77096003)(86362001)(81156004)(92726001)(47776003)(122386002)(46102003)(23726002)(40100003)(97736003)(42186005)(120916001)(62966003)(76176999)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0727;H:home.buserror.net;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 10:36:09AM +0200, LEROY Christophe wrote:
> No need to re-set this bit at each TLB miss. Let's set it in the PTE.
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> ---
> Changes in v2:
> - None
> 
> Changes in v3:
> - Removed PPC405 related macro from PPC8xx specific code
> - PTE_NONE_MASK doesn't need PAGE_ACCESSED in Linux 2.6
> 
> Changes in v4:
> - None
> 
>  arch/powerpc/include/asm/pgtable-ppc32.h | 20 ++++++++++++++++++++
>  arch/powerpc/include/asm/pte-8xx.h       |  7 +++++--
>  arch/powerpc/kernel/head_8xx.S           | 10 ++--------
>  3 files changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
> index 47edde8..35a9b44 100644
> --- a/arch/powerpc/include/asm/pgtable-ppc32.h
> +++ b/arch/powerpc/include/asm/pgtable-ppc32.h
> @@ -172,6 +172,25 @@ static inline unsigned long pte_update(pte_t *p,
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
> +"	stwcx.	%1,0,%4\n\
> +	bne-	1b"

Why do you need this...

> diff --git a/arch/powerpc/include/asm/pte-8xx.h b/arch/powerpc/include/asm/pte-8xx.h
> index d44826e..daa4616 100644
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
> +#define _PTE_NONE_MASK _PAGE_KNLRO
>  
>  /* Until my rework is finished, 8xx still needs atomic PTE updates */
>  #define PTE_ATOMIC_UPDATES	1
>  
>  /* We need to add _PAGE_SHARED to kernel pages */
> -#define _PAGE_KERNEL_RO	(_PAGE_SHARED)
> +#define _PAGE_KERNEL_RO	(_PAGE_SHARED | _PAGE_KNLRO)
> +#define _PAGE_KERNEL_ROX	(_PAGE_EXEC | _PAGE_KNLRO)
>  #define _PAGE_KERNEL_RW	(_PAGE_DIRTY | _PAGE_RW | _PAGE_HWWRITE)

...if 0x200 is already being set in the PTE here?

-Scott
