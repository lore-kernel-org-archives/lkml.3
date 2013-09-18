Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3IRI5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 04:57:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37893 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab3IRI5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 04:57:52 -0400
Date: Wed, 18 Sep 2013 10:57:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Fix broken union in ' struct
 perf_event_mmap_page'
Message-ID: <20130918085722.GL12926@twins.programming.kicks-ass.net>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com>
 <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org>
 <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 04:23:25PM -0400, Vince Weaver wrote:
> >  include/uapi/linux/perf_event.h | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
> > index 00d8274..0041aed 100644
> > --- a/include/uapi/linux/perf_event.h
> > +++ b/include/uapi/linux/perf_event.h
> > @@ -375,9 +375,11 @@ struct perf_event_mmap_page {
> >  	__u64	time_running;		/* time event on cpu */
> >  	union {
> >  		__u64	capabilities;
> > -		__u64	cap_usr_time  : 1,
> > -			cap_usr_rdpmc : 1,
> > -			cap_____res   : 62;
> > +		struct {
> > +			__u64	cap_usr_time		: 1,
> > +				cap_usr_rdpmc		: 1,
> > +				cap_____res		: 62;
> > +		};
> >  	};

> This patch somehow breaks the perf-ABI.

Difficult call that..

> If I take a program that reads "mmap->cap_usr_rdpmc" and compile it
> against the new header with this change (say from 3.12-rc1)
> and then run it on an old kernel (say 3.11) then I get "0" for
> cap_usr_rdpmc.
> 
> If I take the same program and recompile against the old (without this 
> patch) header and run it on 3.11, I get the expected "1" value.
> 
> So something about this changed the bit pattern in an incompatible 
> fashion.

Which was the entire point of the change. Previously cap_usr_time and
cap_usr_rdpmc were the same bit which clearly cannot be right.

With the change they're consecutive bits in the capabilities word.

Should we preserve completely broken things that don't work?
