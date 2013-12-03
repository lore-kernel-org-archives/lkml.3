Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3LCXqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 18:46:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682Ab3LCXql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 18:46:41 -0500
Date: Tue, 3 Dec 2013 23:46:37 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Alex Thorlton <athorlton@sgi.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/15] mm: numa: Flush TLB if NUMA hinting faults race
 with PTE scan update
Message-ID: <20131203234637.GS11295@suse.de>
References: <1386060721-3794-1-git-send-email-mgorman@suse.de>
 <1386060721-3794-15-git-send-email-mgorman@suse.de>
 <529E641A.7040804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <529E641A.7040804@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 06:07:06PM -0500, Rik van Riel wrote:
> On 12/03/2013 03:52 AM, Mel Gorman wrote:
> > NUMA PTE updates and NUMA PTE hinting faults can race against each other. The
> > setting of the NUMA bit defers the TLB flush to reduce overhead. NUMA
> > hinting faults do not flush the TLB as X86 at least does not cache TLB
> > entries for !present PTEs. However, in the event that the two race a NUMA
> > hinting fault may return with the TLB in an inconsistent state between
> > different processors. This patch detects potential for races between the
> > NUMA PTE scanner and fault handler and will flush the TLB for the affected
> > range if there is a race.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 5dfd552..ccc814b 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -1662,6 +1662,39 @@ void wait_migrate_huge_page(struct anon_vma *anon_vma, pmd_t *pmd)
> >  	smp_rmb();
> >  }
> >  
> > +unsigned long numa_fault_prepare(struct mm_struct *mm)
> > +{
> > +	/* Paired with task_numa_work */
> > +	smp_rmb();
> > +	return mm->numa_next_reset;
> > +}
> 
> The patch that introduces mm->numa_next_reset, and the
> patch that increments it, seem to be missing from your
> series...
> 

Damn. s/numa_next_reset/numa_next_scan/ in that patch

-- 
Mel Gorman
SUSE Labs
