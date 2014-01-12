Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaALSeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:34:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45529 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaALSeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:34:08 -0500
Date: Sun, 12 Jan 2014 10:33:44 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-ee4ad93e82b8fd260ae618f6b0413cd321bc09cb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1387460527-15030-2-git-send-email-jolsa@redhat.com>
References: <1387460527-15030-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Factor make install tests
Git-Commit-ID: ee4ad93e82b8fd260ae618f6b0413cd321bc09cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:33:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ee4ad93e82b8fd260ae618f6b0413cd321bc09cb
Gitweb:     http://git.kernel.org/tip/ee4ad93e82b8fd260ae618f6b0413cd321bc09cb
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 19 Dec 2013 14:41:59 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 16:18:08 -0300

perf tests: Factor make install tests

Factoring make install tests to check for multiple files. Adding default
set of installed files for install and install_bin tests.

Putting the 'test' line into the log file instead to the screen as it
gets more complex now.

If the tests fails to find a file, following message is displayed:

$ make -f tests/make make_install_bin
- make_install_bin: cd . && make -f Makefile DESTDIR=/tmp/tmp.nCVuQoSHaJ install-bin
  failed to find: bin/perf

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1387460527-15030-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/make | 38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 2ca0abf..f641c35 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -106,10 +106,36 @@ test_make_python_perf_so := test -f $(PERF)/python/perf.so
 test_make_perf_o     := test -f $(PERF)/perf.o
 test_make_util_map_o := test -f $(PERF)/util/map.o
 
-test_make_install       := test -x $$TMP_DEST/bin/perf
-test_make_install_O     := $(test_make_install)
-test_make_install_bin   := $(test_make_install)
-test_make_install_bin_O := $(test_make_install)
+define test_dest_files
+  for file in $(1); do				\
+    if [ ! -x $$TMP_DEST/$$file ]; then		\
+      echo "  failed to find: $$file";		\
+    fi						\
+  done
+endef
+
+installed_files_bin := bin/perf
+installed_files_bin += etc/bash_completion.d/perf
+installed_files_bin += libexec/perf-core/perf-archive
+
+installed_files_plugins := lib64/traceevent/plugins/plugin_cfg80211.so
+installed_files_plugins += lib64/traceevent/plugins/plugin_scsi.so
+installed_files_plugins += lib64/traceevent/plugins/plugin_xen.so
+installed_files_plugins += lib64/traceevent/plugins/plugin_function.so
+installed_files_plugins += lib64/traceevent/plugins/plugin_sched_switch.so
+installed_files_plugins += lib64/traceevent/plugins/plugin_mac80211.so
+installed_files_plugins += lib64/traceevent/plugins/plugin_kvm.so
+installed_files_plugins += lib64/traceevent/plugins/plugin_kmem.so
+installed_files_plugins += lib64/traceevent/plugins/plugin_hrtimer.so
+installed_files_plugins += lib64/traceevent/plugins/plugin_jbd2.so
+
+installed_files_all := $(installed_files_bin)
+installed_files_all += $(installed_files_plugins)
+
+test_make_install       := $(call test_dest_files,$(installed_files_all))
+test_make_install_O     := $(call test_dest_files,$(installed_files_all))
+test_make_install_bin   := $(call test_dest_files,$(installed_files_bin))
+test_make_install_bin_O := $(call test_dest_files,$(installed_files_bin))
 
 # FIXME nothing gets installed
 test_make_install_man    := test -f $$TMP_DEST/share/man/man1/perf.1
@@ -162,7 +188,7 @@ $(run):
 	cmd="cd $(PERF) && make -f $(MK) DESTDIR=$$TMP_DEST $($@)"; \
 	echo "- $@: $$cmd" && echo $$cmd > $@ && \
 	( eval $$cmd ) >> $@ 2>&1; \
-	echo "  test: $(call test,$@)"; \
+	echo "  test: $(call test,$@)" >> $@ 2>&1; \
 	$(call test,$@) && \
 	rm -f $@ \
 	rm -rf $$TMP_DEST
@@ -174,7 +200,7 @@ $(run_O):
 	cmd="cd $(PERF) && make -f $(MK) O=$$TMP_O DESTDIR=$$TMP_DEST $($(patsubst %_O,%,$@))"; \
 	echo "- $@: $$cmd" && echo $$cmd > $@ && \
 	( eval $$cmd ) >> $@ 2>&1 && \
-	echo "  test: $(call test_O,$@)"; \
+	echo "  test: $(call test_O,$@)" >> $@ 2>&1; \
 	$(call test_O,$@) && \
 	rm -f $@ && \
 	rm -rf $$TMP_O \
