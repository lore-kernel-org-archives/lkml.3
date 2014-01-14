Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbaANRof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:44:35 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45823 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaANRoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:44:30 -0500
Date: Tue, 14 Jan 2014 21:44:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: netfilter-devel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, vvs@openvz.org,
        Florian Westphal <fw@strlen.de>, Vasiliy Averin <vvs@parallels.com>
Subject: Re: [PATCH] [RFC] netfilter: nf_conntrack: don't relase a conntrack
 with non-zero refcnt
Message-ID: <20140114174421.GC1916@moon>
References: <1389710201.31367.255.camel@edumazet-glaptop2.roam.corp.google.com>
 <1389720948-7883-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389720948-7883-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 09:35:48PM +0400, Andrey Vagin wrote:
> ----
> Eric and Florian, could you look at this patch. When you say,
> that it looks good, I will ask the user to validate it.
> I can't reorder these actions, because it's reproduced on a real host
> with real users. Thanks.
> ----
> 
> nf_conntrack_free can't be called for a conntract with non-zero ref-counter,
> because it can race with nf_conntrack_find_get().
> 
> A conntrack slab is created with SLAB_DESTROY_BY_RCU. Non-zero
> ref-conunter says that this conntrack is used now. So when we release a
> conntrack with non-zero counter, we break this assumption.
> 
> CPU1                                    CPU2
> ____nf_conntrack_find()
>                                         nf_ct_put()
>                                          destroy_conntrack()
>                                         ...
>                                         init_conntrack
>                                          __nf_conntrack_alloc (set use = 1)
> atomic_inc_not_zero(&ct->use) (use = 2)
>                                          if (!l4proto->new(ct, skb, dataoff, timeouts))
>                                           nf_conntrack_free(ct); (use = 2 !!!)
>                                         ...
>                                         __nf_conntrack_alloc (set use = 1)
>  if (!nf_ct_key_equal(h, tuple, zone))
>   nf_ct_put(ct); (use = 0)
>    destroy_conntrack()
>                                         /* continue to work with CT */

If I didn't miss something obvious this looks like a pretty possible
scenario. Thanks!
