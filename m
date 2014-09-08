Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbaIHMfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:35:09 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:47427 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbaIHMfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:35:07 -0400
MIME-Version: 1.0
Date: Mon, 8 Sep 2014 14:35:06 +0200
Message-ID: <CABPqkBRREcix0TtLLUgiq8uabUqG=m2un79WKLqPXF=LccSQbw@mail.gmail.com>
Subject: [BUG] perf: cannot read counts in per-process mode in 3.17-rcX
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems something is seriously broken with perf_events in
3.17-rcX. I have tried rc3, rc4. No way to get any counts
out using perf stat in per-process mode. I am trying on Intel
and the PMU is correctly detected:

$ perf stat -e cycles ls
      <not counted> cycles

It is not a permission problem. It is a read problem!
$ strace perf stat -e cycles ls

perf_event_open(0x27d7e20, 2261, -1, -1, 0x8 /* PERF_FLAG_??? */) = 3
write(6, "\0", 1)                       = 1
close(6)                                = 0
wait4(-1, [{WIFEXITED(s) && WEXITSTATUS(s) == 0}], 0, NULL) = 2261
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=2261,
si_status=0, si_utime=0, si_stime=0} ---
rt_sigreturn()                          = 2261
read(3, "", 24)                         = 0
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Looks like read() on the perf returns 0 (nothing read!).

It seems to work fine in system-wide mode. So I bet  there were some
recent changes in the way the events are stored when the process
terminates.

I think the perf tool is not to blame here. I see the same problem with my
libpfm4 toy examples.

Can you reproduce the problem on your system?
