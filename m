Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753554Ab3FYSlv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:41:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab3FYSjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:39:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 14/17] packet: packet_getname_spkt: make sure string is always 0-terminated
Date: Tue, 25 Jun 2013 11:39:29 -0700
Message-Id: <20130625183917.020464188@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625183915.443950649@linuxfoundation.org>
References: <20130625183915.443950649@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1767,12 +1767,11 @@ static int packet_getname_spkt(struct so
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
 


