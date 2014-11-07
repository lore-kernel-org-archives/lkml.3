Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaKGE1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 23:27:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:46584 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaKGE1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 23:27:42 -0500
Message-ID: <545C4A36.9050702@oracle.com>
Date: Thu, 06 Nov 2014 23:27:34 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: mm: shmem: freeing mlocked page
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel, I've stumbled on the following spew:

[ 1441.564471] BUG: Bad page state in process trinity-c612  pfn:12593a
[ 1441.564476] page:ffffea0006e175c0 count:0 mapcount:0 mapping:          (null) index:
0x49
[ 1441.564488] flags: 0xafffff8028000c(referenced|uptodate|swapbacked|mlocked)
[ 1441.564491] page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
[ 1441.564493] bad because of flags:
[ 1441.564498] flags: 0x200000(mlocked)
[ 1441.564503] Modules linked in:
[ 1441.564511] CPU: 2 PID: 11657 Comm: trinity-c612 Not tainted 3.18.0-rc3-next-20141106-sasha-00054-g09b7ccf-dirty #1447
[ 1441.564519]  0000000000000000 0000000000000000 1ffffffff3b44e48 ffff8805c969b868
[ 1441.564526]  ffffffff9c085024 0000000000000000 ffffea0006e175c0 ffff8805c969b898
[ 1441.564532]  ffffffff925fd0a1 ffffea0006e17628 dfffe90000000000 0000000000000000
[ 1441.564534] Call Trace:
[ 1441.568496] dump_stack (lib/dump_stack.c:52)
[ 1441.568516] bad_page (mm/page_alloc.c:338)
[ 1441.568523] free_pages_prepare (mm/page_alloc.c:649 mm/page_alloc.c:755)
[ 1441.568531] free_hot_cold_page (mm/page_alloc.c:1436)
[ 1441.568541] free_hot_cold_page_list (mm/page_alloc.c:1482 (discriminator 3))
[ 1441.568555] release_pages (mm/swap.c:961)
[ 1441.568566] __pagevec_release (include/linux/pagevec.h:44 mm/swap.c:978)
[ 1441.568579] shmem_undo_range (include/linux/pagevec.h:69 mm/shmem.c:451)
[ 1441.568591] shmem_truncate_range (mm/shmem.c:546)
[ 1441.568599] shmem_fallocate (include/linux/spinlock.h:309 mm/shmem.c:2092)
[ 1441.568612] ? __sb_start_write (fs/super.c:1208)
[ 1441.568622] ? __sb_start_write (fs/super.c:1208)
[ 1441.568633] do_fallocate (fs/open.c:297)
[ 1441.568648] SyS_madvise (mm/madvise.c:332 mm/madvise.c:381 mm/madvise.c:531 mm/madvise.c:462)
[ 1441.568660] ? syscall_trace_enter_phase1 (include/linux/context_tracking.h:27 arch/x86/kernel/ptrace.c:1486)
[ 1441.568672] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)

I'm slightly confused here, because the page is mapcount==0, not LOCKED but still MLOCKED...

Thanks,
Sasha
