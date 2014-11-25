Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaKYLb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:31:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58537 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbaKYKlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joe Thornber <ejt@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 109/254] dm bufio: update last_accessed when relinking a buffer
Date: Tue, 25 Nov 2014 10:37:39 +0000
Message-Id: <1416912004-5928-110-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Thornber <ejt@redhat.com>

commit eb76faf53b1ff7a77ce3f78cc98ad392ac70c2a0 upstream.

The 'last_accessed' member of the dm_buffer structure was only set when
the the buffer was created.  This led to each buffer being discarded
after dm_bufio_max_age time even if it was used recently.  In practice
this resulted in all thinp metadata being evicted soon after being read
-- this is particularly problematic for metadata intensive workloads
like multithreaded small random IO.

'last_accessed' is now updated each time the buffer is moved to the head
of the LRU list, so the buffer is now properly discarded if it was not
used in dm_bufio_max_age time.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/dm-bufio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index d724459860d9..da2ebac231b9 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -465,6 +465,7 @@ static void __relink_lru(struct dm_buffer *b, int dirty)
 	c->n_buffers[dirty]++;
 	b->list_mode = dirty;
 	list_move(&b->lru_list, &c->lru[dirty]);
+	b->last_accessed = jiffies;
 }
 
 /*----------------------------------------------------------------
-- 
2.1.0

