Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaHLHaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 03:30:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbaHLHaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 03:30:17 -0400
Date: Tue, 12 Aug 2014 09:29:47 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 00/20] perf: Finish sampling commands when events are closed
Message-ID: <20140812072947.GA1128@krava.brq.redhat.com>
References: <1407747014-18394-1-git-send-email-jolsa@kernel.org>
 <20140811201249.GA4148@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811201249.GA4148@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 05:12:49PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Aug 11, 2014 at 10:49:54AM +0200, Jiri Olsa escreveu:
> > hi,
> > adding support to quit sampling commands:
> >   record,top,trace,kvm stat live
> > 
> > when all the monitored events are closed, like following perf
> > command will now exit when monitored process (pid 1234) exits:
> > 
> >   $ perf record -p 1234
> > 
> > I added independent poller object to handle basic polling
> > tasks. I had to factor some parts, so sending this as RFC,
> 
> Why? I'm trying to figure out why this poller class is needed, just from
> reading the changelog entries, no luck so far.

multiple reasons.. at the moment:
  - have a way to get FD state notification -> callback triggers for FD
    and we can figure when we are out of monitored events or notify there
    was error/hup on event

  - to be able to gather/register more kinds of FDs under one
    poll instance, so we could poll together on standard input
    or other kind of notify event with perf events within a
    single poll call

for future:
  - there's another feature for record to watch hotplug CPUs
    and open/close perf event for it when CPU is added/removed
    we need to watch/poll inotify events for that

  - when having multiple threads for record command we'll need to split
    evlist events into more polling instances, so each thread could
    poll independently

also I think the poller class just encapsulates the polling
processing and reduces the evlist complexity

jirka
