Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934060Ab3GQR4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:56:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933916Ab3GQRus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:50:48 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 09/23] perf tools: Introduce swap_features function
Date: Wed, 17 Jul 2013 19:49:49 +0200
Message-Id: <1374083403-14591-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing swap_features function to make the swapping
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
 tools/perf/util/header.c | 69 ++++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 34 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4ebe4a1..4d82dac 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2512,6 +2512,39 @@ do {								\
 	return -1;
 }
 
+static void swap_features(unsigned long *adds_features)
+{
+	/*
+	 * feature bitmap is declared as an array of unsigned longs --
+	 * not good since its size can differ between the host that
+	 * generated the data file and the host analyzing the file.
+	 *
+	 * We need to handle endianness, but we don't know the size of
+	 * the unsigned long where the file was generated. Take a best
+	 * guess at determining it: try 64-bit swap first (ie., file
+	 * created on a 64-bit host), and check if the hostname feature
+	 * bit is set (this feature bit is forced on as of fbe96f2).
+	 * If the bit is not, undo the 64-bit swap and try a 32-bit
+	 * swap. If the hostname bit is still not set (e.g., older data
+	 * file), punt and fallback to the original behavior --
+	 * clearing all feature bits and setting buildid.
+	 */
+	mem_bswap_64(adds_features, BITS_TO_U64(HEADER_FEAT_BITS));
+
+	if (!test_bit(HEADER_HOSTNAME, adds_features)) {
+		/* unswap as u64 */
+		mem_bswap_64(adds_features, BITS_TO_U64(HEADER_FEAT_BITS));
+
+		/* unswap as u32 */
+		mem_bswap_32(adds_features, BITS_TO_U32(HEADER_FEAT_BITS));
+	}
+
+	if (!test_bit(HEADER_HOSTNAME, adds_features)) {
+		bitmap_zero(adds_features, HEADER_FEAT_BITS);
+		set_bit(HEADER_BUILD_ID, adds_features);
+	}
+}
+
 int perf_file_header__read(struct perf_file_header *header,
 			   struct perf_header *ph, int fd)
 {
@@ -2540,40 +2573,8 @@ int perf_file_header__read(struct perf_file_header *header,
 			bitmap_zero(header->adds_features, HEADER_FEAT_BITS);
 		else
 			return -1;
-	} else if (ph->needs_swap) {
-		/*
-		 * feature bitmap is declared as an array of unsigned longs --
-		 * not good since its size can differ between the host that
-		 * generated the data file and the host analyzing the file.
-		 *
-		 * We need to handle endianness, but we don't know the size of
-		 * the unsigned long where the file was generated. Take a best
-		 * guess at determining it: try 64-bit swap first (ie., file
-		 * created on a 64-bit host), and check if the hostname feature
-		 * bit is set (this feature bit is forced on as of fbe96f2).
-		 * If the bit is not, undo the 64-bit swap and try a 32-bit
-		 * swap. If the hostname bit is still not set (e.g., older data
-		 * file), punt and fallback to the original behavior --
-		 * clearing all feature bits and setting buildid.
-		 */
-		mem_bswap_64(&header->adds_features,
-			    BITS_TO_U64(HEADER_FEAT_BITS));
-
-		if (!test_bit(HEADER_HOSTNAME, header->adds_features)) {
-			/* unswap as u64 */
-			mem_bswap_64(&header->adds_features,
-				    BITS_TO_U64(HEADER_FEAT_BITS));
-
-			/* unswap as u32 */
-			mem_bswap_32(&header->adds_features,
-				    BITS_TO_U32(HEADER_FEAT_BITS));
-		}
-
-		if (!test_bit(HEADER_HOSTNAME, header->adds_features)) {
-			bitmap_zero(header->adds_features, HEADER_FEAT_BITS);
-			set_bit(HEADER_BUILD_ID, header->adds_features);
-		}
-	}
+	} else if (ph->needs_swap)
+		swap_features(header->adds_features);
 
 	memcpy(&ph->adds_features, &header->adds_features,
 	       sizeof(ph->adds_features));
-- 
1.7.11.7

