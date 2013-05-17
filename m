Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab3EQWVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:21:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913Ab3EQVhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Li Zefan <lizfan@huawei.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 028/102] shm: fix null pointer deref when userspace specifies invalid hugepage size
Date: Fri, 17 May 2013 14:35:43 -0700
Message-Id: <20130517213247.320521488@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 091d0d55b286c9340201b4ed4470be87fc568228 upstream.

Dave reported an oops triggered by trinity:

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
  IP: newseg+0x10d/0x390
  PGD cf8c1067 PUD cf8c2067 PMD 0
  Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
  CPU: 2 PID: 7636 Comm: trinity-child2 Not tainted 3.9.0+#67
  ...
  Call Trace:
    ipcget+0x182/0x380
    SyS_shmget+0x5a/0x60
    tracesys+0xdd/0xe2

This bug was introduced by commit af73e4d9506d ("hugetlbfs: fix mmap
failure in unaligned size request").

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Li Zefan <lizfan@huawei.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/shm.c |    8 +++++++-
 mm/mmap.c |    8 ++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -493,7 +493,13 @@ static int newseg(struct ipc_namespace *
 	if (shmflg & SHM_HUGETLB) {
 		struct hstate *hs = hstate_sizelog((shmflg >> SHM_HUGE_SHIFT)
 						& SHM_HUGE_MASK);
-		size_t hugesize = ALIGN(size, huge_page_size(hs));
+		size_t hugesize;
+
+		if (!hs) {
+			error = -EINVAL;
+			goto no_file;
+		}
+		hugesize = ALIGN(size, huge_page_size(hs));
 
 		/* hugetlb_file_setup applies strict accounting */
 		if (shmflg & SHM_NORESERVE)
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1331,9 +1331,13 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned lon
 			len = ALIGN(len, huge_page_size(hstate_file(file)));
 	} else if (flags & MAP_HUGETLB) {
 		struct user_struct *user = NULL;
+		struct hstate *hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) &
+						   SHM_HUGE_MASK);
 
-		len = ALIGN(len, huge_page_size(hstate_sizelog(
-			(flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK)));
+		if (!hs)
+			return -EINVAL;
+
+		len = ALIGN(len, huge_page_size(hs));
 		/*
 		 * VM_NORESERVE is used because the reservations will be
 		 * taken when vm_ops->mmap() is called


