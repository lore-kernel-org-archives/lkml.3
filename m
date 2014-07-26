Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbaGZUCD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:02:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaGZUBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 16:01:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Wiley <wiley.andrew.j@gmail.com>,
        Linus Gasser <list@markas-al-nour.org>,
        Michael Hirsch <hirsch@teufel.de>, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Maithili Hinge <maithili@marvell.com>,
        Avinash Patil <patila@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.15 081/109] mwifiex: fix Tx timeout issue
Date: Sat, 26 Jul 2014 12:02:43 -0700
Message-Id: <20140726190226.306387228@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -647,6 +647,7 @@ mwifiex_hard_start_xmit(struct sk_buff *
 	}
 
 	tx_info = MWIFIEX_SKB_TXCB(skb);
+	memset(tx_info, 0, sizeof(*tx_info));
 	tx_info->bss_num = priv->bss_num;
 	tx_info->bss_type = priv->bss_type;
 	tx_info->pkt_len = skb->len;


