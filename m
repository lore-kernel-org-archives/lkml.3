Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab3ILSCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:02:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab3ILR70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Clark <chris.clark@alcatel-lucent.com>,
        Julian Anastasov <ja@ssi.bg>, "David S. Miller" <davem@davemloft.net>
Subject: [ 31/46] ipv4: sendto/hdrincl: dont use destination address found in header
Date: Thu, 12 Sep 2013 10:58:42 -0700
Message-Id: <20130912175724.380971471@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Clark <chris.clark@alcatel-lucent.com>

[ Upstream commit c27c9322d015dc1d9dfdf31724fca71c0476c4d1 ]

ipv4: raw_sendmsg: don't use header's destination address

A sendto() regression was bisected and found to start with commit
f8126f1d5136be1 (ipv4: Adjust semantics of rt->rt_gateway.)

The problem is that it tries to ARP-lookup the constructed packet's
destination address rather than the explicitly provided address.

Fix this using FLOWI_FLAG_KNOWN_NH so that given nexthop is used.

cf. commit 2ad5b9e4bd314fc685086b99e90e5de3bc59e26b

Reported-by: Chris Clark <chris.clark@alcatel-lucent.com>
Bisected-by: Chris Clark <chris.clark@alcatel-lucent.com>
Tested-by: Chris Clark <chris.clark@alcatel-lucent.com>
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Chris Clark <chris.clark@alcatel-lucent.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/raw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -571,7 +571,8 @@ static int raw_sendmsg(struct kiocb *ioc
 	flowi4_init_output(&fl4, ipc.oif, sk->sk_mark, tos,
 			   RT_SCOPE_UNIVERSE,
 			   inet->hdrincl ? IPPROTO_RAW : sk->sk_protocol,
-			   inet_sk_flowi_flags(sk) | FLOWI_FLAG_CAN_SLEEP,
+			   inet_sk_flowi_flags(sk) | FLOWI_FLAG_CAN_SLEEP |
+			    (inet->hdrincl ? FLOWI_FLAG_KNOWN_NH : 0),
 			   daddr, saddr, 0, 0);
 
 	if (!inet->hdrincl) {


