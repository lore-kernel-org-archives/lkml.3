Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab3KVN1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 08:27:12 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:2786 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754738Ab3KVN1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 08:27:11 -0500
From: Oskar Andero <oskar.andero@sonymobile.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Julian Shandorov <jshandorov@gmail.com>,
        Aleksej Makarov <aleksej.makarov@sonymobile.com>,
        Oskar Andero <oskar.andero@sonymobile.com>
Subject: [PATCH v2] input: don't call input_dev_release_keys() in resume
Date: Fri, 22 Nov 2013 14:27:04 +0100
Message-ID: <1385126824-20446-1-git-send-email-oskar.andero@sonymobile.com>
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
index 846ccdd..511d490 100644
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

