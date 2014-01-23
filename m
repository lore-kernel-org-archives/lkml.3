Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbaAWTic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:38:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43874 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbaAWTiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:38:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>,
        Ingo Molnar <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf tools: Fix traceevent plugin path definitions
Date: Thu, 23 Jan 2014 16:38:13 -0300
Message-Id: <1390505894-19733-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1390505894-19733-1-git-send-email-acme@infradead.org>
References: <1390505894-19733-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@fedoraproject.org>

The plugindir_SQ definition contains $(prefix) which is not needed as
the $(libdir) definition already contains prefix in it.  This leads to
the path including an extra prefix in it, e.g. /usr/usr/lib64.

The -DPLUGIN_DIR defintion includes DESTDIR.  This is incorrect, as it
sets the plugin search path to include the value of DESTDIR.  DESTDIR is
a mechanism to install in a non-standard location such as a chroot or an
RPM build root.  In the RPM case, this leads to the search path being
incorrect after the resulting RPM is installed (or in some cases an RPM
build failure).

Remove both of these unnecessary inclusions.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20140122150147.GK16455@hansolo.jdub.homelinux.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 2 +-
 tools/perf/config/Makefile    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 56d52a33a3df..005c9cc06935 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -63,7 +63,7 @@ endif
 endif
 
 ifeq ($(set_plugin_dir),1)
-PLUGIN_DIR = -DPLUGIN_DIR="$(DESTDIR)/$(plugin_dir)"
+PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
 PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
 endif
 
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index d604e50fc167..c48d44958172 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -600,5 +600,5 @@ perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
 # Otherwise we install plugins into the global $(libdir).
 ifdef DESTDIR
 plugindir=$(libdir)/traceevent/plugins
-plugindir_SQ= $(subst ','\'',$(prefix)/$(plugindir))
+plugindir_SQ= $(subst ','\'',$(plugindir))
 endif
-- 
1.8.1.4

