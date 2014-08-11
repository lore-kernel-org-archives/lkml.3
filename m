Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbaHKPZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 11:25:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43645 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbaHKPZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 11:25:05 -0400
Date: Mon, 11 Aug 2014 17:25:01 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 07/22] Replace the XIP page fault handler with the DAX
 page fault handler
Message-ID: <20140811152501.GA12279@quack.suse.cz>
References: <20140409214331.GQ32103@quack.suse.cz>
 <20140729121259.GL6754@linux.intel.com>
 <20140729210457.GA17807@quack.suse.cz>
 <20140729212333.GO6754@linux.intel.com>
 <20140730095229.GA19205@quack.suse.cz>
 <20140809110000.GA32313@linux.intel.com>
 <20140811085147.GB29526@quack.suse.cz>
 <20140811141308.GZ6754@linux.intel.com>
 <20140811143500.GF29526@quack.suse.cz>
 <20140811150205.GA6754@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811150205.GA6754@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11-08-14 11:02:05, Matthew Wilcox wrote:
> On Mon, Aug 11, 2014 at 04:35:00PM +0200, Jan Kara wrote:
> > On Mon 11-08-14 10:13:08, Matthew Wilcox wrote:
> > > On Mon, Aug 11, 2014 at 10:51:47AM +0200, Jan Kara wrote:
> > > > So I'm afraid we'll have to find some other way to synchronize
> > > > page faults and truncate / punch hole in DAX.
> > > 
> > > What if we don't?  If we hit the race (which is vanishingly unlikely with
> > > real applications), the consequence is simply that after a truncate, a
> > > file may be left with one or two blocks allocated somewhere after i_size.
> > > As I understand it, that's not a real problem; they're temporarily
> > > unavailable for allocation but will be freed on file removal or the next
> > > truncation of that file.
> >   You mean if you won't have any locking between page fault and truncate?
> > You can have:
> > a) extending truncate making forgotten blocks with non-zeros visible
> > b) filesystem corruption due to doubly used blocks (block will be freed
> > from the truncated file and thus can be reallocated but it will still be
> > accessible via mmap from the truncated file).
> > 
> >   So not a good idea.
> 
> Not *no* locking ... just no locking around get_block, like in v7.
> So check i_size, call get_block, lock i_mmap_mutex, re-check i_size,
> insert mapping if i_size is OK, drop i_mmap_mutex.  As long as get_block()
> has enough locking of its own against set_size and concurrent calls
> to get_block(), I don't think we can get visible non-zeroes or double
> allocation.
  Ah, right. Now I remember. Yes, that solution will only occasionally
leave allocated blocks beyond EOF. That may be acceptable especially if we
mark the file with some flag and truncate those blocks after file is closed
in ext4_release_file().

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
