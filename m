Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161251Ab3LFWCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:02:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759440Ab3LFVyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:54:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 05/32] 6lowpan: Uncompression of traffic class field was incorrect
Date: Fri,  6 Dec 2013 13:52:15 -0800
Message-Id: <20131206214957.344479698@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214956.830407026@linuxfoundation.org>
References: <20131206214956.830407026@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jukka Rissanen <jukka.rissanen@linux.intel.com>

[ Upstream commit 1188f05497e7bd2f2614b99c54adfbe7413d5749 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/6lowpan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -803,7 +803,7 @@ lowpan_process_data(struct sk_buff *skb)
 	 * Traffic class carried in-line
 	 * ECN + DSCP (1 byte), Flow Label is elided
 	 */
-	case 1: /* 10b */
+	case 2: /* 10b */
 		if (!skb->len)
 			goto drop;
 		tmp = lowpan_fetch_skb_u8(skb);
@@ -816,7 +816,7 @@ lowpan_process_data(struct sk_buff *skb)
 	 * Flow Label carried in-line
 	 * ECN + 2-bit Pad + Flow Label (3 bytes), DSCP is elided
 	 */
-	case 2: /* 01b */
+	case 1: /* 01b */
 		if (!skb->len)
 			goto drop;
 		tmp = lowpan_fetch_skb_u8(skb);


