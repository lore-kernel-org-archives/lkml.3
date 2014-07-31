Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbaGaGEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:04:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:1809 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756552AbaGaGDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:03:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="569800262"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 29/31] perf tools: Add perf-with-kcore script
Date: Thu, 31 Jul 2014 09:01:12 +0300
Message-Id: <1406786474-9306-30-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Decoding an Intel PT trace of the kernel requires
an accurate kernel object image.  This is provided
by making a copy of kcore.  However the copy needs
to be made under the same conditions as the original
recording, and then it needs to be associated with
the perf.data file. The perf-with-kcore script does
that.

The script also checks the permissions on the buildid
cache and can be used to fix them.  That is needed
for distributions where root does not have a home
directory and consequently writes to the same
buildid cache as the user, resulting in cached files
that the user does not have access to.

Example:

$ ./perf-with-kcore
Usage: perf-with-kcore <perf sub-command> <perf.data directory> [<sub-command options> [ -- <workload>]]
       <perf sub-command> can be record, script, report or inject
   or: perf-with-kcore fix_buildid_cache_permissions
$ ./perf-with-kcore record pt_uname -e intel_pt// -- uname
Recording
Using /home/ahunter/bin/perf
perf version 3.15.rc3.g4549ba
/home/ahunter/bin/perf record -o pt_uname/perf.data -e intel_pt//  -- uname
Linux
[ perf record: Woken up 3 times to write data ]
[ perf record: Captured and wrote 0.023 MB pt_uname/perf.data ]
Copying kcore
[sudo] password for ahunter:
Done
$ tools/perf/perf-with-kcore.sh script pt_uname | head
Using /home/ahunter/bin/perf
perf version 3.15.rc3.g4549ba
/home/ahunter/bin/perf script -i pt_uname/perf.data --kallsyms=pt_uname/kcore_dir/kallsyms
         swapper     0 [002] 161533.969666: sched:sched_switch: swapper/2:0 [120] R ==> perf:11316 [120]
          :11315 11315 [003] 161533.969704: sched:sched_switch: perf:11315 [120] S ==> swapper/3:0 [120]
          :11316 11316 [002] 161533.969783: sched:sched_switch: perf:11316 [120] R ==> migration/2:33 [0]
             :33    33 [002] 161533.969791: sched:sched_switch: migration/2:33 [0] S ==> swapper/2:0 [120]
         swapper     0 [003] 161533.969792: sched:sched_switch: swapper/3:0 [120] R ==> perf:11316 [120]
          :11316 11316 [003] 161533.970062: branches:                 0 [unknown] ([unknown]) => ffffffff810532fa native_write_msr_safe ([kernel.kallsyms])
          :11316 11316 [003] 161533.970062: branches:  ffffffff810532fd native_write_msr_safe ([kernel.kallsyms]) => ffffffff81035b31 pt_config_start ([kernel.kallsyms])

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/.gitignore         |   1 +
 tools/perf/Makefile.perf      |   5 +-
 tools/perf/perf-with-kcore.sh | 259 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 264 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/perf-with-kcore.sh

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 782d86e..717221e 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -15,6 +15,7 @@ perf.data
 perf.data.old
 output.svg
 perf-archive
+perf-with-kcore
 tags
 TAGS
 cscope*
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index f7bb2b4..9b1f05d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -126,6 +126,7 @@ PYRF_OBJS =
 SCRIPT_SH =
 
 SCRIPT_SH += perf-archive.sh
+SCRIPT_SH += perf-with-kcore.sh
 
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
@@ -879,6 +880,8 @@ install-bin: all install-gtk
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(call QUIET_INSTALL, perf-archive) \
 		$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
+	$(call QUIET_INSTALL, perf-with-kcore) \
+		$(INSTALL) $(OUTPUT)perf-with-kcore -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 ifndef NO_LIBPERL
 	$(call QUIET_INSTALL, perl-scripts) \
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'; \
@@ -924,7 +927,7 @@ config-clean:
 	@$(MAKE) -C config/feature-checks clean >/dev/null
 
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
-	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
+	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf-with-kcore $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf
 	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
