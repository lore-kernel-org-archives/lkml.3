Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaECLte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:49:34 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:56633 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaECLtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:49:31 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 15/15] staging: rtl8188eu: Remove 'u8 *pbuf' from struct recv_buf
Date: Sat,  3 May 2014 17:15:32 +0530
Message-Id: <1399117532-8521-16-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
References: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using pbuf to pass sbk data pointer to usb_fill_bulk_urb(),
we can use precvbuf->pskb->data to do that.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c |    5 +----
 drivers/staging/rtl8188eu/include/rtw_recv.h  |    1 -
 drivers/staging/rtl8188eu/os_dep/recv_linux.c |    1 -
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index d3c5ed3..d8fc747 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -612,10 +612,7 @@ static u32 usb_read_port(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *rmem)
 		tmpaddr = (size_t)precvbuf->pskb->data;
 		alignment = tmpaddr & (RECVBUFF_ALIGN_SZ-1);
 		skb_reserve(precvbuf->pskb, (RECVBUFF_ALIGN_SZ - alignment));
-
-		precvbuf->pbuf = precvbuf->pskb->data;
 	} else { /* reuse skb */
-		precvbuf->pbuf = precvbuf->pskb->data;
 		precvbuf->reuse = false;
 	}
 
@@ -627,7 +624,7 @@ static u32 usb_read_port(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *rmem)
 	pipe = ffaddr2pipehdl(pdvobj, addr);
 
 	usb_fill_bulk_urb(purb, pusbd, pipe,
-			  precvbuf->pbuf,
+			  precvbuf->pskb->data,
 			  MAX_RECVBUF_SZ,
 			  usb_read_port_complete,
 			  precvbuf);/* context is precvbuf */
diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index 8dadf30..971dd16 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -236,7 +236,6 @@ struct sta_recv_priv {
 
 struct recv_buf {
 	struct adapter *adapter;
-	u8	*pbuf;
 	struct urb *purb;
 	struct sk_buff *pskb;
 	u8	reuse;
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index c1664b7..29ec014 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -60,7 +60,6 @@ int rtw_os_recvbuf_resource_alloc(struct adapter *padapter,
 		res = _FAIL;
 	precvbuf->pskb = NULL;
 	precvbuf->reuse = false;
-	precvbuf->pbuf = NULL;
 	return res;
 }
 
-- 
1.7.10.4

