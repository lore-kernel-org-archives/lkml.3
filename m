Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab3GEKUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 06:20:18 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:52452 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab3GEKUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 06:20:16 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH v2 3/4] perf: squelch warnings from perl.h to compile-pass
Date: Fri,  5 Jul 2013 15:46:16 +0530
Message-Id: <1373019377-12741-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.722.g3244e19.dirty
In-Reply-To: <1373019377-12741-1-git-send-email-artagnon@gmail.com>
References: <1373019377-12741-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, a simple

  $ make

errors out because we compile with -Werror by default, turning all
warnings into errors.  Although no warnings are emitted by our code
itself, two kinds of warnings are emitted by perl.h (perl 5.18.0):

  -Wundef and -Wswitch-default

Use #pragma statements to squelch exactly those warnings.  The next
patch will regenerate Context.c from Context.xs and make the compile
pass.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs   |  4 ++--
 tools/perf/util/perf-perl.h                          | 10 ++++++++++
 tools/perf/util/scripting-engines/trace-event-perl.c |  2 +-
 3 files changed, 13 insertions(+), 3 deletions(-)
 create mode 100644 tools/perf/util/perf-perl.h

diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
index 8c7ea42..509d22e 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
@@ -19,8 +19,8 @@
  *
  */
 
-#include "EXTERN.h"
-#include "perl.h"
+#include <EXTERN.h>
+#include "../../../util/perf-perl.h"
 #include "XSUB.h"
 #include "../../../perf.h"
 #include "../../../util/trace-event.h"
diff --git a/tools/perf/util/perf-perl.h b/tools/perf/util/perf-perl.h
new file mode 100644
index 0000000..49995d2
--- /dev/null
+++ b/tools/perf/util/perf-perl.h
@@ -0,0 +1,10 @@
+#ifndef __PERF_PERL_H
+#define __PERF_PERL_H
+
+#pragma GCC diagnostic ignored "-Wundef"
+#pragma GCC diagnostic ignored "-Wswitch-default"
+#include <perl.h>
+#pragma GCC diagnostic error "-Wundef"
+#pragma GCC diagnostic error "-Wswitch-default"
+
+#endif
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index eacec85..25fd2dc 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -27,7 +27,7 @@
 
 #include "../util.h"
 #include <EXTERN.h>
-#include <perl.h>
+#include "../perf-perl.h"
 
 #include "../../perf.h"
 #include "../thread.h"
-- 
1.8.3.1.643.gebeea52.dirty

