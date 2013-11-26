Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3KZPXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 10:23:41 -0500
Received: from kanga.kvack.org ([205.233.56.17]:41844 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137Ab3KZPXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 10:23:40 -0500
Date: Tue, 26 Nov 2013 10:23:37 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: GPF in aio_migratepage
Message-ID: <20131126152337.GL15489@kvack.org>
References: <20131126032645.GA32301@redhat.com> <20131126060132.GA6400@redhat.com> <20131126071953.GE9244@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126071953.GE9244@kmo-pixel>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 11:19:53PM -0800, Kent Overstreet wrote:
> On Tue, Nov 26, 2013 at 01:01:32AM -0500, Dave Jones wrote:
> > On Mon, Nov 25, 2013 at 10:26:45PM -0500, Dave Jones wrote:
> >  > Hi Kent,
> >  > 
> >  > I hit the GPF below on a tree based on 8e45099e029bb6b369b27d8d4920db8caff5ecce
> >  > which has your commit e34ecee2ae791df674dfb466ce40692ca6218e43
> >  > ("aio: Fix a trinity splat").  Is this another path your patch missed, or
> >  > a completely different bug to what you were chasing ?
> > 
> > And here's another from a different path, this time on 32bit.

For Dave: what line is this bug on?  Is it the dereference of ctx when 
doing spin_lock_irqsave(&ctx->completion_lock, flags); or is the 
ctx->ring_pages[idx] = new; ?  From the 64 bit splat, I'm thinking the 
former, which is quite strange given that the clearing of 
mapping->private_data is protected by mapping->private_lock.  If it's 
the latter, we might well need to check if ctx->ring_pages is NULL during 
setup. 

Actually, is there easy way to reproduce this with Trinity?  I can have a 
look if you point me in the right direction.

> I'm pretty sure this is a different bug... it appears to be related to
> aio ring buffer migration, which I don't think I've touched.
> 
> Any information on what it was doing at the time? I see exit_aio() in
> the second backtrace, maybe some sort of race between migratepage and
> ioctx teardown? But it is using the address space mapping, so I dunno.

Teardown should be protected by mapping->private_lock (see put_aio_ring_file() 
which takes mapping->private_lock to protect aio_migratepage() against 
accessing the ioctx after releasing the private file for the mapping.

		-ben

> I don't see what's protecting ctx->ring_pages - I imagine it's got to
> have something to do with the page migration machinery but I have no
> idea how that works. Ben?
> > ESI: f68dc508 EDI: deaf4800 EBP: dea23bcc ESP: dea23ba8
> >  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > CR0: 8005003b CR2: 6b6b707b CR3: 2c985000 CR4: 000007f0
> > Stack:
> >  00000000 00000001 deaf4a84 00000286 d709b280 00000000 f68dc508 c11c7955
> >  f6844ed8 dea23c0c c116aa9f 00000001 00000001 c11c7955 c1179a33 00000000
> >  00000000 c114166d f6844ed8 f6844ed8 c1140fc9 dea23c0c 00000000 f6844ed8
> > Call Trace:
> >  [<c11c7955>] ? free_ioctx+0x62/0x62
> >  [<c116aa9f>] move_to_new_page+0x63/0x1bb
> >  [<c11c7955>] ? free_ioctx+0x62/0x62
> >  [<c1179a33>] ? mem_cgroup_prepare_migration+0xc1/0x243
> >  [<c114166d>] ? isolate_migratepages_range+0x3fb/0x675
> >  [<c1140fc9>] ? isolate_freepages_block+0x316/0x316
> >  [<c116b319>] migrate_pages+0x614/0x72b
> >  [<c1140fc9>] ? isolate_freepages_block+0x316/0x316
> >  [<c1141c21>] compact_zone+0x294/0x475
> >  [<c1142065>] try_to_compact_pages+0x129/0x196
> >  [<c15b95e7>] __alloc_pages_direct_compact+0x91/0x197
> >  [<c112a25c>] __alloc_pages_nodemask+0x863/0xa55
> >  [<c116b68f>] get_huge_zero_page+0x52/0xf9
> >  [<c116ef78>] do_huge_pmd_anonymous_page+0x24e/0x39f
> >  [<c1171c4b>] ? __mem_cgroup_count_vm_event+0xa6/0x191
> >  [<c1171c64>] ? __mem_cgroup_count_vm_event+0xbf/0x191
> >  [<c114815c>] handle_mm_fault+0x235/0xd9a
> >  [<c15c7586>] ? __do_page_fault+0xf8/0x5a1
> >  [<c15c75ee>] __do_page_fault+0x160/0x5a1
> >  [<c15c7586>] ? __do_page_fault+0xf8/0x5a1
> >  [<c15c7a2f>] ? __do_page_fault+0x5a1/0x5a1
> >  [<c15c7a3c>] do_page_fault+0xd/0xf
> >  [<c15c4e7c>] error_code+0x6c/0x74
> >  [<c114007b>] ? memcg_update_all_caches+0x23/0x6b
> >  [<c12d0be5>] ? __copy_from_user_ll+0x30/0xdb
> >  [<c12d0ccf>] _copy_from_user+0x3f/0x55
> >  [<c1057aa2>] SyS_setrlimit+0x27/0x50
> >  [<c1044792>] ? SyS_gettimeofday+0x33/0x6d
> >  [<c12d0798>] ? trace_hardirqs_on_thunk+0xc/0x10
> >  [<c15cb33b>] sysenter_do_call+0x12/0x32
> > Code: 6e 8d 8f 84 02 00 00 89 c8 89 4d e4 e8 df bf 3f 00 89 45 e8 89 da 89 f0 e8 99 2b fa ff 8b 43 08 3b 47 54 8b 4d e4 73 06 8b 57 50 <89> 34 82 8b 55 e8 89 c8 e8 aa c1 3f 00 8b 45 ec e8 28 c1 3f 00
> > 

-- 
"Thought is the essence of where you are now."
