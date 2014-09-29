Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbaI2WBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:01:07 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:47979 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbaI2WBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:01:03 -0400
From: Andy Gross <agross@codeaurora.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH] i2c: qup: Fix order of runtime pm initialization
Date: Mon, 29 Sep 2014 17:00:51 -0500
Message-Id: <1412028051-21774-1-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The runtime pm calls need to be done before populating the children via the
i2c_add_adapter call.  If this is not done, a child can run into issues trying
to do i2c read/writes due to the pm_runtime_sync failing.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/i2c/busses/i2c-qup.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
index 3a4d64e..092d89b 100644
--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -674,16 +674,20 @@ static int qup_i2c_probe(struct platform_device *pdev)
 	qup->adap.dev.of_node = pdev->dev.of_node;
 	strlcpy(qup->adap.name, "QUP I2C adapter", sizeof(qup->adap.name));
 
-	ret = i2c_add_adapter(&qup->adap);
-	if (ret)
-		goto fail;
-
 	pm_runtime_set_autosuspend_delay(qup->dev, MSEC_PER_SEC);
 	pm_runtime_use_autosuspend(qup->dev);
 	pm_runtime_set_active(qup->dev);
 	pm_runtime_enable(qup->dev);
+
+	ret = i2c_add_adapter(&qup->adap);
+	if (ret)
+		goto fail_runtime;
+
 	return 0;
 
+fail_runtime:
+	pm_runtime_disable(qup->dev);
+	pm_runtime_set_suspended(qup->dev);
 fail:
 	qup_i2c_disable_clocks(qup);
 	return ret;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

