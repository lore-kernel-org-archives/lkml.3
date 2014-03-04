Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbaCDHOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:14:45 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:56391 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbaCDHNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:13:10 -0500
From: Axel Rasmussen <axel.rasmussen1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 6/9] drivers: staging: rtl8187se: fixed broken indentation
Date: Tue,  4 Mar 2014 00:12:54 -0700
Message-Id: <ea7e76e3eeb570d0e64f8e629ba39431cf0d6ac0.1393916553.git.axel.rasmussen1@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393916553.git.axel.rasmussen1@gmail.com>
References: <cover.1393916553.git.axel.rasmussen1@gmail.com>
In-Reply-To: <cover.1393916553.git.axel.rasmussen1@gmail.com>
References: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com> <cover.1393916553.git.axel.rasmussen1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A section of code in the function rtl8180_tx was indented for no reason,
causing numerous checkpatch.pl warnings.

Signed-off-by: Axel Rasmussen <axel.rasmussen1@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c | 132 +++++++++++++++++----------------
 1 file changed, 69 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index fc0b6d3..d29a6d9 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1750,74 +1750,80 @@ short rtl8180_tx(struct net_device *dev, u8 *txbuf, int len, int priority,
 		break;
 	}
 
-		memcpy(&dest, frag_hdr->addr1, ETH_ALEN);
-		if (is_multicast_ether_addr(dest)) {
-			Duration = 0;
-			RtsDur = 0;
-			bRTSEnable = 0;
+	memcpy(&dest, frag_hdr->addr1, ETH_ALEN);
+	if (is_multicast_ether_addr(dest)) {
+		Duration = 0;
+		RtsDur = 0;
+		bRTSEnable = 0;
+		bCTSEnable = 0;
+
+		ThisFrameTime = ComputeTxTime(len + sCrcLng,
+			rtl8180_rate2rate(rate), 0, bUseShortPreamble);
+		TxDescDuration = ThisFrameTime;
+	} else { /* Unicast packet */
+		u16 AckTime;
+
+		/* YJ,add,080828,for Keep alive */
+		priv->NumTxUnicast++;
+
+		/* Figure out ACK rate according to BSS basic rate
+		 * and Tx rate.
+		 * AckCTSLng = 14 use 1M bps send
+		 */
+		AckTime = ComputeTxTime(14, 10, 0, 0);
+
+		if (((len + sCrcLng) > priv->rts) && priv->rts) { /* RTS/CTS. */
+			u16 RtsTime, CtsTime;
+			/* u16 CtsRate; */
+			bRTSEnable = 1;
 			bCTSEnable = 0;
 
-			ThisFrameTime = ComputeTxTime(len + sCrcLng, rtl8180_rate2rate(rate),
-						      0, bUseShortPreamble);
-			TxDescDuration = ThisFrameTime;
-		} else { /* Unicast packet */
-			u16 AckTime;
-
-			/* YJ,add,080828,for Keep alive */
-			priv->NumTxUnicast++;
-
-			/* Figure out ACK rate according to BSS basic rate
-			 * and Tx rate. */
-			AckTime = ComputeTxTime(14, 10, 0, 0);	/* AckCTSLng = 14 use 1M bps send */
-
-			if (((len + sCrcLng) > priv->rts) && priv->rts) { /* RTS/CTS. */
-				u16 RtsTime, CtsTime;
-				/* u16 CtsRate; */
-				bRTSEnable = 1;
-				bCTSEnable = 0;
-
-				/* Rate and time required for RTS. */
-				RtsTime = ComputeTxTime(sAckCtsLng/8, priv->ieee80211->basic_rate, 0, 0);
-				/* Rate and time required for CTS. */
-				CtsTime = ComputeTxTime(14, 10, 0, 0);	/* AckCTSLng = 14 use 1M bps send */
-
-				/* Figure out time required to transmit this frame. */
-				ThisFrameTime = ComputeTxTime(len + sCrcLng,
-						rtl8180_rate2rate(rate),
-						0,
-						bUseShortPreamble);
-
-				/* RTS-CTS-ThisFrame-ACK. */
-				RtsDur = CtsTime + ThisFrameTime + AckTime + 3*aSifsTime;
-
-				TxDescDuration = RtsTime + RtsDur;
-			} else { /* Normal case. */
-				bCTSEnable = 0;
-				bRTSEnable = 0;
-				RtsDur = 0;
-
-				ThisFrameTime = ComputeTxTime(len + sCrcLng, rtl8180_rate2rate(rate),
-							      0, bUseShortPreamble);
-				TxDescDuration = ThisFrameTime + aSifsTime + AckTime;
-			}
+			/* Rate and time required for RTS. */
+			RtsTime = ComputeTxTime(sAckCtsLng / 8,
+				priv->ieee80211->basic_rate, 0, 0);
 
-			if (!(frag_hdr->frame_control & IEEE80211_FCTL_MOREFRAGS)) {
-				/* ThisFrame-ACK. */
-				Duration = aSifsTime + AckTime;
-			} else { /* One or more fragments remained. */
-				u16 NextFragTime;
-				NextFragTime = ComputeTxTime(len + sCrcLng, /* pretend following packet length equal current packet */
-						rtl8180_rate2rate(rate),
-						0,
-						bUseShortPreamble);
-
-				/* ThisFrag-ACk-NextFrag-ACK. */
-				Duration = NextFragTime + 3*aSifsTime + 2*AckTime;
-			}
+			/* Rate and time required for CTS.
+			 * AckCTSLng = 14 use 1M bps send
+			 */
+			CtsTime = ComputeTxTime(14, 10, 0, 0);
+
+			/* Figure out time required to transmit this frame. */
+			ThisFrameTime = ComputeTxTime(len + sCrcLng,
+				rtl8180_rate2rate(rate), 0,
+				bUseShortPreamble);
+
+			/* RTS-CTS-ThisFrame-ACK. */
+			RtsDur = CtsTime + ThisFrameTime +
+				AckTime + 3 * aSifsTime;
+
+			TxDescDuration = RtsTime + RtsDur;
+		} else { /* Normal case. */
+			bCTSEnable = 0;
+			bRTSEnable = 0;
+			RtsDur = 0;
+
+			ThisFrameTime = ComputeTxTime(len + sCrcLng,
+				rtl8180_rate2rate(rate), 0, bUseShortPreamble);
+			TxDescDuration = ThisFrameTime + aSifsTime + AckTime;
+		}
+
+		if (!(frag_hdr->frame_control & IEEE80211_FCTL_MOREFRAGS)) {
+			/* ThisFrame-ACK. */
+			Duration = aSifsTime + AckTime;
+		} else { /* One or more fragments remained. */
+			u16 NextFragTime;
+
+			/* pretend following packet length = current packet */
+			NextFragTime = ComputeTxTime(len + sCrcLng,
+				rtl8180_rate2rate(rate), 0, bUseShortPreamble);
+
+			/* ThisFrag-ACk-NextFrag-ACK. */
+			Duration = NextFragTime + 3 * aSifsTime + 2 * AckTime;
+		}
 
-		} /* End of Unicast packet */
+	} /* End of Unicast packet */
 
-		frag_hdr->duration_id = Duration;
+	frag_hdr->duration_id = Duration;
 
 	buflen = priv->txbuffsize;
 	remain = len;
-- 
1.8.3.2

