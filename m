Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab3BZFcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 00:32:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:47234 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab3BZFc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 00:32:29 -0500
X-IronPort-AV: E=Sophos;i="4.84,738,1355068800"; 
   d="scan'208";a="6769882"
Message-ID: <512C4881.90409@cn.fujitsu.com>
Date: Tue, 26 Feb 2013 13:30:41 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Simon Horman <horms@verge.net.au>
CC: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/2] kexec: Use min_t to simplify logic
References: <512C44E4.70907@cn.fujitsu.com>
In-Reply-To: <512C44E4.70907@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 13:31:32,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/26 13:31:33,
	Serialize complete at 2013/02/26 13:31:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a tweak: using min_t to simplify logic of variable
assignments.

v3:
- cast type of (PAGE_SIZE - (maddr & ~PAGE_MASK)) into size_t.

v2:
- Rewrite patch description as Simon suggested.
- Fix an inappropriate if test introduced by v1. Thanks Simon.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 kernel/kexec.c |   24 ++++++++----------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 3cbfcc7..b6b16f9 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -822,13 +822,9 @@ static int kimage_load_normal_segment(struct kimage *image,
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
+		mchunk = min_t(size_t, mbytes,
+			       (size_t)(PAGE_SIZE - (maddr & ~PAGE_MASK)));
+		uchunk = min_t(size_t, ubytes, mchunk);
 
 		result = copy_from_user(ptr, buf, uchunk);
 		kunmap(page);
@@ -874,13 +870,10 @@ static int kimage_load_crash_segment(struct kimage *image,
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
+		mchunk = min_t(size_t, mbytes,
+			       (size_t)(PAGE_SIZE - (maddr & ~PAGE_MASK)));
+		uchunk = min_t(size_t, ubytes, mchunk);
+		if (mchunk > uchunk) {
 			/* Zero the trailing part of the page */
 			memset(ptr + uchunk, 0, mchunk - uchunk);
 		}
@@ -1461,8 +1454,7 @@ void vmcoreinfo_append_str(const char *fmt, ...)
 	r = vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 
-	if (r + vmcoreinfo_size > vmcoreinfo_max_size)
-		r = vmcoreinfo_max_size - vmcoreinfo_size;
+	r = min_t(size_t, r, vmcoreinfo_max_size - vmcoreinfo_size);
 
 	memcpy(&vmcoreinfo_data[vmcoreinfo_size], buf, r);
 
-- 
1.7.1
