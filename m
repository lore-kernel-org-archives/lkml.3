Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3EIWNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:13:45 -0400
Received: from longford.logfs.org ([213.229.74.203]:59119 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab3EIWNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:13:43 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 06/14] bcon: add a release work struct
Date: Thu,  9 May 2013 16:43:04 -0400
Message-Id: <1368132193-25817-9-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368132193-25817-1-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The final bcon_put() can be called from atomic context, by way of
bio_endio().  In that case we would sleep in invalidate_mapping_pages(),
with the usual unhappy results.

In nearly a year of production use, I have only seen a matching
backtrace once.  There was a second known issue that could be reproduced
by "yes h > /proc/sysrq-trigger" and concurrently pulling and replugging
the blockconsole device.  It took be somewhere around 30 pulls and sore
thumbs to reproduce and I never found the time to get to the bottom of
it.  Quite likely the two issues are identical.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/block/blockconsole.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
index 32f6c62..b4730f8 100644
--- a/drivers/block/blockconsole.c
+++ b/drivers/block/blockconsole.c
@@ -65,6 +65,7 @@ struct blockconsole {
 	struct block_device *bdev;
 	struct console console;
 	struct work_struct unregister_work;
+	struct work_struct release_work;
 	struct task_struct *writeback_thread;
 	struct notifier_block panic_block;
 };
@@ -74,9 +75,10 @@ static void bcon_get(struct blockconsole *bc)
 	kref_get(&bc->kref);
 }
 
-static void bcon_release(struct kref *kref)
+static void __bcon_release(struct work_struct *work)
 {
-	struct blockconsole *bc = container_of(kref, struct blockconsole, kref);
+	struct blockconsole *bc = container_of(work, struct blockconsole,
+			release_work);
 
 	__free_pages(bc->zero_page, 0);
 	__free_pages(bc->pages, 8);
@@ -85,6 +87,14 @@ static void bcon_release(struct kref *kref)
 	kfree(bc);
 }
 
+static void bcon_release(struct kref *kref)
+{
+	struct blockconsole *bc = container_of(kref, struct blockconsole, kref);
+
+	/* bcon_release can be called from atomic context */
+	schedule_work(&bc->release_work);
+}
+
 static void bcon_put(struct blockconsole *bc)
 {
 	kref_put(&bc->kref, bcon_release);
@@ -512,6 +522,7 @@ static int bcon_create(const char *devname)
 	if (IS_ERR(bc->writeback_thread))
 		goto out2;
 	INIT_WORK(&bc->unregister_work, bcon_unregister);
+	INIT_WORK(&bc->release_work, __bcon_release);
 	register_console(&bc->console);
 	bc->panic_block.notifier_call = blockconsole_panic;
 	bc->panic_block.priority = INT_MAX;
-- 
1.7.10.4

