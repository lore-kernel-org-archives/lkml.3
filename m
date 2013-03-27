Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab3C0NJ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:09:26 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44310 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab3C0NJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:09:24 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 16/17] drbd: use sched_setscheduler()
Date: Wed, 27 Mar 2013 14:08:48 +0100
Message-Id: <1364389729-17559-17-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was unnoticed for some time that assigning to current->policy is
no longer sufficient to set a real time priority for a kernel thread.

Reported-by: Charlie Suffin <Charlie.Suffin@stratus.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    6 ++++--
 include/linux/drbd.h               |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index a75c0b1..0f449bb 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -5257,9 +5257,11 @@ int drbd_asender(struct drbd_thread *thi)
 	bool ping_timeout_active = false;
 	struct net_conf *nc;
 	int ping_timeo, tcp_cork, ping_int;
+	struct sched_param param = { .sched_priority = 2 };
 
-	current->policy = SCHED_RR;  /* Make this a realtime task! */
-	current->rt_priority = 2;    /* more important than all other tasks */
+	rv = sched_setscheduler(current, SCHED_RR, &param);
+	if (rv < 0)
+		conn_err(tconn, "drbd_asender: ERROR set priority, ret=%d\n", rv);
 
 	while (get_t_state(thi) == RUNNING) {
 		drbd_thread_current_set_cpu(thi);
diff --git a/include/linux/drbd.h b/include/linux/drbd.h
index 3163307..1b4d4ee 100644
--- a/include/linux/drbd.h
+++ b/include/linux/drbd.h
@@ -52,7 +52,7 @@
 #endif
 
 extern const char *drbd_buildtag(void);
-#define REL_VERSION "8.4.2"
+#define REL_VERSION "8.4.3"
 #define API_VERSION 1
 #define PRO_VERSION_MIN 86
 #define PRO_VERSION_MAX 101
-- 
1.7.9.5

