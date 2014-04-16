Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbaDPSty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:49:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:61854 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756331AbaDPStw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:49:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,873,1389772800"; 
   d="scan'208";a="521807595"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 06/10] perf, tools: Add perf download to download event files v2
Date: Wed, 16 Apr 2014 11:49:28 -0700
Message-Id: <1397674172-30959-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1397674172-30959-1-git-send-email-andi@firstfloor.org>
References: <1397674172-30959-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add a downloader to automatically download the right
files from a download site.

This is implemented as a script calling wget, similar to
perf archive. The perf driver automatically calls the right
binary. The downloader is extensible, but currently only
implements an Intel event download.  It would be straightforward
to add other sites too for other vendors.

The downloaded event files are put into ~/.cache/pmu-events, where the
builtin event parser in util/* can find them automatically.

Cc: Use ~/.cache
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-download.txt | 28 ++++++++++++++++
 tools/perf/Documentation/perf-list.txt     | 12 ++++++-
 tools/perf/Makefile.perf                   |  5 ++-
 tools/perf/perf-download.sh                | 52 ++++++++++++++++++++++++++++++
 4 files changed, 95 insertions(+), 2 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-download.txt
 create mode 100755 tools/perf/perf-download.sh

diff --git a/tools/perf/Documentation/perf-download.txt b/tools/perf/Documentation/perf-download.txt
new file mode 100644
index 0000000..84a1c14
--- /dev/null
+++ b/tools/perf/Documentation/perf-download.txt
@@ -0,0 +1,28 @@
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
+This command automatically downloads event list for the current CPU and
+stores them in $XDG_CACHE_HOME/pmu-events (or $HOME/.cache/pmu-events).
+The other tools automatically look for them there. The CPU can be also
+specified at the command line.
+
+The downloading is done using http through wget, which needs
+to be installed.
+
+The user should regularly call this to download updated event lists
+for the current CPU.
+
+Note the downloaded files are stored per user, so if you use
+perf as normal user or with sudo you have to run perf download
+for both or specify --json-file for the users manually.
diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index d399e04..e8d5153 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -61,6 +61,16 @@ Sampling). Examples to use IBS:
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
@@ -123,6 +133,6 @@ types specified.
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-top[1],
-linkperf:perf-record[1],
+linkperf:perf-record[1], linkperf:perf-download[1],
 http://www.intel.com/Assets/PDF/manual/253669.pdf[Intel® 64 and IA-32 Architectures Software Developer's Manual Volume 3B: System Programming Guide],
 http://support.amd.com/us/Processor_TechDocs/24593_APM_v2.pdf[AMD64 Architecture Programmer’s Manual Volume 2: System Programming]
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index fdea4cb..6c103f7 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -126,6 +126,7 @@ PYRF_OBJS =
 SCRIPT_SH =
 
 SCRIPT_SH += perf-archive.sh
+SCRIPT_SH += perf-download.sh
 
 grep-libs = $(filter -l%,$(1))
 strip-libs = $(filter-out -l%,$(1))
@@ -869,6 +870,8 @@ install-bin: all install-gtk
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(call QUIET_INSTALL, perf-archive) \
 		$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
+	$(call QUIET_INSTALL, perf-download) \
+		$(INSTALL) $(OUTPUT)perf-download -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 ifndef NO_LIBPERL
 	$(call QUIET_INSTALL, perl-scripts) \
 		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'; \
@@ -914,7 +917,7 @@ config-clean:
 	@$(MAKE) -C config/feature-checks clean >/dev/null
 
 clean: $(LIBTRACEEVENT)-clean $(LIBAPIKFS)-clean config-clean
-	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
+	$(call QUIET_CLEAN, core-objs)  $(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)/perf-download $(OUTPUT)perf.o $(LANG_BINDINGS) $(GTK_OBJS)
 	$(call QUIET_CLEAN, core-progs) $(RM) $(ALL_PROGRAMS) perf
 	$(call QUIET_CLEAN, core-gen)   $(RM)  *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope* $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)PERF-CFLAGS $(OUTPUT)PERF-FEATURES $(OUTPUT)util/*-bison* $(OUTPUT)util/*-flex*
 	$(QUIET_SUBDIR0)Documentation $(QUIET_SUBDIR1) clean
diff --git a/tools/perf/perf-download.sh b/tools/perf/perf-download.sh
new file mode 100755
index 0000000..8f57a2a
--- /dev/null
+++ b/tools/perf/perf-download.sh
@@ -0,0 +1,52 @@
+#!/bin/bash
+# download event files for current cpu for perf
+
+WGETOPT=${WGETOPT:---no-verbose --timeout 5}
+
+set -e
+
+if [ "$1" == "" ] ; then
+	S=$(awk '
+/^vendor/     		{ V=$3 }
+/^model/ && $2 == ":" 	{ M=$3 }
+/^cpu family/ 		{ F = $4 }
+END	      { printf("%s-%s-%X", V, F, M) }' /proc/cpuinfo)
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
+	wget -N $WGETOPT $URLBASE/readme.txt
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
+wget -N $WGETOPT $URLBASE/$MAPFILE
+
+echo "Downloading events file"
+awk -v urlbase=$URLBASE -v cpu="$S" -F, \
+	'$1 == cpu && $4 == "core" { print urlbase $3; exit 0 }' \
+	$MAPFILE > url$$
+if [ -s url$$ ] ; then
+	wget $WGETOPT -q -i url$$ -O $S-core.json
+else
+	echo "CPU $S not found"
+fi
+rm -f url$$
+
-- 
1.8.5.3

