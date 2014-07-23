Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbaGWAKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 20:10:45 -0400
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:56993 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757113AbaGWAKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 20:10:44 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: ming.lei@canonical.com, gregkh@linuxfoundation.org
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] firmware loader: Fix _request_firmware_load() return val for fw load abort
Date: Tue, 22 Jul 2014 18:10:38 -0600
Message-Id: <1406074238-13649-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_request_firmware_load() returns -ENOMEM when fw load is aborted after
timeout. Call is_fw_load_aborted() to check if fw load is aborted and
if true return -EAGAIN.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/base/firmware_class.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index d276e33..3f928b0 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -911,7 +911,9 @@ static int _request_firmware_load(struct firmware_priv *fw_priv,
 	wait_for_completion(&buf->completion);
 
 	cancel_delayed_work_sync(&fw_priv->timeout_work);
-	if (!buf->data)
+	if (is_fw_load_aborted(buf))
+		retval = -EAGAIN;
+	else if (!buf->data)
 		retval = -ENOMEM;
 
 	device_remove_file(f_dev, &dev_attr_loading);
-- 
1.7.10.4

