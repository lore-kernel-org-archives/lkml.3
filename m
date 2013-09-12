Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab3ILSMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:12:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab3ILR7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Phil Oester <kernel@linuxace.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 33/46] tcp: tcp_make_synack() should use sock_wmalloc
Date: Thu, 12 Sep 2013 10:58:44 -0700
Message-Id: <20130912175724.596522715@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Oester <kernel@linuxace.com>

[ Upstream commit eb8895debe1baba41fcb62c78a16f0c63c21662a ]

In commit 90ba9b19 (tcp: tcp_make_synack() can use alloc_skb()), Eric changed
the call to sock_wmalloc in tcp_make_synack to alloc_skb.  In doing so,
the netfilter owner match lost its ability to block the SYNACK packet on
outbound listening sockets.  Revert the change, restoring the owner match
functionality.

This closes netfilter bugzilla #847.

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2664,7 +2664,7 @@ struct sk_buff *tcp_make_synack(struct s
 	int tcp_header_size;
 	int mss;
 
-	skb = alloc_skb(MAX_TCP_HEADER + 15, sk_gfp_atomic(sk, GFP_ATOMIC));
+	skb = sock_wmalloc(sk, MAX_TCP_HEADER + 15, 1, GFP_ATOMIC);
 	if (unlikely(!skb)) {
 		dst_release(dst);
 		return NULL;


