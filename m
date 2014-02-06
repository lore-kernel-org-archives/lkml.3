Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757016AbaBFVjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 16:39:06 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:58350 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbaBFVjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 16:39:04 -0500
Date: Thu, 6 Feb 2014 13:39:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: use __GFP_NORETRY for high order allocations
In-Reply-To: <1391722444.15777.28.camel@joe-AO722>
Message-ID: <alpine.DEB.2.02.1402061335280.12761@chino.kir.corp.google.com>
References: <1391712162.10160.8.camel@edumazet-glaptop2.roam.corp.google.com> <1391718270.15777.20.camel@joe-AO722> <alpine.DEB.2.02.1402061302020.9567@chino.kir.corp.google.com> <1391722444.15777.28.camel@joe-AO722>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, Joe Perches wrote:

> > If they absolutely require local memory to 
> > currnet's cpu node then that would make sense,
> 
> I presumed THISNODE would be used only with NORETRY
> 

Unfortunately, that would avoid attempting to defragment or reclaim 
remotely for the order-3 allocation and only allocate remotely for 
order-0.

So we have to make a decision here what is more important: allocating 
high-order memory or local memory to current's cpu at this given time?

The policy of transparent hugepages, for example, is always to allocate 
order-9 memory remotely instead of falling back to allocating a smallpage 
locally.

The original code never cared about local vs remote memory, so I don't 
think there's any restriction to allocating remotely.  I also don't know 
many allocators that do __GFP_THISNODE and care about local memory to 
current's cpu at this point in time, usually users of that flag are 
allocating memory that must be local to a specific node (for things like 
kmem_cache_alloc_node()).
