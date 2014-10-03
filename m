Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbaJCWEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:04:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430AbaJCWEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:04:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.16 329/357] md/raid1: clean up request counts properly in close_sync()
Date: Fri,  3 Oct 2014 14:31:55 -0700
Message-Id: <20141003212943.345554203@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1548,8 +1548,13 @@ static void close_sync(struct r1conf *co
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


