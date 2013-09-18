Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab3IRKiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:38:50 -0400
Received: from mailout06.t-online.de ([194.25.134.19]:59140 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3IRKit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:38:49 -0400
Message-ID: <5239829F.4080601@t-online.de>
Date: Wed, 18 Sep 2013 12:38:23 +0200
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Linux MM <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Glauber Costa <glommer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] [PATCH] [RFC] mm/shrinker: Add a shrinker flag to
 always shrink a bit
References: <1379495401-18279-1-git-send-email-daniel.vetter@ffwll.ch>
In-Reply-To: <1379495401-18279-1-git-send-email-daniel.vetter@ffwll.ch>
Content-Type: multipart/mixed;
 boundary="------------090302000909020209030900"
X-ID: ZwzG0EZBghBvsKTel6CDd2fioKYMrrtYyO7Ds+00uV56lUokoKNGMs8OE5eOCHWZMy
X-TOI-MSGID: 690e4553-acc6-4a21-8436-a436aeea2f72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090302000909020209030900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

On 18.09.2013 11:10, Daniel Vetter wrote:

Just now I prepared a patch changing the same function in vmscan.c
> Also, this needs to be rebased to the new shrinker api in 3.12, I
> simply haven't rolled my trees forward yet.

Well, you should. Since commit 81e49f  shrinker->count_objects might be
set to SHRINK_STOP, causing shrink_slab_node() to complain loud and often:

[ 1908.234595] shrink_slab: i915_gem_inactive_scan+0x0/0x9c negative objects to delete nr=-xxxxxxxxx

The kernel emitted a few thousand log lines like the one quoted above during the
last few days on my system.

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2cff0d4..d81f6e0 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -254,6 +254,10 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>   			total_scan = max_pass;
>   		}
>   
> +		/* Always try to shrink a bit to make forward progress. */
> +		if (shrinker->evicts_to_page_lru)
> +			total_scan = max_t(long, total_scan, batch_size);
> +
At that place the error message is already emitted.
>   		/*
>   		 * We need to avoid excessive windup on filesystem shrinkers
>   		 * due to large numbers of GFP_NOFS allocations causing the

Have a look at the attached patch. It fixes my problem with the erroneous/misleading
error messages, and I think it´s right to just bail out early if SHRINK_STOP is found.

Do you agree ?

cu,
  Knut


--------------090302000909020209030900
Content-Type: text/x-patch;
 name="0001-mm-respect-SHRINK_STOP-in-shrink_slab_node.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-mm-respect-SHRINK_STOP-in-shrink_slab_node.patch"

>From 75ae570ce7b0bb6b40c76beb18fc075e9af3127a Mon Sep 17 00:00:00 2001
From: Knut Petersen <Knut_Petersen@t-online.de>
Date: Wed, 18 Sep 2013 12:06:33 +0200
Subject: [PATCH] mm: respect SHRINK_STOP in shrink_slab_node()

Since commit 81e49f811404f428a9d9a63295a0c267e802fa12
i915_gem_inactive_count() might return SHRINK_STOP.

Unfortunately SHRINK_STOP is not handled propperly in
shrink_slab_node(), causing a system log cluttered with
kernel error messages complaining about "negative objects
to delete".

I think the proper way of handling SHRINK_STOP is obvious,
we should obey ;-)

Signed-off-by: Knut Petersen <Knut_Petersen@t-online.de>
---
 mm/vmscan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8ed1b77..b1e6f0d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -244,6 +244,8 @@ shrink_slab_node(struct shrink_control *shrinkctl, struct shrinker *shrinker,
 	max_pass = shrinker->count_objects(shrinker, shrinkctl);
 	if (max_pass == 0)
 		return 0;
+	if (max_pass == SHRINK_STOP)
+		return 0;
 
 	/*
 	 * copy the current shrinker scan count into a local variable
-- 
1.8.1.4


--------------090302000909020209030900--
