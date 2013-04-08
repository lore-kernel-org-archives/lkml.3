Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936289Ab3DHKJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:09:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42847 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935738Ab3DHJwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:52:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bing Zhao <bzhao@marvell.com>, "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 054/102] mwifiex: cancel cmd timer and free curr_cmd in shutdown process
Date: Mon,  8 Apr 2013 10:50:09 +0100
Message-Id: <1365414657-29191-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit 084c7189acb3f969c855536166042e27f5dd703f upstream.

curr_cmd points to the command that is in processing or waiting
for its command response from firmware. If the function shutdown
happens to occur at this time we should cancel the cmd timer and
put the command back to free queue.

Tested-by: Marco Cesarano <marco@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/init.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index c1cb004..0346cc2 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -591,6 +591,14 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 		return ret;
 	}
 
+	/* cancel current command */
+	if (adapter->curr_cmd) {
+		dev_warn(adapter->dev, "curr_cmd is still in processing\n");
+		del_timer(&adapter->cmd_timer);
+		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
+		adapter->curr_cmd = NULL;
+	}
+
 	/* shut down mwifiex */
 	dev_dbg(adapter->dev, "info: shutdown mwifiex...\n");
 
-- 
1.8.1.2

