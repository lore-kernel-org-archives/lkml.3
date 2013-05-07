Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab3EGPyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:54:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab3EGPyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:54:17 -0400
Date: Tue, 7 May 2013 16:54:11 +0100
From: Mel Gorman <mgorman@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Zhang Yi <wetpzy@gmail.com>, linux-kernel@vger.kernel.org,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Darren Hart'" <dvhart@linux.intel.com>,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Dave Hansen'" <dave.hansen@linux.intel.com>, zhang.yi20@zte.com.cn,
        wetpzy@163.com
Subject: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
Message-ID: <20130507155411.GO11497@suse.de>
References: <000101ce4277$69df5af0$3d9e10d0$@com>
 <alpine.LFD.2.02.1304261951300.21884@ionos>
 <000101ce4b1d$bddec0b0$399c4210$@com>
 <20130507152007.GA3405@suse.de>
 <alpine.LFD.2.02.1305071724190.2863@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305071724190.2863@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 05:24:57PM +0200, Thomas Gleixner wrote:
> 
> 
> On Tue, 7 May 2013, Mel Gorman wrote:
> 
> > On Tue, May 07, 2013 at 08:23:48PM +0800, Zhang Yi wrote:
> > > diff -uprN linux3.9-orig/kernel/futex.c linux3.9/kernel/futex.c
> > > --- linux3.9-orig/kernel/futex.c	2013-04-15 00:45:16.000000000 +0000
> > > +++ linux3.9/kernel/futex.c	2013-05-06 16:24:40.403525000 +0000
> > > @@ -215,6 +215,22 @@ static void drop_futex_key_refs(union fu
> > >  	}
> > >  }
> > > 
> > > +/*
> > > +* Get subpage index in compound page, and add it into futex_key.
> > > +*/
> > > +static void key_add_compound_idx(union futex_key *key,
> > > +				 struct page *head_page, struct page *page)
> > > +{
> > > +	int compound_idx;
> > > +
> > > +	if (compound_order(head_page) >= MAX_ORDER)
> > > +		compound_idx = page_to_pfn(page) - page_to_pfn(head_page);
> > > +	else
> > > +		compound_idx = page - head_page;
> > > +
> > > +	key->both.offset |= compound_idx << PAGE_SHIFT;
> > > +}
> > > +
> > 
> > This implicitely assumies it is dealing with a hugetlbfs page. Today, it
> > is the case that an inode-based futex with PageCompound is a hugetlbfs
> > page but that could change in the future if THP ever backs files. This
> > would then break again except it would be harder to fix because THP pages
> > can be collapsed underneath you after the futex key has been generated.
> > 
> > As this problem is hugetlbfs-specific should the fix be firmly in hugetlbfs
> > land? Something like the following untested and only partial diff? Is the
> > use of PageCompound in the futex path like this going to be problematic?
> 
> Why should it ?
>  

The comment for it states that it is "generally not used in hot code
paths" but it's a light-weight check that the cache lines should already
be fetched for. I doubt that the overhead of this check versus
page_head == page is noticable.

> > @@ -365,7 +366,7 @@ again:
> >  	} else {
> >  		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
> >  		key->shared.inode = page_head->mapping->host;
> > -		key->shared.pgoff = page_head->index;
> > +		key->shared.pgoff = basepage_index(page_head);
> 
>   That want's to be  basepage_index(page), right ?
> 

BAH, yes.

-- 
Mel Gorman
SUSE Labs
