Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934506Ab3CMXvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:51:38 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:45671 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934455Ab3CMXvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:51:14 -0400
From: Benson Leung <bleung@chromium.org>
To: rydberg@euromail.se, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Cc: bleung@chromium.org, olofj@chromium.org, djkurtz@chromium.org,
        dudl@cypress.com
Subject: [PATCH 3/4] Input: cyapa - Allow filename to be changed in update_fw
Date: Wed, 13 Mar 2013 16:50:50 -0700
Message-Id: <1363218651-22457-4-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1363218651-22457-1-git-send-email-bleung@chromium.org>
References: <1363218651-22457-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the name of the designated firmware to be passed as the
argument to update_fw from user space. This will allow user space
to specify which firmware to load.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/mouse/cyapa.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index e622c25..51e9d44 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -1180,9 +1180,16 @@ static ssize_t cyapa_update_fw_store(struct device *dev,
 				     const char *buf, size_t count)
 {
 	struct cyapa *cyapa = dev_get_drvdata(dev);
-	const char *fw_name = CYAPA_FW_NAME;
+	const char *fw_name;
 	int ret;
 
+	/* Do not allow paths that step out of /lib/firmware  */
+	if (strstr(buf, "../") != NULL)
+		return -EINVAL;
+
+	fw_name = !strncmp(buf, "1", count) ||
+		  !strncmp(buf, "1\n", count) ? CYAPA_FW_NAME : buf;
+
 	ret = cyapa_firmware(cyapa, fw_name);
 	if (ret)
 		dev_err(dev, "firmware update failed, %d\n", ret);
-- 
1.8.1.3

