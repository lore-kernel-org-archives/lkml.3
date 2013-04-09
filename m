Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935680Ab3DISkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:40:05 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40926 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935618Ab3DISkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:40:00 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/8] dmaengine: ste_dma40: Ensure src and dst registers are configured correctly
Date: Tue,  9 Apr 2013 19:39:40 +0100
Message-Id: <1365532783-27425-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Confusingly d40_log_cfg() is used to set up the logical channel
configuration registers, but d40_phy_cfg() is used to configure
physical _and_ logical registers, so it should be called in both
cases. It is the function call's final attribute which determines
whether it's a physical or logical channel, not whether the
function is called or not.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 9e423ad..49d8c9d 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2810,9 +2810,9 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 	/* Fill in register values */
 	if (chan_is_logical(d40c))
 		d40_log_cfg(cfg, &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
-	else
-		d40_phy_cfg(cfg, &d40c->src_def_cfg,
-			    &d40c->dst_def_cfg, false);
+
+	d40_phy_cfg(cfg, &d40c->src_def_cfg, &d40c->dst_def_cfg,
+		    chan_is_logical(d40c));
 
 	/* These settings will take precedence later */
 	d40c->runtime_addr = config_addr;
-- 
1.7.10.4

