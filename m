Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215Ab3LIQ1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:27:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932844Ab3LIQ1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:27:08 -0500
Date: Mon, 9 Dec 2013 16:27:01 +0000
From: Mel Gorman <mgorman@suse.de>
To: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>, Alex Thorlton <athorlton@sgi.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/15] mm: fix TLB flush race between migration, and
 change_protection_range
Message-ID: <20131209162701.GZ11295@suse.de>
References: <529E641A.7040804@redhat.com>
 <20131203234637.GS11295@suse.de>
 <529F3D51.1090203@redhat.com>
 <20131204160741.GC11295@suse.de>
 <20131206141331.10880d2b@annuminas.surriel.com>
 <00000142c99cf5b0-69cc9987-aa36-4889-af6a-1a45032d0d13-000000@email.amazonses.com>
 <52A23FD1.3040102@redhat.com>
 <00000142ca7218fe-a5566a24-0ef5-4545-8a98-d33116b7d703-000000@email.amazonses.com>
 <52A29278.9000609@redhat.com>
 <00000142d816866f-615798f8-74d8-401c-b35a-88aa1dbc8eb5-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <00000142d816866f-615798f8-74d8-401c-b35a-88aa1dbc8eb5-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 04:00:24PM +0000, Christoph Lameter wrote:
> On Fri, 6 Dec 2013, Rik van Riel wrote:
> 
> > > Ok then what are you trying to fix?
> >
> > It would help if you had actually read the patch.
> 
> I read the patch. Please update the documentation to accurately describe
> the race.
> 
> From what I can see this race affects only huge pages and the basic issue
> seems to be that huge pages do not use migration entries but directly
> replace the pmd (migrate_misplaced_transhuge_page() f.e.).
> 

I looked at what would be required to implement migration entry support for
PMDs. It's major surgery because we do not have something like swap-like
entries to use at that page table level. It looked like it would require
inserting a fake entry (easiest would be to point to a global page) that
all page table walkers would recognise, blocking on it and teaching every
page table walker to get it right.

One can't do something simple like clear the entry out because then the
no page handlers for GUP or faults insert the zero page behind and it goes
to hell and we can't hold the page table lock across the migration copy.

> That is not safe and there may be multiple other races as we add more
> general functionality to huge pages. An intermediate stage is needed
> that allows the clearing out of remote tlb entries before the new tlb
> entry becomes visible.
> 

The patch flushes the TLBs as it is and future accesses are help up in the
NUMA hinting fault handler. It's functionally similar to having a migration
entry albeit it is special cased to handle just automatic NUMA balancing

-- 
Mel Gorman
SUSE Labs
