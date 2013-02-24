Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab3BXOhc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 09:37:32 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55455 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab3BXOhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 09:37:31 -0500
Message-ID: <512A25A1.4040002@gmail.com>
Date: Sun, 24 Feb 2013 22:37:21 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Simon Horman <horms@verge.net.au>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] kexec: Use min_t to simplify logic
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

This is just a tweak: using min_t to simplify logic of variable
assignments.

v2:
- Rewrite patch description as Simon suggested.
- Fix an inappropriate if test introduced by v1. Thanks Simon.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Horman <horms@verge.net.au>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 kernel/kexec.c |   22 ++++++----------------
 1 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 2436ffc..effd655 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -822,13 +822,8 @@ static int kimage_load_normal_segment(struct kimage *image,
 		/* Start with a clear page */
 		clear_page(ptr);
 		ptr += maddr & ~PAGE_MASK;
-		mchunk = PAGE_SIZE - (maddr & ~PAGE_MASK);
-		if (mchunk > mbytes)
-			mchunk = mbytes;
-
-		uchunk = mchunk;
-		if (uchunk > ubytes)
-			uchunk = ubytes;
+		mchunk = min_t(size_t, mbytes, PAGE_SIZE - (maddr & ~PAGE_MASK));
+		uchunk = min_t(size_t, ubytes, mchunk);
 
 		result = copy_from_user(ptr, buf, uchunk);
 		kunmap(page);
@@ -874,13 +869,9 @@ static int kimage_load_crash_segment(struct kimage *image,
 		}
 		ptr = kmap(page);
 		ptr += maddr & ~PAGE_MASK;
-		mchunk = PAGE_SIZE - (maddr & ~PAGE_MASK);
-		if (mchunk > mbytes)
-			mchunk = mbytes;
-
-		uchunk = mchunk;
-		if (uchunk > ubytes) {
-			uchunk = ubytes;
+		mchunk = min_t(size_t, mbytes, PAGE_SIZE - (maddr & ~PAGE_MASK));
+		uchunk = min_t(size_t, ubytes, mchunk);
+		if (mchunk > uchunk) {
 			/* Zero the trailing part of the page */
 			memset(ptr + uchunk, 0, mchunk - uchunk);
 		}
@@ -1461,8 +1452,7 @@ void vmcoreinfo_append_str(const char *fmt, ...)
 	r = vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 
-	if (r + vmcoreinfo_size > vmcoreinfo_max_size)
-		r = vmcoreinfo_max_size - vmcoreinfo_size;
+	r = min_t(size_t, r, vmcoreinfo_max_size - vmcoreinfo_size);
 
 	memcpy(&vmcoreinfo_data[vmcoreinfo_size], buf, r);
 
-- 
1.7.1
