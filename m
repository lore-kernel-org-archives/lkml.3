Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3IZLhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 07:37:09 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:49595 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab3IZLhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 07:37:01 -0400
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Ingo Molnar <mingo@kernel.org>, linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, Jean Pihet <jean.pihet@linaro.org>
Subject: [PATCH 3/4] perf tools: Check libunwind for availability of dwarf parsing feature
Date: Thu, 26 Sep 2013 13:36:37 +0200
Message-Id: <1380195398-4402-4-git-send-email-jean.pihet@linaro.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1380195398-4402-1-git-send-email-jean.pihet@linaro.org>
References: <1380195398-4402-1-git-send-email-jean.pihet@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly added dwarf unwinding feature [1] requires:
. a recent version (>= 1.1) of libunwind,
. libunwind to be configured with --enable-debug-frame.

[1] http://www.spinics.net/lists/kernel/msg1598951.html

Add the corresponding API tests in the feature check list.

Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
---
 tools/perf/config/Makefile          |  6 +++++-
 tools/perf/config/feature-tests.mak | 21 ++++++++++++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 4b65710..bbaeb04 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -223,9 +223,13 @@ endif
 
 FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(CFLAGS) $(LIBUNWIND_LDFLAGS) $(LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
 ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
-  msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 0.99);
+  msg := $(warning No libunwind found, disabling post unwind support. Please install libunwind-dev[el] >= 1.1);
   NO_LIBUNWIND := 1
 endif # Libunwind support
+ifneq ($(call try-cc,$(SOURCE_LIBUNWIND_DEBUG_FRAME),$(FLAGS_UNWIND),libunwind debug_frame),y)
+  msg := $(warning No debug_frame support found in libunwind);
+CFLAGS += -DNO_LIBUNWIND_DEBUG_FRAME
+endif # debug_frame support in libunwind
 endif # NO_LIBUNWIND
 
 ifndef NO_LIBUNWIND
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 708fb8e..cde75f5 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -176,7 +176,6 @@ extern int UNW_OBJ(dwarf_search_unwind_table) (unw_addr_space_t as,
                                       unw_proc_info_t *pi,
                                       int need_unwind_info, void *arg);
 
-
 #define dwarf_search_unwind_table UNW_OBJ(dwarf_search_unwind_table)
 
 int main(void)
@@ -188,6 +187,26 @@ int main(void)
 	return 0;
 }
 endef
+
+define SOURCE_LIBUNWIND_DEBUG_FRAME
+#include <libunwind.h>
+#include <stdlib.h>
+
+extern int
+UNW_OBJ(dwarf_find_debug_frame) (int found, unw_dyn_info_t *di_debug,
+				 unw_word_t ip, unw_word_t segbase,
+				 const char *obj_name, unw_word_t start,
+				 unw_word_t end);
+
+#define dwarf_find_debug_frame UNW_OBJ(dwarf_find_debug_frame)
+
+int main(void)
+{
+	dwarf_find_debug_frame(0, NULL, 0, 0, NULL, 0, 0);
+	return 0;
+}
+endef
+
 endif
 
 ifndef NO_BACKTRACE
-- 
1.7.11.7

