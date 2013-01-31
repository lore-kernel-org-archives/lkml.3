Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3AaXvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 18:51:55 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:35059 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab3AaXvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 18:51:52 -0500
MIME-Version: 1.0
Date: Fri, 1 Feb 2013 00:51:51 +0100
Message-ID: <CABPqkBSK_+v+16EPphRkWb+nqmxHwiV6gVo_5yfmqCV8-f062g@mail.gmail.com>
Subject: [BUG] perf annotate: broken in pipe mode
From: Stephane Eranian <eranian@google.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks like perf annotate in pipe mode is totally broken nowadays.
I tried this from tip.git:

$ perf record -o - noploop 5 >perf.data
$ perf annotate -i i < perf.data
Core dump

Callstack looks as follows:
0x000000000049f9e4 in add_hist_entry (hists=0x809708,
entry=0x7fffffffde60, al=0x7fffffffdff0, period=1) at util/hist.c:297
297 while (*p != NULL) {
:t
[Current thread is 1 (Thread 0x7ffff7fc9980 (LWP 13292))]
(gdb) bt
#0  0x000000000049f9e4 in add_hist_entry (hists=0x809708,
entry=0x7fffffffde60, al=0x7fffffffdff0, period=1) at util/hist.c:297
#1  0x000000000049fcca in __hists__add_entry (self=0x809708,
al=0x7fffffffdff0, sym_parent=0x0, period=1) at util/hist.c:395
#2  0x00000000004171b0 in perf_evsel__add_sample (evsel=0x809660,
sample=0x7fffffffe0e0, al=0x7fffffffdff0, ann=0x7fffffffe750) at
builtin-annotate.c:65
#3  0x0000000000417394 in process_sample_event (tool=0x7fffffffe750,
event=0x80af70, sample=0x7fffffffe0e0, evsel=0x809660,
machine=0x8093c8) at builtin-annotate.c:102
#4  0x000000000048c56d in perf_session_deliver_event
(session=0x8092e0, event=0x80af70, sample=0x7fffffffe0e0,
tool=0x7fffffffe750, file_offset=11688)
    at util/session.c:870
#5  0x000000000048cb20 in perf_session__process_event
(session=0x8092e0, event=0x80af70, tool=0x7fffffffe750,
file_offset=11688) at util/session.c:986
#6  0x000000000048cf75 in __perf_session__process_pipe_events
(self=0x8092e0, tool=0x7fffffffe750) at util/session.c:1120

Looks like the session->evlist is not properly initialized in pipe
mode or that evsel->hists
is bogus because it crashes due to evsel->hists->entries_in == NULL.
Don't know how
you can get there.

Anybody has a clue?
