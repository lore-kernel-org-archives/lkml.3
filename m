Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab3DBXPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:15:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761342Ab3DBWMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:12:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Drake <dsd@laptop.org>, Marco Cesarano <marco@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, Amitkumar Karwar <akarwar@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 034/124] mwifiex: skip pending commands after function shutdown
Date: Tue,  2 Apr 2013 15:10:16 -0700
Message-Id: <20130402221108.120754164@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bing Zhao <bzhao@marvell.com>

commit a3e240cacc93a06bff3313e28938e980d01a2160 upstream.

During rmmod mwifiex_sdio processing FUNC_SHUTDOWN command is
sent to firmware. Firmware expcets only FUNC_INIT once WLAN
function is shut down.

Any command pending in the command queue should be ignored and
freed.

Tested-by: Daniel Drake <dsd@laptop.org>
Tested-by: Marco Cesarano <marco@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/cmdevt.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -156,6 +156,20 @@ static int mwifiex_dnld_cmd_to_fw(struct
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
@@ -167,9 +181,6 @@ static int mwifiex_dnld_cmd_to_fw(struct
 	adapter->curr_cmd = cmd_node;
 	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
-	cmd_code = le16_to_cpu(host_cmd->command);
-	cmd_size = le16_to_cpu(host_cmd->size);
-
 	/* Adjust skb length */
 	if (cmd_node->cmd_skb->len > cmd_size)
 		/*


