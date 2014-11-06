Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaKFXNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:13:37 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:40721 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbaKFWlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:10 -0500
Date: Thu, 6 Nov 2014 17:40:53 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        joro@8bytes.org, Mel Gorman <mgorman@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Dave Airlie <airlied@redhat.com>,
        Brendan Conoboy <blc@redhat.com>, Joe Donohue <jdonohue@redhat.com>,
        Duncan Poole <dpoole@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>,
        Subhash Gutti <sgutti@nvidia.com>, John Hubbard <jhubbard@nvidia.com>,
        Mark Hairgrove <mhairgrove@nvidia.com>,
        Lucien Dunning <ldunning@nvidia.com>,
        Cameron Buschardt <cabuschardt@nvidia.com>,
        Arvind Gopalakrishnan <arvindg@nvidia.com>,
        Shachar Raindel <raindel@mellanox.com>,
        Liran Liss <liranl@mellanox.com>,
        Roland Dreier <roland@purestorage.com>,
        Ben Sander <ben.sander@amd.com>, Greg Stoner <Greg.Stoner@amd.com>,
        John Bridgman <John.Bridgman@amd.com>,
        Michael Mantor <Michael.Mantor@amd.com>,
        Paul Blinzer <Paul.Blinzer@amd.com>,
        Laurent Morichetti <Laurent.Morichetti@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Oded Gabbay <Oded.Gabbay@amd.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 3/5] lib: lockless generic and arch independent page
 table (gpt) v2.
Message-ID: <20141106224051.GA6877@gmail.com>
References: <1415047353-29160-1-git-send-email-j.glisse@gmail.com>
 <1415047353-29160-4-git-send-email-j.glisse@gmail.com>
 <545BF6E0.8060001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <545BF6E0.8060001@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 05:32:00PM -0500, Rik van Riel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 11/03/2014 03:42 PM, j.glisse@gmail.com wrote:
> > From: Jérôme Glisse <jglisse@redhat.com>
> > 
> > Page table is a common structure format most notably use by cpu
> > mmu. The arch depend page table code has strong tie to the
> > architecture which makes it unsuitable to be use by other non arch
> > specific code.
> > 
> > This patch implement a generic and arch independent page table. It
> > is generic in the sense that entry size can be u64 or unsigned long
> > (or u32 too on 32bits arch).
> > 
> > It is lockless in the sense that at any point in time you can have
> > concurrent thread updating the page table (removing or changing
> > entry) and faulting in the page table (adding new entry). This is
> > achieve by enforcing each updater and each faulter to take a range
> > lock. There is no exclusion on range lock, ie several thread can
> > fault or update the same range concurrently and it is the
> > responsability of the user to synchronize update to the page table
> > entry (pte), update to the page table directory (pdp) is under gpt
> > responsability.
> > 
> > API usage pattern is : gpt_init()
> > 
> > gpt_lock_update(lock_range) // User can update pte for instance by
> > using atomic bit operation // allowing complete lockless update. 
> > gpt_unlock_update(lock_range)
> > 
> > gpt_lock_fault(lock_range) // User can fault in pte but he is
> > responsible for avoiding thread // to concurrently fault the same
> > pte and for properly accounting // the number of pte faulted in the
> > pdp structure. gpt_unlock_fault(lock_range) // The new faulted pte
> > will only be visible to others updaters only // once all concurrent
> > faulter on the address unlock.
> > 
> > Details on how the lockless concurrent updater and faulter works is
> > provided in the header file.
> > 
> > Changed since v1: - Switch to macro implementation instead of using
> > arithmetic to accomodate the various size for table entry
> > (uint64_t, unsigned long, ...). This is somewhat less flexbile but
> > right now there is no use for the extra flexibility v1 was
> > offering.
> > 
> > Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
> 
> Never a fan of preprocessor magic, but I  see why it's needed.
> 
> Acked-by: Rik van Riel <riel@redhat.com>

v1 is not using preprocessor but has a bigger gpt struct footprint and also
more complex calculation for page table walking due to the fact that i just
rely more on runtime computation than on compile time shift define through
preprocessor magic.

Given i am not a fan either of preprocessor magic if it makes you feel any
better i can resort to use v1, both have seen same kind of testing and both
are functionaly equivalent (API they expose is obviously slightly different).

I am not convince that what the computation i save using preprocessor will
show up in anyway as being bottleneck for hot path.

Cheers,
Jérôme

> 
> 
> - -- 
> All rights reversed
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
> 
> iQEcBAEBAgAGBQJUW/bgAAoJEM553pKExN6Dl6IH/i9rSRtvdO9+lf1cUe686XJb
> GZ8KOp3Qa+ac0W63NqEaY5W+Fi7qyZJdoRFLCyOHBSP44qg9yoEJz8IbdPVNRjGG
> lXyyfyOP0PY3wSakSP/IS3OIvapav6YPXiOIX7FlzPTReL+RWJPDYpmvi6S6nXgS
> PuVTedVT5yaZwcqh0CyfDZ8pQqxEBSyvdVY/ntia7hxtUk9Or/sWVaRn8RE1u6EZ
> xA5DtjqTB+UHmNtmTNe2B5i2TmvhIFYr+/ydCs76osR2e+UBcqQtnN3cdudZWyj3
> Pk1c/7qtTqgS2pdiIkpjCKH5qXIszGM6vDSGCjM/4/7afX+vjk7UQDWeXGfzQFs=
> =ndqX
> -----END PGP SIGNATURE-----
