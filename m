Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab3DBXPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:15:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761509Ab3DBWMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marco Cesarano <marco@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 035/124] mwifiex: cancel cmd timer and free curr_cmd in shutdown process
Date: Tue,  2 Apr 2013 15:10:17 -0700
Message-Id: <20130402221108.252136282@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/init.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -707,6 +707,14 @@ mwifiex_shutdown_drv(struct mwifiex_adap
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
 


