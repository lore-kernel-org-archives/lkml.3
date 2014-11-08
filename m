Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaKHAIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:08:41 -0500
Received: from mail-bl2on0145.outbound.protection.outlook.com ([65.55.169.145]:20016
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753230AbaKHAIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:08:40 -0500
Message-ID: <1415405305.3805.45.camel@snotra.buserror.net>
Subject: Re: [v4,17/21] powerpc/8xx: set PTE bit 22 off TLBmiss
From: Scott Wood <scottwood@freescale.com>
To: leroy christophe <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 7 Nov 2014 18:08:25 -0600
In-Reply-To: <545C7C2E.3060109@c-s.fr>
References: <20140919083609.A92871AB040@localhost.localdomain>
	 <20141107033745.GA23796@home.buserror.net> <545C7C2E.3060109@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2601:2:5800:3f7:39d9:e257:9f3c:9dae]
X-ClientProxiedBy: DM2PR10CA0064.namprd10.prod.outlook.com (10.141.241.32) To
 BY2PR0301MB0726.namprd03.prod.outlook.com (25.160.63.16)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0726;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(377424004)(199003)(24454002)(51704005)(479174003)(189002)(46102003)(21056001)(101416001)(50226001)(89996001)(102836001)(42186005)(92566001)(92726001)(33646002)(87286001)(19580405001)(97736003)(20776003)(107046002)(31966008)(50466002)(87976001)(122386002)(50986999)(105586002)(40100003)(77156002)(110136001)(86362001)(64706001)(23676002)(106356001)(575784001)(103116003)(104166001)(95666004)(120916001)(76176999)(77096003)(62966003)(47776003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0726;H:[IPv6:2601:2:5800:3f7:39d9:e257:9f3c:9dae];FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0615;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 09:00 +0100, leroy christophe wrote:
> Le 07/11/2014 04:37, Scott Wood a écrit :
> > On Fri, Sep 19, 2014 at 10:36:09AM +0200, LEROY Christophe wrote:
> >> No need to re-set this bit at each TLB miss. Let's set it in the PTE.
> >>
> >> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> >> ---
> >> Changes in v2:
> >> - None
> >>
> >> Changes in v3:
> >> - Removed PPC405 related macro from PPC8xx specific code
> >> - PTE_NONE_MASK doesn't need PAGE_ACCESSED in Linux 2.6
> >>
> >> Changes in v4:
> >> - None
> >>
> >>   arch/powerpc/include/asm/pgtable-ppc32.h | 20 ++++++++++++++++++++
> >>   arch/powerpc/include/asm/pte-8xx.h       |  7 +++++--
> >>   arch/powerpc/kernel/head_8xx.S           | 10 ++--------
> >>   3 files changed, 27 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
> >> index 47edde8..35a9b44 100644
> >> --- a/arch/powerpc/include/asm/pgtable-ppc32.h
> >> +++ b/arch/powerpc/include/asm/pgtable-ppc32.h
> >> @@ -172,6 +172,25 @@ static inline unsigned long pte_update(pte_t *p,
> >>   #ifdef PTE_ATOMIC_UPDATES
> >>   	unsigned long old, tmp;
> >>   
> >> +#ifdef CONFIG_PPC_8xx
> >> +	unsigned long tmp2;
> >> +
> >> +	__asm__ __volatile__("\
> >> +1:	lwarx	%0,0,%4\n\
> >> +	andc	%1,%0,%5\n\
> >> +	or	%1,%1,%6\n\
> >> +	/* 0x200 == Extended encoding, bit 22 */ \
> >> +	/* Bit 22 has to be 1 if neither _PAGE_USER nor _PAGE_RW are set */ \
> >> +	rlwimi	%1,%1,32-2,0x200\n /* get _PAGE_USER */ \
> >> +	rlwinm	%3,%1,32-1,0x200\n /* get _PAGE_RW */ \
> >> +	or	%1,%3,%1\n\
> >> +	xori	%1,%1,0x200\n"
> >> +"	stwcx.	%1,0,%4\n\
> >> +	bne-	1b"
> > Why do you need this...
> >
> >> diff --git a/arch/powerpc/include/asm/pte-8xx.h b/arch/powerpc/include/asm/pte-8xx.h
> >> index d44826e..daa4616 100644
> >> --- a/arch/powerpc/include/asm/pte-8xx.h
> >> +++ b/arch/powerpc/include/asm/pte-8xx.h
> >> @@ -48,19 +48,22 @@
> >>    */
> >>   #define _PAGE_RW	0x0400	/* lsb PP bits, inverted in HW */
> >>   #define _PAGE_USER	0x0800	/* msb PP bits */
> >> +/* set when neither _PAGE_USER nor _PAGE_RW are set */
> >> +#define _PAGE_KNLRO	0x0200
> >>   
> >>   #define _PMD_PRESENT	0x0001
> >>   #define _PMD_BAD	0x0ff0
> >>   #define _PMD_PAGE_MASK	0x000c
> >>   #define _PMD_PAGE_8M	0x000c
> >>   
> >> -#define _PTE_NONE_MASK _PAGE_ACCESSED
> >> +#define _PTE_NONE_MASK _PAGE_KNLRO
> >>   
> >>   /* Until my rework is finished, 8xx still needs atomic PTE updates */
> >>   #define PTE_ATOMIC_UPDATES	1
> >>   
> >>   /* We need to add _PAGE_SHARED to kernel pages */
> >> -#define _PAGE_KERNEL_RO	(_PAGE_SHARED)
> >> +#define _PAGE_KERNEL_RO	(_PAGE_SHARED | _PAGE_KNLRO)
> >> +#define _PAGE_KERNEL_ROX	(_PAGE_EXEC | _PAGE_KNLRO)
> >>   #define _PAGE_KERNEL_RW	(_PAGE_DIRTY | _PAGE_RW | _PAGE_HWWRITE)
> > ...if 0x200 is already being set in the PTE here?
> >
> If I understand well the way it works, those defines are used for 
> setting the PTE the first time.
> Then, pte_update() is used to modify the pte settings on an existing pte
> 
> 0x200 must be set when and only when the page is a RO kernel page. If 
> later on pte_update() is called for instance to set the page to RW, the 
> 0x200 has to be removed. Same, if pte_update() is called to remove 
> _PAGE_RW (ptep_set_wrprotect() does this), 0x200 must be set back.

OK, so the _PAGE_KERNEL_RO(X) stuff is because initially setting the PTE
doesn't go through pte_update().

I'll apply this, though it'd be cleaner to just have 8xx versions of the
relevant PTE accessor functions to maintain the PTE the way the hardware
wants (this would also eliminate the _PAGE_RW inversion that's still in
the TLB miss handler).

-Scott


