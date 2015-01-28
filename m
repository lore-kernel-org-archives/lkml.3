Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933887AbbA1ERM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:17:12 -0500
Received: from mail.kernel.org ([198.145.29.136]:37983 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933857AbbA1ERH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:17:07 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 040/177] dm bufio: update last_accessed when relinking a buffer
Date: Wed, 28 Jan 2015 12:07:26 +0800
Message-Id: <1422418236-12852-79-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/md/dm-bufio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 6f99500..5abc8d6 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -467,6 +467,7 @@ static void __relink_lru(struct dm_buffer *b, int dirty)
 	b->list_mode = dirty;
 	list_del(&b->lru_list);
 	list_add(&b->lru_list, &c->lru[dirty]);
+	b->last_accessed = jiffies;
 }
 
 /*----------------------------------------------------------------
-- 
1.9.1

