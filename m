Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbaBCROR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 12:14:17 -0500
Received: from relay3.sgi.com ([192.48.152.1]:49071 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752922AbaBCROP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 12:14:15 -0500
Date: Mon, 3 Feb 2014 11:14:12 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] Revert "thp: make MADV_HUGEPAGE check for
 mm->def_flags"
Message-ID: <20140203171412.GA3034@sgi.com>
References: <1391192628-113858-1-git-send-email-athorlton@sgi.com>
 <1391192628-113858-3-git-send-email-athorlton@sgi.com>
 <20140131145224.7f8efc67d882a2e1a89b0778@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131145224.7f8efc67d882a2e1a89b0778@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 02:52:24PM -0800, Andrew Morton wrote:
> On Fri, 31 Jan 2014 12:23:43 -0600 Alex Thorlton <athorlton@sgi.com> wrote:
> 
> > This reverts commit 8e72033f2a489b6c98c4e3c7cc281b1afd6cb85cm, and adds
> 
> 'm' is not a hex digit ;)

My mistake!  Sorry about that.

> > in code to fix up any issues caused by the revert.
> > 
> > The revert is necessary because hugepage_madvise would return -EINVAL
> > when VM_NOHUGEPAGE is set, which will break subsequent chunks of this
> > patch set.
> 
> This is a bit skimpy.  Why doesn't the patch re-break kvm-on-s390?
> 
> it would be nice to have a lot more detail here, please.  What was the
> intent of 8e72033f2a48, how this patch retains 8e72033f2a48's behavior,
> etc.

I'm actually not too sure about this, off hand.  I just know that we
couldn't have it in there because of the check for VM_NOHUGEPAGE.  The
s390 guys approved the revert, as long as we added in the following
piece:

> > --- a/arch/s390/mm/pgtable.c
> > +++ b/arch/s390/mm/pgtable.c
> > @@ -504,6 +504,9 @@ static int gmap_connect_pgtable(unsigned long address, unsigned long segment,
> >  	if (!pmd_present(*pmd) &&
> >  	    __pte_alloc(mm, vma, pmd, vmaddr))
> >  		return -ENOMEM;
> > +	/* large pmds cannot yet be handled */
> > +	if (pmd_large(*pmd))
> > +		return -EFAULT;
> 
> This bit wasn't in 8e72033f2a48.

I added the fix-up code in with the revert, so that it would all be in
one place; wasn't sure what the standard was for this sort of thing.  If
it's preferable to see this code in a separate patch, that's easy enough
to do.

I'll look into exactly what the original commit was intended to do, and
get a better description of what's going on here.  Let me know if I
should split the two changes into separate patches.

- Alex
