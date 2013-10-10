Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab3JJPrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:47:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52824 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab3JJPru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:47:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Clark <chris.clark@alcatel-lucent.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 020/104] ipv4: sendto/hdrincl: don't use destination address found in header
Date: Thu, 10 Oct 2013 08:41:08 -0700
Message-Id: <1381419752-29733-21-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/raw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 6f08991..47b4797 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -573,7 +573,8 @@ static int raw_sendmsg(struct kiocb *iocb, struct sock *sk, struct msghdr *msg,
 	flowi4_init_output(&fl4, ipc.oif, sk->sk_mark, tos,
 			   RT_SCOPE_UNIVERSE,
 			   inet->hdrincl ? IPPROTO_RAW : sk->sk_protocol,
-			   inet_sk_flowi_flags(sk) | FLOWI_FLAG_CAN_SLEEP,
+			   inet_sk_flowi_flags(sk) | FLOWI_FLAG_CAN_SLEEP |
+			    (inet->hdrincl ? FLOWI_FLAG_KNOWN_NH : 0),
 			   daddr, saddr, 0, 0);
 
 	if (!inet->hdrincl) {
-- 
1.8.1.2

