Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbaHFMbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:31:07 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:53208 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752363AbaHFMbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:31:05 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH] i2c: qup: disable clks and return instead of just returning error
Date: Wed,  6 Aug 2014 18:03:25 +0530
Message-Id: <1407328405-25170-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a error handling scenario where clocks were not being disabled
when QUP_OUTPUT_BLOCK_SIZE returns a size greater than the size of blk_sizes
array. So this patch adds a statement to jump to the fail lable to release the
clocks.

CC: Wolfram Sang <wsa@the-dreams.de>
CC: Grant Likely <grant.likely@linaro.org>
CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Andy Gross <agross@codeaurora.org>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---

Resending the patch by updating CCs list.
Fixed Typos in commit message noticed by Christopher.

 drivers/i2c/busses/i2c-qup.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
index 2a5efb5..3a4d64e 100644
--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -633,13 +633,17 @@ static int qup_i2c_probe(struct platform_device *pdev)
 	 * associated with each byte written/received
 	 */
 	size = QUP_OUTPUT_BLOCK_SIZE(io_mode);
-	if (size >= ARRAY_SIZE(blk_sizes))
-		return -EIO;
+	if (size >= ARRAY_SIZE(blk_sizes)) {
+		ret = -EIO;
+		goto fail;
+	}
 	qup->out_blk_sz = blk_sizes[size] / 2;
 
 	size = QUP_INPUT_BLOCK_SIZE(io_mode);
-	if (size >= ARRAY_SIZE(blk_sizes))
-		return -EIO;
+	if (size >= ARRAY_SIZE(blk_sizes)) {
+		ret = -EIO;
+		goto fail;
+	}
 	qup->in_blk_sz = blk_sizes[size] / 2;
 
 	size = QUP_OUTPUT_FIFO_SIZE(io_mode);
-- 
1.7.9.5

