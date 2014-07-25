Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934794AbaGYPpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:45:25 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:41591 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934629AbaGYPpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:45:21 -0400
Date: Fri, 25 Jul 2014 17:45:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 17/19] perf tools: Always force
 PERF_RECORD_FINISHED_ROUND event
Message-ID: <20140725154512.GA16182@localhost.localdomain>
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
 <1405893363-21967-18-git-send-email-jolsa@kernel.org>
 <20140724213451.GH7831@kernel.org>
 <20140725113426.GC1214@krava.brq.redhat.com>
 <20140725141413.GK7831@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140725141413.GK7831@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 11:14:13AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jul 25, 2014 at 01:34:26PM +0200, Jiri Olsa escreveu:
> > On Thu, Jul 24, 2014 at 06:34:51PM -0300, Arnaldo Carvalho de Melo wrote:
> > > I think both changes are OK, but should be split in different patches,
>  
> > right, I'll split it
> 
> Thanks!
>  
> > > [root@zoo /]# perf stat -r 5 perf report --no-ordered-samples > /dev/null
> > >    101,171,572,553      instructions              #    1.10  insns per cycle        
> > >       30.249514999 seconds time elapsed                                          ( +-  0.48% )
> 
> > > [root@zoo /]# perf stat -r 5 perf report --ordered-samples > /dev/null
> > >    105,982,144,263      instructions              #    1.04  insns per cycle        
> > >       32.636483981 seconds time elapsed                                          ( +-  0.41% )
> 
> > so those 2 extra seconds is the ordering time, right? sounds ok
> 
> Yeah, but I think its worth investigating if using it is a strict
> requirement in all cases, i.e. is it possible to receive out of order
> events when sampling on a single CPU? Or a single CPU socket with a
> coherent time source? etc.

It's theoretically possible to have out of order events if perf_event_output()
is interrupted between perf_prepare_sample() and perf_output_begin() and the irq
generates an event too.

So the first event saves its timestamp "t1" from perf_prepare_sample(), gets interrupted
before perf_output_begin() so it hasn't reserved room in the ring buffer yet. The
irq generates an event with a timestamp t2 that can be t2 > t1 if the clock has a
high enough resolution (tsc works there).

The IRQ write the event in the buffer, returns to the interrupted event which
record after the irq event.

One possibility to solve this is to fetch perf_clock() only from perf_output_sample().
At that time the event has reserved the buffer space so any irq event is guaranteed
to be written _after_ the interrupted event and thus guarantees some monotonicity.

> 
> Providing a way to disable this ordering to be used in corner cases
> where it is not a strict requirement and the volume of samples is so
> high that reducing processing time like shown above seems to be a
> sensible thing to do.
> 
> We're in the business of optimizing stuff, huh? :-)
>  
> - Arnaldo
