Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaLRGdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 01:33:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58792 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaLRGdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 01:33:19 -0500
Date: Wed, 17 Dec 2014 22:32:44 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-i44zs02xt4zexfxywpklo7km@git.kernel.org>
Cc: fweisbec@gmail.com, mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        eranian@google.com, efault@gmx.de, bp@suse.de, acme@redhat.com,
        jolsa@redhat.com, dzickus@redhat.com, peterz@infradead.org,
        hpa@zytor.com, adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        namhyung@kernel.org, dsahern@gmail.com
Reply-To: paulus@samba.org, tglx@linutronix.de, mingo@kernel.org, bp@suse.de,
        efault@gmx.de, eranian@google.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        dsahern@gmail.com, namhyung@kernel.org, jolsa@redhat.com,
        acme@redhat.com, hpa@zytor.com, peterz@infradead.org,
        dzickus@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools: Adopt roundup_pow_of_two
Git-Commit-ID: bd1857948e7667313f9a7bee9b2492c0848174a6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd1857948e7667313f9a7bee9b2492c0848174a6
Gitweb:     http://git.kernel.org/tip/bd1857948e7667313f9a7bee9b2492c0848174a6
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 16 Dec 2014 13:19:23 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 17 Dec 2014 11:58:15 -0300

tools: Adopt roundup_pow_of_two

To replace equivalent code used in the mmap_pages command line
parameter handling in tools/perf.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-i44zs02xt4zexfxywpklo7km@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/linux/log2.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/tools/include/linux/log2.h b/tools/include/linux/log2.h
index 990b138..4144666 100644
--- a/tools/include/linux/log2.h
+++ b/tools/include/linux/log2.h
@@ -48,6 +48,15 @@ bool is_power_of_2(unsigned long n)
 }
 
 /*
+ * round up to nearest power of two
+ */
+static inline __attribute__((const))
+unsigned long __roundup_pow_of_two(unsigned long n)
+{
+	return 1UL << fls_long(n - 1);
+}
+
+/*
  * round down to nearest power of two
  */
 static inline __attribute__((const))
@@ -141,6 +150,22 @@ unsigned long __rounddown_pow_of_two(unsigned long n)
 	__ilog2_u64(n)				\
  )
 
+/**
+ * roundup_pow_of_two - round the given value up to nearest power of two
+ * @n - parameter
+ *
+ * round the given value up to the nearest power of two
+ * - the result is undefined when n == 0
+ * - this can be used to initialise global variables from constant data
+ */
+#define roundup_pow_of_two(n)			\
+(						\
+	__builtin_constant_p(n) ? (		\
+		(n == 1) ? 1 :			\
+		(1UL << (ilog2((n) - 1) + 1))	\
+				   ) :		\
+	__roundup_pow_of_two(n)			\
+ )
 
 /**
  * rounddown_pow_of_two - round the given value down to nearest power of two
