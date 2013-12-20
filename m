Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab3LTKIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:08:44 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35756 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226Ab3LTKIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:08:37 -0500
Subject: [PATCH -tip  0/3] perf-probe: Dwarf support for uprobes
To: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com, Namhyung Kim <namhyung@kernel.org>
Date: Fri, 20 Dec 2013 10:02:55 +0000
Message-ID: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the series of perf-probe patches which adds 
dwarf(debuginfo) support for uprobes.

Currently perf-probe doesn't support debuginfo for uprobes.
The lack of the debuginfo support for uprobes sometimes
confuses users (or makes them cry) because they can't use
perf-probe as for kprobes case, and that is not what I hope.

So I tried to add debuginfo support for uprobes on
perf-probe. Actually, this is not completely done yet.
We still need to add some features for make it perfect.
However, this series can provide minimum debuginfo
support for uprobes.

For example)
- Shows the probe-able lines of the given function
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

- Shows the available variables of the given line
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

- Set a probe with available vars on the given line
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

---

Masami Hiramatsu (3):
      [CLEANUP] perf-probe: Expand given path to absolute path
      perf-probe: Support dwarf on uprobe events
      perf-probe: Use the actual address as a hint for uprobes


 tools/perf/builtin-probe.c     |   11 ++
 tools/perf/util/probe-event.c  |  247 +++++++++++++++++++++++++++-------------
 tools/perf/util/probe-event.h  |    1 
 tools/perf/util/probe-finder.c |    1 
 4 files changed, 176 insertions(+), 84 deletions(-)

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com

