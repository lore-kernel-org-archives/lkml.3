Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313AbaEMJag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:30:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33212 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760154AbaEMJ3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:29:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 174/182] dm thin: fix dangling bio in process_deferred_bios error path
Date: Tue, 13 May 2014 11:28:46 +0200
Message-Id: <8679e185b1db924da70933afbfc25dd889b2ad4b.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit fe76cd88e654124d1431bb662a0fc6e99ca811a5 upstream.

If unable to ensure_next_mapping() we must add the current bio, which
was removed from the @bios list via bio_list_pop, back to the
deferred_bios list before all the remaining @bios.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/md/dm-thin.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e9587101b04f..e4cc196634c1 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1332,9 +1332,9 @@ static void process_deferred_bios(struct pool *pool)
 		 */
 		if (ensure_next_mapping(pool)) {
 			spin_lock_irqsave(&pool->lock, flags);
+			bio_list_add(&pool->deferred_bios, bio);
 			bio_list_merge(&pool->deferred_bios, &bios);
 			spin_unlock_irqrestore(&pool->lock, flags);
-
 			break;
 		}
 
-- 
1.9.3

