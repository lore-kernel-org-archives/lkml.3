Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaHSFvu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 01:51:50 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:53064 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaHSFvt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 01:51:49 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
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
Date: Tue, 19 Aug 2014 14:51:31 +0900
In-Reply-To: <20140818113147.GA5117@krava.redhat.com> (Jiri Olsa's message of
	"Mon, 18 Aug 2014 13:31:47 +0200")
Message-ID: <87lhqlc9i4.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, 18 Aug 2014 13:31:47 +0200, Jiri Olsa wrote:
> On Sat, Aug 16, 2014 at 11:26:31AM +0900, Namhyung Kim wrote:
>
> SNIP
>
>> > 
>> > hum, where is it callee/caller mixed?  with following example:
>> > 
>> > ---
>> > void c(void)
>> > {
>> > }
>> > 
>> > void b(void)
>> > {
>> >         c();
>> > }
>> > 
>> > void a(void)
>> > {
>> >         b();
>> > }
>> > 
>> > int main(void)
>> > {
>> >         while(1) {
>> >                 a();
>> >                 b();
>> >                 c();
>> >         }
>> > }
>> > ---
>> > 
>> > for 'c' the current code will display:
>> > 
>> > -   43.74%    43.74%  t        t                 [.] c                                                                                    ▒
>> >    - __libc_start_main                                                                                                                    ▒
>> >       - 86.33% main                                                                                                                       ▒
>> >            67.08% c                                                                                                                       ▒
>> >          - 32.91% a                                                                                                                       ▒
>> >               99.44% c                                                                                                                    ▒
>> >             - 0.56% b                                                                                                                     ▒
>> >                  c                                                                                                                        ▒
>> >         13.67% c                                                                                                                          ▒
>> > 
>> > and with this patch:
>> > 
>> > -   43.74%    43.74%  t        t                 [.] c                                                                                    ▒
>> >      c                                                                                                                                    ▒
>> > 
>> > 
>> > The 'c' callchain is still in caller order. IMO we should
>> > keep whole callchain here.
>> 
>> The problem is not in pure self entry (that has self overhead = children
>> overhead) and pure cumulative entry (self overhead = 0).  It's in mixed
>> entries, please see last two examples in the description 0/3.
>
> right, but it still affects pure entries as well
> anyway, let's see the mixed entry
>
> for 'a' the current code will display:
> -   31.97%    17.16%  t        t                  [.] a                                                        ▒
>    - __libc_start_main                                                                                         ◆
>         81.08% a                                                                                               ▒
>       - 18.92% main                                                                                            ▒
>            a                                                                                                   ▒
>    - a                                                                                                         ▒
>         85.05% c                                                                                               ▒
>       - 14.91% b                                                                                               ▒
>            100.00% c                                                                                           ▒
>
> and with this patch:
> -   31.97%    17.16%  t        t                  [.] a                                                        ▒
>    - a                                                                                                         ▒
>         85.05% c                                                                                               ▒
>       - 14.91% b                                                                                               ▒
>            100.00% c                                                                                           ▒
>
> so we'll miss the 'self' callchain of 'a' symbol
>
> if we want to avoid the confusion about 2 different callchains, how
> about marking them with 'self' and 'children' tags, instead of removing
> one of them, like:
>
> for 'a' the current code will display:
> -   31.97%    17.16%  t        t                  [.] a                                                        ▒
>    - [self]
>      __libc_start_main                                                                                         ◆
>         81.08% a                                                                                               ▒
>       - 18.92% main                                                                                            ▒
>            a                                                                                                   ▒
>    - [children]
>      a                                                                                                         ▒
>         85.05% c                                                                                               ▒
>       - 14.91% b                                                                                               ▒
>            100.00% c                                                                                           ▒

I think it just adds complexity in implementation and confuses users.
Why do we keep those two callchains just for the caller mode?

