Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbbAIX5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 18:57:45 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36293 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbbAIX5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 18:57:36 -0500
From: mathieu.poirier@linaro.org
To: gregkh@linuxfoundation.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mathieu.poirier@linaro.org
Subject: [PATCH 01/11] coresight-etm: unlock on error paths in mode_store()
Date: Fri,  9 Jan 2015 16:57:12 -0700
Message-Id: <1420847842-31769-2-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420847842-31769-1-git-send-email-mathieu.poirier@linaro.org>
References: <1420847842-31769-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

There are some missing unlocks on the error paths.

Fixes: a939fc5a71ad ('coresight-etm: add CoreSight ETM/PTM driver')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/coresight/coresight-etm3x.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/coresight/coresight-etm3x.c b/drivers/coresight/coresight-etm3x.c
index d9e3ed6aa857..369cac00afaa 100644
--- a/drivers/coresight/coresight-etm3x.c
+++ b/drivers/coresight/coresight-etm3x.c
@@ -573,7 +573,8 @@ static ssize_t mode_store(struct device *dev,
 	if (drvdata->mode & ETM_MODE_STALL) {
 		if (!(drvdata->etmccr & ETMCCR_FIFOFULL)) {
 			dev_warn(drvdata->dev, "stall mode not supported\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_unlock;
 		}
 		drvdata->ctrl |= ETMCR_STALL_MODE;
 	 } else
@@ -582,7 +583,8 @@ static ssize_t mode_store(struct device *dev,
 	if (drvdata->mode & ETM_MODE_TIMESTAMP) {
 		if (!(drvdata->etmccer & ETMCCER_TIMESTAMP)) {
 			dev_warn(drvdata->dev, "timestamp not supported\n");
-			return -EINVAL;
+			ret = -EINVAL;
+			goto err_unlock;
 		}
 		drvdata->ctrl |= ETMCR_TIMESTAMP_EN;
 	} else
@@ -595,6 +597,10 @@ static ssize_t mode_store(struct device *dev,
 	spin_unlock(&drvdata->spinlock);
 
 	return size;
+
+err_unlock:
+	spin_unlock(&drvdata->spinlock);
+	return ret;
 }
 static DEVICE_ATTR_RW(mode);
 
-- 
1.9.1

