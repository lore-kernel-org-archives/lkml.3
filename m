Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaFVIwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:52:54 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:40134 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaFVIwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:52:50 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 37/42] staging: rtl8188eu: Use round_up() instead of _RND4()
Date: Sun, 22 Jun 2014 14:21:41 +0530
Message-Id: <1403427107-12744-9-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
References: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c          |    2 +-
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c    |    4 ++--
 drivers/staging/rtl8188eu/include/osdep_service.h |    8 --------
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c  |    2 +-
 4 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index a292c5d..343a6ca 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -324,7 +324,7 @@ _next:
 
 		pcmdpriv->cmd_issued_cnt++;
 
-		pcmd->cmdsz = _RND4((pcmd->cmdsz));/* _RND4 */
+		pcmd->cmdsz = round_up(pcmd->cmdsz, 4);
 
 		memcpy(pcmdbuf, pcmd->parmbuf, pcmd->cmdsz);
 
diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
index 8543847..902bbe0 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
@@ -544,7 +544,7 @@ s32 rtl8188eu_xmitframe_complete(struct adapter *adapt, struct xmit_priv *pxmitp
 
 		len = xmitframe_need_length(pxmitframe) + TXDESC_SIZE + (pxmitframe->pkt_offset*PACKET_OFFSET_SZ);
 
-		if (_RND8(pbuf + len) > MAX_XMITBUF_SZ) {
+		if (round_up(pbuf + len, 8) > MAX_XMITBUF_SZ) {
 			pxmitframe->agg_num = 1;
 			pxmitframe->pkt_offset = 1;
 			break;
@@ -567,7 +567,7 @@ s32 rtl8188eu_xmitframe_complete(struct adapter *adapt, struct xmit_priv *pxmitp
 
 		/*  handle pointer and stop condition */
 		pbuf_tail = pbuf + len;
-		pbuf = _RND8(pbuf_tail);
+		pbuf = round_up(pbuf_tail, 8);
 
 		pfirstframe->agg_num++;
 		if (MAX_TX_AGG_PACKET_NUMBER == pfirstframe->agg_num)
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 927b30b..913cbfe 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -181,14 +181,6 @@ static inline void flush_signals_thread(void)
 #define _RND(sz, r) ((((sz)+((r)-1))/(r))*(r))
 #define RND4(x)	(((x >> 2) + (((x & 3) == 0) ?  0 : 1)) << 2)
 
-static inline u32 _RND4(u32 sz)
-{
-	u32	val;
-
-	val = ((sz >> 2) + ((sz & 3) ? 1 : 0)) << 2;
-	return val;
-}
-
 struct rtw_netdev_priv_indicator {
 	void *priv;
 	u32 sizeof_priv;
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
index eddff41..ba1e178 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
@@ -163,7 +163,7 @@ static int recvbuf2recvframe(struct adapter *adapt, struct sk_buff *pskb)
 			pkt_offset = (u16) round_up(pkt_offset, 128);
 			break;
 		case USB_RX_AGG_USB:
-			pkt_offset = (u16)_RND4(pkt_offset);
+			pkt_offset = (u16) round_up(pkt_offset, 4);
 			break;
 		case USB_RX_AGG_DISABLE:
 		default:
-- 
1.7.10.4

