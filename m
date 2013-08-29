Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab3H2S2Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:28:16 -0400
Received: from ns.iliad.fr ([212.27.33.1]:52384 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab3H2S2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:28:15 -0400
Message-ID: <1377800893.559.24.camel@sakura.staff.proxad.net>
Subject: [PATCH] firmware loader: fix pending_fw_head list corruption
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 29 Aug 2013 20:28:13 +0200
Organization: Freebox
Content-Type: text/plain; charset="ANSI_X3.4-1968"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got the following oops just before reboot:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
[<8028d300>] (__list_del_entry+0x44/0xac)
[<802e3320>] (__fw_load_abort.part.13+0x1c/0x50)
[<802e337c>] (fw_shutdown_notify+0x28/0x50)
[<80034f80>] (notifier_call_chain.isra.1+0x5c/0x9c)
[<800350ec>] (__blocking_notifier_call_chain+0x44/0x58)
[<80035114>] (blocking_notifier_call_chain+0x14/0x18)
[<80035d64>] (kernel_restart_prepare+0x14/0x38)
[<80035d94>] (kernel_restart+0xc/0x50)

The following race condition triggers here:

  _request_firmware_load()
  device_create_file(...)
  kobject_uevent(...)
  (schedule)
                                       (resume)
                                       firmware_loading_store(1)
                                       firmware_loading_store(0)
                                       list_del_init(&buf->pending_list)
                                       (schedule)
  (resume)
  list_add(&buf->pending_list, &pending_fw_head);
  wait_for_completion(&buf->completion);

causing an oops later when walking pending_list after the firmware has
been released.

The proposed fix is to move the list_add() before sysfs attribute
creation.

Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
---
 drivers/base/firmware_class.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index a439602..c8dac74 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -868,8 +868,15 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 		goto err_del_dev;
 	}
 
+	mutex_lock(&fw_lock);
+	list_add(&buf->pending_list, &pending_fw_head);
+	mutex_unlock(&fw_lock);
+
 	retval = device_create_file(f_dev, &dev_attr_loading);
 	if (retval) {
+		mutex_lock(&fw_lock);
+		list_del_init(&buf->pending_list);
+		mutex_unlock(&fw_lock);
 		dev_err(f_dev, "%s: device_create_file failed\n", __func__);
 		goto err_del_bin_attr;
 	}
@@ -884,10 +891,6 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 		kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
 	}
 
-	mutex_lock(&fw_lock);
-	list_add(&buf->pending_list, &pending_fw_head);
-	mutex_unlock(&fw_lock);
-
 	wait_for_completion(&buf->completion);
 
 	cancel_delayed_work_sync(&fw_priv->timeout_work);
-- 
1.7.9.5


