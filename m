Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3K2Lp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:45:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab3K2Lp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:45:57 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [RFC 0/6] perf tools: Add perf_evlist errno
Date: Fri, 29 Nov 2013 12:45:04 +0100
Message-Id: <1385725510-20118-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
Andi reported wrong error message for :S modifier
on kernel without event ID ioctl support.

The reason was that the ioctl failed, but the error was
printed like the mmap would:

    $ perf.old record -e '{cycles,cache-misses}:S' ls
    failed to mmap with 25 (Inappropriate ioctl for device)
    ls: Terminated

I experimentally added sort of 'libc errno' interface for
perf_evlist to be able to get proper error message, like:

    $ perf record -e '{cycles,cache-misses}:S' ls
    Cannot read event group on this kernel.
    Please consider kernel update (v3.12+).
    ls: Terminated

I'm not sure about this approach. Maybe it'd be better be more
global..? So before throwing this out, sending it as RFC ;-)

thanks for ideas,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
---
Jiri Olsa (6):
      perf tools: Add perf_evlist error string interface
      perf tools: Add PERF_EVLIST__ERRNO_MMAP internal error
      perf tools: Add PERF_EVLIST__ERRNO_OPEN internal error
      perf tools: Add PERF_EVLIST__ERRNO_IOCTL_ID_GROUP internal error
      perf tools: Add PERF_EVLIST__ERRNO_NEWTP internal error
      perf tools: Use perf_evlist__strerror in kvm/record/top/trace commands

 tools/perf/builtin-kvm.c    |   2 +-
 tools/perf/builtin-record.c |  13 +------
 tools/perf/builtin-top.c    |   3 +-
 tools/perf/builtin-trace.c  |  34 ++++++++---------
 tools/perf/util/evlist.c    | 205 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---------------------------------
 tools/perf/util/evlist.h    |  23 +++++++++++-
 6 files changed, 181 insertions(+), 99 deletions(-)
