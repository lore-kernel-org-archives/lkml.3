Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab3E0Kaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:30:30 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:64866 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411Ab3E0Ka2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:30:28 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 2/2] driver core: firmware loader: kill FW_ACTION_NOHOTPLUG requests before suspend
Date: Mon, 27 May 2013 18:30:04 +0800
Message-Id: <1369650604-27941-3-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369650604-27941-1-git-send-email-ming.lei@canonical.com>
References: <1369650604-27941-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch kills the firmware loading requests of FW_ACTION_NOHOTPLUG
before suspend to avoid blocking suspend because there is no timeout
for these requests.

Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---

This patch depends on Takashi Iwai's patch of "firmware: Avoid deadlock of
usermodehelper lock at shutdown"

 drivers/base/firmware_class.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 64e7870..5690e72 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -128,6 +128,7 @@ struct firmware_buf {
 	size_t size;
 #ifdef CONFIG_FW_LOADER_USER_HELPER
 	bool is_paged_buf;
+	bool need_uevent;
 	struct page **pages;
 	int nr_pages;
 	int page_array_size;
@@ -873,6 +874,7 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 	}
 
 	if (uevent) {
+		buf->need_uevent = true;
 		dev_set_uevent_suppress(f_dev, false);
 		dev_dbg(f_dev, "firmware: requesting %s\n", buf->fw_id);
 		if (timeout != MAX_SCHEDULE_TIMEOUT)
@@ -1407,6 +1409,20 @@ static void __device_uncache_fw_images(void)
 	spin_unlock(&fwc->name_lock);
 }
 
+/* kill pending requests without uevent to avoid blocking suspend */
+static void kill_requests_without_uevent(void)
+{
+	struct firmware_buf *buf;
+	struct firmware_buf *next;
+
+	mutex_lock(&fw_lock);
+	list_for_each_entry_safe(buf, next, &pending_fw_head, pending_list) {
+		if (!buf->need_uevent)
+			 fw_load_abort(buf);
+	}
+	mutex_unlock(&fw_lock);
+}
+
 /**
  * device_cache_fw_images - cache devices' firmware
  *
@@ -1486,6 +1502,7 @@ static int fw_pm_notify(struct notifier_block *notify_block,
 	switch (mode) {
 	case PM_HIBERNATION_PREPARE:
 	case PM_SUSPEND_PREPARE:
+		kill_requests_without_uevent();
 		device_cache_fw_images();
 		break;
 
-- 
1.7.9.5

