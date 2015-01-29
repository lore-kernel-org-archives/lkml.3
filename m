Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbbA2ILA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:11:00 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51643 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbbA2IKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:21 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 39/42] perf tools: Convert lseek + read to pread
Date: Thu, 29 Jan 2015 17:07:20 +0900
Message-Id: <1422518843-25818-40-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When dso_cache__read() is called, it reads data from the given offset
using lseek + normal read syscall.  It can be combined to a single
pread syscall.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/dso.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index ae92046ae2c8..b6ad22b3c6f2 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -566,10 +566,7 @@ dso_cache__read(struct dso *dso, struct machine *machine,
 		}
 	}
 
-	if (-1 == lseek(dso->data.fd, cache_offset, SEEK_SET))
-		goto err_unlock;
-
-	ret = read(dso->data.fd, cache->data, DSO__DATA_CACHE_SIZE);
+	ret = pread(dso->data.fd, cache->data, DSO__DATA_CACHE_SIZE, cache_offset);
 	if (ret <= 0)
 		goto err_unlock;
 
-- 
2.2.2

