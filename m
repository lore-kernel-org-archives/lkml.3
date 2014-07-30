Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaG3MSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:18:08 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36803 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbaG3MPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Amitkumar Karwar <akarwar@marvell.com>,
        Maithili Hinge <maithili@marvell.com>,
        Avinash Patil <patila@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 59/94] mwifiex: fix Tx timeout issue
Date: Wed, 30 Jul 2014 14:14:48 +0200
Message-Id: <a113b6a577411ff322386e70b3c0f8637bd2ddc6.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amitkumar Karwar <akarwar@marvell.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d76744a93246eccdca1106037e8ee29debf48277 upstream.

https://bugzilla.kernel.org/show_bug.cgi?id=70191
https://bugzilla.kernel.org/show_bug.cgi?id=77581

It is observed that sometimes Tx packet is downloaded without
adding driver's txpd header. This results in firmware parsing
garbage data as packet length. Sometimes firmware is unable
to read the packet if length comes out as invalid. This stops
further traffic and timeout occurs.

The root cause is uninitialized fields in tx_info(skb->cb) of
packet used to get garbage values. In this case if
MWIFIEX_BUF_FLAG_REQUEUED_PKT flag is mistakenly set, txpd
header was skipped. This patch makes sure that tx_info is
correctly initialized to fix the problem.

Reported-by: Andrew Wiley <wiley.andrew.j@gmail.com>
Reported-by: Linus Gasser <list@markas-al-nour.org>
Reported-by: Michael Hirsch <hirsch@teufel.de>
Tested-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Maithili Hinge <maithili@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/mwifiex/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index c2b91f566e05..edf5239d93df 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -654,6 +654,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
+	memset(tx_info, 0, sizeof(*tx_info));
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
 
-- 
2.0.1

