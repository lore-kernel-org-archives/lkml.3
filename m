Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbaFRSRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 14:17:24 -0400
Received: from mail-qa0-f74.google.com ([209.85.216.74]:34257 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbaFRSOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 14:14:14 -0400
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        Doug Anderson <dianders@chromium.org>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/10] mdf: cros_ec: Detect in-progress commands
Date: Wed, 18 Jun 2014 11:14:01 -0700
Message-Id: <1403115247-8853-5-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403115247-8853-1-git-send-email-dianders@chromium.org>
References: <1403115247-8853-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Glass <sjg@chromium.org>

Some commands take a while to execute. Use -EAGAIN to signal this to the
caller.

Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
Changes in v2: None

 drivers/mfd/cros_ec_spi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mfd/cros_ec_spi.c b/drivers/mfd/cros_ec_spi.c
index 52d4d7b..c29a2d7 100644
--- a/drivers/mfd/cros_ec_spi.c
+++ b/drivers/mfd/cros_ec_spi.c
@@ -292,6 +292,12 @@ static int cros_ec_cmd_xfer_spi(struct cros_ec_device *ec_dev,
 	/* check response error code */
 	ptr = ec_dev->din;
 	if (ptr[0]) {
+		if (ptr[0] == EC_RES_IN_PROGRESS) {
+			dev_dbg(ec_dev->dev, "command 0x%02x in progress\n",
+				ec_msg->cmd);
+			ret = -EAGAIN;
+			goto exit;
+		}
 		dev_warn(ec_dev->dev, "command 0x%02x returned an error %d\n",
 			 ec_msg->cmd, ptr[0]);
 		debug_packet(ec_dev->dev, "in_err", ptr, len);
-- 
2.0.0.526.g5318336

