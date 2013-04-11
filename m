Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935320Ab3DKMs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:48:59 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:34351 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004Ab3DKMs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:48:58 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] fs: fix differed error reporting
Date: Thu, 11 Apr 2013 16:47:59 +0400
Message-Id: <1365684479-29187-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two convenient ways to report errors to userspace
1) retun error to original syscall for example write(2)
2) mark mapping with error flag and return it on later fsync(2)

Second one is broken if (mapping->nrpages == 0)
This is real-life situation because after error pages are likey
to be truncated or invalidated.

We have to return an error regardless to number of pages in the mapping.

#Original testcase: git@github.com:dmonakhov/xfstests.git
MOUNT_OPTIONS="-b1024"
./check shared/305

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 mm/filemap.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index e1979fd..ca47f0b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -184,6 +184,17 @@ static int sleep_on_page_killable(void *word)
 	return fatal_signal_pending(current) ? -EINTR : 0;
 }
 
+static int filemap_check_errors(struct address_space *mapping)
+{
+	int ret = 0;
+	/* Check for outstanding write errors */
+	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
+		ret = -ENOSPC;
+	if (test_and_clear_bit(AS_EIO, &mapping->flags))
+		ret = -EIO;
+	return ret;
+}
+
 /**
  * __filemap_fdatawrite_range - start writeback on mapping dirty pages in range
  * @mapping:	address space structure to write
@@ -265,10 +276,10 @@ int filemap_fdatawait_range(struct address_space *mapping, loff_t start_byte,
 	pgoff_t end = end_byte >> PAGE_CACHE_SHIFT;
 	struct pagevec pvec;
 	int nr_pages;
-	int ret = 0;
+	int ret2, ret = 0;
 
 	if (end_byte < start_byte)
-		return 0;
+		goto out;
 
 	pagevec_init(&pvec, 0);
 	while ((index <= end) &&
@@ -291,12 +302,10 @@ int filemap_fdatawait_range(struct address_space *mapping, loff_t start_byte,
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-
-	/* Check for outstanding write errors */
-	if (test_and_clear_bit(AS_ENOSPC, &mapping->flags))
-		ret = -ENOSPC;
-	if (test_and_clear_bit(AS_EIO, &mapping->flags))
-		ret = -EIO;
+out:
+	ret2 = filemap_check_errors(mapping);
+	if (!ret)
+		ret = ret2;
 
 	return ret;
 }
@@ -337,6 +346,8 @@ int filemap_write_and_wait(struct address_space *mapping)
 			if (!err)
 				err = err2;
 		}
+	} else {
+		err = filemap_check_errors(mapping);
 	}
 	return err;
 }
@@ -368,6 +379,8 @@ int filemap_write_and_wait_range(struct address_space *mapping,
 			if (!err)
 				err = err2;
 		}
+	} else {
+		err = filemap_check_errors(mapping);
 	}
 	return err;
 }
-- 
1.7.1

