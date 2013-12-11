Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab3LKU06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 15:26:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab3LKU0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 15:26:41 -0500
Date: Wed, 11 Dec 2013 21:26:39 +0100
From: Jan Kara <jack@suse.cz>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: Jan Kara <jack@suse.cz>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: why does index in truncate_inode_pages_range() grows so much ?
Message-ID: <20131211202639.GE1163@quack.suse.cz>
References: <529217CD.1000204@gmx.de>
 <20131203140214.GB31128@quack.suse.cz>
 <529E3450.9000700@gmx.de>
 <20131203230058.GA24037@quack.suse.cz>
 <20131204130639.GA31973@quack.suse.cz>
 <52A36389.7010103@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52A36389.7010103@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 07-12-13 19:06:01, Toralf Förster wrote:
> On 12/04/2013 02:06 PM, Jan Kara wrote:
> >   One idea: Can you add
> > WARN_ON(offset > 10000000);
> >   into mm/filemap.c:add_to_page_cache_locked() ? That should tell us
> > whether someone is indeed inserting pages with strange indices into page
> > cache or if page->index got somehow corrupted.
> > 
> >  								Honza
> >> > 
> 
> With this diff :
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b7749a9..e95d90c 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -463,6 +463,7 @@ int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
> 
>         VM_BUG_ON(!PageLocked(page));
>         VM_BUG_ON(PageSwapBacked(page));
> +       WARN_ON(offset > 10000000);
> 
>         error = mem_cgroup_cache_charge(page, current->mm,
>                                         gfp_mask & GFP_RECLAIM_MASK);
> 
> 
> 
> I do get such things :
> 
> Dec  7 18:01:29 trinity tfoerste: M=1
> Dec  7 18:01:36 trinity kernel: type=1006 audit(1386435689.994:3): pid=1260 uid=0 old auid=4294967295 new auid=1000 old ses=4294967295 new ses=2 res=1
> Dec  7 18:01:42 trinity kernel: warning: process `trinity-child0' used the deprecated sysctl system call with
> Dec  7 18:01:42 trinity kernel: VFS: Warning: trinity-child0 using old stat() call. Recompile your binary.
> Dec  7 18:01:44 trinity kernel: ------------[ cut here ]------------
> Dec  7 18:01:44 trinity kernel: WARNING: CPU: 0 PID: 1478 at mm/filemap.c:466 add_to_page_cache_locked+0x34/0xf0()
> Dec  7 18:01:44 trinity kernel: CPU: 0 PID: 1478 Comm: trinity-child0 Not tainted 3.13.0-rc3-dirty #16
> Dec  7 18:01:44 trinity kernel: Stack:
> Dec  7 18:01:44 trinity kernel: 084c0773 084c0773 49be7ca8 00000004 085d0547 49be0000 00000000 084ce2d4
> Dec  7 18:01:44 trinity kernel: 49be7cb8 08425f7f 00000000 00000000 49be7cf0 0807d43b 084cc244 00000000
> Dec  7 18:01:44 trinity kernel: 000005c6 084ce2d4 000001d2 080cb714 080cb714 000001d2 49be7cfc 0b811b60
> Dec  7 18:01:44 trinity kernel: Call Trace:
> Dec  7 18:01:44 trinity kernel: [<08425f7f>] dump_stack+0x26/0x28
> Dec  7 18:01:44 trinity kernel: [<0807d43b>] warn_slowpath_common+0x7b/0xa0
> Dec  7 18:01:44 trinity kernel: [<080cb714>] ? add_to_page_cache_locked+0x34/0xf0
> Dec  7 18:01:44 trinity kernel: [<080cb714>] ? add_to_page_cache_locked+0x34/0xf0
> Dec  7 18:01:44 trinity kernel: [<0807d503>] warn_slowpath_null+0x23/0x30
> Dec  7 18:01:44 trinity kernel: [<080cb714>] add_to_page_cache_locked+0x34/0xf0
> Dec  7 18:01:44 trinity kernel: [<080cb7fb>] add_to_page_cache_lru+0x2b/0x50
> Dec  7 18:01:44 trinity kernel: [<080cd38b>] generic_file_aio_read+0x57b/0x710
> Dec  7 18:01:44 trinity kernel: [<081035ee>] do_sync_read+0x6e/0xa0
> Dec  7 18:01:44 trinity kernel: [<08104199>] vfs_read+0xa9/0x180
> Dec  7 18:01:44 trinity kernel: [<081047cc>] SyS_pread64+0x6c/0xa0
> Dec  7 18:01:44 trinity kernel: [<08062a94>] handle_syscall+0x64/0x80
> Dec  7 18:01:44 trinity kernel: [<083d8831>] ? ptrace+0x31/0x80
> Dec  7 18:01:44 trinity kernel: [<0807a072>] ? get_fp_registers+0x22/0x40
> Dec  7 18:01:44 trinity kernel: [<080750f5>] userspace+0x475/0x5f0
> Dec  7 18:01:44 trinity kernel: [<083d8831>] ? ptrace+0x31/0x80
> Dec  7 18:01:44 trinity kernel: [<0807a5d6>] ? os_set_thread_area+0x26/0x40
> Dec  7 18:01:44 trinity kernel: [<080795a0>] ? do_set_thread_area+0x20/0x50
> Dec  7 18:01:44 trinity kernel: [<08079718>] ? arch_switch_tls+0xb8/0x100
> Dec  7 18:01:44 trinity kernel: [<0805f750>] fork_handler+0x60/0x70
> Dec  7 18:01:44 trinity kernel:
> Dec  7 18:01:44 trinity kernel: ---[ end trace 7ce562aa9f07d154 ]---
  Thanks! So this works more or less as expected - trinity issued a read at
absurdly high offset so we created pagecache page a that offset and tried
to read data into it. That failed. We left the page in the pagecache where
it was for reclaim to reclaim it when free pages are needed. Everything
works as designed except we could possibly argue that it's not the most
efficient way to use pages...

Patch 'vfs: fix a bug when we do some dio reads with append dio writes'
(http://www.spinics.net/lists/linux-fsdevel/msg70899.html) should actually
change the situation and we won't unnecessarily cache these pages.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
