Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934470Ab3BSTC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:02:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54417 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933518Ab3BSSxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:53:23 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 53/81] r8169: remove the obsolete and incorrect AMD workaround
Date: Tue, 19 Feb 2013 15:49:16 -0300
Message-Id: <1361299784-8830-54-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>

commit 5d0feaff230c0abfe4a112e6f09f096ed99e0b2d upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/realtek/r8169.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 0e09bb8..67f73ae 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5812,13 +5812,6 @@ process_pkt:
 			tp->rx_stats.bytes += pkt_size;
 			u64_stats_update_end(&tp->rx_stats.syncp);
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
1.7.9.5

