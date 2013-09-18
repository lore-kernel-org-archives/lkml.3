Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3IRInT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 04:43:19 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:33454 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3IRInR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 04:43:17 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] perf: Support for Openembedded/Yocto -dbg packages
Date: Wed, 18 Sep 2013 10:43:10 +0200
Message-Id: <1379493790-9554-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OpenEmbedded the symbol files are located under a .debug folder on
the same folder as the binary file.

This patch adds support for such files.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 tools/perf/util/dso.c    | 16 ++++++++++++++++
 tools/perf/util/dso.h    |  1 +
 tools/perf/util/symbol.c |  1 +
 3 files changed, 18 insertions(+)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index c4374f0..bab18b7 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -14,6 +14,7 @@ char dso__symtab_origin(const struct dso *dso)
 		[DSO_BINARY_TYPE__BUILD_ID_CACHE]	= 'B',
 		[DSO_BINARY_TYPE__FEDORA_DEBUGINFO]	= 'f',
 		[DSO_BINARY_TYPE__UBUNTU_DEBUGINFO]	= 'u',
+		[DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO] = 'o',
 		[DSO_BINARY_TYPE__BUILDID_DEBUGINFO]	= 'b',
 		[DSO_BINARY_TYPE__SYSTEM_PATH_DSO]	= 'd',
 		[DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE]	= 'K',
@@ -64,6 +65,21 @@ int dso__binary_type_file(struct dso *dso, enum dso_binary_type type,
 			 symbol_conf.symfs, dso->long_name);
 		break;
 
+	case DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO:{
+		char *last_slash;
+
+		last_slash = dso->long_name + dso->long_name_len;
+		while (last_slash != dso->long_name && *last_slash != '/')
+			last_slash--;
+
+		snprintf(file, MIN(size, strlen(symbol_conf.symfs) +
+				(last_slash - dso->long_name) + 2), "%s%s",
+				symbol_conf.symfs, dso->long_name);
+		snprintf(file + strlen(file), size-strlen(file), ".debug%s",
+				last_slash);
+		}
+		break;
+
 	case DSO_BINARY_TYPE__BUILDID_DEBUGINFO:
 		if (!dso->has_build_id) {
 			ret = -1;
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index d51aaf2..4f78e7b 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -20,6 +20,7 @@ enum dso_binary_type {
 	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
 	DSO_BINARY_TYPE__GUEST_KMODULE,
 	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
+	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index d5528e1..f69d57b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -51,6 +51,7 @@ static enum dso_binary_type binary_type_symtab[] = {
 	DSO_BINARY_TYPE__SYSTEM_PATH_DSO,
 	DSO_BINARY_TYPE__GUEST_KMODULE,
 	DSO_BINARY_TYPE__SYSTEM_PATH_KMODULE,
+	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
-- 
1.8.4.rc3

