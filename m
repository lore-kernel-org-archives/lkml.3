Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab3IZFlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:41:32 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:55203 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab3IZFla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:41:30 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-c6-5243c908d63e
Date: Thu, 26 Sep 2013 14:42:04 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        chintu kumar <chintu.kr78@gmail.com>, ch0.han@lge.com,
        "'Gunho Lee'" <gunho.lee@lge.com>
Subject: Re: squashfs enhance [RFC 3/5] squashfs: remove cache for normal
 data page
Message-ID: <20130926054204.GA20214@bbox>
References: <5243A78F.3050800@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5243A78F.3050800@lougher.demon.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Phillip,

On Thu, Sep 26, 2013 at 04:18:39AM +0100, Phillip Lougher wrote:
> 
> Minchan Kim <minchan@kernel.org> wrote:
> >
> >Hello chintu,
> >
> >
> >On Wed, Sep 25, 2013 at 5:13 PM, chintu kumar <chintu.kr78@gmail.com> wrote:
> >>Hi Minchan,
> >>
> >>Thanks for the response!
> >>
> >>I checked add_to_page_cache_lru and you are right for existing pages in page
> >>cache it won't add the page you allocated so my questions are answered thank
> >>you. However my concern is still regarding parallel calls to
> >>squashfs_readpage for the same inode.
> >>
> >>I'll try to rephrase,
> >>
> >>Actually I was concerned about allocation on every squashfs_readpage. In the
> >>original code suppose that all pages weren't present in page cache and we
> >>are taking random read on the file. Now in the original code the
> >>cache->entry would've been filled once for all the requested pages within
> >>that block.
> >>
> >>However with your patch we always do I/O however and as you said
> >>add_to_page_cache_lru would take care of adding that page to the inode's
> >>mapping so we need not worry about that [Correct?] . Now suppose that you've
> >>read those pages as well for which squashfs_readpage has been called however
> >>since you won't be able to add the page to page_cache_lru it'll do I/O again
> >>just to fill the page that a different squashfs_readpage wasn't able to
> >>fill.
> >>
> >>timeline
> >>|
> >>|
> >>---->  Process 1 (VFS initiates read for page 2)
> >>|
> >>----> Initiates read for pages 1-5
> >>Process 2 (VFS intiates read for page 3)
> >>|
> >>----> attempts to add the pages read in page cache
> >>Initiates read for pages 1-5 again
> >>       and fails for page 3 since VFS already initiated
> >>attempts to add pages read in page cache
> >>       read for page 3.
> >>and fails for every page. Page 3 isn't added since you got it from VFS in
> >>squashfs_readpage
> >>
> >>
> >>So it means that cost of memcpy in the original code from cache->entry to
> >>the page cache page IS MORE than   __page_cache_alloc + I/O? that you did in
> >>your patch.
> >
> >If the race happen with same CPU, buffer cache will mitigate a problem
> >but it happens on different CPUs,
> >we will do unnecessary I/O. But I think it's not a severe regression
> >because old code's cache coverage is
> >too limited and even stuck with concurrent I/O due to *a* cache.
> >
> >One of solution is to add locked pages right before request I/O to
> >page cache and if one of the page
> >in the compressed block is found from page cache, it means another
> >stream is going on so we can wait to finish
> >I/O and copy, just return. Does it make sense?
> >
> 
> No it doesn't, there's an obvious logical mistake there.
> 
> I' not convinced about the benefits of this patch.  The
> use of the "unnecessary" cache was there to prevent this race
> condition from happening.  The first racing process enters
> readpage, and grabs the cache entry signifying it is doing a decompress
> for that and the other pages.  A second racing process enters
> readpage, see a decompress is in progress, and waits until it is finished.
> The first process then fills in all the pages it can grab (bar the
> page locked by the second process), and the second process fills in its
> page from the cache entry.  Nice and simple, and no unnecessary extra
> I/O or decompression takes place.
> 
> It is your job to prove that the removal of memcpy outweighs the
> introduction of this regression.  Waving your hands and just
> dismissing this inconvenient issue isn't good enough.

