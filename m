Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab3JTVgR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 17:36:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab3JTVfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 17:35:48 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, x86@kernel.org,
        herrmann.der.user@googlemail.com, ming.lei@canonical.com,
        tigran@aivazian.fsnet.co.uk
Subject: [PATCH 1/2] firmware, fix request_firmware_nowait() freeze with no uevent
Date: Sun, 20 Oct 2013 17:35:25 -0400
Message-Id: <1382304926-1641-2-git-send-email-prarit@redhat.com>
In-Reply-To: <1382304926-1641-1-git-send-email-prarit@redhat.com>
References: <1382304926-1641-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If request_firmware_nowait() is called with uevent == NULL, the firmware
completion is never marked complete resulting in a hang in the process.

If uevent is undefined, that means we're not waiting on anything and the
process should just clean up and complete.  While we're at it, add a
debug dev_dbg() to indicate that the FW has not been found.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: x86@kernel.org
Cc: herrmann.der.user@googlemail.com
Cc: ming.lei@canonical.com
Cc: tigran@aivazian.fsnet.co.uk
---
 drivers/base/firmware_class.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 10a4467..95778dc 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -335,7 +335,8 @@ static bool fw_get_filesystem_firmware(struct device *device,
 		set_bit(FW_STATUS_DONE, &buf->status);
 		complete_all(&buf->completion);
 		mutex_unlock(&fw_lock);
-	}
+	} else
+		dev_dbg(device, "firmware: %s not found\n", buf->fw_id);
 
 	return success;
 }
@@ -886,6 +887,9 @@ static int _request_firmware_load(struct firmware_priv *fw_priv, bool uevent,
 			schedule_delayed_work(&fw_priv->timeout_work, timeout);
 
 		kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
+	} else {
+		/* if there is no uevent then just cleanup */
+		schedule_delayed_work(&fw_priv->timeout_work, 0);
 	}
 
 	wait_for_completion(&buf->completion);
-- 
1.7.9.3

