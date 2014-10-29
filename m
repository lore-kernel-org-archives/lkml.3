Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbaJ2LwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 07:52:04 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19259 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728AbaJ2LvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 07:51:10 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-16-5450d4acbc2f
Subject: [PATCH] mm/balloon_compaction: fix deflation when compaction is
 disabled
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Matt Mullins <mmullins@mmlx.us>, linux-kernel@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, stable@vger.kernel.org
Date: Wed, 29 Oct 2014 14:51:07 +0400
Message-id: <20141029115107.23071.26065.stgit@buzz>
In-reply-to: <20141028202333.GC29098@hydra.tuxags.com>
References: <20141028202333.GC29098@hydra.tuxags.com>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/xa7prrgSEGOz7zmkxZ/0aNosZD3+x
	WPzY2ctqcXnXHDaLe2v+s1rMeb6UyWLxkdvMFgs2PmJ04PDY9GkSu8eJGb9ZPK62zmfz+Pj0
	FovH+31X2Tz6tqxi9Pi8SS6APYrLJiU1J7MstUjfLoErY/usLywFU7gqpl7fwtbAuIeji5GT
	Q0LARGLRxnYWCFtM4sK99WxdjFwcQgJLGSWm/5/ODJIQEmhkktg+PQvEFhYIlmh8voQRxGYT
	MJPYtu82I0iDiMByRolV1x+wgSSYBRwkJq3+CVbEIqAqMW3yESCbg4NXwFhi7U5/kDAnUO/Z
	1xBhIQFTiTWNMSBhUQE5iZWXW1hBbF4BQYkfk++xgJQwC6hLTJmSCzFcXmLzmrfMExgFZiGp
	moVQNQtJ1QJG5lWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIcH/dQfj0mNWhxgFOBiVeHgj
	jgWECLEmlhVX5h5ilOBgVhLhfbcXKMSbklhZlVqUH19UmpNafIiRiYNTqoHRIuoPp4zZ2Vd8
	Ly7NuJ918btrlW/C93fZnnsmxcvFTdJR01pedXC9iUOCu+ztNd9sk0Mi33i35FblNeU2SxVH
	c3sGVjc+fP2N8/s2JqOje043egpUiAUdeVL5i99pnuLvuaHx3u0Syul1334Ffi6InClVL6jk
	4u3n3rA87laATNaC+UvMWZRYijMSDbWYi4oTAas7R5NcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for commit d6d86c0a7f8ddc5b38cf089222cb1d9540762dc2
("mm/balloon_compaction: redesign ballooned pages management").

If CONFIG_BALLOON_COMPACTION=n balloon_page_insert() does not link
pages with balloon and doesn't set PagePrivate flag, as a result
balloon_page_dequeue cannot get any pages because it thinks that
all of them are isolated. Without balloon compaction nobody can
isolate ballooned pages, it's safe to remove this check.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Reported-by: Matt Mullins <mmullins@mmlx.us>
Cc: Stable <stable@vger.kernel.org>	(v3.17)
---
 mm/balloon_compaction.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index b3cbe19..fcad832 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -68,11 +68,13 @@ struct page *balloon_page_dequeue(struct balloon_dev_info *b_dev_info)
 		 * to be released by the balloon driver.
 		 */
 		if (trylock_page(page)) {
+#ifdef CONFIG_BALLOON_COMPACTION
 			if (!PagePrivate(page)) {
 				/* raced with isolation */
 				unlock_page(page);
 				continue;
 			}
+#endif
 			spin_lock_irqsave(&b_dev_info->pages_lock, flags);
 			balloon_page_delete(page);
 			__count_vm_event(BALLOON_DEFLATE);

