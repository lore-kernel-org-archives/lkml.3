Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbaJ0TGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:06:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52910 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaJ0TFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:05:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 075/105] dm bufio: when done scanning return from __scan immediately
Date: Mon, 27 Oct 2014 11:56:50 -0700
Message-Id: <1414436240-13879-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 0e825862f3c04cee40e25f55680333728a4ffa9b upstream.

When __scan frees the required number of buffer entries that the
shrinker requested (nr_to_scan becomes zero) it must return.  Before
this fix the __scan code exited only the inner loop and continued in the
outer loop -- which could result in reduced performance due to extra
buffers being freed (e.g. unnecessarily evicted thinp metadata needing
to be synchronously re-read into bufio's cache).

Also, move dm_bufio_cond_resched to __scan's inner loop, so that
iterating the bufio client's lru lists doesn't result in scheduling
latency.

Reported-by: Joe Thornber <thornber@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-bufio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index bb8d23d..a42efc7 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1456,9 +1456,9 @@ static long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
 		list_for_each_entry_safe_reverse(b, tmp, &c->lru[l], lru_list) {
 			freed += __cleanup_old_buffer(b, gfp_mask, 0);
 			if (!--nr_to_scan)
-				break;
+				return freed;
+			dm_bufio_cond_resched();
 		}
-		dm_bufio_cond_resched();
 	}
 	return freed;
 }
-- 
1.9.1

