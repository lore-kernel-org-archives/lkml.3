Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934137Ab3GQRvF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:51:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934124Ab3GQRvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:51:02 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 10/23] perf tools: Introduce swap_header function
Date: Wed, 17 Jul 2013 19:49:50 +0200
Message-Id: <1374083403-14591-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing swap_header function to make the swapping
code more clear and extensible.

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
 tools/perf/util/header.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4d82dac..eb50de8 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2545,6 +2545,22 @@ static void swap_features(unsigned long *adds_features)
 	}
 }
 
+static int swap_header(struct perf_file_header *header)
+{
+	mem_bswap_64(header, offsetof(struct perf_file_header, adds_features));
+
+	if (header->size != sizeof(*header)) {
+		/* Support the previous format */
+		if (header->size == offsetof(typeof(*header), adds_features))
+			bitmap_zero(header->adds_features, HEADER_FEAT_BITS);
+		else
+			return -1;
+	} else
+		swap_features(header->adds_features);
+
+	return 0;
+}
+
 int perf_file_header__read(struct perf_file_header *header,
 			   struct perf_header *ph, int fd)
 {
@@ -2562,19 +2578,8 @@ int perf_file_header__read(struct perf_file_header *header,
 		return -1;
 	}
 
-	if (ph->needs_swap) {
-		mem_bswap_64(header, offsetof(struct perf_file_header,
-			     adds_features));
-	}
-
-	if (header->size != sizeof(*header)) {
-		/* Support the previous format */
-		if (header->size == offsetof(typeof(*header), adds_features))
-			bitmap_zero(header->adds_features, HEADER_FEAT_BITS);
-		else
-			return -1;
-	} else if (ph->needs_swap)
-		swap_features(header->adds_features);
+	if (ph->needs_swap && swap_header(header))
+		return -1;
 
 	memcpy(&ph->adds_features, &header->adds_features,
 	       sizeof(ph->adds_features));
-- 
1.7.11.7

