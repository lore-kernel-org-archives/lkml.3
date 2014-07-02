Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbaGBQyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:54:04 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33314 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbaGBQyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:54:01 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 37/48] staging: rtl8188eu: Remove members cmd_[allocated,]_buf from struct cmd_priv
Date: Wed,  2 Jul 2014 22:17:33 +0530
Message-Id: <1404319664-8327-37-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
References: <1404319664-8327-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_cmd.c    |   32 ++-------------------------
 drivers/staging/rtl8188eu/include/rtw_cmd.h |    2 --
 2 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 199bbae..817f459 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -32,39 +32,18 @@ No irqsave is necessary.
 
 int rtw_init_cmd_priv(struct cmd_priv *pcmdpriv)
 {
-	int res = _SUCCESS;
-
-
 	sema_init(&(pcmdpriv->cmd_queue_sema), 0);
-	/* sema_init(&(pcmdpriv->cmd_done_sema), 0); */
 	sema_init(&(pcmdpriv->terminate_cmdthread_sema), 0);
 
-
 	_rtw_init_queue(&(pcmdpriv->cmd_queue));
 
-	/* allocate DMA-able/Non-Page memory for cmd_buf and rsp_buf */
-
 	pcmdpriv->cmd_seq = 1;
-
-	pcmdpriv->cmd_allocated_buf = kzalloc(MAX_CMDSZ + CMDBUFF_ALIGN_SZ, GFP_KERNEL);
-
-	if (pcmdpriv->cmd_allocated_buf == NULL) {
-		res = _FAIL;
-		goto exit;
-	}
-
-	pcmdpriv->cmd_buf = pcmdpriv->cmd_allocated_buf  +  CMDBUFF_ALIGN_SZ - ((size_t)(pcmdpriv->cmd_allocated_buf) & (CMDBUFF_ALIGN_SZ-1));
-
-exit:
-	return res;
+	return _SUCCESS;
 }
 
 void rtw_free_cmd_priv(struct cmd_priv *pcmdpriv)
 {
 
-	if (pcmdpriv) {
-		kfree(pcmdpriv->cmd_allocated_buf);
-	}
 }
 
 /*
@@ -192,7 +171,6 @@ int rtw_cmd_thread(void *context)
 {
 	u8 ret;
 	struct cmd_obj *pcmd;
-	u8 *pcmdbuf;
 	u8 (*cmd_hdl)(struct adapter *padapter, u8 *pbuf);
 	void (*pcmd_callback)(struct adapter *dev, struct cmd_obj *pcmd);
 	struct adapter *padapter = (struct adapter *)context;
@@ -200,8 +178,6 @@ int rtw_cmd_thread(void *context)
 
 	allow_signal(SIGTERM);
 
-	pcmdbuf = pcmdpriv->cmd_buf;
-
 	pcmdpriv->cmdthd_running = true;
 	up(&pcmdpriv->terminate_cmdthread_sema);
 
@@ -234,15 +210,11 @@ _next:
 			goto post_process;
 		}
 
-		pcmd->cmdsz = round_up(pcmd->cmdsz, 4);
-
-		memcpy(pcmdbuf, pcmd->parmbuf, pcmd->cmdsz);
-
 		if (pcmd->cmdcode < ARRAY_SIZE(wlancmds)) {
 			cmd_hdl = wlancmds[pcmd->cmdcode].h2cfuns;
 
 			if (cmd_hdl) {
-				ret = cmd_hdl(pcmd->padapter, pcmdbuf);
+				ret = cmd_hdl(pcmd->padapter, pcmd->parmbuf);
 				pcmd->res = ret;
 			}
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_cmd.h b/drivers/staging/rtl8188eu/include/rtw_cmd.h
index d881710..08b371d 100644
--- a/drivers/staging/rtl8188eu/include/rtw_cmd.h
+++ b/drivers/staging/rtl8188eu/include/rtw_cmd.h
@@ -48,8 +48,6 @@ struct cmd_priv {
 	struct semaphore terminate_cmdthread_sema;
 	struct __queue cmd_queue;
 	u8	cmd_seq;
-	u8	*cmd_buf;	/* shall be non-paged, and 4 bytes aligned */
-	u8	*cmd_allocated_buf;
 	u8 cmdthd_running;
 	struct adapter *padapter;
 };
-- 
1.7.10.4

