Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab3HMQEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:04:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18357 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685Ab3HMP6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:32 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=n02W3ty1l3cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=9zDUfKRsAmgA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=okgtKhY1cvBJsHPla7wA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155828.008964167@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [28/88] packet: packet_getname_spkt: make sure string is always 0-terminated
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0028-packet-packet_getname_spkt-make-sure-string-is-alway.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/packet/af_packet.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 13dee6a..a10ee11 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2848,12 +2848,11 @@ static int packet_getname_spkt(struct socket *sock, struct sockaddr *uaddr,
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
1.7.10.4


