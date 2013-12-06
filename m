Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759717Ab3LFVzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:55:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759618Ab3LFVyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:54:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>,
        Jens Axboe <axboe@kernel.dk>, Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH 3.4 30/32] elevator: acquire q->sysfs_lock in elevator_change()
Date: Fri,  6 Dec 2013 13:52:40 -0800
Message-Id: <20131206214959.588722356@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214956.830407026@linuxfoundation.org>
References: <20131206214956.830407026@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoki Sekiyama <tomoki.sekiyama@hds.com>

commit 7c8a3679e3d8e9d92d58f282161760a0e247df97 upstream.

Add locking of q->sysfs_lock into elevator_change() (an exported function)
to ensure it is held to protect q->elevator from elevator_init(), even if
elevator_change() is called from non-sysfs paths.
sysfs path (elv_iosched_store) uses __elevator_change(), non-locking
version, as the lock is already taken by elv_iosched_store().

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/elevator.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/block/elevator.c
+++ b/block/elevator.c
@@ -961,7 +961,7 @@ fail_register:
 /*
  * Switch this queue to the given IO scheduler.
  */
-int elevator_change(struct request_queue *q, const char *name)
+static int __elevator_change(struct request_queue *q, const char *name)
 {
 	char elevator_name[ELV_NAME_MAX];
 	struct elevator_type *e;
@@ -983,6 +983,18 @@ int elevator_change(struct request_queue
 
 	return elevator_switch(q, e);
 }
+
+int elevator_change(struct request_queue *q, const char *name)
+{
+	int ret;
+
+	/* Protect q->elevator from elevator_init() */
+	mutex_lock(&q->sysfs_lock);
+	ret = __elevator_change(q, name);
+	mutex_unlock(&q->sysfs_lock);
+
+	return ret;
+}
 EXPORT_SYMBOL(elevator_change);
 
 ssize_t elv_iosched_store(struct request_queue *q, const char *name,
@@ -993,7 +1005,7 @@ ssize_t elv_iosched_store(struct request
 	if (!q->elevator)
 		return count;
 
-	ret = elevator_change(q, name);
+	ret = __elevator_change(q, name);
 	if (!ret)
 		return count;
 


