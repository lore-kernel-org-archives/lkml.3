Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3GBLIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:08:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36237 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056Ab3GBLIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 21/50] packet: packet_getname_spkt: make sure string is always 0-terminated
Date: Tue,  2 Jul 2013 12:07:09 +0100
Message-Id: <1372763258-20664-22-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit 2dc85bf323515e59e15dfa858d1472bb25cad0fe upstream.

uaddr->sa_data is exactly of size 14, which is hard-coded here and
passed as a size argument to strncpy(). A device name can be of size
IFNAMSIZ (== 16), meaning we might leave the destination string
unterminated. Thus, use strlcpy() and also sizeof() while we're
at it. We need to memset the data area beforehand, since strlcpy
does not padd the remaining buffer with zeroes for user space, so
that we do not possibly leak anything.

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/packet/af_packet.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 4137d01..1522b93 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2854,12 +2854,11 @@ static int packet_getname_spkt(struct socket *sock, struct sockaddr *uaddr,
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
 
-- 
1.8.1.2

