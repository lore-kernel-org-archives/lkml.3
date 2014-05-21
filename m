Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaEUNNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 09:13:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbaEUNNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 09:13:24 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Michael Lentine <mlentine@google.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 22/22] perf tools: Add automatic remapping of Android libraries
Date: Wed, 21 May 2014 15:12:44 +0200
Message-Id: <1400677964-25160-23-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
References: <1400677964-25160-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Lentine <mlentine@google.com>

This patch automatically adjusts the path of MMAP records
associated with Android system libraries.

The Android system is organized with system libraries found in
/system/lib and user libraries in /data/app-lib. On the host system
(not running Android), system libraries can be found in the downloaded
NDK directory under ${NDK_ROOT}/platforms/${APP_PLATFORM}/arch-${ARCH}/usr/lib
and the user libraries are installed under libs/${APP_ABI} within
the apk build directory. This patch makes running the reporting
tools possible on the host system using the libraries from the NDK.

Signed-off-by: Michael Lentine <mlentine@google.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1400579330-5043-3-git-send-email-eranian@google.com
[ fixed 'space required before the open parenthesis' checkpatch.pl errors ]
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/map.c | 95 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 94 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index ba5f5c0c..8ccbb32 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -32,6 +32,93 @@ static inline int is_no_dso_memory(const char *filename)
 	       !strcmp(filename, "[heap]");
 }
 
+static inline int is_android_lib(const char *filename)
+{
+	return !strncmp(filename, "/data/app-lib", 13) ||
+	       !strncmp(filename, "/system/lib", 11);
+}
+
+static inline bool replace_android_lib(const char *filename, char *newfilename)
+{
+	const char *libname;
+	char *app_abi;
+	size_t app_abi_length, new_length;
+	size_t lib_length = 0;
+
+	libname  = strrchr(filename, '/');
+	if (libname)
+		lib_length = strlen(libname);
+
+	app_abi = getenv("APP_ABI");
+	if (!app_abi)
+		return false;
+
+	app_abi_length = strlen(app_abi);
+
+	if (!strncmp(filename, "/data/app-lib", 13)) {
+		char *apk_path;
+
+		if (!app_abi_length)
+			return false;
+
+		new_length = 7 + app_abi_length + lib_length;
+
+		apk_path = getenv("APK_PATH");
+		if (apk_path) {
+			new_length += strlen(apk_path) + 1;
+			if (new_length > PATH_MAX)
+				return false;
+			snprintf(newfilename, new_length,
+				 "%s/libs/%s/%s", apk_path, app_abi, libname);
+		} else {
+			if (new_length > PATH_MAX)
+				return false;
+			snprintf(newfilename, new_length,
+				 "libs/%s/%s", app_abi, libname);
+		}
+		return true;
+	}
+
+	if (!strncmp(filename, "/system/lib/", 11)) {
+		char *ndk, *app;
+		const char *arch;
+		size_t ndk_length;
+		size_t app_length;
+
+		ndk = getenv("NDK_ROOT");
+		app = getenv("APP_PLATFORM");
+
+		if (!(ndk && app))
+			return false;
+
+		ndk_length = strlen(ndk);
+		app_length = strlen(app);
+
+		if (!(ndk_length && app_length && app_abi_length))
+			return false;
+
+		arch = !strncmp(app_abi, "arm", 3) ? "arm" :
+		       !strncmp(app_abi, "mips", 4) ? "mips" :
+		       !strncmp(app_abi, "x86", 3) ? "x86" : NULL;
+
+		if (!arch)
+			return false;
+
+		new_length = 27 + ndk_length +
+			     app_length + lib_length
+			   + strlen(arch);
+
+		if (new_length > PATH_MAX)
+			return false;
+		snprintf(newfilename, new_length,
+			"%s/platforms/%s/arch-%s/usr/lib/%s",
+			ndk, app, arch, libname);
+
+		return true;
+	}
+	return false;
+}
+
 void map__init(struct map *map, enum map_type type,
 	       u64 start, u64 end, u64 pgoff, struct dso *dso)
 {
@@ -59,8 +146,9 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 	if (map != NULL) {
 		char newfilename[PATH_MAX];
 		struct dso *dso;
-		int anon, no_dso, vdso;
+		int anon, no_dso, vdso, android;
 
+		android = is_android_lib(filename);
 		anon = is_anon_memory(filename);
 		vdso = is_vdso_map(filename);
 		no_dso = is_no_dso_memory(filename);
@@ -75,6 +163,11 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 			filename = newfilename;
 		}
 
+		if (android) {
+			if (replace_android_lib(filename, newfilename))
+				filename = newfilename;
+		}
+
 		if (vdso) {
 			pgoff = 0;
 			dso = vdso__dso_findnew(dsos__list);
-- 
1.8.3.1

