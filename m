Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbaKRPDd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:03:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089AbaKROJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:42 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 087/206] dm bufio: when done scanning return from __scan immediately
Date: Tue, 18 Nov 2014 15:07:22 +0100
Message-Id: <de91001eafdb327475a4034b97b1871170d1f0ce.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/dm-bufio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index bb8d23d55c4a..a42efc7f69ed 100644
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
2.1.3