diff --git a/tools/perf/perf-with-kcore.sh b/tools/perf/perf-with-kcore.sh
new file mode 100644
index 0000000..c7ff90a
--- /dev/null
+++ b/tools/perf/perf-with-kcore.sh
@@ -0,0 +1,259 @@
+#!/bin/bash
+# perf-with-kcore: use perf with a copy of kcore
+# Copyright (c) 2014, Intel Corporation.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms and conditions of the GNU General Public License,
+# version 2, as published by the Free Software Foundation.
+#
+# This program is distributed in the hope it will be useful, but WITHOUT
+# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+# more details.
+
+set -e
+
+usage()
+{
+        echo "Usage: perf-with-kcore <perf sub-command> <perf.data directory> [<sub-command options> [ -- <workload>]]" >&2
+        echo "       <perf sub-command> can be record, script, report or inject" >&2
+        echo "   or: perf-with-kcore fix_buildid_cache_permissions" >&2
+        exit 1
+}
+
+find_perf()
+{
+	if [ -n "$PERF" ] ; then
+		return
+	fi
+	PERF=`which perf || true`
+	if [ -z "$PERF" ] ; then
+		echo "Failed to find perf" >&2
+	        exit 1
+	fi
+	if [ ! -x "$PERF" ] ; then
+		echo "Failed to find perf" >&2
+	        exit 1
+	fi
+	echo "Using $PERF"
+	"$PERF" version
+}
+
+copy_kcore()
+{
+	echo "Copying kcore"
+
+	if [ $EUID -eq 0 ] ; then
+		SUDO=""
+	else
+		SUDO="sudo"
+	fi
+
+	rm -f perf.data.junk
+	("$PERF" record -o perf.data.junk $PERF_OPTIONS -- sleep 60) >/dev/null 2>/dev/null &
+	PERF_PID=$!
+
+	# Need to make sure that perf has started
+	sleep 1
+
+	KCORE=$(($SUDO "$PERF" buildid-cache -v -f -k /proc/kcore >/dev/null) 2>&1)
+	case "$KCORE" in
+	"kcore added to build-id cache directory "*)
+		KCORE_DIR=${KCORE#"kcore added to build-id cache directory "}
+	;;
+	*)
+		kill $PERF_PID
+		wait >/dev/null 2>/dev/null || true
+		rm perf.data.junk
+		echo "$KCORE"
+		echo "Failed to find kcore" >&2
+		exit 1
+	;;
+	esac
+
+	kill $PERF_PID
+	wait >/dev/null 2>/dev/null || true
+	rm perf.data.junk
+
+	$SUDO cp -a "$KCORE_DIR" "$(pwd)/$PERF_DATA_DIR"
+	$SUDO rm -f "$KCORE_DIR/kcore"
+	$SUDO rm -f "$KCORE_DIR/kallsyms"
+	$SUDO rm -f "$KCORE_DIR/modules"
+	$SUDO rmdir "$KCORE_DIR"
+
+	KCORE_DIR_BASENAME=$(basename "$KCORE_DIR")
+	KCORE_DIR="$(pwd)/$PERF_DATA_DIR/$KCORE_DIR_BASENAME"
+
+	$SUDO chown $UID "$KCORE_DIR"
+	$SUDO chown $UID "$KCORE_DIR/kcore"
+	$SUDO chown $UID "$KCORE_DIR/kallsyms"
+	$SUDO chown $UID "$KCORE_DIR/modules"
+
+	$SUDO chgrp $GROUPS "$KCORE_DIR"
+	$SUDO chgrp $GROUPS "$KCORE_DIR/kcore"
+	$SUDO chgrp $GROUPS "$KCORE_DIR/kallsyms"
+	$SUDO chgrp $GROUPS "$KCORE_DIR/modules"
+
+	ln -s "$KCORE_DIR_BASENAME" "$PERF_DATA_DIR/kcore_dir"
+}
+
+fix_buildid_cache_permissions()
+{
+	if [ $EUID -ne 0 ] ; then
+		echo "This script must be run as root via sudo " >&2
+		exit 1
+	fi
+
+	if [ -z "$SUDO_USER" ] ; then
+		echo "This script must be run via sudo" >&2
+		exit 1
+	fi
+
+	USER_HOME=$(bash <<< "echo ~$SUDO_USER")
+
+	if [ "$HOME" != "$USER_HOME" ] ; then
+		echo "Fix unnecessary because root has a home: $HOME" >&2
+		exit 1
+	fi
+
+	echo "Fixing buildid cache permissions"
+
+	find "$USER_HOME/.debug" -xdev -type d          ! -user "$SUDO_USER" -ls -exec chown    "$SUDO_USER" \{\} \;
+	find "$USER_HOME/.debug" -xdev -type f -links 1 ! -user "$SUDO_USER" -ls -exec chown    "$SUDO_USER" \{\} \;
+	find "$USER_HOME/.debug" -xdev -type l          ! -user "$SUDO_USER" -ls -exec chown -h "$SUDO_USER" \{\} \;
+
+	if [ -n "$SUDO_GID" ] ; then
+		find "$USER_HOME/.debug" -xdev -type d          ! -group "$SUDO_GID" -ls -exec chgrp    "$SUDO_GID" \{\} \;
+		find "$USER_HOME/.debug" -xdev -type f -links 1 ! -group "$SUDO_GID" -ls -exec chgrp    "$SUDO_GID" \{\} \;
+		find "$USER_HOME/.debug" -xdev -type l          ! -group "$SUDO_GID" -ls -exec chgrp -h "$SUDO_GID" \{\} \;
+	fi
+
+	echo "Done"
+}
+
+check_buildid_cache_permissions()
+{
+	if [ $EUID -eq 0 ] ; then
+		return
+	fi
+
+	PERMISSIONS_OK+=$(find "$HOME/.debug" -xdev -type d          ! -user "$USER" -print -quit)
+	PERMISSIONS_OK+=$(find "$HOME/.debug" -xdev -type f -links 1 ! -user "$USER" -print -quit)
+	PERMISSIONS_OK+=$(find "$HOME/.debug" -xdev -type l          ! -user "$USER" -print -quit)
+
+	PERMISSIONS_OK+=$(find "$HOME/.debug" -xdev -type d          ! -group "$GROUPS" -print -quit)
+	PERMISSIONS_OK+=$(find "$HOME/.debug" -xdev -type f -links 1 ! -group "$GROUPS" -print -quit)
+	PERMISSIONS_OK+=$(find "$HOME/.debug" -xdev -type l          ! -group "$GROUPS" -print -quit)
+
+	if [ -n "$PERMISSIONS_OK" ] ; then
+		echo "*** WARNING *** buildid cache permissions may need fixing" >&2
+	fi
+}
+
+record()
+{
+	echo "Recording"
+
+	if [ $EUID -ne 0 ] ; then
+
+		if [ "$(cat /proc/sys/kernel/kptr_restrict)" -ne 0 ] ; then
+			echo "*** WARNING *** /proc/sys/kernel/kptr_restrict prevents access to kernel addresses" >&2
+		fi
+
+		if echo "$PERF_OPTIONS" | grep -q ' -a \|^-a \| -a$\|^-a$\| --all-cpus \|^--all-cpus \| --all-cpus$\|^--all-cpus$' ; then
+			echo "*** WARNING *** system-wide tracing without root access will not be able to read all necessary information from /proc" >&2
+		fi
+
+		if echo "$PERF_OPTIONS" | grep -q 'intel_pt\|intel_bts\| -I\|^-I' ; then
+			if [ "$(cat /proc/sys/kernel/perf_event_paranoid)" -gt -1 ] ; then
+				echo "*** WARNING *** /proc/sys/kernel/perf_event_paranoid restricts buffer size and tracepoint (sched_switch) use" >&2
+			fi
+
+			if echo "$PERF_OPTIONS" | grep -q ' --per-thread \|^--per-thread \| --per-thread$\|^--per-thread$' ; then
+				true
+			elif echo "$PERF_OPTIONS" | grep -q ' -t \|^-t \| -t$\|^-t$' ; then
+				true
+			elif [ ! -r /sys/kernel/debug -o ! -x /sys/kernel/debug ] ; then
+				echo "*** WARNING *** /sys/kernel/debug permissions prevent tracepoint (sched_switch) use" >&2
+			fi
+		fi
+	fi
+
+	if [ -z "$1" ] ; then
+		echo "Workload is required for recording" >&2
+		usage
+	fi
+
+	if [ -e "$PERF_DATA_DIR" ] ; then
+		echo "'$PERF_DATA_DIR' exists" >&2
+		exit 1
+	fi
+
+	find_perf
+
+	mkdir "$PERF_DATA_DIR"
+
+	echo "$PERF record -o $PERF_DATA_DIR/perf.data $PERF_OPTIONS -- $*"
+	"$PERF" record -o "$PERF_DATA_DIR/perf.data" $PERF_OPTIONS -- $* || true
+
+	if rmdir "$PERF_DATA_DIR" > /dev/null 2>/dev/null ; then
+		exit 1
+	fi
+
+	copy_kcore
+
+	echo "Done"
+}
+
+subcommand()
+{
+	find_perf
+	check_buildid_cache_permissions
+	echo "$PERF $PERF_SUB_COMMAND -i $PERF_DATA_DIR/perf.data --kallsyms=$PERF_DATA_DIR/kcore_dir/kallsyms $*"
+	"$PERF" $PERF_SUB_COMMAND -i "$PERF_DATA_DIR/perf.data" "--kallsyms=$PERF_DATA_DIR/kcore_dir/kallsyms" $*
+}
+
+if [ "$1" = "fix_buildid_cache_permissions" ] ; then
+	fix_buildid_cache_permissions
+	exit 0
+fi
+
+PERF_SUB_COMMAND=$1
+PERF_DATA_DIR=$2
+shift || true
+shift || true
+
+if [ -z "$PERF_SUB_COMMAND" ] ; then
+	usage
+fi
+
+if [ -z "$PERF_DATA_DIR" ] ; then
+	usage
+fi
+
+case "$PERF_SUB_COMMAND" in
+"record")
+	while [ "$1" != "--" ] ; do
+		PERF_OPTIONS+="$1 "
+		shift || break
+	done
+	if [ "$1" != "--" ] ; then
+		echo "Options and workload are required for recording" >&2
+		usage
+	fi
+	shift
+	record $*
+;;
+"script")
+	subcommand $*
+;;
+"report")
+	subcommand $*
+;;
+"inject")
+	subcommand $*
+;;
+*)
+	usage
+;;
+esac
-- 
1.8.3.2

