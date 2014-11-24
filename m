Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaKXEOS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 23:14:18 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55126 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbaKXEOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 23:14:16 -0500
Date: Sun, 23 Nov 2014 20:16:29 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Block layer projects that I haven't had time for
Message-ID: <20141124041629.GA17907@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I'm starting to resign myself to the fact that I'm probably not going to
have much time for upstream development again any time soon, I figured maybe I
should try writing down all the things I was working on or planning on working
on in case someone else is feeling ambitious and looking for things to work on.

If anyone wants to take up any of this stuff, feel free to take my half baked
code and do whatever you want with it, or ping me for ideas/guidance.

 - immutable biovecs went in, but what this was leading up to was making
   generic_make_request() accept arbitrary size bios, and pushing the splitting
   down to the drivers or wherever it's required.

   This is a performance win, and a big reduction in complexity and allows a lot
   of code to be deleted. The performance win is because bio_add_page() doesn't
   have to check anything except "does this page fit in the current bio" -
   checking queue limits is like multiple cache misses. That stuff isn't checked
   until the driver level - when the relevant stuff is going to be in cache
   anyways - and usually bios won't have to be split. If they do have to be
   split, it's quite cheap now.

   I actually benchmarked the impact of this with fio on a micron p320h, it's
   definitely a measurable impact.

   It's also the last thing needed for the dio rewrite I was working on (god,
   who knows when I'll have time for _that_, the code is mostly done :/) - and
   the performance impact of that is _very_ significant.

 - making generic_make_request() take arbitrary size bios means we can delete
   merge_bvec_fn, which deletes over 1k loc. This is done in my tree, needs
   rebasing and testing.

 - kill bio->bi_cnt

   I added bi_remaning and bio_chain() awhile back - but now we have two atomic
   refcounts in struct bio and really we don't need both, bi_remaining is more
   general.

   If you grep there aren't that many uses of bio_get(), most of them are
   straightforward to get rid of but there were one or two tricky ones. Don't
   remember which ones, though.

 - plugging

   that code in generic_make_request() that turns recursion into iteration - if
   you squint, what's really going on is that it's another plugging
   implementation.

   What I'd like to do (only started playing with this) is rework the existing
   plugging to work in terms of bios, not requests - I think this would simplify
   things, and would allow non request based drivers to take advantage of
   plugging (it'd be useful for icache if nothing else).

   Then, replace the open coded plugging in generic_make_request() with a normal
   plug, and in the scheduler hook (where right now we would recurse and
   potentially blow the stack if we did this) - check the current stack usage,
   and if it's over some threshold punt the bios to per request queue
   workqueues.

   If anyone remembers the hack I added to bio_alloc_bioset() awhile back (where
   if we're about to block on allocating from the mempool, we punt any bios
   stranded on current->bio_list to workqueues - so as to avoid deadlocking) -
   this would actually replace that hack.

 - multipage bvecs

   I did a lot of the work to implement this _ages_ ago, it turns out to not be
   that bad it terms of amount of code that has to be changed. The trick is, we
   just add a new bio_for_each_page() macro - analagous to
   bio_for_each_segment() - that iterates over each page in a bvec separately;
   that way we don't have to modify all the code that expects bios to contain
   single pages.

   One of the reasons this is nice is because we can move segment merging up to
   bio_add_page(). Conceptually, right now we're breaking an IO up into single
   page segments to submit it in only for the lower layers to undo that work,
   and merge the segments back together. It's a lot simpler to just submit IOs
   with segments already merged; this does mean that a driver (when it calls
   blk_bio_map_sg()) will potentially have to split segments that are too big
   for the device limits, but remember we want to push bio splitting down to the
   driver anyways so this is actually completely trivial - the model is just
   that the driver incrementally consumes the bio/request.

   This is nice for the upper layers in small ways too, and might help to enable
   other changes we want but I have only a hazy idea of what those might be.
 
 - my dio rewrite, if anyone is feeling really ambitious

If anyone wants to take a look at my (mostly mostly quite messy, and out of
date) in progress work - it's in a branch:

http://evilpiepirate.org/git/linux-bcache.git block_stuff
