Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbaJMLnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 07:43:08 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58481 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979AbaJMLnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 07:43:06 -0400
Date: Mon, 13 Oct 2014 13:42:56 +0200
From: Florian Westphal <fw@strlen.de>
To: Houcheng Lin <houcheng@gmail.com>
Cc: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: release skbuf when nlmsg put fail
Message-ID: <20141013114256.GB6560@breakpoint.cc>
References: <CAL8JtxAqDhOXooLtOebSBHtKxwE=sLFqW8B-VgtCzsr-M4OD7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL8JtxAqDhOXooLtOebSBHtKxwE=sLFqW8B-VgtCzsr-M4OD7g@mail.gmail.com>
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

Did you observe such problem or is this based on code reading?
I ask because nflog should make sure we always have enough room left in
skb to append a done message, see nfulnl_log_packet():

if (inst->skb &&
    size > skb_tailroom(inst->skb) - sizeof(struct nfgenmsg)) {
	/* flush skb */

Your patch fixes such 'can never send' skb condition by leaking the
skb.  So at the very least you would need to call kfree_skb(), and
perhaps also add WARN_ON() so we catch this and can fix up the size
accounting?
