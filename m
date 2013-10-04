Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3JDPG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 11:06:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab3JDPG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 11:06:58 -0400
Date: Fri, 4 Oct 2013 16:03:14 +0100
From: Joe Thornber <thornber@redhat.com>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: mpatocka@redhat.com, dm-devel@redhat.com, devel@driverdev.osuosl.org,
        snitzer@redhat.com, gregkh@linuxfoundation.org, david@fromorbit.com,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        joe@perches.com, akpm@linux-foundation.org, m.chehab@samsung.com,
        ejt@redhat.com, agk@redhat.com, cesarb@cesarb.net
Subject: Re: [dm-devel] dm-writeboost testing
Message-ID: <20131004150313.GB25523@debian>
Mail-Followup-To: Akira Hayakawa <ruby.wktk@gmail.com>, mpatocka@redhat.com,
	dm-devel@redhat.com, devel@driverdev.osuosl.org, snitzer@redhat.com,
	gregkh@linuxfoundation.org, david@fromorbit.com,
	linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
	joe@perches.com, akpm@linux-foundation.org, m.chehab@samsung.com,
	ejt@redhat.com, agk@redhat.com, cesarb@cesarb.net
References: <alpine.LRH.2.02.1310021125150.19199@file01.intranet.prod.int.rdu2.redhat.com>
 <524D70DA.8040308@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524D70DA.8040308@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 03, 2013 at 10:27:54PM +0900, Akira Hayakawa wrote:

> > dm-cache doesn't have this problem, if you overwrite the same piece of 
> > data again and again, it goes to the cache device.
> 
> It is not a bug but should/can be optimized.
> 
> Below is the cache hit path for writes.
> writeboost performs very poorly when a partial write hits
> which then turns `needs_cleanup_perv_cache` to true.

Are you using fixed size blocks for caching then?  The whole point of
using a journal/log based disk layout for caching is you can slurp up
all writes irrespective of their size.

What are the scenarios where you out perform dm-cache?

- Joe




> Partial write hits is believed to be unlikely so
> I decided to give up this path to make other likely-paths optimized.
> I think this is just a tradeoff issue of what to be optimized the most.
> 
>         if (found) {
> 
>                 if (unlikely(on_buffer)) {
>                         mutex_unlock(&cache->io_lock);
> 
>                         update_mb_idx = mb->idx;
>                         goto write_on_buffer;
>                 } else {
>                         u8 dirty_bits = atomic_read_mb_dirtiness(seg, mb);
> 
>                         /*
>                          * First clean up the previous cache
>                          * and migrate the cache if needed.
>                          */
>                         bool needs_cleanup_prev_cache =
>                                 !bio_fullsize || !(dirty_bits == 255);
> 
>                         if (unlikely(needs_cleanup_prev_cache)) {
>                                 wait_for_completion(&seg->flush_done);
>                                 migrate_mb(cache, seg, mb, dirty_bits, true);
>                         }
> 
> I checked that the mkfs.ext4 writes only in 4KB size
> so it is not gonna turn the boolean value true for going into the slowpath.
> 
> Problem:
> Problem is that
> it chooses the slowpath even though the bio is full-sized overwrite
> in the test.
> 
> The reason is that the dirty bits is sometimes seen as 0
> and the suspect is the migration daemon.
> 
> I guess you created the writeboost device with the default configuration.
> In that case migration daemon always works and
> some metadata is cleaned up in background.
> 
> If you turns both enable_migration_modulator and allow_migrate to 0
> before beginning the test
> to stop migration at all
> it never goes into the slowpath with the test.
> 
> Solution:
> Changing the code to
> avoid going into the slowpath when the dirty bits is zero
> will solve this problem.
> 
> And done. Please pull the latest one from the repo.
> --- a/Driver/dm-writeboost-target.c
> +++ b/Driver/dm-writeboost-target.c
> @@ -688,6 +688,14 @@ static int writeboost_map(struct dm_target *ti, struct bio *bio
>                         bool needs_cleanup_prev_cache =
>                                 !bio_fullsize || !(dirty_bits == 255);
> 
> +                       /*
> +                        * Migration works in background
> +                        * and may have cleaned up the metablock.
> +                        * If the metablock is clean we need not to migrate.
> +                        */
> +                       if (!dirty_bits)
> +                               needs_cleanup_prev_cache = false;
> +
>                         if (unlikely(needs_cleanup_prev_cache)) {
>                                 wait_for_completion(&seg->flush_done);
>                                 migrate_mb(cache, seg, mb, dirty_bits, true);
> 
> Thanks,
> Akira
