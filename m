Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab3K1Ka5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:30:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab3K1Ka4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:30:56 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/7] perf tools: Fine tune readn function
Date: Thu, 28 Nov 2013 11:30:15 +0100
Message-Id: <1385634619-8129-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
References: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a 'left' variable to make the flow clearer, and added a debug
check for the return value - returning 'n' is more obvious.

Added small comment for readn.

Original-patch-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 9440481..6ea0b4a 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -6,6 +6,7 @@
 #endif
 #include <stdio.h>
 #include <stdlib.h>
+#include <linux/kernel.h>
 
 /*
  * XXX We need to find a better place for these things...
@@ -151,21 +152,26 @@ unsigned long convert_unit(unsigned long value, char *unit)
 	return value;
 }
 
+/*
+ * Read exactly 'n' bytes or return an error.
+ */
 ssize_t readn(int fd, void *buf, size_t n)
 {
 	void *buf_start = buf;
+	size_t left = n;
 
-	while (n) {
-		ssize_t ret = read(fd, buf, n);
+	while (left) {
+		ssize_t ret = read(fd, buf, left);
 
 		if (ret <= 0)
 			return ret;
 
-		n -= ret;
-		buf += ret;
+		left -= ret;
+		buf  += ret;
 	}
 
-	return buf - buf_start;
+	BUG_ON((size_t)(buf - buf_start) != n);
+	return n;
 }
 
 size_t hex_width(u64 v)
-- 
1.8.3.1

