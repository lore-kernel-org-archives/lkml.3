Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaHPC0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 22:26:39 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:40529 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaHPC0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 22:26:38 -0400
Subject: Re: [PATCH 3/3] perf callchain: Prune misleading callchains for
 self entries
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
In-Reply-To: <20140815195139.GA13425@krava.brq.redhat.com>
References: <1407996100-6359-1-git-send-email-namhyung@kernel.org>
	 <1407996100-6359-4-git-send-email-namhyung@kernel.org>
	 <20140814141056.GA7630@krava.brq.redhat.com>
	 <1408067834.1679.15.camel@leonhard>
	 <20140815195139.GA13425@krava.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Aug 2014 11:26:31 +0900
Message-ID: <1408155991.1672.4.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-15 (금), 21:51 +0200, Jiri Olsa:
> On Fri, Aug 15, 2014 at 10:57:14AM +0900, Namhyung Kim wrote:
> > Hi Jiri,
> > 
> > 2014-08-14 (목), 16:10 +0200, Jiri Olsa:
> > > On Thu, Aug 14, 2014 at 03:01:40PM +0900, Namhyung Kim wrote:
> > > 
> > > SNIP
> > > 
> > > > However, with --children feature added, it now can show all callees of
> > > > the entry.  For example, "start_kernel" entry now can display it calls
> > > > rest_init and in turn cpu_idle and then cpuidle_idle_call (95.72%).
> > > > 
> > > >      6.14%     0.00%  swapper          [kernel.kallsyms]   [k] start_kernel
> > > >                    |
> > > >                     --- start_kernel
> > > >                         rest_init
> > > >                         cpu_idle
> > > >                        |
> > > >                        |--97.52%-- cpuidle_idle_call
> > > >                        |          cpuidle_enter_tk
> > > >                        |          |
> > > >                        |          |--99.91%-- cpuidle_wrap_enter
> > > >                        |          |          cpuidle_enter
> > > >                        |          |          intel_idle
> > > >                        |           --0.09%-- [...]
> > > >                         --2.48%-- [...]
> > > > 
> > > > Note that start_kernel has no self overhead - meaning that it never
> > > > get sampled by itself but constructs such a nice callgraph.  But,
> > > > sadly, if an entry has self overhead, callchain will get confused with
> > > > generated callchain (like above) and self callchains (which reversed
> > > > order) like the eariler example.
> > > > 
> > > > To be consistent with other entries, I'd like to make it just to show
> > > > a single entry - itself - like below since it doesn't have callees
> > > > (children) at all.  But still use the whole callchain to construct
> > > > children entries (like the start_kernel) as usual.
> > > > 
> > > >     40.53%    40.53%  swapper          [kernel.kallsyms]   [k] intel_idle
> > > >                     |
> > > >                     --- intel_idle
> > > 
> > > I understand the consistency point, but I think we'd loose
> > > usefull info by cutting this off
> > > 
> > > I guess I can run 'report -g callee' to find out who called intel_idle
> > > instead.. but I would not need to if the callchain stays here
> > 
> > Yeah, but current behavior intermixes caller-callchains and
> > callee-callchains together so adds confusion to users.  This is a
> > problem IMHO.
> 
> hum, where is it callee/caller mixed?  with following example:
> 
> ---
> void c(void)
> {
> }
> 
> void b(void)
> {
>         c();
> }
> 
> void a(void)
> {
>         b();
> }
> 
> int main(void)
> {
>         while(1) {
>                 a();
>                 b();
>                 c();
>         }
> }
> ---
> 
> for 'c' the current code will display:
> 
> -   43.74%    43.74%  t        t                 [.] c                                                                                    ▒
>    - __libc_start_main                                                                                                                    ▒
>       - 86.33% main                                                                                                                       ▒
>            67.08% c                                                                                                                       ▒
>          - 32.91% a                                                                                                                       ▒
>               99.44% c                                                                                                                    ▒
>             - 0.56% b                                                                                                                     ▒
>                  c                                                                                                                        ▒
>         13.67% c                                                                                                                          ▒
> 
> and with this patch:
> 
> -   43.74%    43.74%  t        t                 [.] c                                                                                    ▒
>      c                                                                                                                                    ▒
> 
> 
> The 'c' callchain is still in caller order. IMO we should
> keep whole callchain here.

The problem is not in pure self entry (that has self overhead = children
overhead) and pure cumulative entry (self overhead = 0).  It's in mixed
entries, please see last two examples in the description 0/3.

Thanks,
Namhyung


