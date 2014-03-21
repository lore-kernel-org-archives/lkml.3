Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621AbaCUBIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:08:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965211AbaCUAEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Boyer <jwboyer@fedoraproject.org>
Subject: [PATCH 3.13 096/149] mm/readahead.c: fix do_readahead() for no readpage(s)
Date: Thu, 20 Mar 2014 17:04:19 -0700
Message-Id: <20140321000440.279414488@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 58d5640ebdb273cc817b0d0cda7bcf2efbbc2ff7 upstream.

Commit 63d0f0a3c7e1 ("mm/readahead.c:do_readhead(): don't check for
->readpage") unintentionally made do_readahead return 0 for all valid
files regardless of whether readahead was supported, rather than the
expected -EINVAL.  This gets forwarded on to userspace, and results in
sys_readahead appearing to succeed in cases that don't make sense (e.g.
when called on pipes or sockets).  This issue is detected by the LTP
readahead01 testcase.

As the exact return value of force_page_cache_readahead is currently
never used, we can simplify it to return only 0 or -EINVAL (when
readpage or readpages is missing).  With that in place we can simply
forward on the return value of force_page_cache_readahead in
do_readahead.

This patch performs said change, restoring the expected semantics.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/readahead.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

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
 
@@ -226,15 +224,13 @@ int force_page_cache_readahead(struct ad
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
@@ -576,8 +572,7 @@ do_readahead(struct address_space *mappi
 	if (!mapping || !mapping->a_ops)
 		return -EINVAL;
 
-	force_page_cache_readahead(mapping, filp, index, nr);
-	return 0;
+	return force_page_cache_readahead(mapping, filp, index, nr);
 }
 
 SYSCALL_DEFINE3(readahead, int, fd, loff_t, offset, size_t, count)


