Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbbAZKNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:13:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbbAZKNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:13:35 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/36] tools build: Add detected config support
Date: Mon, 26 Jan 2015 11:12:02 +0100
Message-Id: <1422267156-13873-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
References: <1422267156-13873-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to include detected configuration makefile
into the build process. This will allow the Build objects
to be configurable based on the config data, like:

  perf-$(CONFIG_KRAVA) += krava.o

The configuration is stored in '.config-detected' file,
which is generated for each compilation.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Tested-by: Will Deacon <will.deacon@arm.com>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/build/Makefile.build | 3 +++
 tools/perf/config/Makefile | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/tools/build/Makefile.build b/tools/build/Makefile.build
index ae203f21cc86..35174d920476 100644
--- a/tools/build/Makefile.build
+++ b/tools/build/Makefile.build
@@ -22,6 +22,9 @@ build-dir := $(srctree)/tools/build
 # Generic definitions
 include $(build-dir)/Build.include
 
+# do not force detected configuration
+-include .config-detected
+
 # Init all relevant variables used in build files so
 # 1) they have correct type
 # 2) they do not inherit any value from the environment
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index 648e31ff4021..bd60ca04d5da 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -11,6 +11,10 @@ ifneq ($(obj-perf),)
 obj-perf := $(abspath $(obj-perf))/
 endif
 
+$(shell echo -n > .config-detected)
+detected     = $(shell echo "$(1)=y"       >> .config-detected)
+detected_var = $(shell echo "$(1)=$($(1))" >> .config-detected)
+
 LIB_INCLUDE := $(srctree)/tools/lib/
 CFLAGS := $(EXTRA_CFLAGS) $(EXTRA_WARNINGS)
 
-- 
1.9.3

