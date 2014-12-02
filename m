Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbaLBUwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:52:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:39516 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711AbaLBUwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:52:16 -0500
Message-ID: <1417551190.27448.8.camel@kernel.crashing.org>
Subject: Re: [PATCH 03/10] mm: Convert p[te|md]_numa users to
 p[te|md]_protnone_numa
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mel Gorman <mgorman@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 03 Dec 2014 07:13:10 +1100
In-Reply-To: <87h9xeh5im.fsf@linux.vnet.ibm.com>
References: <1416578268-19597-1-git-send-email-mgorman@suse.de>
	 <1416578268-19597-4-git-send-email-mgorman@suse.de>
	 <1417473849.7182.9.camel@kernel.crashing.org>
	 <87h9xeh5im.fsf@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-12-02 at 13:01 +0530, Aneesh Kumar K.V wrote:
> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> 
> > On Fri, 2014-11-21 at 13:57 +0000, Mel Gorman wrote:
> >> void set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
> >>                 pte_t pte)
> >>  {
> >> -#ifdef CONFIG_DEBUG_VM
> >> -       WARN_ON(pte_val(*ptep) & _PAGE_PRESENT);
> >> -#endif
> >> +       /*
> >> +        * When handling numa faults, we already have the pte marked
> >> +        * _PAGE_PRESENT, but we can be sure that it is not in hpte.
> >> +        * Hence we can use set_pte_at for them.
> >> +        */
> >> +       VM_WARN_ON((pte_val(*ptep) & (_PAGE_PRESENT | _PAGE_USER)) ==
> >> +               (_PAGE_PRESENT | _PAGE_USER));
> >> +
> >
> > His is that going to fare with set_pte_at() called for kernel pages ?
> >
> 
> Yes, we won't capture those errors now. But is there any other debug
> check i could use to capture the wrong usage of set_pte_at ?

Actually the above is fine, for some reason I mis-read the test as
blowing on kernel pages, it doesn't.

We probably do need to make sure however that protnone isn't used for
kernel pages.

Cheers,
Ben.

> -aneesh
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>


