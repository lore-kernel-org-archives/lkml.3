Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbbAYSbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:31:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbbAYSK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 3.18 106/183] [media] smiapp: Take mutex during PLL update in sensor initialisation
Date: Sun, 25 Jan 2015 10:07:08 -0800
Message-Id: <20150125180814.811313496@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit f85698cd296f08218a7750f321e94607da128600 upstream.

The mutex does not serialise anything in this case but avoids a lockdep
warning from the control framework.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/i2c/smiapp/smiapp-core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2677,7 +2677,9 @@ static int smiapp_registered(struct v4l2
 		pll->flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
 	pll->scale_n = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
 
+	mutex_lock(&sensor->mutex);
 	rval = smiapp_update_mode(sensor);
+	mutex_unlock(&sensor->mutex);
 	if (rval) {
 		dev_err(&client->dev, "update mode failed\n");
 		goto out_nvm_release;


