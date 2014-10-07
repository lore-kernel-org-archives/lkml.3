Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbaJGXmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:42:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbaJGXTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Gross <agross@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.16 07/26] i2c: qup: Fix order of runtime pm initialization
Date: Tue,  7 Oct 2014 16:19:23 -0700
Message-Id: <20141007231848.708806716@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231848.487609292@linuxfoundation.org>
References: <20141007231848.487609292@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Gross <agross@codeaurora.org>

commit 86b59bbfae2a895aa26b3d15f31b1a705dbfede1 upstream.

The runtime pm calls need to be done before populating the children via the
i2c_add_adapter call.  If this is not done, a child can run into issues trying
to do i2c read/writes due to the pm_runtime_sync failing.

Signed-off-by: Andy Gross <agross@codeaurora.org>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-qup.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -670,16 +670,20 @@ static int qup_i2c_probe(struct platform
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


