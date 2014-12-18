Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaLRLXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:23:21 -0500
Received: from mail-bn1bbn0102.outbound.protection.outlook.com ([157.56.111.102]:22336
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751057AbaLRLXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:23:19 -0500
X-Greylist: delayed 32426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Dec 2014 06:23:19 EST
Message-ID: <1418901787.5581.131.camel@freescale.com>
Subject: Re: [v2 PATCH 1/2] powerpc32: adds handling of _PAGE_RO
From: Scott Wood <scottwood@freescale.com>
To: leroy christophe <christophe.leroy@c-s.fr>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>,
        "Joakim Tjernlund" <joakim.tjernlund@transmode.se>
Date: Thu, 18 Dec 2014 05:23:07 -0600
In-Reply-To: <54927E1E.1030407@c-s.fr>
References: <20141217091431.D3F761A5E0D@localhost.localdomain>
	 <1418868868.5581.121.camel@freescale.com> <54927E1E.1030407@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: CY1PR12CA0036.namprd12.prod.outlook.com (25.160.137.46) To
 BY2PR0301MB0728.namprd03.prod.outlook.com (25.160.63.18)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=scottwood@freescale.com; 
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0728;
X-Forefront-PRVS: 042957ACD7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(479174004)(377424004)(24454002)(199003)(51704005)(110136001)(31966008)(89996001)(107046002)(4396001)(120916001)(50226001)(97736003)(23676002)(21056001)(36756003)(46102003)(87976001)(50986999)(62966003)(77156002)(40100003)(19580405001)(105586002)(76176999)(42186005)(64706001)(33646002)(86362001)(92566001)(50466002)(101416001)(106356001)(20776003)(122386002)(47776003)(2950100001)(103116003)(68736005)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0728;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0728;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-18 at 08:11 +0100, leroy christophe wrote:
> Le 18/12/2014 03:14, Scott Wood a écrit :
> > On Wed, 2014-12-17 at 10:14 +0100, Christophe Leroy wrote:
> >> Some powerpc like the 8xx don't have a RW bit in PTE bits but a RO (Read Only) bit.
> >> This patch implements the handling of a _PAGE_RO flag to be used in place of _PAGE_RW
> >>
> >> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> >>
> >> ---
> >> v2 is a complete rework compared to v1
> >>
> >>   arch/powerpc/include/asm/pgtable-ppc32.h | 11 ++++++-----
> >>   arch/powerpc/include/asm/pgtable.h       | 10 +++++++---
> >>   arch/powerpc/include/asm/pte-common.h    | 27 ++++++++++++++++++---------
> >>   arch/powerpc/mm/gup.c                    |  2 ++
> >>   arch/powerpc/mm/mem.c                    |  2 +-
> >>   arch/powerpc/mm/pgtable_32.c             | 24 ++++++++++++++++++++----
> >>   6 files changed, 54 insertions(+), 22 deletions(-)
> >>
> >> diff --git a/arch/powerpc/include/asm/pgtable-ppc32.h b/arch/powerpc/include/asm/pgtable-ppc32.h
> >> index 543bb8e..64ed9e1 100644
> >> --- a/arch/powerpc/include/asm/pgtable-ppc32.h
> >> +++ b/arch/powerpc/include/asm/pgtable-ppc32.h
> >> @@ -125,7 +125,7 @@ extern int icache_44x_need_flush;
> >>   #ifndef __ASSEMBLY__
> >>   
> >>   #define pte_clear(mm, addr, ptep) \
> >> -	do { pte_update(ptep, ~_PAGE_HASHPTE, 0); } while (0)
> >> +	do { pte_update(ptep, ~_PAGE_HASHPTE, _PAGE_RO); } while (0)
> > Is this really necessary?  It's already clearing the valid bit.
> >
> > Likewise in several other places that set or check for _PAGE_RO on pages
> > for which no access is permitted.
> >
> >> @@ -287,8 +287,9 @@ static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
> >>   static inline void __ptep_set_access_flags(pte_t *ptep, pte_t entry)
> >>   {
> >>   	unsigned long bits = pte_val(entry) &
> >> -		(_PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_RW | _PAGE_EXEC);
> >> -	pte_update(ptep, 0, bits);
> >> +		(_PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_RW | _PAGE_RO |
> >> +		 _PAGE_EXEC);
> >> +	pte_update(ptep, _PAGE_RO, bits);
> >>   }
> > You're unconditionally clearing _PAGE_RO, and apparently relying on the
> > undocumented behavior of pte_update() to clear "clr" before setting
> > "set".
> >
> > Instead I'd write this as:
> >
> > 	unsigned long set = pte_val(entry) &
> > 		(_PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_RW | _PAGE_EXEC);
> > 	unsigned long clr = pte_val(entry) & _PAGE_RO;
> Don't you mean ?
> 
> 	unsigned long clr = ~pte_val(entry) & _PAGE_RO;
> 
> Because, we want to clear _PAGE_RO when _PAGE_RO is not set in entry.

Yes, sorry.

-Scott


