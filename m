Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaJFTS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:18:56 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:49839 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbaJFTSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:18:54 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: pipe/page fault oddness.
In-Reply-To: <20141002124537.GL17501@suse.de>
References: <20140930160510.GA15903@redhat.com> <CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com> <20140930162201.GC15903@redhat.com> <20140930164047.GA18354@redhat.com> <CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com> <20140930182059.GA24431@redhat.com> <CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com> <alpine.LSU.2.11.1410010031070.1902@eggly.anvils> <CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com> <CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com> <20141002124537.GL17501@suse.de>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Tue, 07 Oct 2014 00:48:43 +0530
Message-ID: <87d2a5f1m4.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100619-5140-0000-0000-0000005F1DDA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:

> On Wed, Oct 01, 2014 at 09:18:25AM -0700, Linus Torvalds wrote:
>> On Wed, Oct 1, 2014 at 9:01 AM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>> >
>> > We need to get rid of it, and just make it the same as pte_protnone().
>> > And then the real protnone is in the vma flags, and if you actually
>> > ever get to a pte that is marked protnone, you know it's a numa page.
>> 
>> So I'd really suggest we do exactly that. Get rid of "pte_numa()"
>> entirely, get rid of "_PAGE_[BIT_]NUMA" entirely, and instead add a
>> "pte_protnone()" helper to check for the "protnone" case (which on x86
>> is testing the _PAGE_PROTNONE bit, and on most other architectures is
>> just testing that the page has no access rights).
>> 
>
> Do not interpret the following as being against the idea of taking the
> pte_protnone approach. This is intended to give background.
>
> At the time the changes were made to the _PAGE_NUMA bits it was acknowledged
> that a full move to prot_none was an option but it was not the preferred
> solution at the time. It replaced one set of corner cases with another and
> the last time like this time, there was considerable time pressure. The
> VMA would be required to distinguish between a NUMA hinting fault and a
> real prot_none bit. In most cases, we have the VMA now with the exception
> of GUP. GUP would have to unconditionally go into the slow path to do the
> VMA lookup. That is not likely to be a big of a problem but it was a concern.
>
> In early implementations based on prot_none there were some VMA-based
> protection checks that had higher overhead. At the time, there were severe
> problems with overhead due to NUMA balancing and adding more was not
> desirable. This has been addressed since with changes in multiple other
> areas so it's much less of a concern now than it was. In the current shape,
> these probably is not as much a problem as long as any check on pte_numa
> was first guarded by a VMA check. One way of handling the corner cases
> where would be to pass in the VMA where available and have a VM_BUG_ON that
> fires if its a PROT_NONE VMA. That would catch problems during debugging
> without adding overhead in the !debug case.
>
> Going back to the start, the PTE bit was used as the approach due to
> concerns that a pte_protnone helper would not work on all architectures,
> ppc64 in particular.  There was no PROT_NONE bit there and instead prot_none
> protections rely on PAGE_USER not being set so it's inaccessible from
> userspace. There was discussion at the time that this could conceivably be
> broken from some sub-architectures but I don't recall the details. Looking
> at the current shape and your patch, it's conceivable that the pte_protnone
> could be implemented as a _PAGE_PRESENT && !_PAGE_USER check as long
> as it was guarded by a VMA check which x86 requires anyway. Not sure
> if that would work for PMDs as I'm not familiar with with ppc64 to tell
> offhand. Alternatively, ppc64 would potentially use the bit currently used
> for _PAGE_NUMA as a _PROT_NONE bit.

Are we still looking at these options ? I could look at implementing the
first option which will also enable us to free up one pte bit.

Note: Freeing up one bit will enable us to implement soft dirty tracking
needed for CRIU.

-aneesh

