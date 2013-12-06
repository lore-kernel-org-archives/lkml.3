Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082Ab3LFVwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:52:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759016Ab3LFVwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Dave Jones <davej@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 25/83] ipv4: fix possible seqlock deadlock
Date: Fri,  6 Dec 2013 13:51:15 -0800
Message-Id: <20131206214642.415025028@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c9e9042994d37cbc1ee538c500e9da1bb9d1bcdf ]

ip4_datagram_connect() being called from process context,
it should use IP_INC_STATS() instead of IP_INC_STATS_BH()
otherwise we can deadlock on 32bit arches, or get corruptions of
SNMP counters.

Fixes: 584bdf8cbdf6 ("[IPV4]: Fix "ipOutNoRoutes" counter error for TCP and UDP")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/datagram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -57,7 +57,7 @@ int ip4_datagram_connect(struct sock *sk
 	if (IS_ERR(rt)) {
 		err = PTR_ERR(rt);
 		if (err == -ENETUNREACH)
-			IP_INC_STATS_BH(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
+			IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
 		goto out;
 	}
 


