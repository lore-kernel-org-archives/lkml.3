Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbbA2IJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:09:57 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:50854 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbbA2IJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:09:54 -0500
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
Subject: [PATCH 01/42] perf tools: Support to read compressed module from build-id cache
Date: Thu, 29 Jan 2015 17:06:42 +0900
Message-Id: <1422518843-25818-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit c00c48fc6e6e ("perf symbols: Preparation for compressed
kernel module support") added support for compressed kernel modules
but it only supports system path DSOs.  When a dso is read from
build-id cache, its filename doesn't end with ".gz" but has build-id.
In this case, we should fallback to the original dso->name.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/symbol-elf.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 06fcd1bf98b6..b24f9d8727a8 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -574,13 +574,16 @@ static int decompress_kmodule(struct dso *dso, const char *name,
 	const char *ext = strrchr(name, '.');
 	char tmpbuf[] = "/tmp/perf-kmod-XXXXXX";
 
-	if ((type != DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP &&
-	     type != DSO_BINARY_TYPE__GUEST_KMODULE_COMP) ||
-	    type != dso->symtab_type)
+	if (type != DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE_COMP &&
+	    type != DSO_BINARY_TYPE__GUEST_KMODULE_COMP &&
+	    type != DSO_BINARY_TYPE__BUILD_ID_CACHE)
 		return -1;
 
-	if (!ext || !is_supported_compression(ext + 1))
-		return -1;
+	if (!ext || !is_supported_compression(ext + 1)) {
+		ext = strrchr(dso->name, '.');
+		if (!ext || !is_supported_compression(ext + 1))
+			return -1;
+	}
 
 	fd = mkstemp(tmpbuf);
 	if (fd < 0)
-- 
2.2.2

