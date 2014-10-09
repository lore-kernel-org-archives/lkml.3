Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbaJIVFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:05:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58990 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbaJIVF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:05:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 131/163] md/raid1: clean up request counts properly in close_sync()
Date: Thu,  9 Oct 2014 14:02:36 -0700
Message-Id: <1412888588-26755-132-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 669cc7ba77864e7b1ac39c9f2b2afb8730f341f4 upstream.

If there are outstanding writes when close_sync is called,
the change to ->start_next_window might cause them to
decrement the wrong counter when they complete.  Fix this
by merging the two counters into the one that will be decremented.

Having an incorrect value in a counter can cause raise_barrier()
to hangs, so this is suitable for -stable.

Fixes: 79ef3a8aa1cb1523cc231c9a90a278333c21f761
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid1.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e124f01..2414a79 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1544,8 +1544,13 @@ static void close_sync(struct r1conf *conf)
 	mempool_destroy(conf->r1buf_pool);
 	conf->r1buf_pool = NULL;
 
+	spin_lock_irq(&conf->resync_lock);
 	conf->next_resync = 0;
 	conf->start_next_window = MaxSector;
+	conf->current_window_requests +=
+		conf->next_window_requests;
+	conf->next_window_requests = 0;
+	spin_unlock_irq(&conf->resync_lock);
 }
 
 static int raid1_spare_active(struct mddev *mddev)
-- 
1.9.1

