Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab3JROtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:49:36 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:40894 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab3JROtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:49:35 -0400
Message-ID: <52614A6E.6080609@linux.vnet.ibm.com>
Date: Fri, 18 Oct 2013 20:19:18 +0530
From: Hemant <hkshaw@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com, anton@redhat.com,
        systemtap@sourceware.org, namhyung@kernel.org,
        masami.hiramatsu.pt@hitachi.com, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v3 0/3] Perf support to SDT markers
References: <20131018143714.10452.83494.stgit@hemant-fedora>
In-Reply-To: <20131018143714.10452.83494.stgit@hemant-fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101814-5140-0000-0000-000004045252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 08:12 PM, Hemant Kumar wrote:
> This patchset helps in probing dtrace style markers(SDT) present in user space
> applications through perf. Notes/markers are placed at important places by the
> developers. They have a negligible overhead when not enabled. We can enable
> them and probe at these places and find some important information like the
> arguments' values, etc.
>
> How to add SDT markers into user applications:
> We need to have this header sys/sdt.h present.
> sys/sdt.h used is version 3.
> If not present, install systemtap-sdt-devel package (for fedora-18).
>
> A very simple example to show this :
> $ cat user_app.c
>
> #include <sys/sdt.h>
>
> void main () {
>         /* ... */
>         /*
>          * user_app is the provider name
>          * test_probe is the marker name
>          */
>         STAP_PROBE(user_app, test_mark);
>         /* ... */
> }
>
> $ gcc user_app.c
> $ perf probe -M -x ./a.out
> %user_app:test_mark
>
> A different example to show the same :
> - Create a file with .d extension and mention the probe names in it with
> provider name and marker name.
>
> $ cat probes.d
> provider user_app {
>           probe foo_start();
>               probe fun_start();
> };
>
> - Now create the probes.h and probes.o file :
> $ dtrace -C -h -s probes.d -o probes.h
> $ dtrace -C -G -s probes.d -o probes.o
>
> - A program using the markers:
>
> $ cat user_app.c
>
> #include <stdio.h>
> #include "probes.h"
>
> void foo(void)
> {
>          USER_APP_FOO_START();
>          printf("This is foo\n");
> }
>
> void fun(void)
> {
>          USER_APP_FUN_START();
>          printf("Inside fun\n");
> }
> int main(void)
> {
>          printf("In main\n");
>          foo();
>          fun();
>          return 0;
> }
>
> - Compile it and also provide probes.o file to linker:
> $ gcc user_app.c probes.o -o user_app
>
> - Now use perf to list the markers in the app:
> # perf probe --markers -x ./user_app
>
> %user_app:foo_start
> %user_app:fun_start
>
> - And  then use perf probe to add a probe point :
>
> # perf probe -x ./user_app -a '%user_app:foo_start'
>
> Added new event :
> event = foo_start      (on 0x530)
>
> You can now use it on all perf tools such as :
>
>       perf record -e probe_user:foo_start -aR sleep 1
>
> # perf record -e probe_user:foo_start -aR ./user_app
> In main
> This is foo
> Inside fun
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.235 MB perf.data (~10279 samples) ]
>
> - Then use perf tools to analyze it.
> # perf report --stdio
>
> # ========
> # captured on: Tue Sep  3 16:19:55 2013
> # hostname : hemant-fedora
> # os release : 3.11.0-rc3+
> # perf version : 3.9.4-200.fc18.x86_64
> # arch : x86_64
> # nrcpus online : 2
> # nrcpus avail : 2
> # cpudesc : QEMU Virtual CPU version 1.2.2
> # cpuid : GenuineIntel,6,2,3
> # total memory : 2051912 kBIf these are not enabled, they are present in the \
> ELF as nop.
>
> # cmdline : /usr/bin/perf record -e probe_user:foo_start -aR ./user_app
> # event : name = probe_user:foo_start, type = 2, config = 0x38e, config1
> = 0x0, config2 = 0x0, excl_usr = 0, excl_kern = 0, excl_host = 0,
> excl_guest = 1, precise_ip = 0
> # HEADER_CPU_TOPOLOGY info available, use -I to display
> # HEADER_NUMA_TOPOLOGY info available, use -I to display
> # pmu mappings: software = 1, tracepoint = 2, breakpoint = 5
> # ========
> #
> # Samples: 1  of event 'probe_user:foo_start'
> # Event count (approx.): 1
> #
> # Overhead   Command  Shared Object   Symbol
> # ........  ........  .............  .......
> #
>     100.00%  user_app  user_app       [.] foo
>
>
> #
> # (For a higher level overview, try: perf report --sort comm,dso)
> #
>
> This link shows an example of marker probing with Systemtap:
> https://sourceware.org/systemtap/wiki/AddingUserSpaceProbingToApps
>
> Also, this link provides important info regarding SDT notes:
> http://sourceware.org/systemtap/wiki/UserSpaceProbeImplementation
>
> - Markers in binaries :
> These SDT markers are present in the ELF in the section named
> ".note.stapsdt".
> Here, the name of the marker, its provider, type, location, base
> address, semaphore address.
> We can retrieve these values using the members name_off and desc_off in
> Nhdr structure. If these are not enabled, they are present in the ELF as nop.
>
> All the above info is moved in sdt-probes.txt file present in the Documentation
> directory in tools/perf/.
>
> Changes since last version:
> - Added suggested changes by Masami and Namhyung.
> - Fixed some bugs.
> - Removed some redundancies.
> - Updated with error codes.
> - Rebased it to latest kernel tip.
>
> TODO:
> - Recognizing arguments and support to probe on them.
> ---
>
> Hemant Kumar (3):
>        SDT markers listing by perf:
>        Support for perf to probe into SDT markers:
>        Documentation regarding perf/sdt
>
>
>   tools/perf/Documentation/perf-probe.txt |   17 ++
>   tools/perf/Documentation/sdt-probes.txt |  184 ++++++++++++++++++++
>   tools/perf/builtin-probe.c              |   45 +++++
>   tools/perf/util/probe-event.c           |  134 +++++++++++++-
>   tools/perf/util/probe-event.h           |    3
>   tools/perf/util/symbol-elf.c            |  291 +++++++++++++++++++++++++++++++
>   tools/perf/util/symbol.h                |   21 ++
>   7 files changed, 681 insertions(+), 14 deletions(-)
>   create mode 100644 tools/perf/Documentation/sdt-probes.txt
>

Please ignore the previous patchset. Due to some git config issues, the 
from email id was wrong. It has been fixed in this patchset.

-- 
Thanks
Hemant

