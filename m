Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991AbaEKT0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:26:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933425AbaEKT0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:26:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>
Subject: [PATCH 3.10 44/48] dm thin: fix dangling bio in process_deferred_bios error path
Date: Sun, 11 May 2014 21:20:18 +0200
Message-Id: <20140511191954.033457231@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191948.079900414@linuxfoundation.org>
References: <20140511191948.079900414@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit fe76cd88e654124d1431bb662a0fc6e99ca811a5 upstream.

If unable to ensure_next_mapping() we must add the current bio, which
was removed from the @bios list via bio_list_pop, back to the
deferred_bios list before all the remaining @bios.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-thin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1322,9 +1322,9 @@ static void process_deferred_bios(struct
 		 */
 		if (ensure_next_mapping(pool)) {
 			spin_lock_irqsave(&pool->lock, flags);
+			bio_list_add(&pool->deferred_bios, bio);
 			bio_list_merge(&pool->deferred_bios, &bios);
 			spin_unlock_irqrestore(&pool->lock, flags);
-
 			break;
 		}
 


