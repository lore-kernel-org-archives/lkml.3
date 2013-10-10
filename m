Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab3JJQN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:13:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52577 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab3JJPmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:42:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Phil Oester <kernel@linuxace.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 021/104] tcp: tcp_make_synack() should use sock_wmalloc
Date: Thu, 10 Oct 2013 08:41:09 -0700
Message-Id: <1381419752-29733-22-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Oester <kernel@linuxace.com>

commit eb8895debe1baba41fcb62c78a16f0c63c21662a upstream.

In commit 90ba9b19 (tcp: tcp_make_synack() can use alloc_skb()), Eric changed
the call to sock_wmalloc in tcp_make_synack to alloc_skb.  In doing so,
the netfilter owner match lost its ability to block the SYNACK packet on
outbound listening sockets.  Revert the change, restoring the owner match
functionality.

This closes netfilter bugzilla #847.

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/tcp_output.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 0bdd879..436d8fb 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2705,8 +2705,8 @@ struct sk_buff *tcp_make_synack(struct sock *sk, struct dst_entry *dst,
 
 	if (cvp != NULL && cvp->s_data_constant && cvp->s_data_desired)
 		s_data_desired = cvp->s_data_desired;
-	skb = alloc_skb(MAX_TCP_HEADER + 15 + s_data_desired,
-			sk_gfp_atomic(sk, GFP_ATOMIC));
+	skb = sock_wmalloc(sk, MAX_TCP_HEADER + 15 + s_data_desired, 1,
+			GFP_ATOMIC);
 	if (unlikely(!skb)) {
 		dst_release(dst);
 		return NULL;
-- 
1.8.1.2

