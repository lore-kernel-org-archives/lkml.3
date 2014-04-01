Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaDAEQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 00:16:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53926 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaDAEP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 00:15:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3.13 22/22] netfilter: nf_conntrack_dccp: fix skb_header_pointer API usages
Date: Mon, 31 Mar 2014 21:08:52 -0700
Message-Id: <20140401040708.636622468@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140401040703.045139933@linuxfoundation.org>
References: <20140401040703.045139933@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_proto_dccp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -428,7 +428,7 @@ static bool dccp_new(struct nf_conn *ct,
 	const char *msg;
 	u_int8_t state;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	BUG_ON(dh == NULL);
 
 	state = dccp_state_table[CT_DCCP_ROLE_CLIENT][dh->dccph_type][CT_DCCP_NONE];
@@ -486,7 +486,7 @@ static int dccp_packet(struct nf_conn *c
 	u_int8_t type, old_state, new_state;
 	enum ct_dccp_roles role;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	BUG_ON(dh == NULL);
 	type = dh->dccph_type;
 
@@ -577,7 +577,7 @@ static int dccp_error(struct net *net, s
 	unsigned int cscov;
 	const char *msg;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &dh);
+	dh = skb_header_pointer(skb, dataoff, sizeof(_dh), &_dh);
 	if (dh == NULL) {
 		msg = "nf_ct_dccp: short packet ";
 		goto out_invalid;


