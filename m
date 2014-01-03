Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaACGJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 01:09:22 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50922 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaACGJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 01:09:21 -0500
From: Barry Song <21cnbao@gmail.com>
To: jkosina@suse.cz, arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Bin Shi <Bin.Shi@csr.com>, Barry Song <Baohua.Song@csr.com>
Subject: [PATCH] apm-emulation: add hibernation APM events to support suspend2disk
Date: Fri,  3 Jan 2014 14:08:54 +0800
Message-Id: <1388729334-14242-1-git-send-email-21cnbao@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bin Shi <Bin.Shi@csr.com>

Some embedded systems use hibernation for fast boot. and in it,
some software components need to handle specific things before
hibernation and after restore. So it needs to capture the apm
status about these pm events.

Currently apm just supports suspend to ram, but not suspend to disk,
so here add logic about hibernation apm events.

Signed-off-by: Bin Shi <Bin.Shi@csr.com>
Signed-off-by: Barry Song <Baohua.Song@csr.com>
---
 drivers/char/apm-emulation.c  |   11 +++++++++--
 include/uapi/linux/apm_bios.h |    2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index 46118f8..dd9dfa1 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -531,6 +531,7 @@ static int apm_suspend_notifier(struct notifier_block *nb,
 {
 	struct apm_user *as;
 	int err;
+	unsigned long apm_event;
 
 	/* short-cut emergency suspends */
 	if (atomic_read(&userspace_notification_inhibit))
@@ -538,6 +539,9 @@ static int apm_suspend_notifier(struct notifier_block *nb,
 
 	switch (event) {
 	case PM_SUSPEND_PREPARE:
+	case PM_HIBERNATION_PREPARE:
+		apm_event = (event == PM_SUSPEND_PREPARE) ?
+			APM_USER_SUSPEND : APM_USER_HIBERNATION;
 		/*
 		 * Queue an event to all "writer" users that we want
 		 * to suspend and need their ack.
@@ -550,7 +554,7 @@ static int apm_suspend_notifier(struct notifier_block *nb,
 			    as->writer && as->suser) {
 				as->suspend_state = SUSPEND_PENDING;
 				atomic_inc(&suspend_acks_pending);
-				queue_add_event(&as->queue, APM_USER_SUSPEND);
+				queue_add_event(&as->queue, apm_event);
 			}
 		}
 
@@ -601,11 +605,14 @@ static int apm_suspend_notifier(struct notifier_block *nb,
 		return notifier_from_errno(err);
 
 	case PM_POST_SUSPEND:
+	case PM_POST_HIBERNATION:
+		apm_event = (event == PM_POST_SUSPEND) ?
+			APM_NORMAL_RESUME : APM_HIBERNATION_RESUME;
 		/*
 		 * Anyone on the APM queues will think we're still suspended.
 		 * Send a message so everyone knows we're now awake again.
 		 */
-		queue_event(APM_NORMAL_RESUME);
+		queue_event(apm_event);
 
 		/*
 		 * Finally, wake up anyone who is sleeping on the suspend.
diff --git a/include/uapi/linux/apm_bios.h b/include/uapi/linux/apm_bios.h
index 724f409..df79bca 100644
--- a/include/uapi/linux/apm_bios.h
+++ b/include/uapi/linux/apm_bios.h
@@ -67,6 +67,8 @@ struct apm_bios_info {
 #define APM_USER_SUSPEND	0x000a
 #define APM_STANDBY_RESUME	0x000b
 #define APM_CAPABILITY_CHANGE	0x000c
+#define APM_USER_HIBERNATION	0x000d
+#define APM_HIBERNATION_RESUME	0x000e
 
 /*
  * Error codes
-- 
1.7.5.4

