Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbbAVNfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:35:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbbAVNfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:35:13 -0500
Date: Thu, 22 Jan 2015 14:34:55 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: perf: behavior of poll() changed in 3.18
Message-ID: <20150122133455.GC2473@krava.brq.redhat.com>
References: <alpine.DEB.2.11.1501201155380.18043@vincent-weaver-1.umelst.maine.edu>
 <20150120181316.GA12860@krava.brq.redhat.com>
 <alpine.DEB.2.11.1501210058090.21805@vincent-weaver-1.umelst.maine.edu>
 <20150121162108.GD6835@krava.brq.redhat.com>
 <alpine.DEB.2.11.1501220026210.12767@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1501220026210.12767@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 01:53:35AM -0500, Vince Weaver wrote:
> On Wed, 21 Jan 2015, Jiri Olsa wrote:
> > 
> > However if we revert this code, we'll loose nice (and standard) way
> > to check if the event is still valid.. not sure how to handle this.
> 
> there's likely no need to revert as my code wasn't really released and 
> I've already fixed it to work with the new interface.
> 
> I was mostly asking just so I could update the manpage to explain the new 
> behavior, as tools that expect to be backwards compatible will have to 
> handle both ways of detecting a process dieing.
> 
> > > Part of why my code doesn't just exit on POLLHUP is because you can
> > > get that result for reasons other than a process exit (for example,
> > > if you are using ioctl(PERF_EVENT_IOC_REFRESH)
> > 
> > Nope, this is related to POOL_HUP (notice the '_') which you'll get
> > accompanied with SIGIO if you setup this.
> 
> So what happens if you are using a signal handler to monitor a child and 
> the child exits?

AFAICS wrt to SIGIO, we notify only with POLL_IN if there's new data
and POLL_HUP if we reached the event_limit - the one you set with
PERF_EVENT_IOC_REFRESH ioctl

> 
> It's a shame the poll and signal handler interfaces are subtly different, 
> though I guess some of that is probably due to historical reasons.

I've actually never used the SIGIO interface in perf other than
when I was checking your gi repo with test code ;-)

so I'm not sure what the correct behaviour should be when monitored
process dies.. I'd say we should send SIGIO with POLL_HUP, but that
clashes with that 'event_limit' thing.. I'll check on that

thanks,
jirka
