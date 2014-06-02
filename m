Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbaFBX1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 19:27:48 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:46224 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaFBX1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 19:27:46 -0400
Date: Mon, 2 Jun 2014 16:26:13 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Chen Yucong <slaoub@gmail.com>
cc: shli@kernel.org, hughd@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] swap: Delete  the "last_in_cluster < scan_base" loop in
 the body of scan_swap_map()
In-Reply-To: <1401710053-8460-1-git-send-email-slaoub@gmail.com>
Message-ID: <alpine.LSU.2.11.1406021603330.2584@eggly.anvils>
References: <1401710053-8460-1-git-send-email-slaoub@gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2014, Chen Yucong wrote:

> From commit ebc2a1a69111, we can find that all SWP_SOLIDSTATE "seek is cheap"(SSD case) 
> has already gone to si->cluster_info scan_swap_map_try_ssd_cluster() route. So that the
> "last_in_cluster < scan_base" loop in the body of scan_swap_map() has already become a 
> dead code snippet, and it should have been deleted.
> 
> This patch is to delete the redundant loop as Hugh and Shaohua suggested.
> 
> Signed-off-by: Chen Yucong <slaoub@gmail.com>

That is very nice, thank you.

Acked-by: Hugh Dickins <hughd@google.com>

But it does beg for just a little more: perhaps Andrew can kindly fold in:
---

 mm/swapfile.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- chen/mm/swapfile.c	2014-06-02 15:55:44.812368186 -0700
+++ hugh/mm/swapfile.c	2014-06-02 16:15:20.344396124 -0700
@@ -505,13 +505,10 @@ static unsigned long scan_swap_map(struc
 		/*
 		 * If seek is expensive, start searching for new cluster from
 		 * start of partition, to minimize the span of allocated swap.
-		 * But if seek is cheap, search from our current position, so
-		 * that swap is allocated from all over the partition: if the
-		 * Flash Translation Layer only remaps within limited zones,
-		 * we don't want to wear out the first zone too quickly.
+		 * If seek is cheap, that is the SWP_SOLIDSTATE si->cluster_info
+		 * case, just handled by scan_swap_map_try_ssd_cluster() above.
 		 */
-		if (!(si->flags & SWP_SOLIDSTATE))
-			scan_base = offset = si->lowest_bit;
+		scan_base = offset = si->lowest_bit;
 		last_in_cluster = offset + SWAPFILE_CLUSTER - 1;
 
 		/* Locate the first empty (unaligned) cluster */
