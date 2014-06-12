Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbaFLGwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:52:36 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46845 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbaFLGwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:52:34 -0400
Date: Wed, 11 Jun 2014 23:52:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ian Kent <raven@themaw.net>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Thorsten Diehl <thorsten.diehl@de.ibm.com>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/2] fs: proc/stat: use usual seq_file ops rather than
 single_open
In-Reply-To: <1402554262.2642.16.camel@perseus.fritz.box>
Message-ID: <alpine.DEB.2.02.1406112350010.23724@chino.kir.corp.google.com>
References: <20140521122521.GB7471@osiris> <20140521143229.GA32011@infradead.org> <20140528085841.GA4219@osiris> <20140528090153.GC4219@osiris> <20140528153704.b2a3f46dc39ebf8f681d528a@linux-foundation.org> <1402301519.2775.47.camel@perseus.fritz.box>
 <20140611124301.GC4296@osiris> <alpine.DEB.2.02.1406111524330.27885@chino.kir.corp.google.com> <1402554262.2642.16.camel@perseus.fritz.box>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Ian Kent wrote:

> > > diff --git a/fs/seq_file.c b/fs/seq_file.c
> > > index 1d641bb108d2..fca78a04c0d1 100644
> > > --- a/fs/seq_file.c
> > > +++ b/fs/seq_file.c
> > > @@ -8,8 +8,10 @@
> > >  #include <linux/fs.h>
> > >  #include <linux/export.h>
> > >  #include <linux/seq_file.h>
> > > +#include <linux/vmalloc.h>
> > >  #include <linux/slab.h>
> > >  #include <linux/cred.h>
> > > +#include <linux/mm.h>
> > >  
> > >  #include <asm/uaccess.h>
> > >  #include <asm/page.h>
> > > @@ -82,6 +84,31 @@ int seq_open(struct file *file, const struct seq_operations *op)
> > >  }
> > >  EXPORT_SYMBOL(seq_open);
> > >  
> > > +static void seq_alloc(struct seq_file *m)
> > > +{
> > > +	m->size = PAGE_SIZE;
> > > +	m->buf = kmalloc(m->size, GFP_KERNEL | __GFP_NOWARN);
> > > +	if (!m->buf)
> > > +		m->buf = vmalloc(m->size);
> > > +}
> > > +
> > 
> > If m->size is unconditionally PAGE_SIZE, then how is vmalloc() going to 
> > allocate this if kmalloc() fails?
> 
> This is just the initial allocation.
> If it runs out of room the allocation size doubles.
> 
> I think 2*PAGE_SIZE is probably better here since that's closer to what
> the original heuristic allocation requested and is likely to avoid
> reallocations in most cases.
> 
> The issue of kmalloc() failing for larger allocations on low speced
> hardware with fragmented memory might succeed when vmalloc() is used
> since it doesn't require contiguous memory chunks. But I guess the added
> pressure on the page table might still be a problem, nevertheless it's
> probably worth trying before bailing out. 
> 

I'm not quarreling about using vmalloc() for allocations that are 
high-order, I'm referring to the rather obvious fact that m->size is set 
to PAGE_SIZE unconditionally above and thus vmalloc() isn't going to help 
in the slightest.
