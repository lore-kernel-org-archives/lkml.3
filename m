Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaB1WZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 17:25:07 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:25152 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbaB1WZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 17:25:06 -0500
X-Greylist: delayed 112414 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Feb 2014 17:25:06 EST
Message-ID: <1393625885.6784.106.camel@misato.fc.hp.com>
Subject: Re: [PATCH v6 07/22] Replace the XIP page fault handler with the
 DAX page fault handler
From: Toshi Kani <toshi.kani@hp.com>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Date: Fri, 28 Feb 2014 15:18:05 -0700
In-Reply-To: <20140228202031.GB12820@linux.intel.com>
References: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
	 <1393337918-28265-8-git-send-email-matthew.r.wilcox@intel.com>
	 <1393609771.6784.83.camel@misato.fc.hp.com>
	 <20140228202031.GB12820@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 15:20 -0500, Matthew Wilcox wrote:
> On Fri, Feb 28, 2014 at 10:49:31AM -0700, Toshi Kani wrote:
> > On Tue, 2014-02-25 at 09:18 -0500, Matthew Wilcox wrote:
 :
> Glad to see you're looking at it.  Let me try to help ...

Hi Matt,

Thanks for the help.  This is really a nice work, and I am hoping to
help it... (in some day! :-)

> > The original code,
> > xip_file_fault(), jumps to found: and calls vm_insert_mixed() when
> > get_xip_mem(,,0,,) succeeded.  If get_xip_mem() returns -ENODATA, it
> > calls either get_xip_mem(,,1,,) or xip_sparse_page().  In this new
> > function, it looks to me that get_block(,,,0) returns 0 for both cases
> > (success and -ENODATA previously), which are dealt in the same way.  Is
> > that right?  If so, is there any reason for the change?
> 
> Yes, get_xip_mem() returned -ENODATA for a hole.  That was a suboptimal
> interface because filesystems are actually capable of returning more
> information than that, eg how long the hole is (ext4 *doesn't*, but I
> consider that to be a bug).
> 
> I don't get to decide what the get_block() interface looks like.  It's the
> standard way that the VFS calls back into the filesystem and has been
> around for probably close to twenty years at this point.  I'm still trying
> to understand exactly what the contract is for get_blocks() ... I have
> a document that I'm working on to try to explain it, but it's tough going!

Got it.  Yes, get_block() is a beast for file system newbie like me.
Thanks for working on the document.

> > Also, isn't it
> > possible to call get_block(,,,1) even if get_block(,,,0) found a block?
> 
> The code in question looks like this:
> 
>         error = get_block(inode, block, &bh, 0);
>         if (error || bh.b_size < PAGE_SIZE)
>                 goto sigbus;
> 
>         if (!buffer_written(&bh) && !vmf->cow_page) {
>                 if (vmf->flags & FAULT_FLAG_WRITE) {
>                         error = get_block(inode, block, &bh, 1);
> 
> where buffer_written is defined as:
>         return buffer_mapped(bh) && !buffer_unwritten(bh);
> 
> Doing some boolean algebra, that's:
> 
> 	if (!buffer_mapped || buffer_unwritten)

Oh, I see!  When the first get_block(,,,0) succeeded, this buffer is
mapped.  So, it won't go into this path.

> In either case, we want to tell the filesystem that we're writing to
> this block.  At least, that's my current understanding of the get_block()
> interface.  I'm open to correction here!

Thanks again!
-Toshi

