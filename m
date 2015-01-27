Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbbA0Gel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 01:34:41 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62779 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbbA0GeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 01:34:22 -0500
From: Victor Kamensky <victor.kamensky@linaro.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Avi Kivity <avi@cloudius-systems.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Anton Blanchard <anton@samba.org>, Dave Martin <Dave.Martin@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Jiri Olsa <jolsa@kernel.org>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH V3 2/2] perf symbols: debuglink should take symfs option into account
Date: Mon, 26 Jan 2015 22:34:02 -0800
Message-Id: <1422340442-4673-3-git-send-email-victor.kamensky@linaro.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1422340442-4673-1-git-send-email-victor.kamensky@linaro.org>
References: <1422340442-4673-1-git-send-email-victor.kamensky@linaro.org>
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
Acked-and-tested-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/dso.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 45be944..ca8d8d5 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -45,13 +45,13 @@ int dso__read_binary_type_filename(const struct dso *dso,
 	case DSO_BINARY_TYPE__DEBUGLINK: {
 		char *debuglink;
 
-		strncpy(filename, dso->long_name, size);
-		debuglink = filename + dso->long_name_len;
+		len = __symbol__join_symfs(filename, size, dso->long_name);
+		debuglink = filename + len;
 		while (debuglink != filename && *debuglink != '/')
 			debuglink--;
 		if (*debuglink == '/')
 			debuglink++;
-		ret = filename__read_debuglink(dso->long_name, debuglink,
+		ret = filename__read_debuglink(filename, debuglink,
 					       size - (debuglink - filename));
 		}
 		break;
-- 
1.9.3

