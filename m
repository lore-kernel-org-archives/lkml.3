Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013Ab3IHDT3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56014 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756210Ab3IHDSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "yonghua zheng" <younghua.zheng@gmail.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.3729887@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [072/121] fs/proc/task_mmu.c: fix buffer overflow in add_page_map()
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: yonghua zheng <younghua.zheng@gmail.com>

commit 8c8296223f3abb142be8fc31711b18a704c0e7d8 upstream.

Recently we met quite a lot of random kernel panic issues after enabling
CONFIG_PROC_PAGE_MONITOR.  After debuggind we found this has something
to do with following bug in pagemap:

In struct pagemapread:

  struct pagemapread {
      int pos, len;
      pagemap_entry_t *buffer;
      bool v2;
  };

pos is number of PM_ENTRY_BYTES in buffer, but len is the size of
buffer, it is a mistake to compare pos and len in add_page_map() for
checking buffer is full or not, and this can lead to buffer overflow and
random kernel panic issue.

Correct len to be total number of PM_ENTRY_BYTES in buffer.

[akpm@linux-foundation.org: document pagemapread.pos and .len units, fix PM_ENTRY_BYTES definition]
Signed-off-by: Yonghua Zheng <younghua.zheng@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2:
 - Adjust context
 - There is no pagemap_entry_t definition; keep using u64]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/proc/task_mmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -604,7 +604,7 @@ const struct file_operations proc_clear_
 };
 
 struct pagemapread {
-	int pos, len;
+	int pos, len;		/* units: PM_ENTRY_BYTES, not bytes */
 	u64 *buffer;
 };
 
@@ -792,8 +792,8 @@ static ssize_t pagemap_read(struct file
 	if (!count)
 		goto out_task;
 
-	pm.len = PM_ENTRY_BYTES * (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
-	pm.buffer = kmalloc(pm.len, GFP_TEMPORARY);
+	pm.len = (PAGEMAP_WALK_SIZE >> PAGE_SHIFT);
+	pm.buffer = kmalloc(pm.len * PM_ENTRY_BYTES, GFP_TEMPORARY);
 	ret = -ENOMEM;
 	if (!pm.buffer)
 		goto out_task;

