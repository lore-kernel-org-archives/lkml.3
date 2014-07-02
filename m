Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbaGBBu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 21:50:28 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61128 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaGBBu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 21:50:26 -0400
Date: Tue, 1 Jul 2014 18:49:03 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Vlastimil Babka <vbabka@suse.cz>
cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm: shm: hang in shmem_fallocate
In-Reply-To: <53B2A0E0.3000503@suse.cz>
Message-ID: <alpine.LSU.2.11.1407011717350.14301@eggly.anvils>
References: <52AE7B10.2080201@oracle.com> <52F6898A.50101@oracle.com> <alpine.LSU.2.11.1402081841160.26825@eggly.anvils> <52F82E62.2010709@oracle.com> <539A0FC8.8090504@oracle.com> <alpine.LSU.2.11.1406151921070.2850@eggly.anvils> <53A9A7D8.2020703@suse.cz>
 <alpine.LSU.2.11.1406251152450.1580@eggly.anvils> <53ABE479.3080508@suse.cz> <alpine.LSU.2.11.1406262108390.27670@eggly.anvils> <53B2A0E0.3000503@suse.cz>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014, Vlastimil Babka wrote:
> On 06/27/2014 07:36 AM, Hugh Dickins wrote:> [Cc Johannes: at the end I have
> a particular question for you]
> > On Thu, 26 Jun 2014, Vlastimil Babka wrote:
> > > 
> > > Thanks, I didn't notice that. Do I understand correctly that this could
> > > mean
> > > info leak for the punch hole call, but wouldn't be a problem for madvise?
> > > (In
> > > any case, that means the solution is not general enough for all kernels,
> > > so
> > > I'm asking just to be sure).
> > 
> > It's exactly the same issue for the madvise as for the fallocate:
> > data that is promised to have been punched out would still be there.
> 
> AFAIK madvise doesn't promise anything. But nevermind.

Good point.  I was looking at it from an implementation point of
view, that the implementation is the same for both, so therefore the
same issue for both.  But you are right, madvise makes no promise,
so we can therefore excuse it.  You'd make a fine lawyer :)

> > 
> > So let's all forget that patch, although it does help to highlight my
> > mistake in d0823576bf4b.  (Oh, hey, let's all forget my mistake too!)
> 
> What patch? What mistake? :)

Yes, which of my increasingly many? :(

> 
> > Here's the 3.16-rc2 patch that I've now settled on (which will also
> > require a revert of current git's f00cdc6df7d7; well, not require the
> > revert, but this makes that redundant, and cannot be tested with it in).
> > 
> > I've not yet had time to write up the patch description, nor to test
> > it fully; but thought I should get the patch itself into the open for
> > review and testing before then.
> 
> It seems to work here (tested 3.16-rc1 which didn't have f00cdc6df7d7 yet).
> Checking for end != -1 is indeed much more elegant solution than i_size.
> Thanks. So you can add my Tested-by.

Thanks a lot for the testing, Vlastimir.

Though I'm happy with the new shmem.c patch, I've thought more about my
truncate.c patch meanwhile, and grown unhappy with it for two reasons.

One was remembering that XFS still uses lend -1 even when punching a
hole: it writes out dirty pages, then throws away the pagecache from
start of hole to end of file; not brilliant (and a violation of mlock),
but that's how it is, and I'm not about to become an XFS hacker to fix
it (I did long ago send a patch I thought fixed it, but it never went
in, and I could easily have overlooked all kinds of XFS subtleties).

So although the end -1 test is more satisfying in tmpfs, and I don't
particularly like making assumptions in truncate_inode_pages_range()
about what i_size will show at that point, XFS would probably push
me back to using your original i_size test in truncate.c.

If we are to stop the endless pincer in truncate.c like in shmem.c.

But the other reason I'm unhappy with it, is really a generalization
of that.  Starting from the question I asked Hannes below, I came to
realize that truncate_inode_pages_range() is serving many filesystems,
and I don't know what all their assumptions are; and even if I spent
days researching what each requires of truncate_inode_pages_range(),
chances are that I wouldn't get the right answer on all of them.
Maybe there is a filesystem which now depends upon it to clean out
that hole completely: obviously not before I made the change, but
perhaps in the years since.

So, although I dislike tmpfs behaviour diverging from the others here,
we do have Sasha's assurance that tmpfs was the only one to show the
problem, and no intention of implementing hole-punch on ramfs: so I
think the safest course is for me not to interfere with the other
filesystems, just fix the pessimization I introduced back then.

And now that we have hard evidence that my "fix" there in -rc3
must be reverted, I should move forward with the alternative.

Hugh

> 
> > I've checked against v3.1 to see how it works out there: certainly
> > wouldn't apply cleanly (and beware: prior to v3.5's shmem_undo_range,
> > "end" was included in the range, not excluded), but the same
> > principles apply.  Haven't checked the intermediates yet, will
> > probably leave those until each stable wants them - but if you've a
> > particular release in mind, please ask, or ask me to check your port.
> 
> I will try, thanks.
> 
> > I've included the mm/truncate.c part of it here, but that will be a
> > separate (not for -stable) patch when I post the finalized version.
> > 
> > Hannes, a question for you please, I just could not make up my mind.
> > In mm/truncate.c truncate_inode_pages_range(), what should be done
> > with a failed clear_exceptional_entry() in the case of hole-punch?
> > Is that case currently depending on the rescan loop (that I'm about
> > to revert) to remove a new page, so I would need to add a retry for
> > that rather like the shmem_free_swap() one?  Or is it irrelevant,
> > and can stay unchanged as below?  I've veered back and forth,
> > thinking first one and then the other.
> > 
> > Thanks,
> > Hugh
> > 
> > ---
> > 
> >   mm/shmem.c    |   19 ++++++++++---------
> >   mm/truncate.c |   14 +++++---------
> >   2 files changed, 15 insertions(+), 18 deletions(-)
> > 
> > --- 3.16-rc2/mm/shmem.c	2014-06-16 00:28:55.124076531 -0700
> > +++ linux/mm/shmem.c	2014-06-26 15:41:52.704362962 -0700
> > @@ -467,23 +467,20 @@ static void shmem_undo_range(struct inod
> >   		return;
> > 
> >   	index = start;
> > -	for ( ; ; ) {
> > +	while (index < end) {
> >   		cond_resched();
> > 
> >   		pvec.nr = find_get_entries(mapping, index,
> >   				min(end - index, (pgoff_t)PAGEVEC_SIZE),
> >   				pvec.pages, indices);
> >   		if (!pvec.nr) {
> > -			if (index == start || unfalloc)
> > +			/* If all gone or hole-punch or unfalloc, we're done
> > */
> > +			if (index == start || end != -1)
> >   				break;
> > +			/* But if truncating, restart to make sure all gone
> > */
> >   			index = start;
> >   			continue;
> >   		}
> > -		if ((index == start || unfalloc) && indices[0] >= end) {
> > -			pagevec_remove_exceptionals(&pvec);
> > -			pagevec_release(&pvec);
> > -			break;
> > -		}
> >   		mem_cgroup_uncharge_start();
> >   		for (i = 0; i < pagevec_count(&pvec); i++) {
> >   			struct page *page = pvec.pages[i];
> > @@ -495,8 +492,12 @@ static void shmem_undo_range(struct inod
> >   			if (radix_tree_exceptional_entry(page)) {
> >   				if (unfalloc)
> >   					continue;
> > -				nr_swaps_freed += !shmem_free_swap(mapping,
> > -								index, page);
> > +				if (shmem_free_swap(mapping, index, page)) {
> > +					/* Swap was replaced by page: retry
> > */
> > +					index--;
> > +					break;
> > +				}
> > +				nr_swaps_freed++;
> >   				continue;
> >   			}
> > 
> > --- 3.16-rc2/mm/truncate.c	2014-06-08 11:19:54.000000000 -0700
> > +++ linux/mm/truncate.c	2014-06-26 16:31:35.932433863 -0700
> > @@ -352,21 +352,17 @@ void truncate_inode_pages_range(struct a
> >   		return;
> > 
> >   	index = start;
> > -	for ( ; ; ) {
> > +	while (index < end) {
> >   		cond_resched();
> >   		if (!pagevec_lookup_entries(&pvec, mapping, index,
> > -			min(end - index, (pgoff_t)PAGEVEC_SIZE),
> > -			indices)) {
> > -			if (index == start)
> > +			min(end - index, (pgoff_t)PAGEVEC_SIZE), indices)) {
> > +			/* If all gone or hole-punch, we're done */
> > +			if (index == start || end != -1)
> >   				break;
> > +			/* But if truncating, restart to make sure all gone
> > */
> >   			index = start;
> >   			continue;
> >   		}
> > -		if (index == start && indices[0] >= end) {
> > -			pagevec_remove_exceptionals(&pvec);
> > -			pagevec_release(&pvec);
> > -			break;
> > -		}
> >   		mem_cgroup_uncharge_start();
> >   		for (i = 0; i < pagevec_count(&pvec); i++) {
> >   			struct page *page = pvec.pages[i];
