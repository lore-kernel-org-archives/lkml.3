Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580AbaKRPGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:06:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068AbaKROJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:39 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 086/206] dm bufio: update last_accessed when relinking a buffer
Date: Tue, 18 Nov 2014 15:07:21 +0100
Message-Id: <15188b0745439aa1f686e6eb55cacabbe2ea0244.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/dm-bufio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 5056c45be97f..bb8d23d55c4a 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -463,6 +463,7 @@ static void __relink_lru(struct dm_buffer *b, int dirty)
 	c->n_buffers[dirty]++;
 	b->list_mode = dirty;
 	list_move(&b->lru_list, &c->lru[dirty]);
+	b->last_accessed = jiffies;
 }
 
 /*----------------------------------------------------------------
-- 
2.1.3

