Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbaFCLwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:52:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950AbaFCLwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:52:21 -0400
Date: Tue, 3 Jun 2014 13:51:29 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCHv5] perf tools: enable close-on-exec flag on perf file
 descriptor
Message-ID: <20140603115128.GB2497@krava.brq.redhat.com>
References: <20140106144347.GA13500@ghostprotocols.net>
 <20140106142220.GB1183@krava.brq.redhat.com>
 <1389463628-24869-1-git-send-email-ydroneaud@opteya.com>
 <1389607770-4485-1-git-send-email-ydroneaud@opteya.com>
 <20140115185026.GA14248@ghostprotocols.net>
 <1390771203-28415-1-git-send-email-ydroneaud@opteya.com>
 <1394527147-7010-1-git-send-email-ydroneaud@opteya.com>
 <1401706594-4995-1-git-send-email-ydroneaud@opteya.com>
 <20140602192320.GD7861@krava.brq.redhat.com>
 <1401785835.32444.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401785835.32444.18.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 10:57:15AM +0200, Yann Droneaud wrote:
> Le lundi 02 juin 2014 à 21:23 +0200, Jiri Olsa a écrit :
> > On Mon, Jun 02, 2014 at 12:56:34PM +0200, Yann Droneaud wrote:
> > 
> > SNIP
> > 
> > > 
> > > Hi,
> > > 
> > > Quite the same patch from v4. I'm interested in some
> > > feedback so that I could improve the patch if needed.
> > > 
> > > Regards.
> > > 
> > > Changes from v4 [1]:
> > > - rebase on next-20140530 and update commit message.
> > 
> > hi,
> > I wasn't following on this one before.. so please shut me up
> > if my comments were already discussed ;-)
> > 
> 
> You had a chance to review it before :)
> See http://lkml.kernel.org/r/20140106142220.GB1183@krava.brq.redhat.com

yep, but then I drift away ;-)

SNIP

> > >  
> > >  #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
> > > @@ -988,7 +989,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
> > >  			      struct thread_map *threads)
> > >  {
> > >  	int cpu, thread;
> > > -	unsigned long flags = 0;
> > > +	unsigned long flags = PERF_FLAG_FD_CLOEXEC;
> > >  	int pid = -1, err;
> > >  	enum { NO_CHANGE, SET_TO_MAX, INCREASED_MAX } set_rlimit = NO_CHANGE;
> > >  
> > > @@ -997,11 +998,13 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
> > >  		return -ENOMEM;
> > >  
> > >  	if (evsel->cgrp) {
> > > -		flags = PERF_FLAG_PID_CGROUP;
> > > +		flags |= PERF_FLAG_PID_CGROUP;
> > >  		pid = evsel->cgrp->fd;
> > >  	}
> > >  
> > >  fallback_missing_features:
> > > +	if (perf_missing_features.cloexec)
> > > +		flags &= ~(unsigned long)PERF_FLAG_FD_CLOEXEC;
> > >  	if (perf_missing_features.mmap2)
> > >  		evsel->attr.mmap2 = 0;
> > >  	if (perf_missing_features.exclude_guest)
> > > @@ -1070,7 +1073,10 @@ try_fallback:
> > >  	if (err != -EINVAL || cpu > 0 || thread > 0)
> > >  		goto out_close;
> > >  
> > > -	if (!perf_missing_features.mmap2 && evsel->attr.mmap2) {
> > > +	if (!perf_missing_features.cloexec && (flags & PERF_FLAG_FD_CLOEXEC)) {
> > > +		perf_missing_features.cloexec = true;
> > > +		goto fallback_missing_features;
> > 
> > I think it does not fit in here, because we check latest perf_event_attr
> > bits and removing one after another, to see if miracle happens.
> > (also looks like we miss exclude_callchain_(kernel|user) bits)
> > 
> > Wouldn't it be better just to use perf_event_open_cloexec_flag() function
> > as you did in the rest of the code? I think we dont need 2 detection codes
> > for this.
> > 
> 
> I was asked by ACME to use here the missing feature detection pattern
> and to treat the flag just as a new feature like perf_event_attr new
> attributes.
> 
> See http://lkml.kernel.org/r/20140106144347.GA13500@ghostprotocols.net
>     http://lkml.kernel.org/r/20140106211444.GD2810@ghostprotocols.net

ook, I probably missed that.. anyway I still feel like the perf_event_open_cloexec_flag
function should be enough.. I'll leave this one to Arnadlo

thanks,
jirka
