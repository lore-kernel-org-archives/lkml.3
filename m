Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab3GXOGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:06:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45704 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605Ab3GXOG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Francois Romieu" <romieu@fr.zoreil.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.359135881@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [01/85] r8169: fix offloaded tx checksum for small packets.
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

The workaround introduced by commit e5195c1f31f3 'r8169: fix 8168evl
frame padding.' upstream was incorrect and was entirely replaced in
commit b423e9ae49d7 'r8169: fix offloaded tx checksum for small
packets.'

On the 3.2.y branch, the first commit has effectively been applied
twice: the first time by itself, and the second time in commit
3cf40360f431 which squashed the two upstream commits together.  That
left us with both the incorrect and the correct workaround in place.
Remove the incorrect one.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Francois Romieu <romieu@fr.zoreil.com>
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5584,14 +5584,6 @@ static netdev_tx_t rtl8169_start_xmit(st
 		goto err_stop_0;
 	}
 
-	/* 8168evl does not automatically pad to minimum length. */
-	if (unlikely(tp->mac_version == RTL_GIGA_MAC_VER_34 &&
-		     skb->len < ETH_ZLEN)) {
-		if (skb_padto(skb, ETH_ZLEN))
-			goto err_update_stats;
-		skb_put(skb, ETH_ZLEN - skb->len);
-	}
-
 	if (unlikely(le32_to_cpu(txd->opts1) & DescOwn))
 		goto err_stop_0;
 

