Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbaI3JGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 05:06:24 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:40676 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaI3JGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:06:22 -0400
MIME-Version: 1.0
Date: Tue, 30 Sep 2014 11:06:21 +0200
Message-ID: <CAFrcx1kufO2yj7--UiL841Yp5Es5=WqjL__Yzg=-+nPV5XoohA@mail.gmail.com>
Subject: perf & rasd integration plan
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Fu Wei <fu.wei@linaro.org>, Robert Richter <rric@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RAS Deamon (rasd) as available at [1] and the development version
at [2], allows to enable kernel tracepoints and outputs the
tracepoints fields according to the kernel format.

[1] https://git.kernel.org/cgit/utils/ras/rasd.git/
[2] https://git.linaro.org/people/jean.pihet/rasd.git

rasd currently is a duplicate of the perf tool code, ultimately perf
and rasd will use the same common code. The goal is to factor out the
common code from perf and place it in small librairies in tools/lib.

Here is the code that rasd currently uses and that should be moved to tools/lib:

- debugfs: already in tools/lib/api/fs
  . mount and retrieve path

- evlist: tools/perf/util/evlist.[ch]
  . create and init new evlist,
  . set cpu and thread maps,
  . add events to evlist,
  . init and use internal event id,
  . alloc and mmap events buffers, manage file descriptors,
  . enable events,
  . read events buffers, parse data,
  . unmap and free buffers

- evsel: tools/perf/util/evsel.[ch]
  . create and init new tracepoints events,
  . init and use internal event id,
  . open events, manage fds,
  . close and free events

- trace-event: tools/perf/util/trace-event.[ch] and
  tools/perf/util/trace-event-parse.c
  . retrieve and parse events format (using event-parse),
  . print out events fields

- event-parse: already in tools/lib/traceevent/event-parse.[ch]
  . retrieve and parse events format,
  . parse events format and print out events fields

- trace-seq: already in tools/lib/traceevent/trace-seq.c
  . format output string for event fields

- events plugins: already in tools/lib/traceevent/event-plugin.c

- util: tools/perf/util/util.[ch]
  . files open/read,
  . manage events attributes,
  . various macros

- test events attributes: tools/perf/tests/attr.c
  . test_attr__open()

- thread: tools/perf/util/thread_map.[ch] and
- cpu: tools/perf/util/cpumap.[ch]
  . init and manage process maps

- xyarray: tools/perf/util/xyarray.[ch]

- syscall: tools/perf/perf-sys.h

- cgroup: tools/perf/util/cgroup.[ch]

The plan is to move the small and generic functions first: util,
xyarray, cpumap, thread_map etc; then evlist, evsel, trace-event,
trace-event-parse; and finally integrate rasd into the tools/ dir.

Any thought? Can evlist, evsel etc. be moved at once?

Patches should come soon, when time allows.

Regards,
Jean
