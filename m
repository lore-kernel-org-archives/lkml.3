Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3IZMMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:12:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712Ab3IZMMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:12:20 -0400
Date: Thu, 26 Sep 2013 14:11:55 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Don Zickus <dzickus@redhat.com>, Andi Kleen <ak@linux.jf.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC 00/21] perf tools: Add toggling events support
Message-ID: <20130926121154.GA1067@krava.brq.redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
 <20130925191216.GE2018@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925191216.GE2018@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 12:12:16PM -0700, Andi Kleen wrote:
> On Wed, Sep 25, 2013 at 02:50:26PM +0200, Jiri Olsa wrote:
> > hi,
> > sending *RFC* for toggling events support.
> > 
> > Adding perf interface that allows to create toggle events, which can
> > enable or disable another event. Whenever the toggle event is triggered
> > (has overflow), it toggles another event state and either starts or
> > stops it.
> > 
> > The goal is to be able to create toggling tracepoint events to enable and
> > disable HW counters, but the interface is generic enough to be used for
> > any kind of event. 
> 
> Haven't read the patches, but frequent full event switch in/out seems
> very expensive.  If someone puts that switch on a common
> function it would likely disturb things quite a bit.

We dont do full sched in/out.. the toggled event
is scheduled in 'paused' state which means that
it's not started. Once the trigger is hit, pmu 
start/stop is executed.

> 
> It would be better to keep counting and just do RDPMC on 
> the switch points, and then subtract for counting.
> For sampling could need a MSR write to enable/disable.
> Still somewhat expensive, but nowhere near as bad as a full switch.

I'll check on that

> 
> Another problem is that it may be very inexact, as
> the counting will often happen in the background
> and not be very synchronized with the switches.
> Not fully sure how big a problem that would be.

the toggling overflow function does following
(perf_event_toggle_overflow)

 - disable pmu of the toggled event
 - start/stop the toggle event
 - store sample for the trigger function
 - enable pmu of the toggled event

so the overhead (extra count) is:
 - the return code from pmu enable and return from the overflow processing
 - trigger event overflow processing till pmu disable code

and no overhead for user space events ;-)

thanks,
jirka
