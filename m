Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab3KSJYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:24:54 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:57566 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3KSJYu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:24:50 -0500
MIME-Version: 1.0
In-Reply-To: <20131118125945.GA3669@ghostprotocols.net>
References: <1384487490-6865-1-git-send-email-dsahern@gmail.com>
	<20131115054609.GB4514@gmail.com>
	<20131118125945.GA3669@ghostprotocols.net>
Date: Tue, 19 Nov 2013 10:24:49 +0100
Message-ID: <CAFrcx1nqm5G0ASnuh9peMtaUE-cpAYY8xtvsRORHhXwSRod9YQ@mail.gmail.com>
Subject: Re: [PATCH] perf top: Make -g refer to callchains
From: Jean Pihet <jean.pihet@linaro.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, David Ahern <dsahern@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 18 November 2013 13:59, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Fri, Nov 15, 2013 at 06:46:09AM +0100, Ingo Molnar escreveu:
>> btw., here's some 'perf top' call graph performance and profiling
>> quality feedback, with the latest perf code:
>>
>> 'perf top --call-graph fp' now works very well, using just 0.2%
>> of CPU time on a fast system:
>>
>>  4676 mingo     20   0  612m  56m 9948 S     1  0.2   0:00.68 perf
>>
>> 'perf top --call-graph dwarf' on the other hand is horrendously
>> slow, using 20% of CPU time on a 4 GHz CPU:
>>
>>   PID USER      PR  NI  VIRT  RES  SHR S  %CPU %MEM    TIME+  COMMAND
>>  4646 mingo     20   0  658m  81m  12m R    19  0.3   0:18.17 perf
>>
>> On another system with a 2.4GHz CPU it's taking up 100% of CPU
>> time (!):
>>
>>   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
>>  8018 mingo     20   0  290320  45220   8520 R  99.5  0.3   0:58.81 perf
>>
>> Profiling 'perf top' shows all sorts of very high dwarf
>> processing overhead:
>
> Yeah, top dwarf callchain has been so far a proof of concept, it
> exacerbates problems that can be seen on 'report', but since its live,
> we can see it more clearly.
Indeed. Because of the poor performance of the dwarf unwinding code,
the only practical use is to record the data (perf record) and then
later parse it (perf report). perf top does all that at once.

> The work on improving callchain processing, (rb_tree'ing, new comm
> infrastructure) alleviated the problem a bit.
>
> Tuning the stack size requested from the kernel and using --max-stack
> can help when it is really needed, but yes, work on it is *badly* needed.
The problem is that the whole user stack is dumped for every sample
while frame pointer unwinding only dumps the useful part of the
callchain.

Also an important point is the robustness of libunwind wrt async
signal, cf. http://lists.nongnu.org/archive/html/libunwind-devel/2013-09/msg00005.html.

So yes some work is °badly* needed on:
- the data size being dumped,
- the data parsing optimization,
- the choice of an implementation of dwarf unwinding (libunwind, libdw etc.),
- the compatibility with 32 bit binaries on AARCH64, which I am now
busy with in libunwind.

Jean

>
> - Arnaldo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
