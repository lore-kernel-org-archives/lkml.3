Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601Ab3K2RIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:08:00 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44826 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3K2RH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:07:59 -0500
From: Michal Nazarewicz <mpn@google.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: wcn36xx: fix potential NULL pointer dereference
Date: Fri, 29 Nov 2013 18:07:50 +0100
Message-Id: <1385744870-10164-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

If kmalloc fails wcn36xx_smd_rsp_process will attempt to dereference
a NULL pointer.  There might be a better error recovery then just
printing an error, but printing an error message is better then the
current behaviour.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index de9eb2c..10d6ae9 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2041,13 +2041,23 @@ static void wcn36xx_smd_rsp_process(struct wcn36xx *wcn, void *buf, size_t len)
 	case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
 		mutex_lock(&wcn->hal_ind_mutex);
 		msg_ind = kmalloc(sizeof(*msg_ind), GFP_KERNEL);
-		msg_ind->msg_len = len;
-		msg_ind->msg = kmalloc(len, GFP_KERNEL);
-		memcpy(msg_ind->msg, buf, len);
-		list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
-		queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
-		wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
+		if (msg_ind) {
+			msg_ind->msg_len = len;
+			msg_ind->msg = kmalloc(len, GFP_KERNEL);
+			memcpy(msg_ind->msg, buf, len);
+			list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
+			queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
+			wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
+		}
 		mutex_unlock(&wcn->hal_ind_mutex);
+		if (!msg_ind) {
+			/*
+			 * FIXME: Do something smarter then just
+			 * printing an error when allocation fails.
+			 */
+			wcn36xx_err("Run out of memory while hnadling SMD_EVENT (%d)\n",
+				    msg_header->msg_type);
+		}
 		break;
 	default:
 		wcn36xx_err("SMD_EVENT (%d) not supported\n",
-- 
1.8.4.1

