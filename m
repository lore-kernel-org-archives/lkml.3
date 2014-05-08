Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaEHJ1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:27:35 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:32667 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751516AbaEHJ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:27:32 -0400
Date: Thu, 8 May 2014 10:26:46 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [BUG] kmemleak on __radix_tree_preload
Message-ID: <20140508092646.GA17349@arm.com>
References: <1398390340.4283.36.camel@kjgkr>
 <20140501170610.GB28745@arm.com>
 <20140501184112.GH23420@cmpxchg.org>
 <1399431488.13268.29.camel@kjgkr>
 <20140507113928.GB17253@arm.com>
 <1399540611.13268.45.camel@kjgkr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399540611.13268.45.camel@kjgkr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 06:16:51PM +0900, Jaegeuk Kim wrote:
> 2014-05-07 (수), 12:39 +0100, Catalin Marinas:
> > On Wed, May 07, 2014 at 03:58:08AM +0100, Jaegeuk Kim wrote:
> > > unreferenced object 0xffff880004226da0 (size 576):
> > >   comm "fsstress", pid 14590, jiffies 4295191259 (age 706.308s)
> > >   hex dump (first 32 bytes):
> > >     01 00 00 00 81 ff ff ff 00 00 00 00 00 00 00 00  ................
> > >     50 89 34 81 ff ff ff ff b8 6d 22 04 00 88 ff ff  P.4......m".....
> > >   backtrace:
> > >     [<ffffffff816c02e8>] kmemleak_update_trace+0x58/0x80
> > >     [<ffffffff81349517>] radix_tree_node_alloc+0x77/0xa0
> > >     [<ffffffff81349718>] __radix_tree_create+0x1d8/0x230
> > >     [<ffffffff8113286c>] __add_to_page_cache_locked+0x9c/0x1b0
> > >     [<ffffffff811329a8>] add_to_page_cache_lru+0x28/0x80
> > >     [<ffffffff81132f58>] grab_cache_page_write_begin+0x98/0xf0
> > >     [<ffffffffa02e4bf4>] f2fs_write_begin+0xb4/0x3c0 [f2fs]
> > >     [<ffffffff81131b77>] generic_perform_write+0xc7/0x1c0
> > >     [<ffffffff81133b7d>] __generic_file_aio_write+0x1cd/0x3f0
> > >     [<ffffffff81133dfe>] generic_file_aio_write+0x5e/0xe0
> > >     [<ffffffff81195c5a>] do_sync_write+0x5a/0x90
> > >     [<ffffffff811968d2>] vfs_write+0xc2/0x1d0
> > >     [<ffffffff81196daf>] SyS_write+0x4f/0xb0
> > >     [<ffffffff816dead2>] system_call_fastpath+0x16/0x1b
> > >     [<ffffffffffffffff>] 0xffffffffffffffff
> > 
> > OK, it shows that the allocation happens via add_to_page_cache_locked()
> > and I guess it's page_cache_tree_insert() which calls
> > __radix_tree_create() (the latter reusing the preloaded node). I'm not
> > familiar enough to this code (radix-tree.c and filemap.c) to tell where
> > the node should have been freed, who keeps track of it.
> > 
> > At a quick look at the hex dump (assuming that the above leak is struct
> > radix_tree_node):
> > 
> > 	.path = 1
> > 	.count = -0x7f (or 0xffffff81 as unsigned int)
> > 	union {
> > 		{
> > 			.parent = NULL
> > 			.private_data = 0xffffffff81348950
> > 		}
> > 		{
> > 			.rcu_head.next = NULL
> > 			.rcu_head.func = 0xffffffff81348950
> > 		}
> > 	}
> > 
> > The count is a bit suspicious.
> > 
> > From the union, it looks most likely like rcu_head information. Is
> > radix_tree_node_rcu_free() function at the above rcu_head.func?

Thanks for the config. Could you please confirm that 0xffffffff81348950
address corresponds to the radix_tree_node_rcu_free() function in your
System.map (or something else)?

> > Also, if you run echo scan > /sys/kernel/debug/kmemleak a few times, do
> > any of the above leaks disappear (in case the above are some transient
> > rcu freeing reports; normally this shouldn't happen as the objects are
> > still referred but I'll look at the relevant code once I have your
> > .config).
> 
> Once I run the echo, the leaks are still remained.

OK, so they aren't just transient.

Thanks.

-- 
Catalin
