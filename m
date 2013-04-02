Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760376Ab3DBDyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:54:46 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34466 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760315Ab3DBDyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:54:44 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, linux-kbuild@vger.kernel.org
Subject: [PATCH 00/23] perf: integrate with kconfig and CONFIG driven features
Date: Mon,  1 Apr 2013 21:54:14 -0600
Message-Id: <1364874877-5618-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches can also be retrieved from:
  https://github.com/dsahern/linux.git perf-config

I still need to add the conf build targets from the top level Makefile.

For this RFC series, you can run the commands manually to generate the
.config file for perf and the corresponding include/config/auto.conf and
include/generated/autoconf.h files.

To build conf (if it already exists in kernel tree jump to the conf
commands below):

BLDDIR=/tmp/perf-build
SRCDIR=/path/to/kernel.git

BLDDIR=/tmp/perf
SRCDIR=/opt/sw/perf/ahern.git

mkdir $BLDDIR
cd $BLDDIR
mkdir -p include/config include/generated
rsync -av $SRCDIR/scripts/ scripts/
ln -s $SRCDIR source
cd $SRCDIR
make O=$BLDDIR V=1 scripts/kconfig conf

Ignore the .config errors - those relate to the kernel build.
What matters here is that conf is built.

cd $BLDDIR
touch .config
PATH=$BLDDIR/scripts/kconfig:$PATH ARCH=x86 conf --silentoldconfig $SRCDIR/tools/perf/Pconfig

At this point you are asked what options to enable:

Enable newt-based TUI (NEWT) [N/y] (NEW) y
Enable GTK-based UI (GTK2) [N/y] (NEW) n
Enable support for Bionic (e.g., Android platform) (BIONIC) [N/y] (NEW)
Development support for libc is available - glibc or bionic (LIBC) [N/y] (NEW) y
  Enable support for libelf (LIBELF) [N/y] (NEW) y
    Enable support for libunwind (LIBUNWIND) [N/y] (NEW) y
    Enable support for dwarf (DWARF) [N/y] (NEW) y
    Enable support for demangle (DEMANGLE) [N/y] (NEW) y
Enable support for perl scripting engine (LIBPERL) [N/y] (NEW) y
Enable support for python scripting engine (LIBPYTHON) [N/y] (NEW) y
Enable support for libaudit (LIBAUDIT) [N/y/?] (NEW) y
Enable support for libnuma (LIBNUMA) [N/y/?] (NEW) y
Enable support for stack backtrace debugging (BACKTRACE) [N/y] (NEW) y
\#
\# configuration written to .config
\#

Now build it:
cd $SRCDIR

make -C tools/perf O=$BLDDIR DESTDIR=/tmp/perf-install -j 4

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: linux-kbuild@vger.kernel.org
---
David Ahern (23):
  perf: initial infrasructure for kconfig
  perf: make perl support based on CONFIG_LIBPERL
  perf: make python support based on CONFIG_LIBPYTHON
  perf: make gtk2 support based on CONFIG_GTK2
  perf: make newt support based on CONFIG_NEWT
  perf: remove NEWT_SUPPORT in favor of CONFIG_NEWT
  perf: remove GTK2_SUPPORT in favor of CONFIG_GTK2
  perf: make elf support based on CONFIG_LIBELF
  perf: make cfi unwind support based on CONFIG_LIBUNWIND
  perf: make demangle support based on CONFIG_DEMANGLE
  perf: make dwarf support based on CONFIG_DWARF
  perf: config: add BIONIC config option
  perf config: make numa support based on CONFIG_LIBNUMA
  perf config: make backtrace support based on CONFIG_BACKTRACE
  perf: make libaudit support based on CONFIG_LIBAUDIT
  perf: consolidate CONFIG_LIBUNWIND checks in Makefile
  perf: remove LIBUNWIND_SUPPORT in favor of CONFIG_LIBUNWIND
  perf: deprecate LIBELF_SUPPORT in favor of CONFIG_LIBELF
  perf: deprecate DWARF_SUPPORT in favor of CONFIG_DWARF
  perf: consolidate CONFIG_LIBELF checks in Makefile
  perf: consolidate CONFIG_DWARF checks in Makefile
  perf: Makefile: only add elf to EXTLIBS if CONFIG_LIBELF is set
  perf: only add elf-based object files if CONFIG_LIBELF is set

 tools/perf/Makefile                     |  512 ++++++++++++++-----------------
 tools/perf/Pconfig                      |   59 ++++
 tools/perf/arch/arm/Makefile            |    2 +-
 tools/perf/arch/powerpc/Makefile        |    2 +-
 tools/perf/arch/s390/Makefile           |    2 +-
 tools/perf/arch/sh/Makefile             |    2 +-
 tools/perf/arch/sparc/Makefile          |    2 +-
 tools/perf/arch/x86/Makefile            |    4 +-
 tools/perf/builtin-bench.c              |    5 +-
 tools/perf/builtin-inject.c             |    3 +-
 tools/perf/builtin-probe.c              |   15 +-
 tools/perf/builtin-record.c             |   11 +-
 tools/perf/builtin-script.c             |    5 +-
 tools/perf/config/feature-tests.mak     |   18 +-
 tools/perf/perf.c                       |    5 +-
 tools/perf/ui/ui.h                      |    5 +-
 tools/perf/util/annotate.h              |    5 +-
 tools/perf/util/generate-cmdlist.sh     |    4 +-
 tools/perf/util/hist.h                  |    5 +-
 tools/perf/util/include/dwarf-regs.h    |    4 +-
 tools/perf/util/map.c                   |    3 +-
 tools/perf/util/probe-event.c           |    5 +-
 tools/perf/util/probe-finder.h          |    5 +-
 tools/perf/util/symbol.h                |    7 +-
 tools/perf/util/trace-event-scripting.c |   30 +-
 tools/perf/util/unwind.h                |    5 +-
 tools/perf/util/util.c                  |    5 +-
 27 files changed, 379 insertions(+), 351 deletions(-)
 create mode 100644 tools/perf/Pconfig

-- 
1.7.10.1

