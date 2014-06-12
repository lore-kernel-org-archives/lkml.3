Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070AbaFLLKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 07:10:05 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49860 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932998AbaFLLJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 07:09:59 -0400
X-Sasl-enc: WFOEXJQHlS8RCl3PBRmTi2Kc44/RbwGaswIOC/Cl8PrI 1402571397
Message-ID: <1402571393.2642.18.camel@perseus.fritz.box>
Subject: Re: [PATCH 2/2] fs: proc/stat: use usual seq_file ops rather than
 single_open
From: Ian Kent <raven@themaw.net>
To: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
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
Date: Thu, 12 Jun 2014 19:09:53 +0800
In-Reply-To: <alpine.DEB.2.02.1406112350010.23724@chino.kir.corp.google.com>
References: <20140521122521.GB7471@osiris>
	 <20140521143229.GA32011@infradead.org> <20140528085841.GA4219@osiris>
	 <20140528090153.GC4219@osiris>
	 <20140528153704.b2a3f46dc39ebf8f681d528a@linux-foundation.org>
	 <1402301519.2775.47.camel@perseus.fritz.box> <20140611124301.GC4296@osiris>
	 <alpine.DEB.2.02.1406111524330.27885@chino.kir.corp.google.com>
	 <1402554262.2642.16.camel@perseus.fritz.box>
	 <alpine.DEB.2.02.1406112350010.23724@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 23:52 -0700, David Rientjes wrote:
> On Thu, 12 Jun 2014, Ian Kent wrote:
> 
> > > > diff --git a/fs/seq_file.c b/fs/seq_file.c
> > > > index 1d641bb108d2..fca78a04c0d1 100644
> > > > --- a/fs/seq_file.c
> > > > +++ b/fs/seq_file.c
> > > > @@ -8,8 +8,10 @@
> > > >  #include <linux/fs.h>
> > > >  #include <linux/export.h>
> > > >  #include <linux/seq_file.h>
> > > > +#include <linux/vmalloc.h>
> > > >  #include <linux/slab.h>
> > > >  #include <linux/cred.h>
> > > > +#include <linux/mm.h>
> > > >  
> > > >  #include <asm/uaccess.h>
> > > >  #include <asm/page.h>
> > > > @@ -82,6 +84,31 @@ int seq_open(struct file *file, const struct seq_operations *op)
> > > >  }
> > > >  EXPORT_SYMBOL(seq_open);
> > > >  
> > > > +static void seq_alloc(struct seq_file *m)
> > > > +{
> > > > +	m->size = PAGE_SIZE;
> > > > +	m->buf = kmalloc(m->size, GFP_KERNEL | __GFP_NOWARN);
> > > > +	if (!m->buf)
> > > > +		m->buf = vmalloc(m->size);
> > > > +}
> > > > +
> > > 
> > > If m->size is unconditionally PAGE_SIZE, then how is vmalloc() going to 
> > > allocate this if kmalloc() fails?
> > 
> > This is just the initial allocation.
> > If it runs out of room the allocation size doubles.
> > 
> > I think 2*PAGE_SIZE is probably better here since that's closer to what
> > the original heuristic allocation requested and is likely to avoid
> > reallocations in most cases.
> > 
> > The issue of kmalloc() failing for larger allocations on low speced
> > hardware with fragmented memory might succeed when vmalloc() is used
> > since it doesn't require contiguous memory chunks. But I guess the added
> > pressure on the page table might still be a problem, nevertheless it's
> > probably worth trying before bailing out. 
> > 
> 
> I'm not quarreling about using vmalloc() for allocations that are 
> high-order, I'm referring to the rather obvious fact that m->size is set 
> to PAGE_SIZE unconditionally above and thus vmalloc() isn't going to help 
> in the slightest.

LOL, yeah, if kmalloc() can't allocate a single page then we're in much
bigger trouble!

Ian


