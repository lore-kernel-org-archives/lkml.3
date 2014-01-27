Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaA0Oqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:46:46 -0500
Received: from mail-yk0-f175.google.com ([209.85.160.175]:64463 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbaA0Oqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:46:44 -0500
Date: Mon, 27 Jan 2014 11:46:37 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip 0/8] perf-probe: Updates for handling local
 functions correctly
Message-ID: <20140127144637.GA3998@ghostprotocols.net>
References: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
 <52E6345D.6080902@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E6345D.6080902@hitachi.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 27, 2014 at 07:26:37PM +0900, Masami Hiramatsu escreveu:
> Hi Arnaldo,
> 
> Could you wait for pulling this series?
> I've found that this series has an obvious bug on
> kaslr enabled kernel. I'll fix that by using
> the relative address from _stext for kprobes.

No problem, I just processed that map->map_ip() one, that already found
its way into tip/perf/urgent.

I had those patches processed localy, will move them to a "delayed"
branch, will wait for your refreshed patches.

Thanks,

- Arnaldo
 
> Thank you,
> 
> (2014/01/23 11:29), Masami Hiramatsu wrote:
> > Hi,
> > 
> > Here is a series of patches for handling local functions
> > correctly in perf-probe.
> > 
> > Issue 1)
> >  Current perf-probe can't handle probe-points for kprobes,
> >  since it uses symbol-based probe definition. The symbol
> >  based definition is easy to read and robust for differnt
> >  kernel and modules. However, when user gives a local
> >  function name which has several different instances,
> >  it may put probes on wrong (or unexpected) address.
> >  On the other hand, since uprobe events are based on the
> >  actual address, it can avoid this issue.
> > 
> >  E.g.
> > In the case to probe t_show local functions (which has
> > 4 different instances.
> > ----
> > # grep " t_show\$" /proc/kallsyms
> > ffffffff810d9720 t t_show
> > ffffffff810e2e40 t t_show
> > ffffffff810ece30 t t_show
> > ffffffff810f4ad0 t t_show
> > # ./perf probe -f t_show \$vars
> > Added new events:
> >   probe:t_show         (on t_show with $vars)
> >   probe:t_show_1       (on t_show with $vars)
> >   probe:t_show_2       (on t_show with $vars)
> >   probe:t_show_3       (on t_show with $vars)
> > 
> > You can now use it in all perf tools, such as:
> > 
> >         perf record -e probe:t_show_3 -aR sleep 1
> > ----
> > OK, we have 4 different t_show()s. All functions have
> > different arguments as below;
> > ----
> > # cat /sys/kernel/debug/tracing/kprobe_events
> > p:probe/t_show t_show m=%di:u64 v=%si:u64
> > p:probe/t_show_1 t_show m=%di:u64 v=%si:u64 t=%si:u64
> > p:probe/t_show_2 t_show m=%di:u64 v=%si:u64 fmt=%si:u64
> > p:probe/t_show_3 t_show m=%di:u64 v=%si:u64 file=%si:u64
> > ----
> > However, all of them have been put on the *same* address.
> > ----
> > # cat /sys/kernel/debug/kprobes/list
> > ffffffff810d9720  k  t_show+0x0    [DISABLED]
> > ffffffff810d9720  k  t_show+0x0    [DISABLED]
> > ffffffff810d9720  k  t_show+0x0    [DISABLED]
> > ffffffff810d9720  k  t_show+0x0    [DISABLED]
> > ----
> >  oops...
> > 
> > Issue 2)
> >  With the debuginfo, issue 1 can be solved by using
> >  address-based probe definition instead of symbol-based.
> >  However, without debuginfo, perf-probe can only use
> >  symbol-map in the binary (or kallsyms). The map provides
> >  symbol find methods, but it returns only the first matched
> >  symbol. To put probes on all functions which have given
> >  symbol, we need a symbol-list iterator for the map.
> > 
> >  E.g. (built perf with NO_DWARF=1)
> > In the case to probe t_show and identity__map_ip in perf.
> > ----
> > # ./perf probe -a t_show
> > Added new event:
> >   probe:t_show         (on t_show)
> > 
> > You can now use it in all perf tools, such as:
> > 
> >         perf record -e probe:t_show -aR sleep 1
> > 
> > # ./perf probe -x perf -a identity__map_ip
> > no symbols found in /kbuild/ksrc/linux-3/tools/perf/perf, maybe install a debug package?
> > Failed to load map.
> >   Error: Failed to add events. (-22)
> > ----
> >  oops.....
> > 
> > 
> > Solutions)
> > To solve the issue 1, this series changes perf probe to
> > use address-based probe definition. This means that we
> > also need to fix the --list options to analyze probe
> > addresses instead of symbols (and that has been done
> > in this series).
> > 
> > E.g. with this series;
> > ----
> > # ./perf probe -f t_show \$vars
> > Added new events:
> >   probe:t_show         (on t_show with $vars)
> >   probe:t_show_1       (on t_show with $vars)
> >   probe:t_show_2       (on t_show with $vars)
> >   probe:t_show_3       (on t_show with $vars)
> > 
> > You can now use it in all perf tools, such as:
> > 
> >         perf record -e probe:t_show_3 -aR sleep 1
> > 
> > # cat /sys/kernel/debug/tracing/kprobe_events
> > p:probe/t_show 0xffffffff810d9720 m=%di:u64 v=%si:u64
> > p:probe/t_show_1 0xffffffff810e2e40 m=%di:u64 v=%si:u64 t=%si:u64
> > p:probe/t_show_2 0xffffffff810ece30 m=%di:u64 v=%si:u64 fmt=%si:u64
> > p:probe/t_show_3 0xffffffff810f4ad0 m=%di:u64 v=%si:u64 file=%si:u64
> > 
> > # cat /sys/kernel/debug/kprobes/list
> > ffffffff810e2e40  k  t_show+0x0    [DISABLED]
> > ffffffff810ece30  k  t_show+0x0    [DISABLED]
> > ffffffff810f4ad0  k  t_show+0x0    [DISABLED]
> > ffffffff810d9720  k  t_show+0x0    [DISABLED]
> > ----
> > This time we can see the events are set in different
> > addresses.
> > 
> > And for the issue 2, the last patch introduces symbol
> > iterators for map, dso and symbols (since the symbol
> > list is the symbols and it is included dso, and perf
> > probe accesses dso via map).
> > 
> > E.g. with this series (built perf with NO_DWARF=1);
> > ----
> > # ./perf probe -a t_show
> > Added new events:
> >   probe:t_show         (on t_show)
> >   probe:t_show_1       (on t_show)
> >   probe:t_show_2       (on t_show)
> >   probe:t_show_3       (on t_show)
> > 
> > You can now use it in all perf tools, such as:
> > 
> >         perf record -e probe:t_show_3 -aR sleep 1
> > 
> > # ./perf probe -x perf -a identity__map_ip
> > Added new events:
> >   probe_perf:identity__map_ip (on identity__map_ip in /kbuild/ksrc/linux-3/tools/perf/perf)
> >   probe_perf:identity__map_ip_1 (on identity__map_ip in /kbuild/ksrc/linux-3/tools/perf/perf)
> >   probe_perf:identity__map_ip_2 (on identity__map_ip in /kbuild/ksrc/linux-3/tools/perf/perf)
> >   probe_perf:identity__map_ip_3 (on identity__map_ip in /kbuild/ksrc/linux-3/tools/perf/perf)
> > 
> > You can now use it in all perf tools, such as:
> > 
> >         perf record -e probe_perf:identity__map_ip_3 -aR sleep 1
> > ----
> > Now, even without the debuginfo, both the kprobe and
> > uprobe are set 4 different places correctly.
> > 
> > BTW, while testing above, I've found some bugs and
> > another minor issue; perf-probe doesn't show the
> > modules and binaries in which probes are set.
> > I've also fixed it in this series as below.
> > 
> > Without the fix;
> > 
> > # ./perf probe -m drm drm_av_sync_delay
> > # ./perf probe -x perf dso__load_vmlinux
> > 
> > # ./perf probe -l
> >   probe:drm_av_sync_delay (on drm_av_sync_delay)
> >   probe_perf:dso__load_vmlinux (on 0x000000000006d110)
> > 
> > With this fix;
> > 
> > # ./perf probe -l
> >   probe:drm_av_sync_delay (on drm_av_sync_delay in drm)
> >   probe_perf:dso__load_vmlinux (on 0x000000000006d110 in /kbuild/ksrc/linux-3/tools/perf/perf)
> > 
> > 
> > TODO:
> >  - Support local functions in modules. This requires kernel
> >  side enhancement to allow setting probes by the relative
> >  addresses in modules too.
> >  - Uprobe-event MUST traces the change of given binary even
> >  when the event is disabled. I've found that user can replace
> >  the target binary after setting events and the events can be
> >  enabled on the different instructions...
> > 
> > ---
> > 
> > Masami Hiramatsu (8):
> >       [BUGFIX] perf-probe: Fix to do exit call for symbol maps
> >       [BUGFIX] perf-tools: Load map before using map->map_ip
> >       perf-probe: Show in what binaries/modules probes are set
> >       perf-probe: Use the actual address instead of the symbol name
> >       perf-probe: Show source level information for address only kprobes
> >       perf-probe: Show symbol+offset for address only kprobes
> >       perf-probe: Show source-level or symbol-level info for uprobes
> >       perf-probe: Allow to add events on the local functions
> > 
> > 
> >  tools/perf/util/dso.h         |   10 +
> >  tools/perf/util/map.c         |    3 
> >  tools/perf/util/map.h         |   10 +
> >  tools/perf/util/probe-event.c |  661 ++++++++++++++++++++++-------------------
> >  tools/perf/util/symbol.h      |   11 +
> >  5 files changed, 387 insertions(+), 308 deletions(-)
> > 
> 
> 
> -- 
> Masami HIRAMATSU
> IT Management Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
> 
