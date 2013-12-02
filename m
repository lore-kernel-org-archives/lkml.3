Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3LBNJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:09:41 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:39746 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3LBNJi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:09:38 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Peter Stuge <peter@stuge.se>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>, ath9k-devel@venema.h4ckr.net,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2] net: wireless: wcn36xx: fix potential NULL pointer dereference
In-Reply-To: <20131201004715.11125.qmail@stuge.se>
Organization: http://mina86.com/
References: <1385744870-10164-1-git-send-email-mpn@google.com> <20131201004715.11125.qmail@stuge.se>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131202:linux-wireless@vger.kernel.org::fPOaWaFLuszLroLQ:00000000000000000000000000000000g84
X-Hashcash: 1:20:131202:k.eugene.e@gmail.com::ZYeQteAweS3n4tSx:000000000000000000000000000000000000000002gbi
X-Hashcash: 1:20:131202:linux-kernel@vger.kernel.org::YHj6NoqBdWTjQ0jp:0000000000000000000000000000000002YRA
X-Hashcash: 1:20:131202:peter@stuge.se::RG3unx/5EAyVhF0B:0004SxM
X-Hashcash: 1:20:131202:ath9k-devel@lists.ath9k.org::NJ7Dy7lMEVV1T9j9:00000000000000000000000000000000007NxH
X-Hashcash: 1:20:131202:linville@tuxdriver.com::u6QrCTDW3ezLwDHn:000000000000000000000000000000000000000B0mE
Date: Mon, 02 Dec 2013 14:09:34 +0100
Message-ID: <xa1tiov78kmp.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If kmalloc fails wcn36xx_smd_rsp_process will attempt to dereference
a NULL pointer.  There might be a better error recovery then just
printing an error, but printing an error message is better then the
current behaviour.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

On Sun, Dec 01 2013, Peter Stuge wrote:
> Michal Nazarewicz wrote:
>> +			wcn36xx_err("Run out of memory while hnadling SMD_EVENT (%d)\n",
>> +				    msg_header->msg_type);
>
> Typo hnadling.

Fixed.

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index de9eb2c..3663394 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2041,13 +2041,20 @@ static void wcn36xx_smd_rsp_process(struct wcn36xx *wcn, void *buf, size_t len)
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
+		if (msg_ind)
+			break;
+		/* FIXME: Do something smarter then just printing an error. */
+		wcn36xx_err("Run out of memory while handling SMD_EVENT (%d)\n",
+			    msg_header->msg_type);
 		break;
 	default:
 		wcn36xx_err("SMD_EVENT (%d) not supported\n",
-- 
1.8.4.1

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
