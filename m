Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934122Ab3GQRvC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:51:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933394Ab3GQRu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:50:58 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 13/23] perf tools: Introduce perf.data version 3 format
Date: Wed, 17 Jul 2013 19:49:53 +0200
Message-Id: <1374083403-14591-14-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing perf.data version 3 format. No functional change,
just introducing doc, magic bytes and the struct.

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
 tools/perf/Documentation/perf-data-file-v3.txt | 60 ++++++++++++++++++++++++++
 tools/perf/util/header.c                       |  8 +++-
 tools/perf/util/header.h                       |  8 ++++
 3 files changed, 75 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/Documentation/perf-data-file-v3.txt

diff --git a/tools/perf/Documentation/perf-data-file-v3.txt b/tools/perf/Documentation/perf-data-file-v3.txt
new file mode 100644
index 0000000..9073931
--- /dev/null
+++ b/tools/perf/Documentation/perf-data-file-v3.txt
@@ -0,0 +1,60 @@
+perf-data-file-v3(1)
+====================
+Following text describes version 3 of the perf data file format,
+which is version that is currently used by perf tool.
+
+In version 3 we got rid of following sections:
+  EVENT IDS
+  EVENT ATTRIBUTES
+  EVENT TYPES
+
+and keep only data and features sections. All the data
+from above listed sections are now read from specific
+FEATURES sections.
+
+benefits:
+  - siplified header storage at the time the file is closed
+  - allowing cpu hotpluged addition/removal event IDs
+    during the session due to 1)
+
+High level view of the format:
+  FILE HEADER
+  EVENT DATA
+  FEATURES
+
+
+FILE HEADER
+-----------
+Starting point of the data file with magic bytes and global
+section information.
+
+The section contains following data:
+  struct perf_file_header header
+
+struct perf_file_header::
+  struct perf_file_header {
+        u64  magic;
+        u64  size;
+        u64  attr_size;
+        struct perf_file_section  data;
+        struct perf_file_section  features;
+        DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
+  }
+
+  magic           ID 'PERFILE3'
+  size            size minus sizeof(struct perf_file_header)
+  attr_size       attribute size minus sizeof(struct perf_file_attr)
+  data            location of 'EVENT DATA'
+  features        location of 'EVENT TYPES'
+  adds_features   'FEATURES' bitmask
+
+
+EVENT DATA
+----------
+This section contains blob of all events' data - auxiliary events
+and samples.
+
+
+FEATURES
+--------
+Same as in version 2.
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 65e44cc..3f97ae1 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -30,6 +30,7 @@ static const char **header_argv;
 
 /*
  * magic2 = "PERFILE2"
+ * magic3 = "PERFILE3"
  * must be a numerical value to let the endianness
  * determine the memory layout. That way we are able
  * to detect endianness when reading the perf.data file
@@ -40,6 +41,8 @@ static const char **header_argv;
 static const char *__perf_magic1 = "PERFFILE";
 static const u64 __perf_magic2    = 0x32454c4946524550ULL;
 static const u64 __perf_magic2_sw = 0x50455246494c4532ULL;
+static const u64 __perf_magic3    = 0x33454c4946524550ULL;
+static const u64 __perf_magic3_sw = 0x50455246494c4533ULL;
 
 #define PERF_MAGIC	__perf_magic2
 
@@ -2460,7 +2463,9 @@ bool is_perf_magic(u64 magic)
 {
 	if (!memcmp(&magic, __perf_magic1, sizeof(magic))
 		|| magic == __perf_magic2
-		|| magic == __perf_magic2_sw)
+		|| magic == __perf_magic2_sw
+		|| magic == __perf_magic3
+		|| magic == __perf_magic3_sw)
 		return true;
 
 	return false;
@@ -2502,6 +2507,7 @@ do {								\
 } while (0)
 
 	CHECK(__perf_magic2, PERF_HEADER_VERSION_2);
+	CHECK(__perf_magic3, PERF_HEADER_VERSION_3);
 
 	return -1;
 }
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index c6ea4603..bcd3e64 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -37,6 +37,7 @@ enum {
 enum perf_header_version {
 	PERF_HEADER_VERSION_1,
 	PERF_HEADER_VERSION_2,
+	PERF_HEADER_VERSION_3,
 };
 
 struct perf_file_section {
@@ -52,6 +53,12 @@ struct perf_file_header_v2 {
 	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
 };
 
+struct perf_file_header_v3 {
+	struct perf_file_section	data;
+	struct perf_file_section	features;
+	DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
+};
+
 struct perf_file_header {
 	u64	magic;
 	u64	size;
@@ -60,6 +67,7 @@ struct perf_file_header {
 	/* version specific data */
 	union {
 		struct perf_file_header_v2 v2;
+		struct perf_file_header_v3 v3;
 	};
 };
 
-- 
1.7.11.7

