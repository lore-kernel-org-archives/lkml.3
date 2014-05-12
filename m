Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbaELCJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:09:20 -0400
Received: from 1wt.eu ([62.212.114.60]:34513 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbaELBmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:42:17 -0400
Message-Id: <20140512003206.563589750@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>, Willy Tarreau <w@1wt.eu>
Subject: [ 141/143] netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit b22f5126a24b3b2f15448c3f2a254fc10cbc2b92 upstream

Some occurences in the netfilter tree use skb_header_pointer() in
the following way ...

  struct dccp_hdr _dh, *dh;
  ...
  skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);

... where dh itself is a pointer that is being passed as the copy
buffer. Instead, we need to use &_dh as the forth argument so that
we're copying the data into an actual buffer that sits on the stack.

Currently, we probably could overwrite memory on the stack (e.g.
with a possibly mal-formed DCCP packet), but unintentionally, as
we only want the buffer to be placed into _dh variable.

Fixes: 2bc780499aa3 ("[NETFILTER]: nf_conntrack: add DCCP protocol support")
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 1b816a2..274e8a7 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -430,7 +430,7 @@ static bool dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	const char *msg;
 	u_int8_t state;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	BUG_ON(dh == NULL);
 
 	state = dccp_state_table[CT_DCCP_ROLE_CLIENT][dh->dccph_type][CT_DCCP_NONE];
@@ -479,7 +479,7 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 	u_int8_t type, old_state, new_state;
 	enum ct_dccp_roles role;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	BUG_ON(dh == NULL);
 	type = dh->dccph_type;
 
@@ -570,7 +570,7 @@ static int dccp_error(struct net *net, struct sk_buff *skb,
 	unsigned int cscov;
 	const char *msg;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	if (dh == NULL) {
 		msg = "nf_ct_dccp: short packet ";
 		goto out_invalid;
-- 
1.7.12.2.21.g234cd45.dirty



