Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab3LRVg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:36:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3LRVN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 051/118] ath9k: fix duration calculation for non-aggregated packets
Date: Wed, 18 Dec 2013 13:11:28 -0800
Message-Id: <20131218211220.913915648@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit bbf807bc0697e577c137a5fffb30fca7c6a45da1 upstream.

When not aggregating packets, fi->framelen should be passed in as length
to calculate the duration. Before the tx path rework, ath_tx_fill_desc
was called for either one aggregate, or one single frame, with the
length of the packet or the aggregate as a parameter.
After the rework, ath_tx_sched_aggr can pass a burst of single frames to
ath_tx_fill_desc and sets len=0.
Fix broken duration calculation by overriding the length in ath_tx_fill_desc
before passing it to ath_buf_set_rate.

Reported-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/xmit.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1275,6 +1275,10 @@ static void ath_tx_fill_desc(struct ath_
 				if (!rts_thresh || (len > rts_thresh))
 					rts = true;
 			}
+
+			if (!aggr)
+				len = fi->framelen;
+
 			ath_buf_set_rate(sc, bf, &info, len, rts);
 		}
 


