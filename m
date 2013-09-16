Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab3IPJS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 05:18:27 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:62284 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab3IPJRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 05:17:51 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@kernel.org>
Cc: patches@linaro.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 3/4] perf tools: Check libunwind for availability of dwarf parsing feature
Date: Mon, 16 Sep 2013 11:17:32 +0200
Message-Id: <1379323053-11458-4-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379323053-11458-1-git-send-email-jean.pihet@linaro.org>
References: <1379323053-11458-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly added dwarf unwinding feature [1] requires:
. a recent version (>= 1.1) of libunwind,
. libunwind to be configured with --enable-debug-frame.

[1] http://www.spinics.net/lists/kernel/msg1598951.html

Add the corresponding API test in the feature check list.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/config/Makefile          |  2 +-
 tools/perf/config/feature-tests.mak | 11 ++++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 4b65710..395bc41 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -223,7 +223,7 @@ endif
 
 FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(CFLAGS) $(LIBUNWIND_LDFLAGS) $(LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
 ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
-  msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
+  msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1);
   NO_LIBUNWIND := 1
 endif # Libunwind support
 endif # NO_LIBUNWIND
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 708fb8e..87124d0 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -176,14 +176,23 @@ extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
                                       unw_proc_info_t *pi,
                                       int need_unwind_info, void *arg);
 
-
 #define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
 
+extern int
+UNW_OBJ(dwarf_find_debug_frame) (int found, unw_dyn_info_t *di_debug,
+				 unw_word_t ip,
+				 unw_word_t segbase,
+				 const char *obj_name, unw_word_t start,
+				 unw_word_t end);
+
+#define dwarf_find_debug_frame UNW_OBJ(dwarf_find_debug_frame)
+
 int main(void)
 {
 	unw_addr_space_t addr_space;
 	addr_space = unw_create_addr_space(NULL, 0);
 	unw_init_remote(NULL, addr_space, NULL);
+	dwarf_find_debug_frame(0, NULL, 0, 0, NULL, 0, 0);
 	dwarf_search_unwind_table(addr_space, 0, NULL, NULL, 0, NULL);
 	return 0;
 }
-- 
1.7.11.7

