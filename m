Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaHILAH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 07:00:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:13703 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbaHILAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 07:00:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,832,1400050800"; 
   d="scan'208";a="574165397"
Date: Sat, 9 Aug 2014 07:00:00 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 07/22] Replace the XIP page fault handler with the DAX
 page fault handler
Message-ID: <20140809110000.GA32313@linux.intel.com>
References: <cover.1395591795.git.matthew.r.wilcox@intel.com>
 <c2e602f401a580c4fac54b9b8f4a6f8dd0ac1071.1395591795.git.matthew.r.wilcox@intel.com>
 <20140409102758.GM32103@quack.suse.cz>
 <20140409205111.GG5727@linux.intel.com>
 <20140409214331.GQ32103@quack.suse.cz>
 <20140729121259.GL6754@linux.intel.com>
 <20140729210457.GA17807@quack.suse.cz>
 <20140729212333.GO6754@linux.intel.com>
 <20140730095229.GA19205@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730095229.GA19205@quack.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 11:52:29AM +0200, Jan Kara wrote:
>   I see the problem now. How about an attached patch? Do you see other
> lockdep warnings with it?

Hit another one :-(  Same inversion between i_mmap_mutex and jbd2_handle:

 -> #1 (&mapping->i_mmap_mutex){+.+...}:
        [<ffffffff810cfa12>] lock_acquire+0xb2/0x1f0
        [<ffffffff815cb5e5>] mutex_lock_nested+0x75/0x420
        [<ffffffff811bc0ff>] rmap_walk+0x6f/0x390
        [<ffffffff811bc5a9>] page_mkclean+0x69/0x90
        [<ffffffff81189c10>] clear_page_dirty_for_io+0x60/0x120
        [<ffffffffa01d1017>] mpage_submit_page+0x47/0x80 [ext4]
        [<ffffffffa01d1160>] mpage_process_page_bufs+0x110/0x120 [ext4]
        [<ffffffffa01d16f0>] mpage_prepare_extent_to_map+0x1f0/0x2f0 [ext4]
        [<ffffffffa01d6e57>] ext4_writepages+0x427/0x1060 [ext4]
        [<ffffffff8118c211>] do_writepages+0x21/0x40
        [<ffffffff8117e909>] __filemap_fdatawrite_range+0x59/0x60
        [<ffffffff8117ea0d>] filemap_write_and_wait_range+0x2d/0x70
        [<ffffffffa01cd7d8>] ext4_sync_file+0x118/0x490 [ext4]
        [<ffffffff8122dd2b>] vfs_fsync_range+0x1b/0x30
        [<ffffffff811b99ad>] SyS_msync+0x1ed/0x250

(ext4_writepages starts a transaction before calling
mpage_prepare_extent_to_map)
