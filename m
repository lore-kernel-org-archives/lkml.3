Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953Ab3CZSDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:03:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9615 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3CZRgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:04 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Wjw9aU-4INEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_34Hw5B3_qIA:10 a=zhf81SHlAAAA:8 a=J1Y8HTJGAAAA:8 a=yAcoP-ATsIItWhWqB8UA:9 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173602.671906380@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>,
        Francois Romieu <romieu@fr.zoreil.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 17/86] r8169: remove the obsolete and incorrect AMD workaround
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0017-r8169-remove-the-obsolete-and-incorrect-AMD-workarou.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>

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
---
 drivers/net/ethernet/realtek/r8169.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index df7bbba..6c1c396 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -6088,13 +6088,6 @@ process_pkt:
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
1.7.10.4


