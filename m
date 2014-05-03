Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303AbaECLsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:48:23 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64403 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaECLsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:48:20 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 09/15] staging: rtl8188eu: Remove 'irp_pending' from struct recv_buf
Date: Sat,  3 May 2014 17:15:26 +0530
Message-Id: <1399117532-8521-10-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
References: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

irp_pending is initialized to false inside rtw_os_recvbuf_resource_alloc()
and value of irq_pending never changed after that, so 'if (!precvbuf->irp_pending)'
inside rtw_os_read_port() function will be always true.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_recv.h  |    1 -
 drivers/staging/rtl8188eu/os_dep/recv_linux.c |    6 ++----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index 8d3424b..987445a 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -242,7 +242,6 @@ struct recv_buf {
 	u32	len;
 	struct urb *purb;
 	u32 alloc_sz;
-	u8  irp_pending;
 	struct sk_buff *pskb;
 	u8	reuse;
 };
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index 99b5910..7f9b654 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -55,7 +55,6 @@ int rtw_os_recvbuf_resource_alloc(struct adapter *padapter,
 {
 	int res = _SUCCESS;
 
-	precvbuf->irp_pending = false;
 	precvbuf->purb = usb_alloc_urb(0, GFP_KERNEL);
 	if (precvbuf->purb == NULL)
 		res = _FAIL;
@@ -229,9 +228,8 @@ void rtw_os_read_port(struct adapter *padapter, struct recv_buf *precvbuf)
 	dev_kfree_skb_any(precvbuf->pskb);
 	precvbuf->pskb = NULL;
 	precvbuf->reuse = false;
-	if (!precvbuf->irp_pending)
-		rtw_read_port(padapter, precvpriv->ff_hwaddr, 0,
-			      (unsigned char *)precvbuf);
+	rtw_read_port(padapter, precvpriv->ff_hwaddr, 0,
+			(unsigned char *)precvbuf);
 }
 
 static void _rtw_reordering_ctrl_timeout_handler(void *func_context)
-- 
1.7.10.4

