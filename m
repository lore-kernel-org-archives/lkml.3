Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140Ab3GQRys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:54:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934115Ab3GQRvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:51:01 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 14/23] perf tools: Add perf data version 3 header swap
Date: Wed, 17 Jul 2013 19:49:54 +0200
Message-Id: <1374083403-14591-15-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf data version 3 header swap same way
as it's done for v2.

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
 tools/perf/util/header.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 3f97ae1..5df73da 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2564,13 +2564,28 @@ static int swap_header_v2(struct perf_file_header *header)
 	return 0;
 }
 
-static int swap_header(struct perf_file_header *header)
+static int swap_header_v3(struct perf_file_header *header)
+{
+	struct perf_file_header_v3 *v3 = &header->v3;
+
+	mem_bswap_64(v3, offsetof(struct perf_file_header_v3,
+		     adds_features));
+
+	swap_features(v3->adds_features);
+	return 0;
+}
+
+static int swap_header(struct perf_header *ph,
+		       struct perf_file_header *header)
 {
 	/* swap the generic part */
 	mem_bswap_64(header, offsetof(struct perf_file_header, v2));
 
 	/* version specific swap */
-	return swap_header_v2(header);
+	if (ph->version <= PERF_HEADER_VERSION_2)
+		return swap_header_v2(header);
+
+	return swap_header_v3(header);
 }
 
 int perf_file_header__read(struct perf_file_header *header,
@@ -2590,7 +2605,7 @@ int perf_file_header__read(struct perf_file_header *header,
 		return -1;
 	}
 
-	return ph->needs_swap ? swap_header(header) : 0;
+	return ph->needs_swap ? swap_header(ph, header) : 0;
 }
 
 static int perf_file_section__process(struct perf_file_section *section,
-- 
1.7.11.7

