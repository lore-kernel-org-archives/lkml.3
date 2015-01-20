Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbbATQmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:42:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184AbbATQmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:42:37 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Florian Fainelli <florian@openwrt.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jan Heylen <heyleke@gmail.com>,
        Mark Salter <msalter@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "S. Lockwood-Childs" <sjl@vctlabs.com>,
        Sam Ravnborg <sam@ravnborg.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCHv3 00/36] perf tools: New build framework
Date: Tue, 20 Jan 2015 17:38:57 +0100
Message-Id: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
I'm following up on latest post from Alexis:
  http://marc.info/?l=linux-kernel&m=141427580405357&w=2

v3 changes:
  - disabling only builtin rules, keeping builtin variables in place
    because some projects we depends on using them (traceevent) [David]
  - fixed empy source list issue that happened on arm [Will, Mark]
  - updated to the current Arnaldo's perf/core branch
  - added automated tests into: tools/build/tests/
  - tested on arm64,ppc64,s390,x86_64,i386

v2 changes:
  - build Makefiles librarized and moved to 'tools/build' [Ingo]
  - several minor fixies [Namhyung]
  - tested on other archs now - x86_64, i386, powerpc
  - moved tools/lib/* under new build framework to show
    that it's possible ;-)
    included traceevent/lockdep maintainers to get the feedback
  - omitted last 2 patches

The patchset is also available in:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/build

All tests/make tests passed.

Any feedback from ARM guys would be great ;-)


Since it's actually small portion of kbuild that perf needs,
I realized it's actually better to steal it than 'reconfigure'
kbuild to be usable for perf.

Also this patchset is kind of incremental version of the latest:
  perf tools: Add kbuild support into Makefile.kbuild
so it should be easier to review.

NOTE I couldn't find any copyright/credit messages in the kbuild
system, but would be happy to include it if someone suggests one.

The stolen parts are in files:
  Makefile.kbuild
  Build.include

The idea and more details are explained in the 'Documentation/Build'
file. The basic idea is the same as in kbuild system, with some minor
changes to allow for multiple binaries build definitions.

User provides 'Build' files with objects definitions like:
  perf-y += perf.o
  perf-y += builtin-bench.o
  ...

  libperf-y += util/
  ...

and the build framework outputs files:
  perf-in.o
  libperf-in.o

which are then linked into appropriate binaries/libraries.
(perf libperf.a libperf-gtk.so)

Also now we have the full dependency check ((gcc -Wp,-MD,... stuff) and
build command line is stored/checked automatically by the build system.

thanks for comments,
jirka


Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jan Heylen <heyleke@gmail.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: S. Lockwood-Childs <sjl@vctlabs.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
Jiri Olsa (36):
      tools build: Add new build support
      tools build: Add detected config support
      tools build: Add subdir support
      perf tools: Remove api fs object from python build
      perf build: Disable make's built-in rules
      perf build: Add bench objects building
      perf build: Add tests objects building
      perf build: Add builtin objects building
      perf build: Add libperf objects building
      perf build: Add probe objects building
      perf build: Add dwarf objects building
      perf build: Add dwarf unwind objects building
      perf build: Add ui objects building
      perf build: Add slang objects building
      perf build: Add gtk objects building
      perf build: Add scripts objects building
      perf build: Add perf regs objects building
      perf build: Add zlib objects building
      perf build: Add perf.o object building
      perf build: Add arch x86 objects building
      perf build: Add arch arm objects building
      perf build: Add arch arm64 objects building
      perf build: Add arch powerpc objects building
      perf build: Add arch s390 objects building
      perf build: Add arch sh objects building
      perf build: Add arch sparc objects building
      perf build: Add single target build framework support
      perf build: Remove directory dependency rules
      perf build: Remove uneeded variables
      perf build: Remove PERF-CFLAGS file
      perf build: Add build documentation
      tools lib api: Use tools build framework
      tools lib api: Rename libapikfs.a to libapi.a
      tools lib traceevent: Use tools build framework
      tools lib lockdep: Use tools build framework
      perf build: Display make commands on V=1

 tools/build/Build.include                       |  74 +++
 tools/build/Documentation/Build.txt             | 132 ++++++
 tools/build/Makefile.build                      | 125 +++++
 tools/build/tests/ex/Build                      |   8 +
 tools/build/tests/ex/Makefile                   |  23 +
 tools/build/tests/ex/a.c                        |   5 +
 tools/build/tests/ex/arch/Build                 |   2 +
 tools/build/tests/ex/arch/e.c                   |   5 +
 tools/build/tests/ex/arch/f.c                   |   5 +
 tools/build/tests/ex/b.c                        |   5 +
 tools/build/tests/ex/c.c                        |   5 +
 tools/build/tests/ex/d.c                        |   5 +
 tools/build/tests/ex/empty/Build                |   0
 tools/build/tests/ex/ex.c                       |  19 +
 tools/build/tests/run.sh                        |  42 ++
 tools/lib/api/Build                             |   2 +
 tools/lib/api/Makefile                          |  57 +--
 tools/lib/api/fd/Build                          |   1 +
 tools/lib/api/fs/Build                          |   2 +
 tools/lib/lockdep/Build                         |   1 +
 tools/lib/lockdep/Makefile                      | 132 +-----
 tools/lib/traceevent/Build                      |  17 +
 tools/lib/traceevent/Makefile                   | 161 ++-----
 tools/perf/Build                                |  43 ++
 tools/perf/Documentation/Build.txt              |  49 ++
 tools/perf/MANIFEST                             |   1 +
 tools/perf/Makefile.perf                        | 605 +++---------------------
 tools/perf/arch/Build                           |   2 +
 tools/perf/arch/arm/Build                       |   2 +
 tools/perf/arch/arm/Makefile                    |  11 -
 tools/perf/arch/arm/tests/Build                 |   2 +
 tools/perf/arch/arm/util/Build                  |   4 +
 tools/perf/arch/arm64/Build                     |   1 +
 tools/perf/arch/arm64/Makefile                  |   4 -
 tools/perf/arch/arm64/util/Build                |   2 +
 tools/perf/arch/powerpc/Build                   |   1 +
 tools/perf/arch/powerpc/Makefile                |   3 -
 tools/perf/arch/powerpc/util/Build              |   4 +
 tools/perf/arch/s390/Build                      |   1 +
 tools/perf/arch/s390/Makefile                   |   3 -
 tools/perf/arch/s390/util/Build                 |   4 +
 tools/perf/arch/sh/Build                        |   1 +
 tools/perf/arch/sh/Makefile                     |   1 -
 tools/perf/arch/sh/util/Build                   |   1 +
 tools/perf/arch/sparc/Build                     |   1 +
 tools/perf/arch/sparc/Makefile                  |   1 -
 tools/perf/arch/sparc/util/Build                |   1 +
 tools/perf/arch/x86/Build                       |   2 +
 tools/perf/arch/x86/Makefile                    |  15 -
 tools/perf/arch/x86/tests/Build                 |   2 +
 tools/perf/arch/x86/util/Build                  |   8 +
 tools/perf/bench/Build                          |  11 +
 tools/perf/config/Makefile                      |  41 ++
 tools/perf/scripts/Build                        |   2 +
 tools/perf/scripts/perl/Perf-Trace-Util/Build   |   3 +
 tools/perf/scripts/python/Perf-Trace-Util/Build |   3 +
 tools/perf/tests/Build                          |  42 ++
 tools/perf/ui/Build                             |  14 +
 tools/perf/ui/browsers/Build                    |  10 +
 tools/perf/ui/gtk/Build                         |   9 +
 tools/perf/ui/tui/Build                         |   4 +
 tools/perf/util/Build                           | 142 ++++++
 tools/perf/util/python-ext-sources              |   1 -
 tools/perf/util/scripting-engines/Build         |   6 +
 64 files changed, 1058 insertions(+), 833 deletions(-)
 create mode 100644 tools/build/Build.include
 create mode 100644 tools/build/Documentation/Build.txt
 create mode 100644 tools/build/Makefile.build
 create mode 100644 tools/build/tests/ex/Build
 create mode 100644 tools/build/tests/ex/Makefile
 create mode 100644 tools/build/tests/ex/a.c
 create mode 100644 tools/build/tests/ex/arch/Build
 create mode 100644 tools/build/tests/ex/arch/e.c
 create mode 100644 tools/build/tests/ex/arch/f.c
 create mode 100644 tools/build/tests/ex/b.c
 create mode 100644 tools/build/tests/ex/c.c
 create mode 100644 tools/build/tests/ex/d.c
 create mode 100644 tools/build/tests/ex/empty/Build
 create mode 100644 tools/build/tests/ex/ex.c
 create mode 100755 tools/build/tests/run.sh
 create mode 100644 tools/lib/api/Build
 create mode 100644 tools/lib/api/fd/Build
 create mode 100644 tools/lib/api/fs/Build
 create mode 100644 tools/lib/lockdep/Build
 create mode 100644 tools/lib/traceevent/Build
 create mode 100644 tools/perf/Build
 create mode 100644 tools/perf/Documentation/Build.txt
 create mode 100644 tools/perf/arch/Build
 create mode 100644 tools/perf/arch/arm/Build
 create mode 100644 tools/perf/arch/arm/tests/Build
 create mode 100644 tools/perf/arch/arm/util/Build
 create mode 100644 tools/perf/arch/arm64/Build
 create mode 100644 tools/perf/arch/arm64/util/Build
 create mode 100644 tools/perf/arch/powerpc/Build
 create mode 100644 tools/perf/arch/powerpc/util/Build
 create mode 100644 tools/perf/arch/s390/Build
 create mode 100644 tools/perf/arch/s390/util/Build
 create mode 100644 tools/perf/arch/sh/Build
 create mode 100644 tools/perf/arch/sh/util/Build
 create mode 100644 tools/perf/arch/sparc/Build
 create mode 100644 tools/perf/arch/sparc/util/Build
 create mode 100644 tools/perf/arch/x86/Build
 create mode 100644 tools/perf/arch/x86/tests/Build
 create mode 100644 tools/perf/arch/x86/util/Build
 create mode 100644 tools/perf/bench/Build
 create mode 100644 tools/perf/scripts/Build
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/Build
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/Build
 create mode 100644 tools/perf/tests/Build
 create mode 100644 tools/perf/ui/Build
 create mode 100644 tools/perf/ui/browsers/Build
 create mode 100644 tools/perf/ui/gtk/Build
 create mode 100644 tools/perf/ui/tui/Build
 create mode 100644 tools/perf/util/Build
 create mode 100644 tools/perf/util/scripting-engines/Build
