Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab3HAG2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 02:28:19 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:35282 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3HAG2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 02:28:18 -0400
Date: Thu, 1 Aug 2013 10:28:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, luto@amacapital.net,
        xemul@parallels.com, akpm@linux-foundation.org, mpm@selenic.com,
        xiaoguangrong@linux.vnet.ibm.com, mtosatti@redhat.com,
        kosaki.motohiro@gmail.com, sfr@canb.auug.org.au, peterz@infradead.org,
        aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [patch 1/2] [PATCH] mm: Save soft-dirty bits on swapped pages
Message-ID: <20130801062814.GB1764@moon>
References: <20130730204154.407090410@gmail.com>
 <20130730204654.844299768@gmail.com>
 <20130801005132.GB19540@bbox>
 <20130801055303.GA1764@moon>
 <20130801061632.GE19540@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130801061632.GE19540@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 03:16:32PM +0900, Minchan Kim wrote:
> 
> I don't get it. Could you correct me with below example?
> 
> Process A context
>         try_to_unmap
>                 swp_pte = swp_entry_to_pte /* change generic swp into arch swap */
>                 swp_pte = pte_swp_mksoft_dirty(swp_pte);
>                 set_pte_at(, swp_pte);
> 
> Process A context
>         ..
>         mincore_pte_range
		pte_t pte = *ptep;	<-- local copy of the pte value, in memory it remains the same
						with swap softdirty bit set
>                 pte_to_swp_entry
>                         pte = pte_swp_clear_soft_dirty  <=== 1)
>                         change arch swp with generic swp
>                 mincore_page 
> 
> Process B want to know dirty state of the page
>         ..
>         pagemap_read
>         pte_to_pagemap_entry
>         is_swap_pte
>                 if (pte_swap_soft_dirty(pte)) <=== but failed by 1)
> 
> So, Process B can't get the dirty status from process A's the page.
