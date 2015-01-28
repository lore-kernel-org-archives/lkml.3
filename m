Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760733AbbA2JUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:20:45 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44890 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760376AbbA2JHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:07:22 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 096/176] smiapp: Take mutex during PLL update in sensor initialisation
Date: Wed, 28 Jan 2015 15:28:46 +0100
Message-Id: <6b77d12ba98e4e0217131f0029ad298487338626.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f85698cd296f08218a7750f321e94607da128600 upstream.

The mutex does not serialise anything in this case but avoids a lockdep
warning from the control framework.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/i2c/smiapp/smiapp-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 371ca22843ee..4bfe83ffd577 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2625,7 +2625,9 @@ static int smiapp_registered(struct v4l2_subdev *subdev)
 		pll->flags |= SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE;
 	pll->scale_n = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
 
+	mutex_lock(&sensor->mutex);
 	rval = smiapp_update_mode(sensor);
+	mutex_unlock(&sensor->mutex);
 	if (rval) {
 		dev_err(&client->dev, "update mode failed\n");
 		goto out_nvm_release;
-- 
2.2.2

