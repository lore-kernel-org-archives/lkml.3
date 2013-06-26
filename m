Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab3FZMja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:39:30 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:61667 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3FZMj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:39:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130626091346.GB1019@krava.brq.redhat.com>
References: <CABPqkBQ843gUmk596NrOyybBH63o02sz8-8qW0jOkEodrs1a7g@mail.gmail.com>
	<20130626091346.GB1019@krava.brq.redhat.com>
Date: Wed, 26 Jun 2013 14:39:28 +0200
Message-ID: <CABPqkBRqY8HfMBKD4zpJer0_voAQK=+b5kxHW9VgaCvERRY1kw@mail.gmail.com>
Subject: Re: [BUG] perf report: garbage output with event grouping
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 11:13 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Jun 26, 2013 at 10:42:49AM +0200, Stephane Eranian wrote:
>> Hi,
>>
>>
>> $ perf record -e 'cpi{cycles,instructions}' noploop 5
>>
>> $ perf report --stdio --group
>> # group: ^P^Q<A0>\{cycles,instructions}
>> # ========
>> #
>> # Samples: 39K of event '^P^Q<A0>\ { cycles, instructions }'
>> # Event count (approx.): 37782563692
>> #
>> #         Overhead  Command      Shared Object                       Symbol
>> # ................  .......  .................  ...........................
>> #
>>     99.91%  99.98%  noploop  noploop            [.] main
>>      0.06%   -nan%  noploop  [kernel.kallsyms]  [k] read_hpet
>>      0.01%   0.01%  noploop  [kernel.kallsyms]  [k] __acct_update_integrals
>>      0.01%   -nan%  noploop  [kernel.kallsyms]  [k] raise_softirq
>>      0.01%   -nan%  noploop  [kernel.kallsyms]  [k] apic_timer_interrupt
>>      0.01%   -nan%  noploop  [kernel.kallsyms]  [k] __do_softirq
>>      0.01%   -nan%  noploop  [kernel.kallsyms]  [k] common_interrupt
>>      0.00%   0.00%  noploop  [kernel.kallsyms]  [k] intel_pmu_enable_all
>>      0.00%   0.01%  noploop  [kernel.kallsyms]  [k] cpuacct_account_field
>>      0.00%   0.01%  noploop  [kernel.kallsyms]  [k] __local_bh_enable
>>
>>
>> 1. The group name is garbage if not anonymous group.
>> 2. arithmetic error in the overhead columns leading to NaN.
>> 3. I assume the Overhead column order is the group event order. Is that right?
>
> hi
>
> 1) attached patch fixies that for me
> 2) I cannot reproduce this one on acme's tree
> 3) right, and we do need event names there ;-)
>
> ---
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 738d3b8..673d98c 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -2089,7 +2089,7 @@ static int process_group_desc(struct perf_file_section *section __maybe_unused,
>                         evsel->leader = evsel;
>                         /* {anon_group} is a dummy name */
>                         if (strcmp(desc[i].name, "{anon_group}"))
> -                               evsel->group_name = desc[i].name;
> +                               evsel->group_name = strdup(desc[i].name);
>                         evsel->nr_members = desc[i].nr_members;
>
>                         if (i >= nr_groups || nr > 0) {

Ok, works. Submit the patch please.

Related question: trying to understand the point of naming a group. Is
this used somewhere else in
perf report/annotate?
