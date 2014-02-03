Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376AbaBCQWM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:22:12 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:37876 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaBCQWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:22:09 -0500
Message-ID: <1391444524.28432.99.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] [RFC] netfilter: nf_conntrack: don't relase a conntrack
 with non-zero refcnt
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Andrew Vagin <avagin@parallels.com>,
        Andrey Vagin <avagin@openvz.org>, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vvs@openvz.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Vasiliy Averin <vvs@parallels.com>
Date: Mon, 03 Feb 2014 08:22:04 -0800
In-Reply-To: <20140202233046.GA4137@localhost>
References: <1389710201.31367.255.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1389720948-7883-1-git-send-email-avagin@openvz.org>
	 <20140114185329.GB28205@breakpoint.cc>
	 <20140115180844.GA3605@paralelels.com>
	 <20140116092301.GF28205@breakpoint.cc> <20140202233046.GA4137@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-03 at 00:30 +0100, Pablo Neira Ayuso wrote:
>          */
>         smp_wmb();
> -       atomic_set(&ct->ct_general.use, 1);
> +       atomic_set(&ct->ct_general.use, 0);
>         return ct; 

Hi Pablo !

I think your patch is the way to go, but might need some extra care
with memory barriers.

I believe the smp_wmb() here is no longer needed.

If its a newly allocated memory, no other users can access to ct,
if its a recycled ct, content is already 0 anyway.

After your patch, nf_conntrack_get(&tmpl->ct_general) should increment 
an already non zero refcnt, so no memory barrier is needed.

But one smp_wmb() is needed right before this point :

	/* The caller holds a reference to this object */
	atomic_set(&ct->ct_general.use, 2);

Thanks !


