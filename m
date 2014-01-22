Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbaAVPCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 10:02:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755240AbaAVPCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 10:02:01 -0500
Date: Wed, 22 Jan 2014 10:01:48 -0500
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf tools: Fix traceevent plugin path definitions
Message-ID: <20140122150147.GK16455@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The plugindir_SQ definition contains $(prefix) which is not needed
as the $(libdir) definition already contains prefix in it.  This
leads to the path including an extra prefix in it, e.g. /usr/usr/lib64.

The -DPLUGIN_DIR defintion includes DESTDIR.  This is incorrect, as it
sets the plugin search path to include the value of DESTDIR.  DESTDIR
is a mechanism to install in a non-standard location such as a chroot
or an RPM build root.  In the RPM case, this leads to the search path
being incorrect after the resulting RPM is installed (or in some cases
an RPM build failure).

Remove both of these unnecessary inclusions.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---
 tools/lib/traceevent/Makefile | 2 +-
 tools/perf/config/Makefile    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 56d52a3..005c9cc 100644
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
index d604e50..c48d449 100644
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
1.8.4.2

