Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab3IXGU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:20:26 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39279 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3IXGTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:19:10 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org
Cc: axboe@kernel.dk, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 08/11] bcache: Fix a dumb CPU spinning bug in writeback
Date: Mon, 23 Sep 2013 23:17:33 -0700
Message-Id: <1380003456-19938-9-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
References: <1380003456-19938-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

schedule_timeout() != schedule_timeout_uninterruptible()

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
---
 drivers/md/bcache/writeback.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 27ac519..ba3ee48 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -397,8 +397,7 @@ static void read_dirty(struct closure *cl)
 		if (delay > 0 &&
 		    (KEY_START(&w->key) != dc->last_read ||
 		     jiffies_to_msecs(delay) > 50))
-			while (delay)
-				delay = schedule_timeout(delay);
+			delay = schedule_timeout_uninterruptible(delay);
 
 		dc->last_read	= KEY_OFFSET(&w->key);
 
-- 
1.8.4.rc3

