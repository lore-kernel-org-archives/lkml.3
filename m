Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbaEFVOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:14:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41047 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaEFVOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:14:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Borkmann <dborkman@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 1/4] netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages
Date: Tue,  6 May 2014 14:13:52 -0700
Message-Id: <1399410835-24162-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399410835-24162-1-git-send-email-kamal@canonical.com>
References: <1399410835-24162-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

commit b22f5126a24b3b2f15448c3f2a254fc10cbc2b92 upstream.

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
Reference: CVE-2014-2523
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/netfilter/nf_conntrack_proto_dccp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index a8ae287..9a2cec6 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -428,7 +428,7 @@ static bool dccp_new(struct nf_conn *ct, const struct sk_buff *skb,
 	const char *msg;
 	u_int8_t state;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	BUG_ON(dh == NULL);
 
 	state = dccp_state_table[CT_DCCP_ROLE_CLIENT][dh->dccph_type][CT_DCCP_NONE];
@@ -485,7 +485,7 @@ static int dccp_packet(struct nf_conn *ct, const struct sk_buff *skb,
 	u_int8_t type, old_state, new_state;
 	enum ct_dccp_roles role;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	BUG_ON(dh == NULL);
 	type = dh->dccph_type;
 
@@ -576,7 +576,7 @@ static int dccp_error(struct net *net, struct nf_conn *tmpl,
 	unsigned int cscov;
 	const char *msg;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	if (dh == NULL) {
 		msg = "nf_ct_dccp: short packet ";
 		goto out_invalid;
-- 
1.9.1

