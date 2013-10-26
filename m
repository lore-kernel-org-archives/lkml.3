Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab3JZRxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 13:53:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab3JZRxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 13:53:47 -0400
Date: Sat, 26 Oct 2013 19:53:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 4/4] perf,x86: add RAPL hrtimer support
Message-ID: <20131026175305.GE1069@krava.brq.redhat.com>
References: <1382533085-7166-1-git-send-email-eranian@google.com>
 <1382533085-7166-5-git-send-email-eranian@google.com>
 <20131025174448.GD7024@krava.brq.redhat.com>
 <CABPqkBTKec0T0NDFUoC8qDVO9stACkzc2xnUqwx6yODHXKaYTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTKec0T0NDFUoC8qDVO9stACkzc2xnUqwx6yODHXKaYTg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 07:07:06PM +0200, Stephane Eranian wrote:
> On Fri, Oct 25, 2013 at 7:44 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Wed, Oct 23, 2013 at 02:58:05PM +0200, Stephane Eranian wrote:

SNIP

> >> +     list_for_each_entry(event, &pmu->active_list, active_entry) {
> >> +             rapl_event_update(event);
> >> +     }
> >
> > hi,
> > I dont fully understand the reason for the timer,
> > I'm probably missing something..
> >
> The reason is rather simple and is similar to what happens with uncore.
> The counter are narrow, 32-bit and there is no interrupt capability. We
> need to poll the counters and accumulate in the sw counter to avoid missing
> an overflow.
> 
> > - the timer calls rapl_event_update for all defined events
> 
> No, only for the defined RAPL events which is what we want.

ok, that's what I meant

> 
> > - but rapl_pmu_event_read calls rapl_event_update any time the
> >   event is read (sys_read)
> >
> Yes, but we want to prevent missing a counter overflow. It may happen
> if the counter counts in a unit which increments fast.
> 
> > The rapl_event_update only read msr and updates
> > event->count|hw,prev_count.
> No, it does update the count:
>         local64_add(sdelta, &event->count);

ah, there's the shift that takes care of the
overflowed msr value.. ok

thanks,
jirka
