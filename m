Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933998Ab3GQRut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:50:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933699Ab3GQRup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:50:45 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 08/23] perf tools: Introduce perf data file version CHECK macro
Date: Wed, 17 Jul 2013 19:49:48 +0200
Message-Id: <1374083403-14591-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing perf data file version CHECK macro, so the check
is easily extensible for new versions.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/header.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f558f83..4ebe4a1 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2493,18 +2493,23 @@ static int check_magic_endian(u64 magic, uint64_t hdr_sz,
 	 * - encode endianness of file
 	 */
 
-	/* check magic number with one endianness */
-	if (magic == __perf_magic2)
-		return 0;
-
-	/* check magic number with opposite endianness */
-	if (magic != __perf_magic2_sw)
-		return -1;
+#define CHECK(__m, __v)						\
+do {								\
+	/* check magic number with one endianness */		\
+	if (magic == __m)					\
+		goto v ## __v;					\
+	/* check magic number with opposite endianness */	\
+	if (magic != __m ## _sw)				\
+		break;						\
+	ph->needs_swap = true;					\
+ v ## __v:							\
+	ph->version = __v;					\
+	return 0;						\
+} while (0)
+
+	CHECK(__perf_magic2, PERF_HEADER_VERSION_2);
 
-	ph->needs_swap = true;
-	ph->version = PERF_HEADER_VERSION_2;
-
-	return 0;
+	return -1;
 }
 
 int perf_file_header__read(struct perf_file_header *header,
-- 
1.7.11.7

