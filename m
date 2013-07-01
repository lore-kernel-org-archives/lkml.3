Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab3GAURf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:17:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab3GAUKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Phil Oester <kernel@linuxace.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [ 26/26] netfilter: nf_conntrack_ipv6: Plug sk_buff leak in fragment handling
Date: Mon,  1 Jul 2013 13:10:21 -0700
Message-Id: <20130701200732.809264201@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200729.872850414@linuxfoundation.org>
References: <20130701200729.872850414@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Oester <kernel@linuxace.com>

commit 142dcdd3c25fc7a3866bb06980e8f93a2ed7e050 upstream.

In commit 4cdd3408 ("netfilter: nf_conntrack_ipv6: improve fragmentation
handling"), an sk_buff leak was introduced when dealing with reassembled
packets by grabbing a reference to the original skb instead of the
reassembled skb.  At this point, the leak only impacted conntracks with an
associated helper.

In commit 58a317f1 ("netfilter: ipv6: add IPv6 NAT support"), the bug was
expanded to include all reassembled packets with unconfirmed conntracks.

Fix this by grabbing a reference to the proper reassembled skb.  This
closes netfilter bugzilla #823.

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -204,7 +204,7 @@ static unsigned int __ipv6_conntrack_in(
 		if (ct != NULL && !nf_ct_is_untracked(ct)) {
 			help = nfct_help(ct);
 			if ((help && help->helper) || !nf_ct_is_confirmed(ct)) {
-				nf_conntrack_get_reasm(skb);
+				nf_conntrack_get_reasm(reasm);
 				NF_HOOK_THRESH(NFPROTO_IPV6, hooknum, reasm,
 					       (struct net_device *)in,
 					       (struct net_device *)out,


