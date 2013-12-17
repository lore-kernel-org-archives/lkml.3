Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3LQSN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 13:13:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60704 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab3LQSNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 13:13:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 006/103] 6lowpan: Uncompression of traffic class field was incorrect
Date: Tue, 17 Dec 2013 18:11:55 +0000
Message-Id: <1387304012-23805-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
References: <1387304012-23805-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.28 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jukka Rissanen <jukka.rissanen@linux.intel.com>

commit 1188f05497e7bd2f2614b99c54adfbe7413d5749 upstream.

If priority/traffic class field in IPv6 header is set (seen when
using ssh), the uncompression sets the TC and Flow fields incorrectly.

Example:

This is IPv6 header of a sent packet. Note the priority/TC (=1) in
the first byte.

00000000: 61 00 00 00 00 2c 06 40 fe 80 00 00 00 00 00 00
00000010: 02 02 72 ff fe c6 42 10 fe 80 00 00 00 00 00 00
00000020: 02 1e ab ff fe 4c 52 57

This gets compressed like this in the sending side

00000000: 72 31 04 06 02 1e ab ff fe 4c 52 57 ec c2 00 16
00000010: aa 2d fe 92 86 4e be c6 ....

In the receiving end, the packet gets uncompressed to this
IPv6 header

00000000: 60 06 06 02 00 2a 1e 40 fe 80 00 00 00 00 00 00
00000010: 02 02 72 ff fe c6 42 10 fe 80 00 00 00 00 00 00
00000020: ab ff fe 4c 52 57 ec c2

First four bytes are set incorrectly and we have also lost
two bytes from destination address.

The fix is to switch the case values in switch statement
when checking the TC field.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ieee802154/6lowpan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
index 32eb417..2dce3b7 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -818,7 +818,7 @@ lowpan_process_data(struct sk_buff *skb)
 	 * Traffic class carried in-line
 	 * ECN + DSCP (1 byte), Flow Label is elided
 	 */
-	case 1: /* 10b */
+	case 2: /* 10b */
 		if (!skb->len)
 			goto drop;
 		tmp = lowpan_fetch_skb_u8(skb);
@@ -831,7 +831,7 @@ lowpan_process_data(struct sk_buff *skb)
 	 * Flow Label carried in-line
 	 * ECN + 2-bit Pad + Flow Label (3 bytes), DSCP is elided
 	 */
-	case 2: /* 01b */
+	case 1: /* 01b */
 		if (!skb->len)
 			goto drop;
 		tmp = lowpan_fetch_skb_u8(skb);
-- 
1.8.3.2

