Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab3LBUtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:49:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54065 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305Ab3LBUtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:49:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/12] perf tools: Fine tune readn function
Date: Mon,  2 Dec 2013 17:49:00 -0300
Message-Id: <1386017349-24486-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386017349-24486-1-git-send-email-acme@infradead.org>
References: <1386017349-24486-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Added a 'left' variable to make the flow clearer, and added a debug
check for the return value - returning 'n' is more obvious.

Added small comment for readn.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Original-patch-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1385634619-8129-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 9440481e9092..6ea0b4ae9569 100644
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
1.8.1.4

