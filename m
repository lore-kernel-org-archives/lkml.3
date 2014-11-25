Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbaKYLbF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:31:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58544 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaKYKls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 110/254] dm bufio: when done scanning return from __scan immediately
Date: Tue, 25 Nov 2014 10:37:40 +0000
Message-Id: <1416912004-5928-111-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-bufio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index da2ebac231b9..598ba99d2e15 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1486,9 +1486,9 @@ static long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
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
2.1.0

