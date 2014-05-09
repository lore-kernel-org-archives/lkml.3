Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbaEITy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 15:54:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaEITy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 15:54:28 -0400
Date: Fri, 9 May 2014 12:54:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: cl@linux.com, mhocko@suse.cz, hannes@cmpxchg.org, riel@redhat.com,
        minchan@kernel.org, zhangyanfei@cn.fujitsu.com,
        hanpt@linux.vnet.ibm.com, sasha.levin@oracle.com, oleg@redhat.com,
        fabf@skynet.be, mgorman@suse.de, aarcange@redhat.com, cldu@marvell.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: use a irq-safe __mod_zone_page_state in
 mlocked_vma_newpage()
Message-Id: <20140509125426.e585b751a81bfcc96b6b8b88@linux-foundation.org>
In-Reply-To: <1399652208-18987-1-git-send-email-nasa4836@gmail.com>
References: <1399652208-18987-1-git-send-email-nasa4836@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2014 00:16:48 +0800 Jianyu Zhan <nasa4836@gmail.com> wrote:

> mlocked_vma_newpage() is only called in fault path by
> page_add_new_anon_rmap(), which is called on a *new* page.
> And such page is initially only visible via the pagetables, and the
> pte is locked while calling page_add_new_anon_rmap(), so we need not
> use an irq-safe mod_zone_page_state() here, using a light-weight version
> __mod_zone_page_state() would be OK.
> 
> ...
>
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -196,7 +196,7 @@ static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
>  		return 0;
>  
>  	if (!TestSetPageMlocked(page)) {
> -		mod_zone_page_state(page_zone(page), NR_MLOCK,
> +		__mod_zone_page_state(page_zone(page), NR_MLOCK,
>  				    hpage_nr_pages(page));
>  		count_vm_event(UNEVICTABLE_PGMLOCKED);
>  	}

The comment over __mod_zone_page_state() says "For use when we know
that interrupts are disabled".  But that is not the case here.

Please fix this up, probably by altering the __mod_zone_page_state()
documentation.


Your proposed change to (the very poorly named) mlocked_vma_newpage()
makes that function more dangerous - people might add new callsites
without knowing that they're adding races.  This risk can be reduced by

a) adding documentation explaining why __mod_zone_page_state() is
   used and why it is safe and

b) moving mlocked_vma_newpage() out of internal.h and placing it in
   mm/rmap.c immediately before page_add_new_anon_rmap().  Or, probably
   better, by removing mlocked_vma_newpage() altogether and open-coding
   its logic into page_add_new_anon_rmap().


