Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759653Ab3HNKDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:03:34 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33437 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab3HNKDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:03:32 -0400
Date: Wed, 14 Aug 2013 12:04:26 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu, jolsa@redhat.com,
        namhyung.kim@lge.com, dsahern@gmail.com
Subject: [PATCH] perf tools: improve robutness of topology parsing code
Message-ID: <20130814100426.GA3444@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This patch improves the robutness of the build_cpu_topo()
routine by allowing either the CPU parsing or the thread
parsing to fail and yet get perf to produce some topology
data which could be useful for the analysis. Without this
patch, if the cpu parsing fails, the thread parsing is not
attempted vice-versa.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f558f83..c993204 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -716,18 +716,19 @@ static int build_cpu_topo(struct cpu_topo *tp, int cpu)
 	char filename[MAXPATHLEN];
 	char *buf = NULL, *p;
 	size_t len = 0;
+	ssize_t sret;
 	u32 i = 0;
 	int ret = -1;
 
 	sprintf(filename, CORE_SIB_FMT, cpu);
 	fp = fopen(filename, "r");
 	if (!fp)
-		return -1;
-
-	if (getline(&buf, &len, fp) <= 0)
-		goto done;
-
+		goto try_threads;
+		
+	sret = getline(&buf, &len, fp);
 	fclose(fp);
+	if (sret <= 0)
+		goto try_threads;
 
 	p = strchr(buf, '\n');
 	if (p)
@@ -743,7 +744,9 @@ static int build_cpu_topo(struct cpu_topo *tp, int cpu)
 		buf = NULL;
 		len = 0;
 	}
+	ret = 0;
 
+try_threads:
 	sprintf(filename, THRD_SIB_FMT, cpu);
 	fp = fopen(filename, "r");
 	if (!fp)
