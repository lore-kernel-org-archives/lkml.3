Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233Ab3JPI2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:28:48 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:41776 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174Ab3JPI2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:28:45 -0400
MIME-Version: 1.0
In-Reply-To: <20131016061502.GB21109@gmail.com>
References: <20131015161843.GA17653@quad>
	<20131016061502.GB21109@gmail.com>
Date: Wed, 16 Oct 2013 10:28:45 +0200
Message-ID: <CABPqkBS3WOKRb3i6d7E=vru7WKffp+PGzi8HYDfyTtGABYHiNw@mail.gmail.com>
Subject: Re: [PATCH] perf: revert PERF_RECORD_MMAP2 support
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 8:15 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>>
>> This unified patch removes the following commits
>> for both kernel and perf tool:
>>
>> 6adb0b0 perf tools: Add default handler for mmap2 events
>> 384c671 perf trace: Add mmap2 handler
>> 5c5e854 perf tools: Add attr->mmap2 support
>> d008d52 perf: Fix up MMAP2 buffer space reservation
>> 13d7a24 perf: Add attr->mmap2 attribute to an event
>>
>> The MMAP2 record extension is not quite ready for prime time.
>> We have identified address space cases where mappings would
>> not be reported properly when apps fiddled directly with clone()
>> and VM_CLONE. We will revisit the patch series soon.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> ---
>>  include/uapi/linux/perf_event.h |   24 +----------------
>>  kernel/events/core.c            |   47 +++-----------------------------
>>  tools/perf/builtin-annotate.c   |    1 -
>>  tools/perf/builtin-inject.c     |   15 -----------
>>  tools/perf/builtin-mem.c        |    1 -
>>  tools/perf/builtin-report.c     |    1 -
>>  tools/perf/builtin-script.c     |    1 -
>>  tools/perf/builtin-trace.c      |    1 -
>>  tools/perf/tests/perf-record.c  |   15 +++--------
>>  tools/perf/util/build-id.c      |    1 -
>>  tools/perf/util/event.c         |   56 +++++++++------------------------------
>>  tools/perf/util/event.h         |   19 -------------
>>  tools/perf/util/evsel.c         |   16 +++--------
>>  tools/perf/util/header.c        |    3 ---
>>  tools/perf/util/machine.c       |   53 +-----------------------------------
>>  tools/perf/util/machine.h       |    1 -
>>  tools/perf/util/map.c           |    8 +-----
>>  tools/perf/util/map.h           |    8 ++----
>>  tools/perf/util/session.c       |   27 +------------------
>>  tools/perf/util/tool.h          |    1 -
>>  20 files changed, 30 insertions(+), 269 deletions(-)
>
> Ugh, that's way too large.
>
> I thought the plan was to do a minimal revert. Is there really no way to
> do this in a (much) shorter fashion?
>
> For example by a simple patch that returns -EINVAL (or -ENOSYS) if the new
> flag is used - i.e. behaves like the old kernel in that regard - but
> leaves the rest in place. (the 'rest' will hopefully be fixed for v3.13)
>
That's what I did in my initial revert patch. But it did not include the
perf tool revert.

I believe in the end, we will still go with the extended MMAP record and
not with the physical address (which adds a PERF_SAMPLE_*). So
we can leave the attr->mmap2 bit defined and return -EINVAL for now.

As for the perf tool, we can remove everything and add that later on
because the layout of the MMAP2 record may change.

> Tooling will then fall back as if it was an old kernel - i.e. no changes
> needed there at all. Right?
>
Yes.
