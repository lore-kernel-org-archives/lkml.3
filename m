Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaBXT6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:58:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49154 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbaBXT4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:56:53 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/12] perf symbols: Check return value of filename__read_debuglink()
Date: Mon, 24 Feb 2014 16:56:39 -0300
Message-Id: <1393271800-17505-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1393271800-17505-1-git-send-email-acme@infradead.org>
References: <1393271800-17505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

When dso__read_binary_type_filename() called, it doesn't check the
return value of filename__read_debuglink() so that it'll try to open the
debuglink file even if it doesn't exist.

Also fix return value of the filename__read_debuglink() as it always
return -1 regardless of the result.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1392859976-32760-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c        | 4 ++--
 tools/perf/util/symbol-elf.c | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 4045d086d9d9..64453d63b971 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -45,8 +45,8 @@ int dso__read_binary_type_filename(const struct dso *dso,
 			debuglink--;
 		if (*debuglink == '/')
 			debuglink++;
-		filename__read_debuglink(dso->long_name, debuglink,
-					 size - (debuglink - filename));
+		ret = filename__read_debuglink(dso->long_name, debuglink,
+					       size - (debuglink - filename));
 		}
 		break;
 	case DSO_BINARY_TYPE__BUILD_ID_CACHE:
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 3e9f336740fa..8ac4a4fe2abd 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -506,6 +506,8 @@ int filename__read_debuglink(const char *filename, char *debuglink,
 	/* the start of this section is a zero-terminated string */
 	strncpy(debuglink, data->d_buf, size);
 
+	err = 0;
+
 out_elf_end:
 	elf_end(elf);
 out_close:
-- 
1.8.1.4

