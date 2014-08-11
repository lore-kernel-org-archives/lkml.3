Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaHKIvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 04:51:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbaHKIvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 04:51:51 -0400
Date: Mon, 11 Aug 2014 10:51:47 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 07/22] Replace the XIP page fault handler with the DAX
 page fault handler
Message-ID: <20140811085147.GB29526@quack.suse.cz>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <c2e602f401a580c4fac54b9b8f4a6f8dd0ac1071.1395591795.git.matthew.r.wilcox@intel.com>
 <20140409102758.GM32103@quack.suse.cz>
 <20140409205111.GG5727@linux.intel.com>
 <20140409214331.GQ32103@quack.suse.cz>
 <20140729121259.GL6754@linux.intel.com>
 <20140729210457.GA17807@quack.suse.cz>
 <20140729212333.GO6754@linux.intel.com>
 <20140730095229.GA19205@quack.suse.cz>
 <20140809110000.GA32313@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140809110000.GA32313@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 09-08-14 07:00:00, Matthew Wilcox wrote:
> On Wed, Jul 30, 2014 at 11:52:29AM +0200, Jan Kara wrote:
> >   I see the problem now. How about an attached patch? Do you see other
> > lockdep warnings with it?
> 
> Hit another one :-(  Same inversion between i_mmap_mutex and jbd2_handle:
> 
>  -> #1 (&mapping->i_mmap_mutex){+.+...}:
>         [<ffffffff810cfa12>] lock_acquire+0xb2/0x1f0
>         [<ffffffff815cb5e5>] mutex_lock_nested+0x75/0x420
>         [<ffffffff811bc0ff>] rmap_walk+0x6f/0x390
>         [<ffffffff811bc5a9>] page_mkclean+0x69/0x90
>         [<ffffffff81189c10>] clear_page_dirty_for_io+0x60/0x120
>         [<ffffffffa01d1017>] mpage_submit_page+0x47/0x80 [ext4]
>         [<ffffffffa01d1160>] mpage_process_page_bufs+0x110/0x120 [ext4]
>         [<ffffffffa01d16f0>] mpage_prepare_extent_to_map+0x1f0/0x2f0 [ext4]
>         [<ffffffffa01d6e57>] ext4_writepages+0x427/0x1060 [ext4]
>         [<ffffffff8118c211>] do_writepages+0x21/0x40
>         [<ffffffff8117e909>] __filemap_fdatawrite_range+0x59/0x60
>         [<ffffffff8117ea0d>] filemap_write_and_wait_range+0x2d/0x70
>         [<ffffffffa01cd7d8>] ext4_sync_file+0x118/0x490 [ext4]
>         [<ffffffff8122dd2b>] vfs_fsync_range+0x1b/0x30
>         [<ffffffff811b99ad>] SyS_msync+0x1ed/0x250
> 
> (ext4_writepages starts a transaction before calling
> mpage_prepare_extent_to_map)
  Hum, yes, this is difficult. Getting rid of
clear_page_dirty_for_io() when the transaction is started isn't easily
possible :(. So I'm afraid we'll have to find some other way to synchronize
page faults and truncate / punch hole in DAX.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
