Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaJZQxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 12:53:15 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:45339 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbaJZQxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 12:53:03 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2 01/15] net: dsa: Don't set skb->protocol on outgoing tagged packets
Date: Sun, 26 Oct 2014 09:52:31 -0700
Message-Id: <1414342365-27191-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414342365-27191-1-git-send-email-linux@roeck-us.net>
References: <1414342365-27191-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020207.544D26EF.0044,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 19
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting skb->protocol to a private protocol type may result in warning
messages such as
	e1000e 0000:00:19.0 em1: checksum_partial proto=dada!

This happens if the L3 protocol is IP or IPv6 and skb->ip_summed is set
to CHECKSUM_PARTIAL. Looking through the code, it appears that changing
skb->protocol for transmitted packets is not necessary and may actually
be harmful. Drop it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- No change

 net/dsa/tag_dsa.c     | 2 --
 net/dsa/tag_edsa.c    | 2 --
 net/dsa/tag_trailer.c | 2 --
 3 files changed, 6 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index ce90c8b..2dab270 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -63,8 +63,6 @@ static netdev_tx_t dsa_xmit(struct sk_buff *skb, struct net_device *dev)
 		dsa_header[3] = 0x00;
 	}
 
-	skb->protocol = htons(ETH_P_DSA);
-
 	skb->dev = p->parent->dst->master_netdev;
 	dev_queue_xmit(skb);
 
diff --git a/net/dsa/tag_edsa.c b/net/dsa/tag_edsa.c
index 94fcce7..9aeda59 100644
--- a/net/dsa/tag_edsa.c
+++ b/net/dsa/tag_edsa.c
@@ -76,8 +76,6 @@ static netdev_tx_t edsa_xmit(struct sk_buff *skb, struct net_device *dev)
 		edsa_header[7] = 0x00;
 	}
 
-	skb->protocol = htons(ETH_P_EDSA);
-
 	skb->dev = p->parent->dst->master_netdev;
 	dev_queue_xmit(skb);
 
diff --git a/net/dsa/tag_trailer.c b/net/dsa/tag_trailer.c
index 115fdca..e268f9d 100644
--- a/net/dsa/tag_trailer.c
+++ b/net/dsa/tag_trailer.c
@@ -57,8 +57,6 @@ static netdev_tx_t trailer_xmit(struct sk_buff *skb, struct net_device *dev)
 	trailer[2] = 0x10;
 	trailer[3] = 0x00;
 
-	nskb->protocol = htons(ETH_P_TRAILER);
-
 	nskb->dev = p->parent->dst->master_netdev;
 	dev_queue_xmit(nskb);
 
-- 
1.9.1