I ran same code, recorded data and report it with current code.  It shows
who are the callers of the symbol:

  $ perf report   # same as passing -g callee
    Children      Self  Command  Shared Object      Symbols
  ---------------------------------------------------------------------------------
  +   99.98%     0.00%  abc2     libc-2.17.so       [.] __libc_start_main
  -   79.75%    11.29%  abc2     abc2               [.] main
       main
       __libc_start_main
  -   53.07%    52.99%  abc2     abc2               [.] c
     - c
        + 46.12% main
        + 30.99% a
          12.88% __libc_start_main
        + 10.01% b
  -   34.12%    28.75%  abc2     abc2               [.] b
     - b
        + 52.61% main
          25.93% __libc_start_main
        + 21.46% a
  -   30.56%     6.78%  abc2     abc2               [.] a
     - a
        + 85.14% main
          14.86% __libc_start_main
  +    0.17%     0.01%  abc2     [kernel.kallsyms]  [k] apic_timer_interrupt
  +    0.15%     0.00%  abc2     [kernel.kallsyms]  [k] smp_apic_timer_interrupt
  +    0.11%     0.00%  abc2     [kernel.kallsyms]  [k] hrtimer_interrupt


With -g caller option, the current code now shows callees and callers
altogether:

  $ perf report -g caller
    Children      Self  Command  Shared Object      Symbols
  ---------------------------------------------------------------------------------
  +   99.98%     0.00%  abc2     libc-2.17.so       [.] __libc_start_main
  -   79.75%    11.29%  abc2     abc2               [.] main
     - main
        + 38.01% a
        + 35.75% c
        + 26.22% b
       __libc_start_main
       main
  -   53.07%    52.99%  abc2     abc2               [.] c
     - __libc_start_main
        + 87.15% main
          12.85% c
  -   34.12%    28.75%  abc2     abc2               [.] b
     - __libc_start_main
        + 69.27% main
          30.73% b
     - b
          98.85% c
        + 1.15% apic_timer_interrupt
  -    30.56%     6.78%  abc2     abc2              [.] a
     - a
        + 69.15% c
        + 30.80% b
     - __libc_start_main
          66.86% a
        + 33.14% main
  +    0.17%     0.01%  abc2     [kernel.kallsyms]  [k] apic_timer_interrupt
  +    0.15%     0.00%  abc2     [kernel.kallsyms]  [k] smp_apic_timer_interrupt
  +    0.11%     0.00%  abc2     [kernel.kallsyms]  [k] hrtimer_interrupt


IMHO, it's harder to find out the right info.  Even if we might add
self/children tag to the callchains, I still think it'd be better just
to trim down irrelavant info from the output.

After applying this patch, it'll only show the callees of the symbol and
I think this is what most users expect to see:

  +   99.98%     0.00%  abc2     libc-2.17.so       [.] __libc_start_main
  -   79.75%    11.29%  abc2     abc2               [.] main
     - main
        + 38.01% a
        + 35.75% c
        + 26.22% b
  -   53.07%    52.99%  abc2     abc2               [.] c
     - c
        + 100.00% apic_timer_interrupt
  -   34.12%    28.75%  abc2     abc2               [.] b
     - b
          98.85% c
        + 1.15% apic_timer_interrupt
  -   30.56%     6.78%  abc2     abc2               [.] a
     - a
        + 69.15% c
        + 30.80% b
  +    0.17%     0.01%  abc2     [kernel.kallsyms]  [k] apic_timer_interrupt
  +    0.15%     0.00%  abc2     [kernel.kallsyms]  [k] smp_apic_timer_interrupt
  +    0.11%     0.00%  abc2     [kernel.kallsyms]  [k] hrtimer_interrupt


If you want to see the callers of 'c', you may go to above entries (main
and __libc_start_main in this case) and then follow the callchains.  If
it's not enough, you can re-run perf report with -g callee option.

Now It becomes a problem of dispalying whether callers or callees of
symbols rather than which order (callee-first or caller-first) it
prints.  So what current name (caller and callee) does is exactly the
opposite.  :-/

Btw I can see some other bugs in the callchain result too and will try
to fix it soon.

Thanks,
Namhyung
