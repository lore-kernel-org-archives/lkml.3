Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059Ab3LGROI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 12:14:08 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:42932 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab3LGROD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 12:14:03 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: Peter Stuge <peter@stuge.se>, "John W. Linville" <linville@tuxdriver.com>,
        ath9k-devel <ath9k-devel@venema.h4ckr.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: wirelesse: wcn36xx: pull allocation outside of critical
 section
In-Reply-To: <CAFSJ42YckTDO=UV=fWG9mmVXSBYep1x6xiHahzGDcrB4dy0oOQ@mail.gmail.com>
References: <1385744870-10164-1-git-send-email-mpn@google.com> <20131201004715.11125.qmail@stuge.se> <xa1tiov78kmp.fsf@mina86.com> <CAFSJ42YckTDO=UV=fWG9mmVXSBYep1x6xiHahzGDcrB4dy0oOQ@mail.gmail.com>
User-Agent: Notmuch/0.16+80~g81ee785 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Sat, 07 Dec 2013 18:13:58 +0100
Message-ID: <878uvw1t49.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This also simplifies flow-controll as there is now only one if
condition with a single branch.
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

On Thu, Dec 05 2013, Eugene Krasnikov <k.eugene.e@gmail.com> wrote:
> I think code will look neater if error case will be handled in "else"
> statement something like: [...]

How about the following:

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 823631c..ebab2db 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2056,22 +2056,24 @@ static void wcn36xx_smd_rsp_process(struct wcn36xx *wcn, void *buf, size_t len)
 	case WCN36XX_HAL_OTA_TX_COMPL_IND:
 	case WCN36XX_HAL_MISSED_BEACON_IND:
 	case WCN36XX_HAL_DELETE_STA_CONTEXT_IND:
-		mutex_lock(&wcn->hal_ind_mutex);
 		msg_ind = kmalloc(sizeof(*msg_ind), GFP_KERNEL);
-		if (msg_ind) {
-			msg_ind->msg_len = len;
-			msg_ind->msg = kmalloc(len, GFP_KERNEL);
-			memcpy(msg_ind->msg, buf, len);
-			list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
-			queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
-			wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
+		if (!msg_ind) {
+			/*
+			 * FIXME: Do something smarter then just
+			 * printing an error.
+			 */
+			wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
+				    msg_header->msg_type);
+			break;
 		}
+		mutex_lock(&wcn->hal_ind_mutex);
+		msg_ind->msg_len = len;
+		msg_ind->msg = kmalloc(len, GFP_KERNEL);
+		memcpy(msg_ind->msg, buf, len);
+		list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
+		queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);
+		wcn36xx_dbg(WCN36XX_DBG_HAL, "indication arrived\n");
 		mutex_unlock(&wcn->hal_ind_mutex);
-		if (msg_ind)
-			break;
-		/* FIXME: Do something smarter then just printing an error. */
-		wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
-			    msg_header->msg_type);
 		break;
 	default:
 		wcn36xx_err("SMD_EVENT (%d) not supported\n",
-- 
1.8.4

