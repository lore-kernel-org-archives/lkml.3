Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaHCFRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 01:17:30 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:46562 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaHCFR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 01:17:28 -0400
Message-ID: <53DDC5EB.3010209@gmail.com>
Date: Sun, 03 Aug 2014 01:17:31 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: anssi.hannula@iki.fi
CC: ejt@redhat.com, snitzer@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] dm cache: fix race affecting dirty block count
References: <53DD97B0.8040001@gmail.com> <CAJhHMCCFz5qpxocMbF1POBbFs6zPVaoM_j-52bw5vwpm1MV9aw@mail.gmail.com> <53DDBE9C.3030609@gmail.com> <53DDC13B.3090206@gmail.com>
In-Reply-To: <53DDC13B.3090206@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2014 12:57 AM, Pranith Kumar wrote:
> On 08/03/2014 12:46 AM, Pranith Kumar wrote:
>> On 08/02/2014 10:10 PM, Pranith Kumar wrote:
>>> Corrently adding Anssi this time.
>>>
>>> On Sat, Aug 2, 2014 at 10:00 PM, Pranith Kumar <bobby.prani@gmail.com> wrote:
>>>> Hello Anssi, Joe, Mike,
>>>>
>>>> I just found your patch in the latest rc and wanted to ask a few
>>>> questions. I am not sure how this patch helps at all other than luck in
>>>> that dm_cblock_t type is of type int32_t, which should guarantee that it
>>>> is atomic on most platforms. Which begs the question, what platform did
>>>> you encounter this problem?
>>>>
>>>> The patch purports to solve a race condition by making use of atomic_t.
>>>> I am not sure that is enough. If indeed there is a race you need to use
>>>> smp_mb__{before/after}_atomic() for both your uses of atomic_inc() and
>>>> atomic_set().
>>>>
>>>> Also I have a concern about why this mail was not CC'ed on LKML. I had
>>>> to go to some difficulty in finding this patch. So please CC LKML for
>>>> such patches.
>>>>
>>>> Thanks,
>>>> --
>>>> Pranith
>>>>
>>>> -- Begin forwarded Message --
>>>>
>>>>
>>>> nr_dirty is updated without locking, causing it to drift so that it is
>>>> non-zero (either a small positive integer, or a very large one when an
>>>> underflow occurs) even when there are no actual dirty blocks.
>>>>
>>>> Fix that by using an atomic type for nr_dirty.
>>>>
>>>> Signed-off-by: Anssi Hannula <anssi hannula iki fi>
>>>> Cc: Joe Thornber <ejt redhat com>
>>>> Cc: stable vger kernel org
> 

There are more in the following patch. I think you need to really check what
else I might be missing.

From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 3 Aug 2014 01:15:10 -0400
Subject: [PATCH 1/1] dm cache: Fix more incorrect pointer assignments

Fix incorrect pointer uses and assignments.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/md/dm-cache-target.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 49e47e7..1627035 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1777,13 +1777,13 @@ static void destroy(struct cache *cache)
 	if (cache->cmd)
 		dm_cache_metadata_close(cache->cmd);
 
-	if (cache->metadata_dev)
+	if (cache.metadata_dev)
 		dm_put_device(cache->ti, cache->metadata_dev);
 
-	if (cache->origin_dev)
+	if (cache.origin_dev)
 		dm_put_device(cache->ti, cache->origin_dev);
 
-	if (cache->cache_dev)
+	if (cache.cache_dev)
 		dm_put_device(cache->ti, cache->cache_dev);
 
 	if (cache->policy)
@@ -1861,13 +1861,13 @@ struct cache_args {
 
 static void destroy_cache_args(struct cache_args *ca)
 {
-	if (ca->metadata_dev)
+	if (ca.metadata_dev)
 		dm_put_device(ca->ti, ca->metadata_dev);
 
-	if (ca->cache_dev)
+	if (ca.cache_dev)
 		dm_put_device(ca->ti, ca->cache_dev);
 
-	if (ca->origin_dev)
+	if (ca.origin_dev)
 		dm_put_device(ca->ti, ca->origin_dev);
 
 	kfree(ca);
@@ -2190,7 +2190,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	cache->origin_dev = ca->origin_dev;
 	cache->cache_dev = ca->cache_dev;
 
-	ca->metadata_dev = ca->origin_dev = ca->cache_dev = NULL;
+	ca.metadata_dev = ca.origin_dev = ca.cache_dev = NULL;
 
 	/* FIXME: factor out this whole section */
 	origin_blocks = cache->origin_sectors = ca->origin_sectors;
-- 
1.9.1


