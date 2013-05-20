Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab3ETLDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:03:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56312 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab3ETKxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 083/115] net: qmi_wwan: fixup destination address (firmware bug workaround)
Date: Mon, 20 May 2013 11:51:23 +0100
Message-Id: <1369047116-9378-84-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

commit 6483bdc9d76fb98174797516a19d289eb837909e upstream.

Received packets are sometimes addressed to 00:a0:c6:00:00:00
instead of the address the device firmware should have learned
from the host:

321.224126 77.16.85.204 -> 148.122.171.134 ICMP 98 Echo (ping) request  id=0x4025, seq=64/16384, ttl=64

0000  82 c0 82 c9 f1 67 82 c0 82 c9 f1 67 08 00 45 00   .....g.....g..E.
0010  00 54 00 00 40 00 40 01 57 cc 4d 10 55 cc 94 7a   .T..@.@.W.M.U..z
0020  ab 86 08 00 62 fc 40 25 00 40 b2 bc 6e 51 00 00   ....b.@%.@..nQ..
0030  00 00 6b bd 09 00 00 00 00 00 10 11 12 13 14 15   ..k.............
0040  16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25   .......... !"#$%
0050  26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33 34 35   &'()*+,-./012345
0060  36 37                                             67

321.240607 148.122.171.134 -> 77.16.85.204 ICMP 98 Echo (ping) reply    id=0x4025, seq=64/16384, ttl=55

0000  00 a0 c6 00 00 00 02 50 f3 00 00 00 08 00 45 00   .......P......E.
0010  00 54 00 56 00 00 37 01 a0 76 94 7a ab 86 4d 10   .T.V..7..v.z..M.
0020  55 cc 00 00 6a fc 40 25 00 40 b2 bc 6e 51 00 00   U...j.@%.@..nQ..
0030  00 00 6b bd 09 00 00 00 00 00 10 11 12 13 14 15   ..k.............
0040  16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 25   .......... !"#$%
0050  26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33 34 35   &'()*+,-./012345
0060  36 37                                             67

The bogus address is always the same, and matches the address
suggested by many devices as a default address.  It is likely a
hardcoded firmware default.

The circumstances where this bug has been observed indicates that
the trigger is related to timing or some other factor the host
cannot control. Repeating the exact same configuration sequence
that caused it to trigger once, will not necessarily cause it to
trigger the next time. Reproducing the bug is therefore difficult.
This opens up a possibility that the bug is more common than we can
confirm, because affected devices often will work properly again
after a reset.  A procedure most users are likely to try out before
reporting a bug.

Unconditionally rewriting the destination address if the first digit
of the received packet is 0, is considered an acceptable compromise
since we already have to inspect this digit.  The simplification will
cause unnecessary rewrites if the real address starts with 0, but this
is still better than adding additional tests for this particular case.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/usb/qmi_wwan.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 953046c..83a2a14 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -190,6 +190,10 @@ err:
  * This means that this function will reliably add the appropriate
  * header iff necessary, provided our hardware address does not start
  * with 4 or 6.
+ *
+ * Another common firmware bug results in all packets being addressed
+ * to 00:a0:c6:00:00:00 despite the host address being different.
+ * This function will also fixup such packets.
  */
 static int qmi_wwan_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 {
@@ -206,6 +210,12 @@ static int qmi_wwan_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	case 0x60:
 		proto = htons(ETH_P_IPV6);
 		break;
+	case 0x00:
+		if (is_multicast_ether_addr(skb->data))
+			return 1;
+		/* possibly bogus destination - rewrite just in case */
+		skb_reset_mac_header(skb);
+		goto fix_dest;
 	default:
 		/* pass along other packets without modifications */
 		return 1;
@@ -216,6 +226,7 @@ static int qmi_wwan_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 	skb_reset_mac_header(skb);
 	eth_hdr(skb)->h_proto = proto;
 	memset(eth_hdr(skb)->h_source, 0, ETH_ALEN);
+fix_dest:
 	memcpy(eth_hdr(skb)->h_dest, dev->net->dev_addr, ETH_ALEN);
 	return 1;
 }
-- 
1.8.1.2

