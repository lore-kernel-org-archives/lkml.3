Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbaLZB4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 20:56:17 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:63597 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaLZB4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 20:56:14 -0500
MIME-Version: 1.0
In-Reply-To: <20141225220905.GC8719@krava>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-6-git-send-email-namhyung@kernel.org> <20141225220905.GC8719@krava>
From: Namhyung Kim <namhyung@kernel.org>
Date: Fri, 26 Dec 2014 10:55:54 +0900
X-Google-Sender-Auth: sRKZ14cevpy8zIeW7rpIjwWbUCA
Message-ID: <CAM9d7ciEEVHFxM-Jffet5xsmY1skF+jqPAuPHGy4T=Lr9TEXZA@mail.gmail.com>
Subject: Re: [PATCH 05/37] perf tools: Create separate mmap for dummy tracking event
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2014 at 7:09 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Dec 24, 2014 at 04:15:01PM +0900, Namhyung Kim wrote:
>
> SNIP
>
>>
>>  union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx);
>> -
>>  void perf_evlist__mmap_consume(struct perf_evlist *evlist, int idx);
>> +struct perf_mmap *perf_evlist__mmap_desc(struct perf_evlist *evlist, int idx);
>>
>>  int perf_evlist__open(struct perf_evlist *evlist);
>>  void perf_evlist__close(struct perf_evlist *evlist);
>> @@ -211,6 +214,12 @@ bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str);
>>  void perf_evlist__to_front(struct perf_evlist *evlist,
>>                          struct perf_evsel *move_evsel);
>>
>> +/* convert from/to negative idx for track mmaps */
>> +static inline int track_mmap_idx(int idx)
>> +{
>> +     return -idx - 1;
>> +}
>
> hum, whats the logic with negative numbers in here?
> you still access track_mmap array with this index no?

For each index (per-cpu or per-task depends on user input), it now has
two mmaps - one for normal (sampling) mmap and another for track
(metadata) mmap.  So I wanted to distinguish them by using positive
and negative number.  But simply changing the sign did not work due to
0 index.  And the subtracting by 1 works nicely for both direction.

0 => -1 => 0
1 => -2 => 1
2 => -3 => 2
3 => -4 => 3

So when it sees a negative index, it'll convert it using
track_mmap_idx() to get a matching (track) mmap.

Thanks,
Namhyung
