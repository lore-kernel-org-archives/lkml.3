Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139AbaHJOsW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 10:48:22 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:44091 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaHJOsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 10:48:18 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 20/22] staging: rtl8188eu: rtw_iol.c: Remove unused functions
Date: Sun, 10 Aug 2014 20:14:33 +0530
Message-Id: <1407681875-2611-20-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
References: <1407681875-2611-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_iol.c    |   63 ---------------------------
 drivers/staging/rtl8188eu/include/rtw_iol.h |   18 --------
 2 files changed, 81 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_iol.c b/drivers/staging/rtl8188eu/core/rtw_iol.c
index 7281bb6..cdcf0ea 100644
--- a/drivers/staging/rtl8188eu/core/rtw_iol.c
+++ b/drivers/staging/rtl8188eu/core/rtw_iol.c
@@ -20,29 +20,6 @@
 
 #include<rtw_iol.h>
 
-int rtw_IOL_append_cmds(struct xmit_frame *xmit_frame, u8 *IOL_cmds, u32 cmd_len)
-{
-	struct pkt_attrib	*pattrib = &xmit_frame->attrib;
-	u16 buf_offset;
-	u32 ori_len;
-
-	buf_offset = TXDESC_OFFSET;
-	ori_len = buf_offset+pattrib->pktlen;
-
-	/* check if the io_buf can accommodate new cmds */
-	if (ori_len + cmd_len + 8 > MAX_XMITBUF_SZ) {
-		DBG_88E("%s %u is large than MAX_XMITBUF_SZ:%u, can't accommodate new cmds\n",
-			__func__ , ori_len + cmd_len + 8, MAX_XMITBUF_SZ);
-		return _FAIL;
-	}
-
-	memcpy(xmit_frame->buf_addr + buf_offset + pattrib->pktlen, IOL_cmds, cmd_len);
-	pattrib->pktlen += cmd_len;
-	pattrib->last_txcmdsz += cmd_len;
-
-	return _SUCCESS;
-}
-
 bool rtw_IOL_applied(struct adapter  *adapter)
 {
 	if (1 == adapter->registrypriv.fw_iol)
@@ -52,43 +29,3 @@ bool rtw_IOL_applied(struct adapter  *adapter)
 		return true;
 	return false;
 }
-
-int rtw_IOL_append_LLT_cmd(struct xmit_frame *xmit_frame, u8 page_boundary)
-{
-	return _SUCCESS;
-}
-
-int _rtw_IOL_append_WB_cmd(struct xmit_frame *xmit_frame, u16 addr, u8 value, u8 mask)
-{
-	struct ioreg_cfg cmd = {8, IOREG_CMD_WB_REG, 0x0, 0x0, 0x0};
-
-	cmd.address = cpu_to_le16(addr);
-	cmd.data = cpu_to_le32(value);
-
-	if (mask != 0xFF) {
-		cmd.length = 12;
-		cmd.mask = cpu_to_le32(mask);
-	}
-	return rtw_IOL_append_cmds(xmit_frame, (u8 *)&cmd, cmd.length);
-}
-
-int _rtw_IOL_append_WRF_cmd(struct xmit_frame *xmit_frame, u8 rf_path, u16 addr, u32 value, u32 mask)
-{
-	struct ioreg_cfg cmd = {8, IOREG_CMD_W_RF, 0x0, 0x0, 0x0};
-
-	cmd.address = cpu_to_le16((rf_path<<8) | ((addr) & 0xFF));
-	cmd.data = cpu_to_le32(value);
-
-	if (mask != 0x000FFFFF) {
-		cmd.length = 12;
-		cmd.mask =  cpu_to_le32(mask);
-	}
-	return rtw_IOL_append_cmds(xmit_frame, (u8 *)&cmd, cmd.length);
-}
-
-int rtw_IOL_append_END_cmd(struct xmit_frame *xmit_frame)
-{
-	struct ioreg_cfg cmd = {4, IOREG_CMD_END, cpu_to_le16(0xFFFF), cpu_to_le32(0xFF), 0x0};
-
-	return rtw_IOL_append_cmds(xmit_frame, (u8 *)&cmd, 4);
-}
diff --git a/drivers/staging/rtl8188eu/include/rtw_iol.h b/drivers/staging/rtl8188eu/include/rtw_iol.h
index 193f2eb..8ebdddb 100644
--- a/drivers/staging/rtl8188eu/include/rtw_iol.h
+++ b/drivers/staging/rtl8188eu/include/rtw_iol.h
@@ -46,24 +46,6 @@ enum ioreg_cmd {
 	IOREG_CMD_END		= 0xFF,
 };
 
-int rtw_IOL_append_cmds(struct xmit_frame *xmit_frame, u8 *IOL_cmds,
-			u32 cmd_len);
-int rtw_IOL_append_LLT_cmd(struct xmit_frame *xmit_frame, u8 page_boundary);
 bool rtw_IOL_applied(struct adapter  *adapter);
-int rtw_IOL_append_END_cmd(struct xmit_frame *xmit_frame);
-
-void read_efuse_from_txpktbuf(struct adapter *adapter, int bcnhead,
-			      u8 *content, u16 *size);
-
-int _rtw_IOL_append_WB_cmd(struct xmit_frame *xmit_frame, u16 addr,
-			   u8 value, u8 mask);
-int _rtw_IOL_append_WRF_cmd(struct xmit_frame *xmit_frame, u8 rf_path,
-			    u16 addr, u32 value, u32 mask);
-#define rtw_IOL_append_WB_cmd(xmit_frame, addr, value, mask)		\
-	_rtw_IOL_append_WB_cmd((xmit_frame), (addr), (value) , (mask))
-#define rtw_IOL_append_WW_cmd(xmit_frame, addr, value, mask)		\
-	_rtw_IOL_append_WW_cmd((xmit_frame), (addr), (value), (mask))
-#define rtw_IOL_append_WRF_cmd(xmit_frame, rf_path, addr, value, mask)	\
-	_rtw_IOL_append_WRF_cmd((xmit_frame), (rf_path), (addr), (value), (mask))
 
 #endif /* __RTW_IOL_H_ */
-- 
1.7.10.4

