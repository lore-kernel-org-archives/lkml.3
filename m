Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaAXLnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 06:43:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaAXLnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 06:43:52 -0500
Date: Fri, 24 Jan 2014 11:43:47 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Steven Noonan <steven@uplinklabs.net>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Alex Thorlton <athorlton@sgi.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BISECTED] Linux 3.12.7 introduces page map handling regression
Message-ID: <20140124114347.GT4963@suse.de>
References: <20140121232708.GA29787@amazon.com>
 <20140122014908.GG18164@kroah.com>
 <CA+55aFw7fTFJtOAa+RETGSL7ZXZE4Ysk9+Xmg6_5yyLkwRtcTw@mail.gmail.com>
 <52E008F0.3060602@redhat.com>
 <CA+55aFypCEec_15J-bPAuc1G=GtnQXjnnW5+dzwODq2DNW4Bsg@mail.gmail.com>
 <52E01064.9090905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <52E01064.9090905@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 01:39:32PM -0500, Rik van Riel wrote:
> On 01/22/2014 01:24 PM, Linus Torvalds wrote:
> >On Wed, Jan 22, 2014 at 10:07 AM, Rik van Riel <riel@redhat.com> wrote:
> >>
> >>The difference between a numa pte and a protnone pte is
> >>the VMA permissions.
> >
> >If that is indeed the only difference, then we should damn well get
> >rid of that f*cking stupid _PAGE_NUMA name entirely.
> >
> >It's misleading crap. Really. Just do a quick grep for that bit, and
> >you see just *how* confused people are about it:
> >
> >    #define _PAGE_NUMA _PAGE_PROTNONE
> >    ...
> >         if ((pte_flags(a) & (_PAGE_PROTNONE | _PAGE_NUMA)) &
> >
> >think about it. Just *THINK* about how broken that code is. The whole
> >thing is a disaster. _PAGE_NUMA must die. It's shit.
> 
> The reason things are this way is that we were
> not sure whether we can indeed use _PAGE_PROTNONE
> for NUMA balancing on all architectures.
> 

Power is not using _PAGE_PROTNONE to trap NUMA hinting faults because they
do not have that bit. Instead they reuse _PAGE_COHERENT with various tricks,
patches are in -next.

92c08a0d522c7e62c01a63e42597f0c2b02c4245 powerpc/mm: Use HPTE constants when updating hpte bits
c8c06f5a0dde0fed260c54d550962187f266ed0d powerpc/mm: Free up _PAGE_COHERENCE for numa fault use later
8937ba48dcf62b5cdf7abb93652914af16756f50 powerpc/mm: Only check for _PAGE_PRESENT in set_pte/pmd functions
c34a51ce49b40b9667cd7f5cc2e40475af8b4c3d powerpc/mm: Enable _PAGE_NUMA for book3s

As confusing as _PAGE_NUMA is, the intent was to express support in an
architecture-independent manner. If we had started with _PAGE_PROTNONE
then it would still be ambiguous -- are we interested in NUMA hinting
information or is this really PROTNONE protection? The power people would
then have had to add something like _PAGE_NUMA anyway when they had no
_PAGE_PROTNONE bit or define _PAGE_PROTNONE as _PAGE_COHERENT which is
just a different type of misleading.

> If we are sure that _PAGE_PROTNONE can be used
> everywhere, I agree we should get rid of the whole
> _PAGE_NUMA naming, and replace that ambiguous
> code with some comments and documentation instead.

We are sure that _PAGE_PROTNONE cannot be used everywhere.

-- 
Mel Gorman
SUSE Labs
