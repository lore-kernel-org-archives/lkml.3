Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaHSNBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 09:01:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50456 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaHSNBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 09:01:35 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org
Cc: Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH] bcache: prevent crash on changing writeback_running
Date: Tue, 19 Aug 2014 15:01:33 +0200
Message-Id: <1408453293-17917-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a664d0f05a2ec02c8f042db536d84d15d6e19e81
    bcache: fix crash on shutdown in passthrough mode

added a safeguard in the shutdown case. At least while not being
attached it is also possible to trigger a kernel bug by writing into
writeback_running. This change  adds the same check before trying to
wake up the thread for that case.

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/md/bcache/writeback.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/writeback.h b/drivers/md/bcache/writeback.h
index 0a9dab1..073a042 100644
--- a/drivers/md/bcache/writeback.h
+++ b/drivers/md/bcache/writeback.h
@@ -63,7 +63,8 @@ static inline bool should_writeback(struct cached_dev *dc, struct bio *bio,
 
 static inline void bch_writeback_queue(struct cached_dev *dc)
 {
-	wake_up_process(dc->writeback_thread);
+	if (!IS_ERR_OR_NULL(dc->writeback_thread))
+		wake_up_process(dc->writeback_thread);
 }
 
 static inline void bch_writeback_add(struct cached_dev *dc)
-- 
1.9.1

