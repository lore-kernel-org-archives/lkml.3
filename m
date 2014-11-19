Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaKSD4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:56:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaKSD4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:56:31 -0500
Date: Tue, 18 Nov 2014 19:56:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: mm: shmem: freeing mlocked page
Message-Id: <20141118195656.f80ff650.akpm@linux-foundation.org>
In-Reply-To: <546C1202.1020502@oracle.com>
References: <545C4A36.9050702@oracle.com>
	<5466142C.60100@oracle.com>
	<20141118135843.bd711e95d3977c74cf51d803@linux-foundation.org>
	<546C1202.1020502@oracle.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 22:44:02 -0500 Sasha Levin <sasha.levin@oracle.com> wrote:

> On 11/18/2014 04:58 PM, Andrew Morton wrote:
> > On Fri, 14 Nov 2014 09:39:40 -0500 Sasha Levin <sasha.levin@oracle.com> wrote:
> > 
> >>
> >> [ 1026.988043] BUG: Bad page state in process trinity-c374  pfn:23f70
> >> [ 1026.989684] page:ffffea0000b3d300 count:0 mapcount:0 mapping:          (null) index:0x5b
> >> [ 1026.991151] flags: 0x1fffff8028000c(referenced|uptodate|swapbacked|mlocked)
> >> [ 1026.992410] page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> >> [ 1026.993479] bad because of flags:
> >> [ 1026.994125] flags: 0x200000(mlocked)
> > 
> > Gee that new page dumping code is nice!
> > 
> >> [ 1026.994816] Modules linked in:
> >> [ 1026.995378] CPU: 7 PID: 7879 Comm: trinity-c374 Not tainted 3.18.0-rc4-next-20141113-sasha-00047-gd1763ce-dirty #1455
> >> [ 1026.996123] FAULT_INJECTION: forcing a failure.
> >> [ 1026.996123] name failslab, interval 100, probability 30, space 0, times -1
> >> [ 1026.999050]  0000000000000000 0000000000000000 0000000000b3d300 ffff88061295bbd8
> >> [ 1027.000676]  ffffffff92f71097 0000000000000000 ffffea0000b3d300 ffff88061295bc08
> >> [ 1027.002020]  ffffffff8197ef7a ffffea0000b3d300 ffffffff942dd148 dfffe90000000000
> >> [ 1027.003359] Call Trace:
> >> [ 1027.003831] dump_stack (lib/dump_stack.c:52)
> >> [ 1027.004725] bad_page (mm/page_alloc.c:338)
> >> [ 1027.005623] free_pages_prepare (mm/page_alloc.c:657 mm/page_alloc.c:763)
> >> [ 1027.006761] free_hot_cold_page (mm/page_alloc.c:1438)
> >> [ 1027.007772] ? __page_cache_release (mm/swap.c:66)
> >> [ 1027.008815] put_page (mm/swap.c:270)
> >> [ 1027.009665] page_cache_pipe_buf_release (fs/splice.c:93)
> >> [ 1027.010888] __splice_from_pipe (fs/splice.c:784 fs/splice.c:886)
> >> [ 1027.011917] ? might_fault (./arch/x86/include/asm/current.h:14 mm/memory.c:3734)
> >> [ 1027.012856] ? pipe_lock (fs/pipe.c:69)
> >> [ 1027.013728] ? write_pipe_buf (fs/splice.c:1534)
> >> [ 1027.014756] vmsplice_to_user (fs/splice.c:1574)
> >> [ 1027.015725] ? rcu_read_lock_held (kernel/rcu/update.c:169)
> >> [ 1027.016757] ? __fget_light (include/linux/fdtable.h:80 fs/file.c:684)
> >> [ 1027.017782] SyS_vmsplice (fs/splice.c:1656 fs/splice.c:1639)
> >> [ 1027.018863] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)
> >>
> > 
> > So what happened here?  Userspace fed some mlocked memory into splice()
> > and then, while splice() was running, userspace dropped its reference
> > to the memory, leaving splice() with the last reference.  Yet somehow,
> > that page was still marked as being mlocked.  I wouldn't expect the
> > kernel to permit userspace to drop its reference to the memory without
> > first clearing the mlocked state.
> > 
> > Is it possible to work out from trinity sources what the exact sequence
> > was?  Which syscalls are being used, for example?
> 
> Trinity can't really log anything because attempts to log syscalls slow everything
> down to a crawl to the point nothing reproduces.

Ah.  I was thinking that it could be worked out by looking at the
trinity source around where it calls splice().  But I suspect that
doesn't make sense if trinity just creates a zillion threads each of
which sprays semi-random syscalls at the kernel(?).


> I've just looked at that trace above, and got a bit more confused. I didn't think
> that you can mlock page cache. How would a user do that exactly?

mmap it then mlock it!  The kernel will fault everything in for you
then pin it down.
