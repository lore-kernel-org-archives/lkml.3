Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbbAMWr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 17:47:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbbAMWrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 17:47:55 -0500
Date: Tue, 13 Jan 2015 14:47:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v12 08/20] dax,ext2: Replace the XIP page fault handler
 with the DAX page fault handler
Message-Id: <20150113144753.ea2658cdf1a78e1b8cbdb576@linux-foundation.org>
In-Reply-To: <20150113215334.GK5661@wil.cx>
References: <1414185652-28663-1-git-send-email-matthew.r.wilcox@intel.com>
	<1414185652-28663-9-git-send-email-matthew.r.wilcox@intel.com>
	<20150112150952.b44ee750a6292284e7a909ff@linux-foundation.org>
	<20150113215334.GK5661@wil.cx>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015 16:53:34 -0500 Matthew Wilcox <willy@linux.intel.com> wrote:

> /*
>  * Lock ordering in mm:
>  *
>  * inode->i_mutex       (while writing or truncating, not reading or faulting)
>  *   mm->mmap_sem
> 
> > >  	   In the worst case, the file still has blocks
> > > +	 * allocated past the end of the file.
> > > +	 */
> > > +	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> > > +	if (unlikely(vmf->pgoff >= size)) {
> > > +		error = -EIO;
> > > +		goto out;
> > > +	}
> > 
> > How does this play with holepunching?  Checking i_size won't work there?
> 
> It doesn't.  But the same problem exists with non-DAX files too, and
> when I pointed it out, it was met with a shrug from the crowd.  I saw a
> patch series just recently that fixes it for XFS, but as far as I know,
> btrfs and ext4 still don't play well with pagefault vs hole-punch races.

What are the user-visible effects of the race?

> > > +	memset(&bh, 0, sizeof(bh));
> > > +	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - blkbits);
> > > +	bh.b_size = PAGE_SIZE;
> > 
> > ah, there.
> > 
> > PAGE_SIZE varies a lot between architectures.  What are the
> > implications of this>?
> 
> At the moment, you can only do DAX for blocksizes that are equal to
> PAGE_SIZE.  That's a restriction that existed for the previous XIP code,
> and I haven't fixed it all for DAX yet.  I'd like to, but it's not high on
> my list of things to fix.  Since these are in-mmeory filesystems, there's
> not likely to be high demand to move the filesystem between machines.

hm, I guess not.

This means that our users will need to mkfs their filesystems with
blocksize==pagesize.  The "error: unsupported blocksize for dax" printk
should get the message across, but a mention in
Documentation/filesystems/dax.txt's "Shortcomings" section wouldn't
hurt.

