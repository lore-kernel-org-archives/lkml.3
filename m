Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932833Ab3LDPlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:41:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58272 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932818Ab3LDPlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:41:09 -0500
Date: Wed, 4 Dec 2013 07:40:22 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-838d14520267769648fb2fc2a637107a1d102590@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, efault@gmx.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, efault@gmx.de, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1385634619-8129-4-git-send-email-jolsa@redhat.com>
References: <1385634619-8129-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fine tune readn function
Git-Commit-ID: 838d14520267769648fb2fc2a637107a1d102590
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 04 Dec 2013 07:40:28 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  838d14520267769648fb2fc2a637107a1d102590
Gitweb:     http://git.kernel.org/tip/838d14520267769648fb2fc2a637107a1d102590
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 28 Nov 2013 11:30:15 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Dec 2013 09:22:46 -0300

perf tools: Fine tune readn function

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
