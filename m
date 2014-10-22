Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694AbaJVQCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:02:50 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:53903 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbaJVPpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:39 -0400
Message-ID: <1413992737.9031.1.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] igb: don't reuse pages with pfmemalloc flag
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        peter.p.waskiewicz.jr@intel.com, alexander.h.duyck@intel.com,
        john.ronciak@intel.com, tushar.n.dave@intel.com, davem@davemloft.net,
        sassmann@kpanic.de, gregkh@linuxfoundation.org,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 22 Oct 2014 08:45:37 -0700
In-Reply-To: <1413985819-9553-1-git-send-email-klamm@yandex-team.ru>
References: <1413985819-9553-1-git-send-email-klamm@yandex-team.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-22 at 17:50 +0400, Roman Gushchin wrote:
> Incoming packet is dropped silently by sk_filter(), if the skb was
> allocated from pfmemalloc reserves and the corresponding socket is
> not marked with the SOCK_MEMALLOC flag.
> 
> Igb driver allocates pages for DMA with __skb_alloc_page(), which
> calls alloc_pages_node() with the __GFP_MEMALLOC flag. So, in case
> of OOM condition, igb can get pages with pfmemalloc flag set.
> 
> If an incoming packet hits the pfmemalloc page and is large enough
> (small packets are copying into the memory, allocated with
> netdev_alloc_skb_ip_align(), so they are not affected), it will be
> dropped.
> 
> This behavior is ok under high memory pressure, but the problem is
> that the igb driver reuses these mapped pages. So, packets are still
> dropping even if all memory issues are gone and there is a plenty
> of free memory.
> 
> In my case, some TCP sessions hang on a small percentage (< 0.1%)
> of machines days after OOMs.
> 
> Fix this by avoiding reuse of such pages.
> 
> Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
> ---

Interesting...

It seems we also need to clear skb->pfmemalloc in napi_reuse_skb()



