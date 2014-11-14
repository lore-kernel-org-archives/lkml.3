Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965463AbaKNMvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 07:51:42 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50681 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbaKNMvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 07:51:10 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-ce-5465fabb3bbb
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>, Michal Marek <mmarek@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yury Gribov <y.gribov@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: [PATCH v2 1/2] kernel: printk: specify alignment for struct printk_log
Date: Fri, 14 Nov 2014 15:50:45 +0300
Message-id: <1415969446-26356-2-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.1.3
In-reply-to: <1415969446-26356-1-git-send-email-a.ryabinin@samsung.com>
References: <1415969446-26356-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t/xK7q7f6WGGLxq1bLY9usRm8Wc9WvY
	LJ4caGe0mPCwjd1i2kZxi5WdD1gtFrYtYbH4s2sHk8XlXXPYLB7PmsdmcenAAiaLln0XmCyO
	9x5gsnh7ZzqLxeIjt5ktNm+aymzxY8NjVotDnxczOQh57Jx1l91jwaZSj80rtDw2repk83h3
	7hy7x4kZv1k8FvdNZvX4+PQWi8eFrmyP9/uusnn0bVnF6HFmwRF2j8+b5DxOtHxhDeCL4rJJ
	Sc3JLEst0rdL4Mr4dmE1U8F07orV/3cyNjAu5uxi5OCQEDCR+LLdp4uRE8gUk7hwbz1bFyMX
	h5DAUkaJaX1zWSCcPiaJzo03mEGq2AT0JP7N2s4GYosIKEhs7n3GClLELPCWRWLe5rtgRcIC
	/hLbFrcygmxgEVCVWH0sAyTMK+Am0XBrDjvEYjmJreu8QcKcAu4SE6ZfZAGxhYBKJh6+wTSB
	kXcBI8MqRtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJCY+LqDcekxq0OMAhyMSjy8GpmpIUKs
	iWXFlbmHGCU4mJVEeL8/BwrxpiRWVqUW5ccXleakFh9iZOLglGpgjHvwXEz+3aw/2+3MUy8V
	9qic7Q1drbjx3572kO0nT758KqzumTqp+Gujgd7OFzmO57c3hgfJ1h7ltNz9bpk9x3q2eT+j
	YidEW3xm+/n1sVqwwqmz3VeYuOx3Ruz+0x6f/O3uI7uLK7/YRp4PP7329slX8cySITuqe0Qe
	MDZM+NPMb7AjarbyTiWW4oxEQy3mouJEAPP9IW5nAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On architectures that have support for efficient unaligned access
struct printk_log has 4-byte alignment.
Specify alignment attribute in type declaration.

The whole point of this patch is to fix deadlock which happening
when UBSan detects unaligned access in printk() thus UBSan recursively
calls printk() with logbuf_lock held by top printk() call.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 kernel/printk/printk.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ced2b84..39be027 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -223,7 +223,11 @@ struct printk_log {
 	u8 facility;		/* syslog facility */
 	u8 flags:5;		/* internal record flags */
 	u8 level:3;		/* syslog level */
-};
+}
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+__packed __aligned(4)
+#endif
+;
 
 /*
  * The logbuf_lock protects kmsg buffer, indices, counters.  This can be taken
@@ -261,11 +265,7 @@ static u32 clear_idx;
 #define LOG_LINE_MAX		(1024 - PREFIX_MAX)
 
 /* record buffer */
-#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
-#define LOG_ALIGN 4
-#else
 #define LOG_ALIGN __alignof__(struct printk_log)
-#endif
 #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
 static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
-- 
2.1.3

