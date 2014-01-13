Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaAMQjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:39:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53298 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbaAMQDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 099/208] mm/memory-failure.c: transfer page count from head page to tail page after split thp
Date: Mon, 13 Jan 2014 15:59:00 +0000
Message-Id: <1389628849-1614-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

commit a3e0f9e47d5ef7858a26cc12d90ad5146e802d47 upstream.

Memory failures on thp tail pages cause kernel panic like below:

   mce: [Hardware Error]: Machine check events logged
   MCE exception done on CPU 7
   BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
   IP: [<ffffffff811b7cd1>] dequeue_hwpoisoned_huge_page+0x131/0x1e0
   PGD bae42067 PUD ba47d067 PMD 0
   Oops: 0000 [#1] SMP
  ...
   CPU: 7 PID: 128 Comm: kworker/7:2 Tainted: G   M       O 3.13.0-rc4-131217-1558-00003-g83b7df08e462 #25
  ...
   Call Trace:
     me_huge_page+0x3e/0x50
     memory_failure+0x4bb/0xc20
     mce_process_work+0x3e/0x70
     process_one_work+0x171/0x420
     worker_thread+0x11b/0x3a0
     ? manage_workers.isra.25+0x2b0/0x2b0
     kthread+0xe4/0x100
     ? kthread_create_on_node+0x190/0x190
     ret_from_fork+0x7c/0xb0
     ? kthread_create_on_node+0x190/0x190
  ...
   RIP   dequeue_hwpoisoned_huge_page+0x131/0x1e0
   CR2: 0000000000000058

The reasoning of this problem is shown below:
 - when we have a memory error on a thp tail page, the memory error
   handler grabs a refcount of the head page to keep the thp under us.
 - Before unmapping the error page from processes, we split the thp,
   where page refcounts of both of head/tail pages don't change.
 - Then we call try_to_unmap() over the error page (which was a tail
   page before). We didn't pin the error page to handle the memory error,
   this error page is freed and removed from LRU list.
 - We never have the error page on LRU list, so the first page state
   check returns "unknown page," then we move to the second check
   with the saved page flag.
 - The saved page flag have PG_tail set, so the second page state check
   returns "hugepage."
 - We call me_huge_page() for freed error page, then we hit the above panic.

The root cause is that we didn't move refcount from the head page to the
tail page after split thp.  So this patch suggests to do this.

This panic was introduced by commit 524fca1e73 ("HWPOISON: fix
misjudgement of page_action() for errors on mlocked pages").  Note that we
did have the same refcount problem before this commit, but it was just
ignored because we had only first page state check which returned "unknown
page." The commit changed the refcount problem from "doesn't work" to
"kernel panic."

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 mm/memory-failure.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b4cd46d..e79f395 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -936,6 +936,16 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 				BUG_ON(!PageHWPoison(p));
 				return SWAP_FAIL;
 			}
+			/*
+			 * We pinned the head page for hwpoison handling,
+			 * now we split the thp and we are interested in
+			 * the hwpoisoned raw page, so move the refcount
+			 * to it.
+			 */
+			if (hpage != p) {
+				put_page(hpage);
+				get_page(p);
+			}
 			/* THP is split, so ppage should be the real poisoned page. */
 			ppage = p;
 		}
-- 
1.8.3.2

