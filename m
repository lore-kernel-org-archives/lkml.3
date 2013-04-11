Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936434Ab3DKVE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:04:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935737Ab3DKUtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:16 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=wcmGBiZDuZMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=ZAjoVRll-d8A:10 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=Op-mwl0xAAAA:8 a=vmLDa1wCAAAA:8 a=i5l3BeYsPBN1KbzBBJEA:9 a=9RRF0ttvEvMA:10 a=d4CUUju0HPYA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=2_WZD1659A0AaAsh:21 a=6-XEiyBeNNVP2N8t:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202602.492885462@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Drake <dsd@laptop.org>, Marco Cesarano <marco@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Amitkumar Karwar <akarwar@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 100/171 ] mwifiex: skip pending commands after function shutdown
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0100-mwifiex-skip-pending-commands-after-function-shutdow.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

[ Upstream commit a3e240cacc93a06bff3313e28938e980d01a2160 ]

During rmmod mwifiex_sdio processing FUNC_SHUTDOWN command is
sent to firmware. Firmware expcets only FUNC_INIT once WLAN
function is shut down.

Any command pending in the command queue should be ignored and
freed.

Cc: <stable@vger.kernel.org> # 3.8
Tested-by: Daniel Drake <dsd@laptop.org>
Tested-by: Marco Cesarano <marco@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/mwifiex/cmdevt.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index da50426..c65efd0 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -156,6 +156,20 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		return -1;
 	}
 
+	cmd_code = le16_to_cpu(host_cmd->command);
+	cmd_size = le16_to_cpu(host_cmd->size);
+
+	if (adapter->hw_status == MWIFIEX_HW_STATUS_RESET &&
+	    cmd_code != HostCmd_CMD_FUNC_SHUTDOWN &&
+	    cmd_code != HostCmd_CMD_FUNC_INIT) {
+		dev_err(adapter->dev,
+			"DNLD_CMD: FW in reset state, ignore cmd %#x\n",
+			cmd_code);
+		mwifiex_complete_cmd(adapter, cmd_node);
+		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+		return -1;
+	}
+
 	/* Set command sequence number */
 	adapter->seq_num++;
 	host_cmd->seq_num = cpu_to_le16(HostCmd_SET_SEQ_NO_BSS_INFO
@@ -167,9 +181,6 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	adapter->curr_cmd = cmd_node;
 	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
-	cmd_code = le16_to_cpu(host_cmd->command);
-	cmd_size = le16_to_cpu(host_cmd->size);
-
 	/* Adjust skb length */
 	if (cmd_node->cmd_skb->len > cmd_size)
 		/*
-- 
1.7.10.4


