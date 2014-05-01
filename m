Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaEAVCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:02:36 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58452 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaEAVCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:02:35 -0400
Date: Thu, 1 May 2014 14:02:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, vbabka@suse.cz, iamjoonsoo.kim@lge.com,
        gthelen@google.com, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 1/2] mm, migration: add destination page freeing
 callback
In-Reply-To: <5361d71e.236ec20a.1b3d.ffffc8aeSMTPIN_ADDED_BROKEN@mx.google.com>
Message-ID: <alpine.DEB.2.02.1405011402160.32268@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <5361d71e.236ec20a.1b3d.ffffc8aeSMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2014, Naoya Horiguchi wrote:

> Looks good to me.
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> 

Thanks!

> I have one comment below ...
> 
> [snip]
> 
> > @@ -1056,20 +1059,30 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
> >  	if (!page_mapped(hpage))
> >  		rc = move_to_new_page(new_hpage, hpage, 1, mode);
> >  
> > -	if (rc)
> > +	if (rc != MIGRATEPAGE_SUCCESS)
> >  		remove_migration_ptes(hpage, hpage);
> >  
> >  	if (anon_vma)
> >  		put_anon_vma(anon_vma);
> >  
> > -	if (!rc)
> > +	if (rc == MIGRATEPAGE_SUCCESS)
> >  		hugetlb_cgroup_migrate(hpage, new_hpage);
> >  
> >  	unlock_page(hpage);
> >  out:
> >  	if (rc != -EAGAIN)
> >  		putback_active_hugepage(hpage);
> > -	put_page(new_hpage);
> > +
> > +	/*
> > +	 * If migration was not successful and there's a freeing callback, use
> > +	 * it.  Otherwise, put_page() will drop the reference grabbed during
> > +	 * isolation.
> > +	 */
> 
> This comment is true both for normal page and huge page, and people more likely
> to see unmap_and_move() at first, so this had better be (also) in unmap_and_move().
> 

Ok!
