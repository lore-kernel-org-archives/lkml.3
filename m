Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbbAMQ7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:59:31 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:65391 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbbAMQ73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:59:29 -0500
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, David Ahern <dsahern@gmail.com>,
        Will Deacon <will.deacon@arm.com>, Dave Martin <Dave.Martin@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH 2/2] perf symbols: debuglink should take symfs option into account
Date: Tue, 13 Jan 2015 08:59:04 -0800
Message-Id: <1421168344-5363-2-git-send-email-victor.kamensky@linaro.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1421168344-5363-1-git-send-email-victor.kamensky@linaro.org>
References: <1421168344-5363-1-git-send-email-victor.kamensky@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently code that tries to read corresponding debug symbol
file from .gnu_debuglink section (DSO_BINARY_TYPE__DEBUGLINK)
does not take in account symfs option, so filename__read_debuglink
function cannot open ELF file, if symfs option is used.

Fix is to add proper handling of symfs as it is done in other
places: use __symbol__join_symfs function to get real file name
of target ELF file.

Created malloced copy of target filename in symfs before passing
it to __symbol__join_symfs function because filename will be
modified by it if corresponding debuglink is found.

Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Waiman Long <Waiman.Long@hp.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/dso.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 45be944..6a2f663 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -42,19 +42,30 @@ int dso__read_binary_type_filename(const struct dso *dso,
 	size_t len;
 
 	switch (type) {
-	case DSO_BINARY_TYPE__DEBUGLINK: {
+	case DSO_BINARY_TYPE__DEBUGLINK:
+	{
 		char *debuglink;
-
-		strncpy(filename, dso->long_name, size);
-		debuglink = filename + dso->long_name_len;
-		while (debuglink != filename && *debuglink != '/')
-			debuglink--;
-		if (*debuglink == '/')
-			debuglink++;
-		ret = filename__read_debuglink(dso->long_name, debuglink,
-					       size - (debuglink - filename));
-		}
+		char *filename_copy;
+
+		filename_copy = malloc(PATH_MAX);
+		if (filename_copy) {
+			len = __symbol__join_symfs(filename, size,
+						   dso->long_name);
+			strncpy(filename_copy, filename, PATH_MAX);
+			debuglink = filename + len;
+			while (debuglink != filename && *debuglink != '/')
+				debuglink--;
+			if (*debuglink == '/')
+				debuglink++;
+			ret = filename__read_debuglink(filename_copy, debuglink,
+						       size - (debuglink -
+							       filename));
+			free(filename_copy);
+		} else
+			ret = -1;
 		break;
+	}
+
 	case DSO_BINARY_TYPE__BUILD_ID_CACHE:
 		/* skip the locally configured cache if a symfs is given */
 		if (symbol_conf.symfs[0] ||
-- 
1.9.3

