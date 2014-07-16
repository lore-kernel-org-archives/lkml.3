Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaGPUEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:04:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbaGPUDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:03:20 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 09/13] perf tools: Add perf download to download event files
Date: Wed, 16 Jul 2014 22:02:45 +0200
Message-Id: <1405540969-18975-10-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
References: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a downloader to automatically download the right
files from a download site.

This is implemented as a script calling curl, similar to
perf archive. The perf driver automatically calls the right
binary. The downloader is extensible, but currently only
implements an Intel event download.  It would be straightforward
to add other sites too for other vendors.

The downloaded event files are put into ~/.cache/pmu-events, where the
builtin event parser in util/* can find them automatically.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/n/1405123165-22666-8-git-send-email-andi@firstfloor.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/Documentation/perf-download.txt | 31 +++++++++++++++++
 tools/perf/Documentation/perf-list.txt     | 12 ++++++-
 tools/perf/Makefile.perf                   |  5 ++-
 tools/perf/perf-download.sh                | 56 ++++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-download.txt
 create mode 100755 tools/perf/perf-download.sh

diff --git a/tools/perf/Documentation/perf-download.txt b/tools/perf/Documentation/perf-download.txt
new file mode 100644
index 000000000000..9e5b28e10c91
--- /dev/null
+++ b/tools/perf/Documentation/perf-download.txt
@@ -0,0 +1,31 @@
+perf-download(1)
+===============
+
+NAME
+----
+perf-download - Download event files for current CPU.
+
+SYNOPSIS
+--------
+[verse]
+'perf download' [vendor-family-model]
+
+DESCRIPTION
+-----------
+This command automatically downloads the event list for the current CPU and
+stores them in $XDG_CACHE_HOME/pmu-events (or $HOME/.cache/pmu-events).
+The other tools automatically look for them there. The CPU can be also
+specified at the command line.
+
+The downloading is done using http through wget, which needs
+to be installed. When behind a firewall the proxies
+may also need to be set up using "export https_proxy=...."
+
+The user should regularly call this to download updated event lists
+for the current CPU.
+
+Note the downloaded files are stored per user, so if perf is
+used as both normal user and with sudo the event files may
+also need to be moved to root's home directory with
+sudo mkdir /root/.cache ; sud cp -r ~/.cache/pmu-events /root/.cache
+after downloading.
diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index da03992a635b..d241b5c8708f 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -63,6 +63,16 @@ Sampling). Examples to use IBS:
  perf record -a -e r076:p ...          # same as -e cpu-cycles:p
  perf record -a -e r0C1:p ...          # use ibs op counting micro-ops
 
+PER CPU EVENT LISTS
+-------------------
+
+For some CPUs (particularly modern Intel CPUs) "perf download" can
+download additional CPU specific event definitions, which then
+become visible in perf list and available in the other perf tools.
+
+This obsoletes the raw event description method described below
+for most cases.
+
 RAW HARDWARE EVENT DESCRIPTOR
 -----------------------------
 Even when an event is not available in a symbolic form within perf right now,
@@ -125,6 +135,6 @@ types specified.
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-top[1],
-linkperf:perf-record[1],
+linkperf:perf-record[1], linkperf:perf-download[1],
 http://www.intel.com/Assets/PDF/manual/253669.pdf[Intel® 64 and IA-32 Architectures Software Developer's Manual Volume 3B: System Programming Guide],
 http://support.amd.com/us/Processor_TechDocs/24593_APM_v2.pdf[AMD64 Architecture Programmer’s Manual Volume 2: System Programming]
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index f65eb859e116..b1c0b758f88d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -126,6 +126,7 @@ PYRF_OBJS =
 SCRIPT_SH =
 
 SCRIPT_SH += perf-archive.sh
+SCRIPT_SH += perf-download.sh
 
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
@@ -878,6 +879,8 @@ install-bin: all install-gtk
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(call QUIET_INSTALL, perf-archive) \
 		$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
+	$(call QUIET_INSTALL, perf-download) \
+		$(INSTALL) $(OUTPUT)perf-download -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 ifndef NO_LIBPERL
 	$(call QUIET_INSTALL, perl-scripts) \
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'; \
@@ -923,7 +926,7 @@ config-clean:
 	@$(MAKE) -C config/feature-checks clean >/dev/null
 
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
-	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
+	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)/perf-download $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf
 	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
diff --git a/tools/perf/perf-download.sh b/tools/perf/perf-download.sh
new file mode 100755
index 000000000000..f8809f166d8e
--- /dev/null
+++ b/tools/perf/perf-download.sh
@@ -0,0 +1,56 @@
+#!/bin/bash
+# download event files for current cpu for perf
+
+CURLOPT=${CURLOPT:- --max-time 5 -#}
+
+set -e
+
+if ! type curl > /dev/null ; then
+	echo "please install curl"
+	exit 1
+fi
+
+if [ "$1" == "" ] ; then
+	S=$(awk '
+/^vendor/     		{ V=$3 }
+/^model/ && $2 == ":" 	{ M=$3 }
+/^cpu family/ 		{ F = $4 }
+END	      		{ printf("%s-%s-%X", V, F, M) }' /proc/cpuinfo)
+else
+	S="$1"
+fi
+V=$(echo $S  | ( IFS=- read v f m ; echo $v) )
+
+CACHEDIR=${XDG_CACHE_HOME:-~/.cache}
+[ ! -d $CACHEDIR/pmu-events ] && mkdir -p $CACHEDIR/pmu-events
+cd $CACHEDIR/pmu-events
+
+case "$V" in
+GenuineIntel)
+	echo "Downloading models file"
+	URLBASE=${URLBASE:-https://download.01.org/perfmon}
+	MAPFILE=${MAPFILE:-mapfile.csv}
+	echo "Downloading readme.txt"
+	curl $CURLOPT $URLBASE/readme.txt -o readme.txt
+	;;
+
+# Add more CPU vendors here
+
+*)
+	echo "Unsupported CPU vendor $V"
+	exit 1
+	;;
+esac
+
+curl $CURLOPT $URLBASE/$MAPFILE -o $MAPFILE
+
+echo "Downloading events file"
+awk -v urlbase=$URLBASE -v cpu="$S" -F, \
+	'$1 == cpu && $4 == "core" { print "url = \"" urlbase $3 "\""; exit 0 }' \
+	$MAPFILE > url$$
+if [ -s url$$ ] ; then
+	curl $CURLOPT -K url$$ -o $S-core.json
+else
+	echo "CPU $S not found"
+fi
+rm -f url$$
-- 
1.8.3.1

