Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbaDVNhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:37:36 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:57243 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaDVNhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:37:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140422133242.GF1104@krava.brq.redhat.com>
References: <20140421160655.GA4201@quad>
	<20140422133242.GF1104@krava.brq.redhat.com>
Date: Tue, 22 Apr 2014 15:37:30 +0200
Message-ID: <CABPqkBQNQJT6X8g7_tsCFEOQgE8p=-KN9qa2QhX9wpbSgEciUA@mail.gmail.com>
Subject: Re: [PATCH] perf tools: fix processing of pid/tid for mmap records
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

On Tue, Apr 22, 2014 at 3:32 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> hi,
>
> On Mon, Apr 21, 2014 at 06:06:55PM +0200, Stephane Eranian wrote:
>> perf tools: fix processing of pid/tid for mmap records
>
> extra description line ^^^
>
>>
>> Mmaps are global to a process (always). Processing them
>> per-thread was causing some serious issues in case mmaps
>> would overlap. The overlap fixups would only occur in the
>> context of the thread which generated the overlapping
>> mmap. But that was cause issues later on when a sample
>> from another thread would fall into that overlapping
>> mmap.
>>
>> The solution to the problem is to handle ALL mmaps as
>> occurring in the master thread (pid = tid) and then to
>> lookup for thread map using pid as the tid argument.
>> This is how samples are looking up for the thread map
>> already (notice pid passed twice):
>>
>> int perf_event__preprocess_sample(const union perf_event *event,
>>                                   struct machine *machine,
>>                                   struct addr_location *al,
>>                                   struct perf_sample *sample)
>> {
>>         struct thread *thread = machine__findnew_thread(machine, sample->pid,
>>                                                         sample->pid);
>> }
>>
>> Without this fix, some samples in overlapping regions
>> may not be symbolized.
>
> could you please take a look on following patchset:
> http://marc.info/?l=linux-kernel&m=139749074531132&w=2
>
> this makes the map groups shared within the process,
> so it should fix above issue as well
>
It could probably solve my problem. I will try it out.

I am wondering why the tid was taken into consideration in the first place
when looking for maps? why was pid not enough?
