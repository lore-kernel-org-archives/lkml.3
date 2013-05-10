Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab3EJJmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 05:42:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3EJJmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 05:42:31 -0400
Date: Fri, 10 May 2013 10:42:22 +0100
From: Mel Gorman <mgorman@suse.de>
To: zhang.yi20@zte.com.cn
Cc: "'Dave Hansen'" <dave.hansen@linux.intel.com>,
        "'Darren Hart'" <dvhart@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Ingo Molnar'" <mingo@kernel.org>,
        "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Thomas Gleixner'" <tglx@linutronix.de>, wetpzy@163.com,
        Zhang Yi <wetpzy@gmail.com>
Subject: Re: Re: [PATCH] futex: bugfix for futex-key conflict when futex use
 hugepage
Message-ID: <20130510094222.GL11497@suse.de>
References: <000101ce4277$69df5af0$3d9e10d0$@com>
 <alpine.LFD.2.02.1304261951300.21884@ionos>
 <000101ce4b1d$bddec0b0$399c4210$@com>
 <20130507152007.GA3405@suse.de>
 <OF48CE8C5D.403E463A-ON48257B67.0031867F-48257B67.00324443@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <OF48CE8C5D.403E463A-ON48257B67.0031867F-48257B67.00324443@zte.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 05:08:30PM +0800, zhang.yi20@zte.com.cn wrote:
> 
> 
> Mel Gorman <mgorman@suse.de> wrote on 2013/05/07 23:20:07:
> 
> >
> > Re: [PATCH] futex: bugfix for futex-key conflict when futex use hugepage
> >
> > On Tue, May 07, 2013 at 08:23:48PM +0800, Zhang Yi wrote:
> > > diff -uprN linux3.9-orig/kernel/futex.c linux3.9/kernel/futex.c
> > > --- linux3.9-orig/kernel/futex.c   2013-04-15 00:45:16.000000000 +0000
> > > +++ linux3.9/kernel/futex.c   2013-05-06 16:24:40.403525000 +0000
> > > @@ -215,6 +215,22 @@ static void drop_futex_key_refs(union fu
> > >     }
> > >  }
> > >
> > > +/*
> > > +* Get subpage index in compound page, and add it into futex_key.
> > > +*/
> > > +static void key_add_compound_idx(union futex_key *key,
> > > +             struct page *head_page, struct page *page)
> > > +{
> > > +   int compound_idx;
> > > +
> > > +   if (compound_order(head_page) >= MAX_ORDER)
> > > +      compound_idx = page_to_pfn(page) - page_to_pfn(head_page);
> > > +   else
> > > +      compound_idx = page - head_page;
> > > +
> > > +   key->both.offset |= compound_idx << PAGE_SHIFT;
> > > +}
> > > +
> >
> > This implicitely assumies it is dealing with a hugetlbfs page. Today, it
> > is the case that an inode-based futex with PageCompound is a hugetlbfs
> > page but that could change in the future if THP ever backs files. This
> > would then break again except it would be harder to fix because THP pages
> > can be collapsed underneath you after the futex key has been generated.
> >
> > As this problem is hugetlbfs-specific should the fix be firmly in
> hugetlbfs
> 
> I think we should do.
> Eg, user applications want high performance, they may use DPDK  which using
> hugetlbfs.
> 
> 
> Should I rework the patch like the following code, and test it?
> 

Yes please, making sure to fix the bug Thomas pointed out.

-- 
Mel Gorman
SUSE Labs
