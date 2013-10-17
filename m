Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3JQNug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:50:36 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:57716 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755327Ab3JQNue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:50:34 -0400
Date: Thu, 17 Oct 2013 08:48:27 -0500
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave@sr71.net>, Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] vmsplice: unmap gifted pages for recipient
Message-ID: <20131017134827.GB19741@linux.vnet.ibm.com>
Mail-Followup-To: Vlastimil Babka <vbabka@suse.cz>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Rik van Riel <riel@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, Dave Hansen <dave@sr71.net>,
	Matt Helsley <matt.helsley@gmail.com>,
	Anthony Liguori <anthony@codemonkey.ws>,
	Michael Roth <mdroth@linux.vnet.ibm.com>,
	Lei Li <lilei@linux.vnet.ibm.com>,
	Leonardo Garcia <lagarcia@linux.vnet.ibm.com>
References: <1381177293-27125-1-git-send-email-rcj@linux.vnet.ibm.com>
 <1381177293-27125-2-git-send-email-rcj@linux.vnet.ibm.com>
 <525FB9EE.3070609@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525FB9EE.3070609@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101713-1396-0000-0000-000003B9491C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vlastimil Babka (vbabka@suse.cz) wrote:
> On 10/07/2013 10:21 PM, Robert C Jennings wrote:
> > Introduce use of the unused SPLICE_F_MOVE flag for vmsplice to zap
> > pages.
> > 
> > When vmsplice is called with flags (SPLICE_F_GIFT | SPLICE_F_MOVE) the
> > writer's gift'ed pages would be zapped.  This patch supports further work
> > to move vmsplice'd pages rather than copying them.  That patch has the
> > restriction that the page must not be mapped by the source for the move,
> > otherwise it will fall back to copying the page.
> > 
> > Signed-off-by: Matt Helsley <matt.helsley@gmail.com>
> > Signed-off-by: Robert C Jennings <rcj@linux.vnet.ibm.com>
> > ---
> > Since the RFC went out I have coalesced the zap_page_range() call to
> > operate on VMAs rather than calling this for each page.  For a 256MB
> > vmsplice this reduced the write side 50% from the RFC.
> > ---
> >  fs/splice.c            | 51 +++++++++++++++++++++++++++++++++++++++++++++++++-
> >  include/linux/splice.h |  1 +
> >  2 files changed, 51 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/splice.c b/fs/splice.c
> > index 3b7ee65..a62d61e 100644
> > --- a/fs/splice.c
> > +++ b/fs/splice.c
> > @@ -188,12 +188,17 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
> >  {
> >  	unsigned int spd_pages = spd->nr_pages;
> >  	int ret, do_wakeup, page_nr;
> > +	struct vm_area_struct *vma;
> > +	unsigned long user_start, user_end;
> >  
> >  	ret = 0;
> >  	do_wakeup = 0;
> >  	page_nr = 0;
> > +	vma = NULL;
> > +	user_start = user_end = 0;
> >  
> >  	pipe_lock(pipe);
> > +	down_read(&current->mm->mmap_sem);
> 
> Seems like you could take the mmap_sem only when GIFT and MOVE is set.
> Maybe it won't help that much for performance but at least serve as
> documenting the reason it's needed?
> 
> Vlastimil
> 

I had been doing that previously but moving this outside the loop and
acquiring it once did improve performance.  I'll add a comment on
down_read() as to the reason for taking this though.

-Rob

> >  	for (;;) {
> >  		if (!pipe->readers) {
> > @@ -212,8 +217,44 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
> >  			buf->len = spd->partial[page_nr].len;
> >  			buf->private = spd->partial[page_nr].private;
> >  			buf->ops = spd->ops;
> > -			if (spd->flags & SPLICE_F_GIFT)
> > +			if (spd->flags & SPLICE_F_GIFT) {
> > +				unsigned long useraddr =
> > +						spd->partial[page_nr].useraddr;
> > +
> > +				if ((spd->flags & SPLICE_F_MOVE) &&
> > +						!buf->offset &&
> > +						(buf->len == PAGE_SIZE)) {
> > +					/* Can move page aligned buf, gather
> > +					 * requests to make a single
> > +					 * zap_page_range() call per VMA
> > +					 */
> > +					if (vma && (useraddr == user_end) &&
> > +						   ((useraddr + PAGE_SIZE) <=
> > +						    vma->vm_end)) {
> > +						/* same vma, no holes */
> > +						user_end += PAGE_SIZE;
> > +					} else {
> > +						if (vma)
> > +							zap_page_range(vma,
> > +								user_start,
> > +								(user_end -
> > +								 user_start),
> > +								NULL);
> > +						vma = find_vma_intersection(
> > +								current->mm,
> > +								useraddr,
> > +								(useraddr +
> > +								 PAGE_SIZE));
> > +						if (!IS_ERR_OR_NULL(vma)) {
> > +							user_start = useraddr;
> > +							user_end = (useraddr +
> > +								    PAGE_SIZE);
> > +						} else
> > +							vma = NULL;
> > +					}
> > +				}
> >  				buf->flags |= PIPE_BUF_FLAG_GIFT;
> > +			}
> >  
> >  			pipe->nrbufs++;
> >  			page_nr++;
> > @@ -255,6 +296,10 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
> >  		pipe->waiting_writers--;
> >  	}
> >  
> > +	if (vma)
> > +		zap_page_range(vma, user_start, (user_end - user_start), NULL);
> > +
> > +	up_read(&current->mm->mmap_sem);
> >  	pipe_unlock(pipe);
> >  
> >  	if (do_wakeup)
> > @@ -485,6 +530,7 @@ fill_it:
> >  
> >  		spd.partial[page_nr].offset = loff;
> >  		spd.partial[page_nr].len = this_len;
> > +		spd.partial[page_nr].useraddr = index << PAGE_CACHE_SHIFT;
> >  		len -= this_len;
> >  		loff = 0;
> >  		spd.nr_pages++;
> > @@ -656,6 +702,7 @@ ssize_t default_file_splice_read(struct file *in, loff_t *ppos,
> >  		this_len = min_t(size_t, vec[i].iov_len, res);
> >  		spd.partial[i].offset = 0;
> >  		spd.partial[i].len = this_len;
> > +		spd.partial[i].useraddr = (unsigned long)vec[i].iov_base;
> >  		if (!this_len) {
> >  			__free_page(spd.pages[i]);
> >  			spd.pages[i] = NULL;
> > @@ -1475,6 +1522,8 @@ static int get_iovec_page_array(const struct iovec __user *iov,
> >  
> >  			partial[buffers].offset = off;
> >  			partial[buffers].len = plen;
> > +			partial[buffers].useraddr = (unsigned long)base;
> > +			base = (void*)((unsigned long)base + PAGE_SIZE);
> >  
> >  			off = 0;
> >  			len -= plen;
> > diff --git a/include/linux/splice.h b/include/linux/splice.h
> > index 74575cb..56661e3 100644
> > --- a/include/linux/splice.h
> > +++ b/include/linux/splice.h
> > @@ -44,6 +44,7 @@ struct partial_page {
> >  	unsigned int offset;
> >  	unsigned int len;
> >  	unsigned long private;
> > +	unsigned long useraddr;
> >  };
> >  
> >  /*
> > 
> 

