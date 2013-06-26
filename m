Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab3FZCvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:51:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54118 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751461Ab3FZCpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Daniel Borkmann" <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 26 Jun 2013 03:35:59 +0100
Message-ID: <lsq.1372214159.186699797@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [23/26] packet: packet_getname_spkt: make sure string is  always
 0-terminated
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/packet/af_packet.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 5a70215..a2ac2c3 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2820,12 +2820,11 @@ static int packet_getname_spkt(struct socket *sock, struct sockaddr *uaddr,
 		return -EOPNOTSUPP;
 
 	uaddr->sa_family = AF_PACKET;
+	memset(uaddr->sa_data, 0, sizeof(uaddr->sa_data));
 	rcu_read_lock();
 	dev = dev_get_by_index_rcu(sock_net(sk), pkt_sk(sk)->ifindex);
 	if (dev)
-		strncpy(uaddr->sa_data, dev->name, 14);
-	else
-		memset(uaddr->sa_data, 0, 14);
+		strlcpy(uaddr->sa_data, dev->name, sizeof(uaddr->sa_data));
 	rcu_read_unlock();
 	*uaddr_len = sizeof(*uaddr);
 

