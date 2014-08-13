Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaHMFUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 01:20:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45169 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaHMFUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 01:20:07 -0400
Date: Tue, 12 Aug 2014 22:19:45 -0700
From: tip-bot for Thomas Ilsche <tipbot@zytor.com>
Message-ID: <tip-d6a947fb6cdff3a19db93895c746f70b5903a965@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, thomas.ilsche@tu-dresden.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, thomas.ilsche@tu-dresden.de, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <53DF8493.6070206@tu-dresden.de>
References: <53DF8493.6070206@tu-dresden.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Default to python version 2
Git-Commit-ID: d6a947fb6cdff3a19db93895c746f70b5903a965
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6a947fb6cdff3a19db93895c746f70b5903a965
Gitweb:     http://git.kernel.org/tip/d6a947fb6cdff3a19db93895c746f70b5903a965
Author:     Thomas Ilsche <thomas.ilsche@tu-dresden.de>
AuthorDate: Mon, 4 Aug 2014 15:03:15 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 12 Aug 2014 12:03:08 -0300

perf tools: Default to python version 2

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
index e05d8f9..75d4c23 100644
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
 
