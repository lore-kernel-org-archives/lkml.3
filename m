Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761764AbbA1Eol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:44:41 -0500
Received: from mail.kernel.org ([198.145.29.136]:40347 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964955AbbA1EXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:23:30 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wang Nan <wangnan0@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 112/177] cgroup/kmemleak: add kmemleak_free() for cgroup deallocations.
Date: Wed, 28 Jan 2015 12:09:30 +0800
Message-Id: <1422418236-12852-203-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wang Nan <wangnan0@huawei.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 401507d67d5c2854f5a88b3f93f64fc6f267bca5 upstream.

Commit ff7ee93f4715 ("cgroup/kmemleak: Annotate alloc_page() for cgroup
allocations") introduces kmemleak_alloc() for alloc_page_cgroup(), but
corresponding kmemleak_free() is missing, which makes kmemleak be
wrongly disabled after memory offlining.  Log is pasted at the end of
this commit message.

This patch add kmemleak_free() into free_page_cgroup().  During page
offlining, this patch removes corresponding entries in kmemleak rbtree.
After that, the freed memory can be allocated again by other subsystems
without killing kmemleak.

  bash # for x in 1 2 3 4; do echo offline > /sys/devices/system/memory/memory$x/state ; sleep 1; done ; dmesg | grep leak

  Offlined Pages 32768
  kmemleak: Cannot insert 0xffff880016969000 into the object search tree (overlaps existing)
  CPU: 0 PID: 412 Comm: sleep Not tainted 3.17.0-rc5+ #86
  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
  Call Trace:
    dump_stack+0x46/0x58
    create_object+0x266/0x2c0
    kmemleak_alloc+0x26/0x50
    kmem_cache_alloc+0xd3/0x160
    __sigqueue_alloc+0x49/0xd0
    __send_signal+0xcb/0x410
    send_signal+0x45/0x90
    __group_send_sig_info+0x13/0x20
    do_notify_parent+0x1bb/0x260
    do_exit+0x767/0xa40
    do_group_exit+0x44/0xa0
    SyS_exit_group+0x17/0x20
    system_call_fastpath+0x16/0x1b

  kmemleak: Kernel memory leak detector disabled
  kmemleak: Object 0xffff880016900000 (size 524288):
  kmemleak:   comm "swapper/0", pid 0, jiffies 4294667296
  kmemleak:   min_count = 0
  kmemleak:   count = 0
  kmemleak:   flags = 0x1
  kmemleak:   checksum = 0
  kmemleak:   backtrace:
        log_early+0x63/0x77
        kmemleak_alloc+0x4b/0x50
        init_section_page_cgroup+0x7f/0xf5
        page_cgroup_init+0xc5/0xd0
        start_kernel+0x333/0x408
        x86_64_start_reservations+0x2a/0x2c
        x86_64_start_kernel+0xf5/0xfc

Fixes: ff7ee93f4715 (cgroup/kmemleak: Annotate alloc_page() for cgroup allocations)
Signed-off-by: Wang Nan <wangnan0@huawei.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 mm/page_cgroup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 1ccbd71..b7693fd 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -170,6 +170,7 @@ static void free_page_cgroup(void *addr)
 			sizeof(struct page_cgroup) * PAGES_PER_SECTION;
 
 		BUG_ON(PageReserved(page));
+		kmemleak_free(addr);
 		free_pages_exact(addr, table_size);
 	}
 }
-- 
1.9.1