I didn't dismiss and I see the problem.
I will handle it in next version. ;-)

> 
> I have a couple of other reservations about this patch, as it
> introduces two additional regressions.  This will be in my review.
> 
> As I said in my reply to your private message on Monday (where you
> asked me to review the patches), I reviewed them on the weekend.  As yet, I
> have not had time to pull my observations into something suitable for
> the kernel mailing list.  That will be done ASAP, but, due to full-time
> work commitments I may not have any time until the weekend again.

No problem. I will wait and want to handle all of issues from you and
others all at once. :)

> 
> On the subject of review, I notice this email contains patch review and
> discussion off-list.  That is not good kernel etiquette, patch discussion
> should be open, public and in full view, let's keep it that way.
> Also as maintainer I should have been CC'd on this email, rather than
> accidently discovering it on the kernel mailing list.

Argh, I just did reply-to-all without noticing Chintu omitting you and LKML.
Chintu, Please no touch to To and Cc line and use plain text mode for your MUA.

Thanks for the reivew.

> 
> Phillip
> 
> 
> >>
> >>
> >>Regards,
> >>Chintu
> >>
> >>
> >>
> >>On Wed, Sep 25, 2013 at 5:52 AM, Minchan Kim <minchan@kernel.org> wrote:
> >>>
> >>>Hello,
> >>>
> >>>On Tue, Sep 24, 2013 at 6:07 PM, chintu kumar <chintu.kr78@gmail.com>
> >>>wrote:
> >>>> Hi Minchan,
> >>>>
> >>>>
> >>>> In the below snippet
> >>>>
> >>>> + /* alloc buffer pages */
> >>>> + for (i = 0; i < pages; i++) {
> >>>> + if (page->index == start_index + i)
> >>>> + push_page = page;
> >>>> + else
> >>>> + push_page = __page_cache_alloc(gfp_mask);
> >>>>
> >>>>
> >>>> You are adding the allocated page in the inode mapping regardless of
> >>>> whether
> >>>> it was already there or not.
> >>>>
> >>>> ......
> >>>> ......
> >>>>
> >>>> + if (add_to_page_cache_lru(push_page, mapping,
> >>>> + start_index + i, gfp_mask)) {
> >>>>   page_cache_release(push_page);
> >>>>
> >>>>
> >>>>
> >>>>
> >>>> 1) My question is what happens to the previous mapped page; in case,
> >>>> there
> >>>> already was a mapping to that page and it was uptodate?.
> >>>
> >>>add_to_page_cache_lru would fail and the page will be freed by
> >>>page_cache_release.
> >>>
> >>>>
> >>>> 2.a) Another case occurs for multiple simultaneous squashfs_readpage
> >>>> calls.
> >>>> In those cases the page passed in via read_pages should be the one that
> >>>> needs to be filled and unlocked however since while filling cache entry
> >>>> only
> >>>> a single squashfs_readpage would actually fill data the rest of the
> >>>> processes waiting for the entry to be filled wouldn't get the page they
> >>>> sent
> >>>> in. [Correct?]
> >>>>
> >>>> 2.b) Wouldn't that result in a non updated page to be returned to the
> >>>> process which would result in EIO?
> >>>>
> >>>> 2.c) But on subsequent calls it would get the freshly allocated page
> >>>> which
> >>>> you added above in page cache.[Correct?]
> >>>
> >>>I couldn't understand your questions. Could you elaborate on a bit?
> >>>Anyway, it seem you worry about race by several sources for readahead.
> >>>Thing is add_to_page_cache_lru which will prevent the race and free pages.
> >>>
> >>>Thanks for the review!
> >>>
> >>>>
> >>>>
> >>>>
> >>>> Regards,
> >>>> Chintu
> >>>>
> >>>>
> >>>
> >>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Kind regards,
Minchan Kim
