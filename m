Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaJNKtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 06:49:33 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60280 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932068AbaJNKtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 06:49:31 -0400
Date: Tue, 14 Oct 2014 12:49:23 +0200
From: Florian Westphal <fw@strlen.de>
To: Houcheng Lin <houcheng@gmail.com>
Cc: pablo@netfilter.org, Patrick McHardy <kaber@trash.net>,
        kadlec@blackhole.kfki.hu, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] netfilter: release skbuf when nlmsg put fail
Message-ID: <20141014104923.GA30916@breakpoint.cc>
References: <CAL8JtxD=Vopo7fvKEnfKgOa3T=WyVH=mb_YqX9mES+n-6dJbrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL8JtxD=Vopo7fvKEnfKgOa3T=WyVH=mb_YqX9mES+n-6dJbrQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Houcheng Lin <houcheng@gmail.com> wrote:
> When system is under heavy loading, the __nfulnl_send() may may failed
> to put nlmsg into skbuf of nfulnl_instance. If not clear the skbuff on failed,
> the __nfulnl_send() will still try to put next nlmsg onto this half-full skbuf
> and cause the user program can never receive packet.
> 
> This patch fix this issue by releasing skbuf immediately after nlmst put
> failed.

Could you please try this patch on top of this one and see if the
WARN_ON goes away?

Thanks

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -649,7 +649,8 @@ nfulnl_log_packet(struct net *net,
 		+ nla_total_size(sizeof(u_int32_t))	/* gid */
 		+ nla_total_size(plen)			/* prefix */
 		+ nla_total_size(sizeof(struct nfulnl_msg_packet_hw))
-		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp));
+		+ nla_total_size(sizeof(struct nfulnl_msg_packet_timestamp))
+		+ nla_total_size(sizeof(struct nfgenmsg));	/* NLMSG_DONE */
 
 	if (in && skb_mac_header_was_set(skb)) {
 		size +=   nla_total_size(skb->dev->hard_header_len)
@@ -692,8 +693,7 @@ nfulnl_log_packet(struct net *net,
 		goto unlock_and_release;
 	}
 
-	if (inst->skb &&
-	    size > skb_tailroom(inst->skb) - sizeof(struct nfgenmsg)) {
+	if (inst->skb && size > skb_tailroom(inst->skb)) {
 		/* either the queue len is too high or we don't have
 		 * enough room in the skb left. flush to userspace. */
 		__nfulnl_flush(inst);
