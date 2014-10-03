Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229AbaJCWXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:23:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46898 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970AbaJCWOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:14:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brassow Jonathan <jbrassow@redhat.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.14 219/238] md/raid1: count resync requests in nr_pending.
Date: Fri,  3 Oct 2014 14:32:14 -0700
Message-Id: <20141003212920.673535604@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -856,6 +856,7 @@ static void raise_barrier(struct r1conf
 			     conf->next_resync + RESYNC_SECTORS),
 			    conf->resync_lock);
 
+	conf->nr_pending++;
 	spin_unlock_irq(&conf->resync_lock);
 }
 
@@ -865,6 +866,7 @@ static void lower_barrier(struct r1conf
 	BUG_ON(conf->barrier <= 0);
 	spin_lock_irqsave(&conf->resync_lock, flags);
 	conf->barrier--;
+	conf->nr_pending--;
 	spin_unlock_irqrestore(&conf->resync_lock, flags);
 	wake_up(&conf->wait_barrier);
 }


