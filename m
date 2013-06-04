Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab3FDXKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:10:52 -0400
Received: from 1wt.eu ([62.212.114.60]:35499 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab3FDWmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:31 -0400
Message-Id: <20130604172134.042467140@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:00 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?ISO-8859-15?q?Timo=20Ter=E4s?= <timo.teras@iki.fi>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Bork <tom@eisfair.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 090/184] r8169: remove the obsolete and incorrect AMD
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 workaround

From: =?latin1?q?Timo=20Ter=E4s?= <timo.teras@iki.fi>

[ Upstream commit 5d0feaff230c0abfe4a112e6f09f096ed99e0b2d ]

This was introduced in commit 6dccd16 "r8169: merge with version
6.001.00 of Realtek's r8169 driver". I did not find the version
6.001.00 online, but in 6.002.00 or any later r8169 from Realtek
this hunk is no longer present.

Also commit 05af214 "r8169: fix Ethernet Hangup for RTL8110SC
rev d" claims to have fixed this issue otherwise.

The magic compare mask of 0xfffe000 is dubious as it masks
parts of the Reserved part, and parts of the VLAN tag. But this
does not make much sense as the VLAN tag parts are perfectly
valid there. In matter of fact this seems to be triggered with
any VLAN tagged packet as RxVlanTag bit is matched. I would
suspect 0xfffe0000 was intended to test reserved part only.

Finally, this hunk is evil as it can cause more packets to be
handled than what was NAPI quota causing net/core/dev.c:
net_rx_action(): WARN_ON_ONCE(work > weight) to trigger, and
mess up the NAPI state causing device to hang.

As result, any system using VLANs and having high receive
traffic (so that NAPI poll budget limits rtl_rx) would result
in device hang.

Signed-off-by: Timo Teräs <timo.teras@iki.fi>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 3a42cce923b0242d0293cae0a162601afa89d552)
Cc: Thomas Bork <tom@eisfair.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/r8169.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 6197140..b22623d 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -4571,13 +4571,6 @@ static int rtl8169_rx_interrupt(struct net_device *dev,
 			dev->stats.rx_bytes += pkt_size;
 			dev->stats.rx_packets++;
 		}
-
-		/* Work around for AMD plateform. */
-		if ((desc->opts2 & cpu_to_le32(0xfffe000)) &&
-		    (tp->mac_version == RTL_GIGA_MAC_VER_05)) {
-			desc->opts2 = 0;
-			cur_rx++;
-		}
 	}
 
 	count = cur_rx - tp->cur_rx;
-- 
1.7.12.2.21.g234cd45.dirty



