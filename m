Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab3LZXpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 18:45:11 -0500
Received: from mail-gg0-f175.google.com ([209.85.161.175]:36920 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab3LZXpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 18:45:09 -0500
Date: Thu, 26 Dec 2013 15:45:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
cc: akpm@linux-foundation.org, tj@kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] mm/memblock: use WARN_ONCE when MAX_NUMNODES passed as
 input parameter
In-Reply-To: <1387578536-18280-1-git-send-email-santosh.shilimkar@ti.com>
Message-ID: <alpine.DEB.2.02.1312261542260.9342@chino.kir.corp.google.com>
References: <1387578536-18280-1-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Dec 2013, Santosh Shilimkar wrote:

> diff --git a/mm/memblock.c b/mm/memblock.c
> index 71b11d9..6af873a 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -707,11 +707,9 @@ void __init_memblock __next_free_mem_range(u64 *idx, int nid,
>  	struct memblock_type *rsv = &memblock.reserved;
>  	int mi = *idx & 0xffffffff;
>  	int ri = *idx >> 32;
> -	bool check_node = (nid != NUMA_NO_NODE) && (nid != MAX_NUMNODES);
>  
> -	if (nid == MAX_NUMNODES)
> -		pr_warn_once("%s: Usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE instead\n",
> -			     __func__);
> +	if (WARN_ONCE(nid == MAX_NUMNODES, "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
> +		nid = NUMA_NO_NODE;
>  
>  	for ( ; mi < mem->cnt; mi++) {
>  		struct memblock_region *m = &mem->regions[mi];

Um, why do this at runtime?  This is only used for 
for_each_free_mem_range(), which is used rarely in x86 and memblock-only 
code.  I'm struggling to understand why we can't deterministically fix the 
callers if this condition is possible.
