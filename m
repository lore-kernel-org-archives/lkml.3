Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaHDQVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:21:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:39751 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbaHDQVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:21:48 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Thomas Ilsche <thomas.ilsche@tu-dresden.de>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 33/33] perf tools: Default to python version 2
Date: Mon,  4 Aug 2014 13:17:44 -0300
Message-Id: <1407169064-25625-34-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407169064-25625-1-git-send-email-acme@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Ilsche <thomas.ilsche@tu-dresden.de>

According to PEP 394 recommendation [1], it's more portable to use
python2 rather than plain python to refer python binary version 2.

Since there're distros using python3 by default like Arch, and we don't
support python3 (yet), it'd be better using python2 explicitly.

But older versions (prior to 2.7) seem not to provide python2 but just
python.  Given that it's only old version, try python2 first and then
fallback to python.  It'll ensure that it always points to python 2.x.

I tested (compiles and perf script runs) with the combinations:

1) python  -> python2.x, python-config  -> python2.x-config
   python2 N/A,          python2-config N/A

2) python  -> python3.x, python-config  -> python3.x-config
   python2 -> python2.x, python2-config -> python2.x-config

3) python  -> python2.x, python-config  -> python2.x-config
   python2 -> python2.x, python2-config -> python2.x-config

4) python  -> python2.x, python-config  -> python2.x-config
   python2 -> python2.x, python2-config N/A

Based on / replaces the patch 2/2 by Namhyung Kim.

[1] https://www.python.org/dev/peps/pep-0394

Based-on-patch-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Thomas Ilsche <thomas.ilsche@tu-dresden.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/53DF8493.6070206@tu-dresden.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/Makefile | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index e05d8f99424d..75d4c237b03d 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -121,10 +121,16 @@ ifdef PARSER_DEBUG
 endif
 
 ifndef NO_LIBPYTHON
-  override PYTHON := \
-    $(call get-executable-or-default,PYTHON,python)
+  # Try different combinations to accommodate systems that only have
+  # python[2][-config] in weird combinations but always preferring
+  # python2 and python2-config as per pep-0394. If we catch a
+  # python[-config] in version 3, the version check will kill it.
+  PYTHON2 := $(if $(call get-executable,python2),python2,python)
+  override PYTHON := $(call get-executable-or-default,PYTHON,$(PYTHON2))
+  PYTHON2_CONFIG := \
+    $(if $(call get-executable,$(PYTHON)-config),$(PYTHON)-config,python-config)
   override PYTHON_CONFIG := \
-    $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON)-config)
+    $(call get-executable-or-default,PYTHON_CONFIG,$(PYTHON2_CONFIG))
 
   PYTHON_CONFIG_SQ := $(call shell-sq,$(PYTHON_CONFIG))
 
-- 
1.9.3

