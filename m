Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaIJBIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 21:08:41 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36546 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaIJBIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 21:08:39 -0400
MIME-Version: 1.0
In-Reply-To: <1410307433-12475-1-git-send-email-andi@firstfloor.org>
References: <1410307433-12475-1-git-send-email-andi@firstfloor.org>
Date: Tue, 9 Sep 2014 18:08:39 -0700
Message-ID: <CAE40pddC+rxdpycg3W6TR9+=N46VR1QErTMYY23vPgMf8n_TkQ@mail.gmail.com>
Subject: Re: [PATCH] perf, tools: Add PERF_PID
From: Brendan Gregg <brendan.d.gregg@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014 at 5:03 PM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> It's currently difficult to filter out perf itself using a filter.
> This can give cascading effects during IO tracing when the IO
> perf does itself causes more trace output.
>
> The best way to filter is to use the pid. But it's difficult to get the pid
> of perf without using hacks.
>
> Add a PERF_PID meta variable to the perf filter that contains the current pid.
>
> With this patch the following works
>
> % perf record -e syscalls:sys_enter_write -a --filter 'common_pid != PERF_PID' ...
>
> This won't work for more complex perf pipe lines with multiple processes,
> but at least solves the problem nicely for a single perf.

Thank you, this will be handy. I tested it and it works.

It will mean I can avoid hacks like this:
https://github.com/brendangregg/perf-tools/blob/d30e8a1a9f136d532ba78c6d48aedb99dc316be9/syscount#L144

I think it's unrelated to this patch, but the very next test I tried
didn't work as expected:

# perf record -e 'syscalls:sys_enter_*' --filter 'common_pid !=
PERF_PID' -a sleep 5

It only filters the last event from the wildcard expansion, leaving
write() unfiltered. Looks like it's because parse_filter() is only
setting the filter for perf_evlist__last(), instead of doing an
evlist__for_each(). How best to deal with this can be addressed in a
separate patch later.

Brendan
