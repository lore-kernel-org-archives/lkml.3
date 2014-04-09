Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351AbaDIUzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:55:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36576 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010AbaDIUzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:55:31 -0400
Date: Wed, 9 Apr 2014 22:55:29 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 06/22] Replace XIP read and write with DAX I/O
Message-ID: <20140409205529.GO32103@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <3ebe329d8713f7db4c105021a845316a47a29797.1395591795.git.matthew.r.wilcox@intel.com>
 <20140408175600.GE2713@quack.suse.cz>
 <20140408202102.GB5727@linux.intel.com>
 <20140409091450.GA32103@quack.suse.cz>
 <20140409151908.GD5727@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409151908.GD5727@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 09-04-14 11:19:08, Matthew Wilcox wrote:
> On Wed, Apr 09, 2014 at 11:14:50AM +0200, Jan Kara wrote:
> > On Tue 08-04-14 16:21:02, Matthew Wilcox wrote:
> > > On Tue, Apr 08, 2014 at 07:56:00PM +0200, Jan Kara wrote:
> > > > > +static void dax_new_buf(void *addr, unsigned size, unsigned first,
> > > > > +					loff_t offset, loff_t end, int rw)
> > > > > +{
> > > > > +	loff_t final = end - offset + first; /* The final byte of the buffer */
> > > > > +	if (rw != WRITE) {
> > > > > +		memset(addr, 0, size);
> > > > > +		return;
> > > > > +	}
> > > >   It seems counterintuitive to zero out "on-disk" blocks (it seems you'd do
> > > > this for unwritten blocks) when reading from them. Presumably it could also
> > > > have undesired effects on endurance of persistent memory. Instead I'd expect
> > > > that you simply zero out user provided buffer the same way as you do it for
> > > > holes.
> > > 
> > > I think we have to zero it here, because the second time we call
> > > get_block() for a given block, it won't be BH_New any more, so we won't
> > > know that it's supposed to be zeroed.
> >   But how can you have BH_New buffer when you didn't ask get_blocks() to
> > create any block? That would be a bug in the get_blocks() implementation...
> > Or am I missing something?
> 
> Oh ... right.  So just to be clear, we're looking at the case where
> we're doing a read of a filesystem block which is BH_Unwritten, but
> isn't a hole ... so it's been allocated on storage and not yet written.
> That's already treated as a hole:
> 
>                         if (rw == WRITE) {
> ...
>                         } else {
>                                 hole = !buffer_written(bh);
>                         }
> 
> and dax_new_buf is only called in the !hole case.
  Ah, my bad. But then dax_new_buf() won't ever be called for rw != WRITE.
get_blocks() cannot ever return BH_New buffer when 'create' argument was 0.

> > > > > +	if ((flags & DIO_LOCKING) && (rw == READ)) {
> > > > > +		struct address_space *mapping = inode->i_mapping;
> > > > > +		mutex_lock(&inode->i_mutex);
> > > > > +		retval = filemap_write_and_wait_range(mapping, offset, end - 1);
> > > > > +		if (retval) {
> > > > > +			mutex_unlock(&inode->i_mutex);
> > > > > +			goto out;
> > > > > +		}
> > > >   Is there a reason for this? I'd assume DAX has no pages in pagecache...
> > > 
> > > There will be pages in the page cache for holes that we page faulted on.
> > > They must go!  :-)
> >   Well, but this will only writeback dirty pages and if I read the code
> > correctly those pages will never be dirty since dax_mkwrite() will replace
> > them. Or am I missing something?
> 
> In addition to writing back dirty pages, filemap_write_and_wait_range()
> will evict clean pages.  Unintuitive, I know, but it matches what the
> direct I/O path does.  Plus, if we fall back to buffered I/O for holes
> (see above), then this will do the right thing at that time.
  Ugh, I'm pretty certain filemap_write_and_wait_range() doesn't evict
anything ;). Direct IO path calls that function so that direct IO read
after buffered write returns the written data. In that case we don't evict
anything from page cache because direct IO read doesn't invalidate any
information we have cached. Only direct IO write does that and for that we
call invalidate_inode_pages2_range() after writing the pages. So I maintain
that what you do doesn't make sense to me. You might need to do some
invalidation of hole pages. But note that generic_file_direct_write() does
that for you and even though that isn't serialized in any way with page
faults which can instantiate the hole pages again, things should work out
fine for you since that function also invalidates the range again after
->direct_IO callback is done. So AFAICT you don't have to do anything
except writing some nice comment about this ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
