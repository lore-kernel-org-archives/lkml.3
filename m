Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168Ab3GZPQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:16:36 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:35794 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab3GZPQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:16:33 -0400
Date: Fri, 26 Jul 2013 10:16:21 -0500
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/2] vmsplice unmap gifted pages for recipient
Message-ID: <20130726151621.GA5037@linux.vnet.ibm.com>
Mail-Followup-To: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Rik van Riel <riel@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Matt Helsley <matt.helsley@gmail.com>,
	Anthony Liguori <aliguori@us.ibm.com>,
	Michael Roth <mdroth@linux.vnet.ibm.com>,
	Lei Li <lilei@linux.vnet.ibm.com>,
	Leonardo Garcia <lagarcia@linux.vnet.ibm.com>
References: <1374772906-21511-1-git-send-email-rcj@linux.vnet.ibm.com>
 <1374772906-21511-2-git-send-email-rcj@linux.vnet.ibm.com>
 <51F160A5.2040004@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F160A5.2040004@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072615-3864-0000-0000-00000946A75E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Hansen (dave@sr71.net) wrote:
> On 07/25/2013 10:21 AM, Robert Jennings wrote:
> > +static void zap_buf_page(unsigned long useraddr)
> > +{
> > +	struct vm_area_struct *vma;
> > +
> > +	down_read(&current->mm->mmap_sem);
> > +	vma = find_vma_intersection(current->mm, useraddr,
> > +			useraddr + PAGE_SIZE);
> > +	if (!IS_ERR_OR_NULL(vma))
> > +		zap_page_range(vma, useraddr, PAGE_SIZE, NULL);
> > +	up_read(&current->mm->mmap_sem);
> > +}
> > +
> >  /**
> >   * splice_to_pipe - fill passed data into a pipe
> >   * @pipe:	pipe to fill
> > @@ -212,8 +224,16 @@ ssize_t splice_to_pipe(struct pipe_inode_info *pipe,
> >  			buf->len = spd->partial[page_nr].len;
> >  			buf->private = spd->partial[page_nr].private;
> >  			buf->ops = spd->ops;
> > -			if (spd->flags & SPLICE_F_GIFT)
> > +			if (spd->flags & SPLICE_F_GIFT) {
> > +				unsigned long useraddr =
> > +						spd->partial[page_nr].useraddr;
> > +
> > +				if ((spd->flags & SPLICE_F_MOVE) &&
> > +				    !buf->offset && (buf->len == PAGE_SIZE))
> > +					/* Can move page aligned buf */
> > +					zap_buf_page(useraddr);
> >  				buf->flags |= PIPE_BUF_FLAG_GIFT;
> > +			}
> 
> There isn't quite enough context here, but is it going to do this
> zap_buf_page() very often?  Seems a bit wasteful to do the up/down and
> find_vma() every trip through the loop.

The call to zap_buf_page() is in a loop where each pipe buffer is being
processed, but in that loop we have a pipe_wait() where we schedule().
So as things are structured I don't have the ability to hold mmap_sem
for multiple find_vma() calls.

