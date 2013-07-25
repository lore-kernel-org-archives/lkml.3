Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3GYMJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:09:25 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:15414 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755226Ab3GYMJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:09:21 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Radovan Lekanovic <radovan.lekanovic@sonymobile.com>,
        Aleksej Makarov <aleksej.makarov@sonymobile.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Oskar Andero <oskar.andero@sonymobile.com>
Subject: [PATCH v2] input: don't call input_dev_release_keys() in resume
Date: Thu, 25 Jul 2013 14:09:14 +0200
Message-ID: <1374754154-7990-1-git-send-email-oskar.andero@sonymobile.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aleksej Makarov <aleksej.makarov@sonymobile.com>

When waking up the platform by pressing a specific key, sending a
release on that key makes it impossible to react on the event in
user-space. This is fixed by moving the input_reset_device() call to
resume instead.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
Signed-off-by: Aleksej Makarov <aleksej.makarov@sonymobile.com>
Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
---
 drivers/input/input.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index c044699..ee3ff16 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1676,22 +1676,13 @@ static int input_dev_suspend(struct device *dev)
 {
 	struct input_dev *input_dev = to_input_dev(dev);
 
-	mutex_lock(&input_dev->mutex);
-
-	if (input_dev->users)
-		input_dev_toggle(input_dev, false);
-
-	mutex_unlock(&input_dev->mutex);
+	input_reset_device(input_dev);
 
 	return 0;
 }
 
 static int input_dev_resume(struct device *dev)
 {
-	struct input_dev *input_dev = to_input_dev(dev);
-
-	input_reset_device(input_dev);
-
 	return 0;
 }
 
-- 
1.8.1.5

