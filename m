Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab3APTV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 14:21:27 -0500
Received: from mx2.parallels.com ([64.131.90.16]:36495 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab3APTV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 14:21:26 -0500
Message-ID: <50F6FDC8.5020909@parallels.com>
Date: Wed, 16 Jan 2013 11:21:44 -0800
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mm@kvack.org>, <xfs@oss.sgi.com>,
        Greg Thelen <gthelen@google.com>, Ying Han <yinghan@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 09/19] list_lru: per-node list infrastructure
References: <1354058086-27937-1-git-send-email-david@fromorbit.com> <1354058086-27937-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1354058086-27937-10-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [216.239.55.193]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 03:14 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have an LRU list API, we can start to enhance the
> implementation.  This splits the single LRU list into per-node lists
> and locks to enhance scalability. Items are placed on lists
> according to the node the memory belongs to. To make scanning the
> lists efficient, also track whether the per-node lists have entries
> in them in a active nodemask.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  include/linux/list_lru.h |   14 ++--
>  lib/list_lru.c           |  160 +++++++++++++++++++++++++++++++++++-----------
>  2 files changed, 129 insertions(+), 45 deletions(-)
> 
> diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
> index 3423949..b0e3ba2 100644
> --- a/include/linux/list_lru.h
> +++ b/include/linux/list_lru.h
> @@ -8,21 +8,23 @@
>  #define _LRU_LIST_H 0
>  
>  #include <linux/list.h>
> +#include <linux/nodemask.h>
>  
> -struct list_lru {
> +struct list_lru_node {
>  	spinlock_t		lock;
>  	struct list_head	list;
>  	long			nr_items;
> +} ____cacheline_aligned_in_smp;
> +
> +struct list_lru {
> +	struct list_lru_node	node[MAX_NUMNODES];
> +	nodemask_t		active_nodes;
>  };
>  
MAX_NUMNODES will default to 1 << 9, if I'm not mistaken. Your
list_lru_node seems to be around 32 bytes on 64-bit systems (128 with
debug). So we're talking about 16k per lru.
The superblocks only, are present by the dozens even in a small system,
and I believe the whole goal of this API is to get more users to switch
to it. This can easily use up a respectable bunch of megs.

Isn't it a bit too much ?

I am wondering if we can't do better in here and at least allocate+grow
according to the actual number of nodes.

