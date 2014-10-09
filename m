Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410AbaJIVGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:06:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59067 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357AbaJIVGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:06:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 135/163] md/raid1: count resync requests in nr_pending.
Date: Thu,  9 Oct 2014 14:02:40 -0700
Message-Id: <1412888588-26755-136-git-send-email-kamal@canonical.com>
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

commit 34e97f170149bfa14979581c4c748bc9b4b79d5b upstream.

Both normal IO and resync IO can be retried with reschedule_retry()
and so be counted into ->nr_queued, but only normal IO gets counted in
->nr_pending.

Before the recent improvement to RAID1 resync there could only
possibly have been one or the other on the queue.  When handling a
read failure it could only be normal IO.  So when handle_read_error()
called freeze_array() the fact that freeze_array only compares
->nr_queued against ->nr_pending was safe.

But now that these two types can interleave, we can have both normal
and resync IO requests queued, so we need to count them both in
nr_pending.

This error can lead to freeze_array() hanging if there is a read
error, so it is suitable for -stable.

Fixes: 79ef3a8aa1cb1523cc231c9a90a278333c21f761
Reported-by: Brassow Jonathan <jbrassow@redhat.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5ad11da..2cf4f69 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -858,6 +858,7 @@ static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
 			     conf->next_resync + RESYNC_SECTORS),
 			    conf->resync_lock);
 
+	conf->nr_pending++;
 	spin_unlock_irq(&conf->resync_lock);
 }
 
@@ -867,6 +868,7 @@ static void lower_barrier(struct r1conf *conf)
 	BUG_ON(conf->barrier <= 0);
 	spin_lock_irqsave(&conf->resync_lock, flags);
 	conf->barrier--;
+	conf->nr_pending--;
 	spin_unlock_irqrestore(&conf->resync_lock, flags);
 	wake_up(&conf->wait_barrier);
 }
-- 
1.9.1

