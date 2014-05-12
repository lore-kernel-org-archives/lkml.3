Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaELBnQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:43:16 -0400
Received: from 1wt.eu ([62.212.114.60]:34699 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbaELBnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:14 -0400
Message-Id: <20140512003202.712288837@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:50 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 050/143] packet: packet_getname_spkt: make sure string is always 0-terminated
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 2dc85bf323515e59e15dfa858d1472bb25cad0fe ]

uaddr->sa_data is exactly of size 14, which is hard-coded here and
passed as a size argument to strncpy(). A device name can be of size
IFNAMSIZ (== 16), meaning we might leave the destination string
unterminated. Thus, use strlcpy() and also sizeof() while we're
at it. We need to memset the data area beforehand, since strlcpy
does not padd the remaining buffer with zeroes for user space, so
that we do not possibly leak anything.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/packet/af_packet.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 728c080..f084e01 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1525,12 +1525,12 @@ static int packet_getname_spkt(struct socket *sock, struct sockaddr *uaddr,
 		return -EOPNOTSUPP;
 
 	uaddr->sa_family = AF_PACKET;
+	memset(uaddr->sa_data, 0, sizeof(uaddr->sa_data));
 	dev = dev_get_by_index(sock_net(sk), pkt_sk(sk)->ifindex);
 	if (dev) {
-		strncpy(uaddr->sa_data, dev->name, 14);
+		strlcpy(uaddr->sa_data, dev->name, sizeof(uaddr->sa_data));
 		dev_put(dev);
-	} else
-		memset(uaddr->sa_data, 0, 14);
+	}
 	*uaddr_len = sizeof(*uaddr);
 
 	return 0;
-- 
1.7.12.2.21.g234cd45.dirty



