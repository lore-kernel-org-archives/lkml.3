Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab3LQSO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:14:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60963 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab3LQSO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:14:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomoki Sekiyama <tomoki.sekiyama@hds.com>, Jens Axboe <axboe@kernel.dk>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 051/103] elevator: acquire q->sysfs_lock in elevator_change()
Date: Tue, 17 Dec 2013 18:12:40 +0000
Message-Id: <1387304012-23805-52-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/elevator.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 6a55d41..f69363e 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -936,7 +936,7 @@ fail_init:
 /*
  * Switch this queue to the given IO scheduler.
  */
-int elevator_change(struct request_queue *q, const char *name)
+static int __elevator_change(struct request_queue *q, const char *name)
 {
 	char elevator_name[ELV_NAME_MAX];
 	struct elevator_type *e;
@@ -958,6 +958,18 @@ int elevator_change(struct request_queue *q, const char *name)
 
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
@@ -968,7 +980,7 @@ ssize_t elv_iosched_store(struct request_queue *q, const char *name,
 	if (!q->elevator)
 		return count;
 
-	ret = elevator_change(q, name);
+	ret = __elevator_change(q, name);
 	if (!ret)
 		return count;
 
-- 
1.8.3.2

