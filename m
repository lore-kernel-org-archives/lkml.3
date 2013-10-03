Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3JCN2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 09:28:03 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:49505 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab3JCN2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 09:28:01 -0400
Message-ID: <524D70DA.8040308@gmail.com>
Date: Thu, 03 Oct 2013 22:27:54 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: mpatocka@redhat.com
CC: dm-devel@redhat.com, devel@driverdev.osuosl.org, thornber@redhat.com,
        snitzer@redhat.com, gregkh@linuxfoundation.org, david@fromorbit.com,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com,
        joe@perches.com, akpm@linux-foundation.org, m.chehab@samsung.com,
        ejt@redhat.com, agk@redhat.com, cesarb@cesarb.net, ruby.wktk@gmail.com
Subject: Re: [dm-devel] dm-writeboost testing
References: <alpine.LRH.2.02.1310021125150.19199@file01.intranet.prod.int.rdu2.redhat.com>
In-Reply-To: <alpine.LRH.2.02.1310021125150.19199@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mikulas,

Thank you for reporting.
I am really happy to see this report.

First, I respond to the performance problem.
I will make time later for investigating the rest and answer.
Some deadlock issues are difficult to solve in short time.



> I tested dm-writeboost with disk as backing device and ramdisk as cache 
> device. When I run mkfs.ext4 on the dm-writeboost device, it writes data 
> to the cache on the first time. However, on next mkfs.ext4 invocations, 
> dm-writeboost writes data to the disk, not to the cache.
> 
> mkfs.ext4 on raw disk:	1.5s
> mkfs.ext4 on dm-cache using raw disk and ramdisk:
> 1st time - 0.15s
> next time - 0.12s
> mkfs.ext4 on dm-writeboost using raw disk and ramdisk:
> 1st time - 0.11s
> next time - 1.71s, 1.31s, 0.91s, 0.86s, 0.82s
> 
> - there seems to be some error in logic in dm-writeboost that makes it not 
> cache writes if these writes are already placed in the cache. In 
> real-world scenarios where the same piece of disk is overwritten over and 
> over again (for example journal), this could cause performance problems.
> 
> dm-cache doesn't have this problem, if you overwrite the same piece of 
> data again and again, it goes to the cache device.

It is not a bug but should/can be optimized.

Below is the cache hit path for writes.
writeboost performs very poorly when a partial write hits
which then turns `needs_cleanup_perv_cache` to true.
Partial write hits is believed to be unlikely so
I decided to give up this path to make other likely-paths optimized.
I think this is just a tradeoff issue of what to be optimized the most.

        if (found) {

                if (unlikely(on_buffer)) {
                        mutex_unlock(&cache->io_lock);

                        update_mb_idx = mb->idx;
                        goto write_on_buffer;
                } else {
                        u8 dirty_bits = atomic_read_mb_dirtiness(seg, mb);

                        /*
                         * First clean up the previous cache
                         * and migrate the cache if needed.
                         */
                        bool needs_cleanup_prev_cache =
                                !bio_fullsize || !(dirty_bits == 255);

                        if (unlikely(needs_cleanup_prev_cache)) {
                                wait_for_completion(&seg->flush_done);
                                migrate_mb(cache, seg, mb, dirty_bits, true);
                        }

I checked that the mkfs.ext4 writes only in 4KB size
so it is not gonna turn the boolean value true for going into the slowpath.

Problem:
Problem is that
it chooses the slowpath even though the bio is full-sized overwrite
in the test.

The reason is that the dirty bits is sometimes seen as 0
and the suspect is the migration daemon.

I guess you created the writeboost device with the default configuration.
In that case migration daemon always works and
some metadata is cleaned up in background.

If you turns both enable_migration_modulator and allow_migrate to 0
before beginning the test
to stop migration at all
it never goes into the slowpath with the test.

Solution:
Changing the code to
avoid going into the slowpath when the dirty bits is zero
will solve this problem.

And done. Please pull the latest one from the repo.
--- a/Driver/dm-writeboost-target.c
+++ b/Driver/dm-writeboost-target.c
@@ -688,6 +688,14 @@ static int writeboost_map(struct dm_target *ti, struct bio *bio
                        bool needs_cleanup_prev_cache =
                                !bio_fullsize || !(dirty_bits == 255);

+                       /*
+                        * Migration works in background
+                        * and may have cleaned up the metablock.
+                        * If the metablock is clean we need not to migrate.
+                        */
+                       if (!dirty_bits)
+                               needs_cleanup_prev_cache = false;
+
                        if (unlikely(needs_cleanup_prev_cache)) {
                                wait_for_completion(&seg->flush_done);
                                migrate_mb(cache, seg, mb, dirty_bits, true);

Thanks,
Akira
