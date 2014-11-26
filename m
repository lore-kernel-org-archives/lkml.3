Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaKZWs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 17:48:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaKZWss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 17:48:48 -0500
Date: Wed, 26 Nov 2014 14:48:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [patch] fs, seq_file: fallback to vmalloc instead of oom kill
 processes
Message-Id: <20141126144846.d7a3ec1a2a0c20d9cb1a7c49@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.10.1411261434080.13014@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1411261415500.13014@chino.kir.corp.google.com>
	<20141126142404.bc6b03387d5e869908db5e38@linux-foundation.org>
	<alpine.DEB.2.10.1411261434080.13014@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014 14:40:06 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> On Wed, 26 Nov 2014, Andrew Morton wrote:
> 
> > You forgot something.
> > 
> > --- a/fs/seq_file.c~fs-seq_file-fallback-to-vmalloc-instead-of-oom-kill-processes-fix
> > +++ a/fs/seq_file.c
> > @@ -36,6 +36,10 @@ static void *seq_buf_alloc(unsigned long
> >  {
> >  	void *buf;
> >  
> > +	/*
> > +	 * __GFP_NORETRY to avoid oom-killings with high-order allocations -
> > +	 * it's better to fall back to vmalloc() than to kill things.
> > +	 */
> >  	buf = kmalloc(size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
> >  	if (!buf && size > PAGE_SIZE)
> >  		buf = vmalloc(size);
> > 
> 
> ...
>
> The slowpath tries to allocate, calls memory compaction if necessary, 
> tries to allocate, calls direct reclaim, tries to allocate, call the oom 
> killer and tries to allocate if we are going to loop, and then loop if 
> allowed.  There's no need to try to allocate if we don't call the oom 
> killer since it won't succeed and there's no need to call the oom killer 
> to free memory if we aren't going to retry.

My concern is that an open-coded __GFP_NORETRY is very obscure.  Even
something like

#define __GFP_NO_OOM_KILL __GFP_NORETRY

would help make things a bit self-documenting.

> Even if __GFP_NO_OOM_KILL existed, it wouldn't be applicable to this 
> patch: the change here is that seqfile will now return -ENOMEM instead of 
> oom killing processes;

Not really?  The change makes seq_buf_alloc() fall back to vmalloc()
rather than killing things.  Doesn't it?

Unless the allocation is < PAGE_SIZE, in which case we do go ENOMEM. 
That's daft - it would be better to vmalloc() a whole page in this
case.  Not that the vmalloc is likely to be successful anyway..

> the slab allocation will no longer loop forever 
> trying to allocate memory.
