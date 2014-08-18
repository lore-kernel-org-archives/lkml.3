Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbaHRJde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:33:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42394 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaHRJd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Maithili Hinge <maithili@marvell.com>,
        Avinash Patil <patila@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 002/137] mwifiex: fix Tx timeout issue
Date: Mon, 18 Aug 2014 10:31:03 +0100
Message-Id: <1408354398-10226-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amitkumar Karwar <akarwar@marvell.com>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 02cc93b673c1..29cadf29af78 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -603,6 +603,7 @@ mwifiex_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
+	memset(tx_info, 0, sizeof(*tx_info));
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
 
-- 
1.9.1

