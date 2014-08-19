Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaHSIUZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 04:20:25 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:34817 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaHSIUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 04:20:22 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>
Subject: Re: [PATCH 3/3] perf callchain: Prune misleading callchains for self entries
References: <1407996100-6359-1-git-send-email-namhyung@kernel.org>
	<1407996100-6359-4-git-send-email-namhyung@kernel.org>
	<20140814141056.GA7630@krava.brq.redhat.com>
	<1408067834.1679.15.camel@leonhard>
	<20140815195139.GA13425@krava.brq.redhat.com>
	<1408155991.1672.4.camel@leonhard>
	<20140818113147.GA5117@krava.redhat.com>
	<87lhqlc9i4.fsf@sejong.aot.lge.com>
	<20140819071024.GB1123@krava.brq.redhat.com>
Date: Tue, 19 Aug 2014 17:20:20 +0900
In-Reply-To: <20140819071024.GB1123@krava.brq.redhat.com> (Jiri Olsa's message
	of "Tue, 19 Aug 2014 09:10:24 +0200")
Message-ID: <87zjf0c2m3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2014 09:10:24 +0200, Jiri Olsa wrote:
> On Tue, Aug 19, 2014 at 02:51:31PM +0900, Namhyung Kim wrote:
> SNIP
>
>> IMHO, it's harder to find out the right info.  Even if we might add
>> self/children tag to the callchains, I still think it'd be better just
>> to trim down irrelavant info from the output.
>> 
>> After applying this patch, it'll only show the callees of the symbol and
>> I think this is what most users expect to see:
>> 
>>   +   99.98%     0.00%  abc2     libc-2.17.so       [.] __libc_start_main
>>   -   79.75%    11.29%  abc2     abc2               [.] main
>>      - main
>>         + 38.01% a
>>         + 35.75% c
>>         + 26.22% b
>>   -   53.07%    52.99%  abc2     abc2               [.] c
>>      - c
>>         + 100.00% apic_timer_interrupt
>>   -   34.12%    28.75%  abc2     abc2               [.] b
>>      - b
>>           98.85% c
>>         + 1.15% apic_timer_interrupt
>>   -   30.56%     6.78%  abc2     abc2               [.] a
>>      - a
>>         + 69.15% c
>>         + 30.80% b
>>   +    0.17%     0.01%  abc2     [kernel.kallsyms]  [k] apic_timer_interrupt
>>   +    0.15%     0.00%  abc2     [kernel.kallsyms]  [k] smp_apic_timer_interrupt
>>   +    0.11%     0.00%  abc2     [kernel.kallsyms]  [k] hrtimer_interrupt
>> 
>> 
>> If you want to see the callers of 'c', you may go to above entries (main
>> and __libc_start_main in this case) and then follow the callchains.  If
>> it's not enough, you can re-run perf report with -g callee option.
>
> but only if you know who called them, like in this simple example

Nope.  The --children option tends to collect callers above a callee.
This is not guaranteed though, but for most cases it'll work.  If it's
not case, one can use -g callee.


>
> IMHO this part of callchain is not confusing enough to be cut,
> for me it's usefull info for which I'd need to make more steps
> to get it

Well, that might be true for this simple case, but I'm not sure for
large and complex data.  I'd really like to keep the code and the output
simpler, more consistent and more intuitive.


>
> anyway, this is from review point of view.. as a user I dont use
> '-g caller' often enough to actually care ;-)

Yeah, me too.  But with --children option, it becomes very powerful and
can give another viewpoint of the performance analysis IMHO.

Thanks,
Namhyung
