Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab3LBQg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:36:27 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48884 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352Ab3LBQgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:36:24 -0500
Date: Mon, 2 Dec 2013 17:36:20 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Pekka Enberg <penberg@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@iki.fi>
Subject: Re: [PATCH 1/3] perf tools: Record total sampling time
Message-ID: <20131202163620.GC27781@gmail.com>
References: <1385967199-3759-1-git-send-email-namhyung@kernel.org>
 <1385967199-3759-2-git-send-email-namhyung@kernel.org>
 <20131202124527.GB22212@gmail.com>
 <20131202125709.GA22404@gmail.com>
 <1385999009.1710.72.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385999009.1710.72.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> 2013-12-02 (월), 13:57 +0100, Ingo Molnar:
> > So basically, in the end I think it should be possible to have the 
> > following behavior:
> > 
> >    perf record -a -e cycles sleep 1
> > 
> >    perf report stat              # Reports as if we ran: 'perf stat -a -e cycles sleep 1'
> >    perf report                   # Reports the usual histogram
> > 
> >    perf report --stat            # Reports the perf stat output and the histogram
> > 
> > or so.
> 
> I don't think we need both of 'perf report stat' and 'perf report
> --stat'.  At least it looks somewhat confusing to users IMHO.

Okay. Maybe the --stat option would be the more logical choice, 
because '--' options can be added arbitrarily, while it would be weird 
to add multiple subcommand options.

So basically there would be two options:

   --show-stat         [--no-show-stat]
   --show-histogram    [--no-show-histogram]

Today --show-histogram is the only one enabled by default.

Running:

   perf report --no-show-histogram --show-stat

would give perf-stat output.

This --show-* pattern could be used in the future, for example to 
express debug output:

  perf report --show-debug

Or to show other details that are off by default.

'perf report --show' should perhaps list all --show options that are 
available currently.

Maybe the syntax should be similar to the sort option?

What's your preference?

> For perf report stat usage, I think there's not much thing we can do 
> for a single event - the most case.  We can simple show total count 
> and elapsed (or sampled time) for the event, but it's already in the 
> header with this patch.
> 
>       # Samples: 4K of event 'cycles'
>       # Event count (approx.): 4087481688
>       # Total sampling time  : 1.001260 (sec)

That's what I mean, instead of 'this patch' we should utilize perf 
stat output mode. That will solve your particular feature request 
here, plus gives us much more: it gives perf stat integration into 
report.

> If an user really want to see perf stat-like output (without the 
> usual histogram) for a recorded session, it'd be better to have 
> 'perf record --stat' do the job (like git diff --stat) IMHO.

Why? Showing the result is a reporting feature really. Firstly we 
record everything, then we 'analyze', looking at various details of 
data.

Getting perf stat output could be used to get a first, rough, high 
level overview.

> > i.e. a perf.data file would by default always carry enough information 
> > to enable the extraction of the 'perf stat' data.
> > 
> > At that point visualizing it is purely report-time logic, it does not 
> > need any record-time options.
> > 
> > This would work for multi-event sampling as well, if we do:
> > 
> >    perf record -a -e cycles -e branches sleep 1
> > 
> > then 'perf report stat' would output the same as:
> > 
> >  $ perf stat -e cycles -e branches -a sleep 1
> > 
> >  Performance counter stats for 'system wide':
> > 
> >         34,174,518      cycles                    [100.00%]
> >          3,155,677      branches                                                    
> > 
> >        1.000802852 seconds time elapsed
> > 
> 
> Yeah, it'd be good to have same output both for perf stat and perf 
> report --stat (or stat if you want).  But I don't think it's 
> possible to determine multiplexed counter values like perf stat does 
> unless we use PERF_SAMPLE_READ for recoding.

That's my point: is there any reason why we shouldn't turn on 
PERF_SAMPLE_READ for these events, and read them at the beginning and 
at the end of a sampling session?

( some people might even want periodic samples emitted inbetween, to 
  be able to see a time flow representation of samples, but that's for 
  the future. )

> > Another neat feature this kind of workflo enables is the integration 
> > of --repeat to perf record, so something like:
> > 
> >     perf record --repeat 3 -a -e cycles -e branches sleep 1
> > 
> > would save 3 samples after each other, and would allow extraction of 
> > the statistical stability of the measurement, and 'perf report stat' 
> > would print the same result as a raw perf stat run would:
> > 
> >  $ perf stat --repeat 3 -e cycles -e branches -e instructions -a sleep 1
> > 
> >  Performance counter stats for 'system wide' (3 runs):
> > 
> >     28,975,150,642      cycles                     ( +-  0.43% ) [100.00%]
> >     10,740,235,371      branches                                                      ( +-  0.47% ) [100.00%]
> >     44,535,464,754      instructions              #    1.54  insns per cycle          ( +-  0.47% )
> > 
> >        1.005718027 seconds time elapsed                                          ( +-  0.43% )
> 
> Yeah, but it can be used only for a new forked workload.

Well, it can be used for anything that perf record can do today, 
except maybe the Ctrl-C method of measurement, right?

> > Or something like that. At that point we share reporting between 
> > perf stat and perf report, no special ad-hoc options are needed to 
> > just measure and report timestamps, it would all be a 'natural' 
> > side effect of having perf stat.
> > 
> > What do you think?
> 
> I think it'd be better if we can share code as much as possible.  
> And it'd much better if we can forget about the difference in 
> options. :)

Agreed - see the --show-<xyz> pattern I suggested above.

It could be different as well, sort-key alike:

   --show +stat,-hist,+debug

Thanks,

	Ingo
