Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaAVNC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:02:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153AbaAVNC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:02:27 -0500
Date: Wed, 22 Jan 2014 14:02:11 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf tests: Add install prefix tests
Message-ID: <20140122130211.GB1132@krava.brq.redhat.com>
References: <CA+5PVA7LcDe5Y2RePTFbLdSHd85WhHcHHnFw2mBycfFRJ2m-FQ@mail.gmail.com>
 <CA+5PVA5SWV-pWxfisAVXB-PkARqRsHiaWOne2sXiG7r1D5M6Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5SWV-pWxfisAVXB-PkARqRsHiaWOne2sXiG7r1D5M6Rg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 07:58:41PM -0500, Josh Boyer wrote:
> On Tue, Jan 21, 2014 at 3:02 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> > Hi All,
> >
> > I went to build Linux v3.13-737-g7fe67a1 in Fedora this morning and it
> > resulted in RPM complaining that the perf and perf.so binaries had
> 

SNIP

> I'm not sure why DESTDIR is included in the -DPLUGIN_DIR definition in
> tools/lib/traceevent/Makefile, nor why $(prefix) is in plugindir_SQ in
> tools/perf/config/Makefile.
> 
> josh
> 
> diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
> index 56d52a3..005c9cc 100644
> --- a/tools/lib/traceevent/Makefile
> +++ b/tools/lib/traceevent/Makefile
> @@ -63,7 +63,7 @@ endif
>  endif
> 
>  ifeq ($(set_plugin_dir),1)
> -PLUGIN_DIR = -DPLUGIN_DIR="$(DESTDIR)/$(plugin_dir)"
> +PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
>  PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'

hi,
this one needs to stay, otherwise perf have wrong path
to load plugins from..


>  endif
> 
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index d604e50..c48d449 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -600,5 +600,5 @@ perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
>  # Otherwise we install plugins into the global $(libdir).
>  ifdef DESTDIR
>  plugindir=$(libdir)/traceevent/plugins
> -plugindir_SQ= $(subst ','\'',$(prefix)/$(plugindir))
> +plugindir_SQ= $(subst ','\'',$(plugindir))

this one is proper fix, $(libdir) is defined as:

libdir = $(prefix)/$(lib)

please let me know if you want me to send the patch or
if you do that by yourself..

attached is updated perf make test with new prefix
tests.. we never test this ;-)

thanks for the fix,
jirka


---
Adding automated tests for:
  $ make install prefix=/usr DESTDIR=...
  $ make_install_bin prefix=/usr DESTDIR=...

Plus some generalization fixies for install tests.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/tests/make | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 00544b8..faf3a1f 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -44,6 +44,8 @@ make_install_man    := install-man
 make_install_html   := install-html
 make_install_info   := install-info
 make_install_pdf    := install-pdf
+make_install_prefix     := install prefix=/usr
+make_install_bin_prefix := install prefix=/usr
 
 # all the NO_* variable combined
 make_minimal        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1
@@ -75,6 +77,8 @@ run += make_perf_o
 run += make_util_map_o
 run += make_install
 run += make_install_bin
+run += make_install_prefix
+run += make_install_bin_prefix
 # FIXME 'install-*' commented out till they're fixed
 # run += make_install_doc
 # run += make_install_man
@@ -117,16 +121,17 @@ test_make_perf_o     := test -f $(PERF)/perf.o
 test_make_util_map_o := test -f $(PERF)/util/map.o
 
 define test_dest_files
-  for file in $(1); do				\
-    if [ ! -x $$TMP_DEST/$$file ]; then		\
-      echo "  failed to find: $$file";		\
-    fi						\
+  for file in $(1); do					\
+    if [ ! -x $$TMP_DEST/$$file ]; then			\
+      echo "  failed to find: $$TMP_DEST/$$file";	\
+    fi							\
   done
 endef
 
-installed_files_bin := bin/perf
-installed_files_bin += etc/bash_completion.d/perf
-installed_files_bin += libexec/perf-core/perf-archive
+installed_files_bin_no_prefix := etc/bash_completion.d/perf
+
+installed_files_bin_prefix += bin/perf
+installed_files_bin_prefix += libexec/perf-core/perf-archive
 
 installed_files_plugins := $(lib)/traceevent/plugins/plugin_cfg80211.so
 installed_files_plugins += $(lib)/traceevent/plugins/plugin_scsi.so
@@ -139,7 +144,11 @@ installed_files_plugins += $(lib)/traceevent/plugins/plugin_kmem.so
 installed_files_plugins += $(lib)/traceevent/plugins/plugin_hrtimer.so
 installed_files_plugins += $(lib)/traceevent/plugins/plugin_jbd2.so
 
-installed_files_all := $(installed_files_bin)
+installed_files_bin := $(installed_files_bin_no_prefix)
+installed_files_bin += $(nstalled_files_bin_prefix)
+
+installed_files_all := $(installed_files_bin_no_prefix)
+installed_files_all += $(installed_files_bin)
 installed_files_all += $(installed_files_plugins)
 
 test_make_install       := $(call test_dest_files,$(installed_files_all))
@@ -147,6 +156,18 @@ test_make_install_O     := $(call test_dest_files,$(installed_files_all))
 test_make_install_bin   := $(call test_dest_files,$(installed_files_bin))
 test_make_install_bin_O := $(call test_dest_files,$(installed_files_bin))
 
+installed_files_prefix_bin := $(addprefix usr/,$(installed_files_bin_prefix))
+installed_files_prefix_bin += $(installed_files_bin_no_prefix)
+
+installed_files_prefix_all := $(addprefix usr/,$(installed_files_plugins))
+installed_files_prefix_all += $(addprefix usr/,$(installed_files_bin_prefix))
+installed_files_prefix_all += $(installed_files_bin_no_prefix)
+
+test_make_install_prefix       := $(call test_dest_files,$(installed_files_prefix_all))
+test_make_install_prefix_O     := $(call test_dest_files,$(installed_files_prefix_all))
+test_make_install_bin_prefix   := $(call test_dest_files,$(installed_files_prefix_bin))
+test_make_install_bin_prefix_O := $(call test_dest_files,$(installed_files_prefix_bin))
+
 # FIXME nothing gets installed
 test_make_install_man    := test -f $$TMP_DEST/share/man/man1/perf.1
 test_make_install_man_O  := $(test_make_install_man)
-- 
1.8.3.1
