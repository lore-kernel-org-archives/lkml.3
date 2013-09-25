Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab3IYUWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:22:55 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:36756 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab3IYUWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:22:52 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: hch@infradead.org, axboe@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH WIP] Multipage biovecs
Date: Wed, 25 Sep 2013 13:22:38 -0700
Message-Id: <1380140564-9030-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is most definitely not done yet - I wanted to get it
out so other people could look at where I'm going with it.

It implements multipage biovecs - a single biovec can point to an
arbitrary amount of physically contiguous memory. For code that still
needs to work on individual pages, we add bio_for_each_page() which does
magic to allow iteration over single page bvecs.

This then changes how segment merging works: instead of blk-merge.c
trying to figure out which segments it can merge, we start out by
merging everything that could possibly be merged, and we add
blk_max_segment() which various code can use to find the maximum segment
size, and when building up sglists we split as needed. The end result is
a lot cleaner, IMO.

This patch then deletes bi_seg_front_size and bi_seg_back_size - they're
not needed anymore since the first and last segment size are the lengths
of the biovecs themselves. The patch series does drop segment merging
across bios - my belief is that with the upper layers always building up
the largest bios they can (which is part of what all the immutable
biovec work is intended to help with) that functionality won't be needed
so much anymore - if it still is needed, we can readd it without
bringing back bi_seg_front_size and bi_seg_back_size.

bi_phys_segments can also be deleted now - the only reason this series
doesn't delete it is because the md code is abusing it for other
purposes (I think it's only using it for counting bio splits, which it
could use bi_remaining for instead).

The series is on top of immutable biovecs, and some other stuff not
included here - it's also in my git repository (there's a bunch of other
random crap in that branch though)
git://evilpiepirate.org/~kent/linux-bcache.git block_stuff.

