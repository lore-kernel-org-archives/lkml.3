Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937419Ab3DJWsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:48:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937394Ab3DJWrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Drake <dsd@laptop.org>, Marco Cesarano <marco@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Amitkumar Karwar <akarwar@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 63/64] mwifiex: complete last internal scan
Date: Wed, 10 Apr 2013 15:47:00 -0700
Message-Id: <20130410224348.336064034@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit 21de979ecfc7b7f9442f8aea9a54b3ab670d0151 upstream.

We are waiting on first scan command of internal scan request
before association, so we should complete on last internal scan
command response.

Tested-by: Daniel Drake <dsd@laptop.org>
Tested-by: Marco Cesarano <marco@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/scan.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1371,8 +1371,10 @@ int mwifiex_scan_networks(struct mwifiex
 			queue_work(adapter->workqueue, &adapter->main_work);
 
 			/* Perform internal scan synchronously */
-			if (!priv->scan_request)
+			if (!priv->scan_request) {
+				dev_dbg(adapter->dev, "wait internal scan\n");
 				mwifiex_wait_queue_complete(adapter, cmd_node);
+			}
 		} else {
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 					       flags);
@@ -1768,7 +1770,12 @@ check_next_scan:
 		/* Need to indicate IOCTL complete */
 		if (adapter->curr_cmd->wait_q_enabled) {
 			adapter->cmd_wait_q.status = 0;
-			mwifiex_complete_cmd(adapter, adapter->curr_cmd);
+			if (!priv->scan_request) {
+				dev_dbg(adapter->dev,
+					"complete internal scan\n");
+				mwifiex_complete_cmd(adapter,
+						     adapter->curr_cmd);
+			}
 		}
 		if (priv->report_scan_result)
 			priv->report_scan_result = false;


