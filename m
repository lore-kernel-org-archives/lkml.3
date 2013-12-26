Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3LZGDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 01:03:52 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43378 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3LZGDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 01:03:51 -0500
Subject: [PATCH -tip v2 0/2] perf-probe: Dwarf support for uprobes
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@kernel.org>
Date: Thu, 26 Dec 2013 05:41:48 +0000
Message-ID: <20131226054148.22364.25224.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the 2nd version of the series of perf-probe patches
which adds basic dwarf(debuginfo) support for uprobes.

Currently perf-probe doesn't support debuginfo for uprobes.
The lack of the debuginfo support for uprobes sometimes
confuses users (or makes them cry) because they can't use
perf-probe as for kprobes case, and that is not what I hope.

So I tried to add debuginfo support for uprobes on
perf-probe. Actually, this is not completely done yet.
We still need to add some features for make it perfect.
However, this series can provide minimum debuginfo
support for uprobes.

For example, the following command shows the probe-able lines of
a given user space function. Something that so far was only
available in the 'perf probe' tool for kernel space functions:
----
# ./perf probe -x perf --line map__load
<map__load@/home/fedora/ksrc/linux-2.6/tools/perf/util/map.c:0>
      0  int map__load(struct map *map, symbol_filter_t filter)
      1  {
      2         const char *name = map->dso->long_name;
                int nr;

      5         if (dso__loaded(map->dso, map->type))
      6                 return 0;

      8         nr = dso__load(map->dso, map, filter);
      9         if (nr < 0) {
     10                 if (map->dso->has_build_id) {
----

And this shows the available variables at the given line of
the function.
----
# ./perf probe -x perf --vars map__load:8
Available variables at map__load:8
        @<map__load+96>
                char*   name
                struct map*     map
                symbol_filter_t filter
        @<map__find_symbol+112>
                char*   name
                symbol_filter_t filter
        @<map__find_symbol_by_name+136>
                char*   name
                symbol_filter_t filter
        @<map_groups__find_symbol_by_name+176>
                char*   name
                struct map*     map
                symbol_filter_t filter
----

At last, we can now define a probe(s) with all available
variables on the given line.
----
# ./perf probe -x perf --add 'map__load:8 $vars'

Added new events:
  probe_perf:map__load (on map__load:8 with $vars)
  probe_perf:map__load_1 (on map__load:8 with $vars)
  probe_perf:map__load_2 (on map__load:8 with $vars)
  probe_perf:map__load_3 (on map__load:8 with $vars)

You can now use it in all perf tools, such as:

        perf record -e probe_perf:map__load_3 -aR sleep 1
----

To complete this requires Namhyung's uprobe
fetch-method updates which is almost done on LKML.

TODO:
 - Convert data symbol name in arguments to address
   offset value.
 - Support distro style debuginfo path (/usr/lib/debug/...)
 - Support --list to show actual lines and executable names.

Changes from previous one:
 - Fix not to print null string.
 - Allocate memory for given path/module name everytime.
 - Fix patch descriptions.
 - Add examples in the patch description.
 - Use .text section start address and dwarf symbol address
   for calculating the offset of given symbol, instead of
   searching the symbol in symtab again.
   With this change, we can safely handle multiple local
   function instances (e.g. scnprintf in perf).

---

Masami Hiramatsu (2):
      [CLEANUP] perf-probe: Expand given path to absolute path
      perf-probe: Support basic dwarf-based operations on uprobe events


 tools/perf/builtin-probe.c     |   18 ++++
 tools/perf/util/probe-event.c  |  162 ++++++++++++++++++++++++++++++++++------
 tools/perf/util/probe-event.h  |    1 
 tools/perf/util/probe-finder.c |    1 
 4 files changed, 155 insertions(+), 27 deletions(-)

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

