Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab3LRVSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:18:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab3LRVOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:14:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3.12 084/118] dm delay: fix a possible deadlock due to shared workqueue
Date: Wed, 18 Dec 2013 13:12:01 -0800
Message-Id: <20131218211221.825794876@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 718822c1c112dc99e0c72c8968ee1db9d9d910f0 upstream.

The dm-delay target uses a shared workqueue for multiple instances.  This
can cause deadlock if two or more dm-delay targets are stacked on the top
of each other.

This patch changes dm-delay to use a per-instance workqueue.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-delay.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -20,6 +20,7 @@
 struct delay_c {
 	struct timer_list delay_timer;
 	struct mutex timer_lock;
+	struct workqueue_struct *kdelayd_wq;
 	struct work_struct flush_expired_bios;
 	struct list_head delayed_bios;
 	atomic_t may_delay;
@@ -45,14 +46,13 @@ struct dm_delay_info {
 
 static DEFINE_MUTEX(delayed_bios_lock);
 
-static struct workqueue_struct *kdelayd_wq;
 static struct kmem_cache *delayed_cache;
 
 static void handle_delayed_timer(unsigned long data)
 {
 	struct delay_c *dc = (struct delay_c *)data;
 
-	queue_work(kdelayd_wq, &dc->flush_expired_bios);
+	queue_work(dc->kdelayd_wq, &dc->flush_expired_bios);
 }
 
 static void queue_timeout(struct delay_c *dc, unsigned long expires)
@@ -191,6 +191,12 @@ out:
 		goto bad_dev_write;
 	}
 
+	dc->kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
+	if (!dc->kdelayd_wq) {
+		DMERR("Couldn't start kdelayd");
+		goto bad_queue;
+	}
+
 	setup_timer(&dc->delay_timer, handle_delayed_timer, (unsigned long)dc);
 
 	INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
@@ -203,6 +209,8 @@ out:
 	ti->private = dc;
 	return 0;
 
+bad_queue:
+	mempool_destroy(dc->delayed_pool);
 bad_dev_write:
 	if (dc->dev_write)
 		dm_put_device(ti, dc->dev_write);
@@ -217,7 +225,7 @@ static void delay_dtr(struct dm_target *
 {
 	struct delay_c *dc = ti->private;
 
-	flush_workqueue(kdelayd_wq);
+	destroy_workqueue(dc->kdelayd_wq);
 
 	dm_put_device(ti, dc->dev_read);
 
@@ -350,12 +358,6 @@ static int __init dm_delay_init(void)
 {
 	int r = -ENOMEM;
 
-	kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
-	if (!kdelayd_wq) {
-		DMERR("Couldn't start kdelayd");
-		goto bad_queue;
-	}
-
 	delayed_cache = KMEM_CACHE(dm_delay_info, 0);
 	if (!delayed_cache) {
 		DMERR("Couldn't create delayed bio cache.");
@@ -373,8 +375,6 @@ static int __init dm_delay_init(void)
 bad_register:
 	kmem_cache_destroy(delayed_cache);
 bad_memcache:
-	destroy_workqueue(kdelayd_wq);
-bad_queue:
 	return r;
 }
 
@@ -382,7 +382,6 @@ static void __exit dm_delay_exit(void)
 {
 	dm_unregister_target(&delay_target);
 	kmem_cache_destroy(delayed_cache);
-	destroy_workqueue(kdelayd_wq);
 }
 
 /* Module hooks */


