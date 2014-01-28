Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaA1LO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 06:14:29 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36440 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754198AbaA1LO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 06:14:28 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Rutland <mark.rutland@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: readahead: fix do_readahead for no readpage(s)
Date: Tue, 28 Jan 2014 11:14:19 +0000
Message-Id: <1390907659-11675-1-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 63d0f0a3c7e1 (mm/readahead.c:do_readhead(): don't check for
->readpage) unintentionally made do_readahead return 0 for all valid
files regardless of whether readahead was supported, rather than the
expected -EINVAL. This gets forwarded on to userspace, and results in
sys_readahead appearing to succeed in cases that don't make sense (e.g.
when called on pipes or sockets). This issue is detected by the LTP
readahead01 testcase.

As the exact return value of force_page_cache_readahead is currently
never used, we can simplify it to return only 0 or -EINVAL (when
readpage or readpages is missing). With that in place we can simply
forward on the return value of force_page_cache_readahead in
do_readahead.

This patch performs said change, restoring the expected semantics.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/readahead.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 7cdbb44..0de2360d 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -211,8 +211,6 @@ out:
 int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 		pgoff_t offset, unsigned long nr_to_read)
 {
-	int ret = 0;
-
 	if (unlikely(!mapping->a_ops->readpage && !mapping->a_ops->readpages))
 		return -EINVAL;
 
@@ -226,15 +224,13 @@ int force_page_cache_readahead(struct address_space *mapping, struct file *filp,
 			this_chunk = nr_to_read;
 		err = __do_page_cache_readahead(mapping, filp,
 						offset, this_chunk, 0);
-		if (err < 0) {
-			ret = err;
-			break;
-		}
-		ret += err;
+		if (err < 0)
+			return err;
+
 		offset += this_chunk;
 		nr_to_read -= this_chunk;
 	}
-	return ret;
+	return 0;
 }
 
 /*
@@ -576,8 +572,7 @@ do_readahead(struct address_space *mapping, struct file *filp,
 	if (!mapping || !mapping->a_ops)
 		return -EINVAL;
 
-	force_page_cache_readahead(mapping, filp, index, nr);
-	return 0;
+	return force_page_cache_readahead(mapping, filp, index, nr);
 }
 
 SYSCALL_DEFINE3(readahead, int, fd, loff_t, offset, size_t, count)
-- 
1.8.1.1

