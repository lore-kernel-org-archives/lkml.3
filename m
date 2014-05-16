Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992542AbaEPXQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:16:11 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62083 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992485AbaEPXQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:16:08 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, jolsa@redhat.com,
        namhyung@kernel.org, Michael Lentine <mlentine@google.com>
Subject: [PATCH 2/2] perf tools: add automatic remapping of Android libraries
Date: Sat, 17 May 2014 01:15:56 +0200
Message-Id: <1400282156-4661-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400282156-4661-1-git-send-email-eranian@google.com>
References: <1400282156-4661-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Lentine <mlentine@google.com>

This patch automtically adjusts the path of MMAP records
associated with Android system libraries. It enables running
perf reporting tools directly on the Android system natively.

Reviewed-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Michael Lentine <mlentine@google.com>
---
 tools/perf/util/map.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index ba5f5c0c..1960883 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -32,6 +32,86 @@ static inline int is_no_dso_memory(const char *filename)
 	       !strcmp(filename, "[heap]");
 }
 
+static inline int is_android_lib(const char *filename)
+{
+	return !strncmp(filename, "/data/app-lib", 13) ||
+	       !strncmp(filename, "/system/lib", 11);
+}
+
+static inline bool replace_android_lib(const char *filename, char **newfilename)
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
+		if(apk_path) {
+			snprintf(*newfilename, new_length + strlen(apk_path) + 1,
+				 "%s/libs/%s/%s", apk_path, app_abi, libname);
+		} else {
+			snprintf(*newfilename, new_length,
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
+		snprintf(*newfilename, new_length,
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
@@ -59,8 +139,9 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 	if (map != NULL) {
 		char newfilename[PATH_MAX];
 		struct dso *dso;
-		int anon, no_dso, vdso;
+		int anon, no_dso, vdso, android;
 
+		android = is_android_lib(filename);
 		anon = is_anon_memory(filename);
 		vdso = is_vdso_map(filename);
 		no_dso = is_no_dso_memory(filename);
@@ -75,6 +156,12 @@ struct map *map__new(struct list_head *dsos__list, u64 start, u64 len,
 			filename = newfilename;
 		}
 
+		if (android) {
+			char *newfilename_ptr = newfilename;
+			if (replace_android_lib(filename, &newfilename_ptr))
+				filename = newfilename;
+		}
+
 		if (vdso) {
 			pgoff = 0;
 			dso = vdso__dso_findnew(dsos__list);
-- 
1.9.1.423.g4596e3a

