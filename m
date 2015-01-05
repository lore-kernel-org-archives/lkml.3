Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbbAEPlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:41:51 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:39490 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbbAEPlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:41:49 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] firmware class: remove from pending list on load failure
Date: Mon,  5 Jan 2015 10:41:21 -0500
Message-Id: <1420472494-25836-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we failed loading the firmware we have to make sure it leaves the pending
list if abort wasn't executed for it.

Otherwise we'd free an object still on the pending list and corrupt it.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/base/firmware_class.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index 58470c3..8ccf6cf4 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -929,9 +929,18 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
 	cancel_delayed_work_sync(&fw_priv->timeout_work);
 	if (is_fw_load_aborted(buf))
 		retval = -EAGAIN;
-	else if (!buf->data)
+	else if (!buf->data) {
 		retval = -ENOMEM;
 
+		/*
+		 * We failed loading, but abort was never done so we
+		 * need to remove it from the pending list ourselves.
+		 */
+		mutex_lock(&fw_lock);
+		list_del_init(&buf->pending_list);
+		mutex_unlock(&fw_lock);
+	}
+
 	device_remove_file(f_dev, &dev_attr_loading);
 err_del_bin_attr:
 	device_remove_bin_file(f_dev, &firmware_attr_data);
-- 
2.1.0

