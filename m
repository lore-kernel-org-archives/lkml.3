Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbaHFSR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:17:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:53096 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbaHFSRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:17:24 -0400
X-IronPort-AV: E=Sophos;i="5.01,813,1400025600"; 
   d="scan'208";a="159399439"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Mathias Krause <minipli@googlemail.com>,
        Daniel Borkmann <dborkman@redhat.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>,
        "David S. Miller" <davem@davemloft.net>, Thomas Graf <tgraf@suug.ch>,
        Joe Perches <joe@perches.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: [PATCH net-next 3/4 v5] pktgen: Fixing UPD checksum calculation
Date: Wed, 6 Aug 2014 19:17:03 +0100
Message-ID: <1407349024-2489-4-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407349024-2489-1-git-send-email-zoltan.kiss@citrix.com>
References: <1407349024-2489-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It passes port number instead of IP address for checksuming. The udp4_hwcsum()
call is also bad, but my next patch will get rid of it anyway. The IPv6 code
does it correctly already. It also changes replaces 8 with sizeof(struct udphdr) 

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org
---
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index ba61e2b..d8905cd 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3061,8 +3061,9 @@ static struct sk_buff *fill_packet_ipv4(struct net_device *odev,
 		__wsum csum = udp_csum(skb);
 
 		/* add protocol-dependent pseudo-header */
-		udph->check = csum_tcpudp_magic(udph->source, udph->dest,
-						datalen + 8, IPPROTO_UDP, csum);
+		udph->check = csum_tcpudp_magic(iph->saddr, iph->daddr,
+						datalen + sizeof(struct udphdr),
+						IPPROTO_UDP, csum);
 
 		if (udph->check == 0)
 			udph->check = CSUM_MANGLED_0;
