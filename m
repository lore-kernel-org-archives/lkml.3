Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965096Ab3GLPzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:55:40 -0400
Received: from www.sr71.net ([198.145.64.142]:46424 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964785Ab3GLPzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:55:37 -0400
Message-ID: <51E026F3.6010505@sr71.net>
Date: Fri, 12 Jul 2013 08:55:31 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Dave Hansen <dave.hansen@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Yet more softlockups.
References: <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com> <20130705143821.GB325@redhat.com> <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de> <20130705160043.GF325@redhat.com> <20130706072408.GA14865@gmail.com> <20130710151324.GA11309@redhat.com> <20130710152015.GA757@x4> <20130710154029.GB11309@redhat.com> <20130712103117.GA14862@gmail.com> <51E0230C.9010509@intel.com> <20130712154521.GD1020@redhat.com>
In-Reply-To: <20130712154521.GD1020@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 08:45 AM, Dave Jones wrote:
> On Fri, Jul 12, 2013 at 08:38:52AM -0700, Dave Hansen wrote:
>  > Dave, for your case, my suspicion would be that it got turned on
>  > inadvertently, or that we somehow have a bug which bumped up
>  > perf_event.c's 'active_events' and we're running some perf code that we
>  > don't have to.
>  
> What do you 'inadvertantly' ? I see this during bootup every time.
> Unless systemd or something has started playing with perf, (which afaik it isn't)

I mean that somebody turned 'active_events' on without actually wanting
perf to be on.  I'd be curious how it got set to something nonzero.
Could you stick a WARN_ONCE() or printk_ratelimit() on the three sites
that modify it?

>  > But, I'm suspicious.  I was having all kinds of issues with perf and
>  > NMIs taking hundreds of milliseconds.  I never isolated it to having a
>  > real, single, cause.  I attributed it to my large NUMA system just being
>  > slow.  Your description makes me wonder what I missed, though.
> 
> Here's a fun trick:
> 
> trinity -c perf_event_open -C4 -q -l off
> 
> Within about a minute, that brings any of my boxes to its knees.
> The softlockup detector starts going nuts, and then the box wedges solid.

On my box, the same happens with 'perf top'. ;)

*But* dropping the perf sample rate has been really effective at keeping
me from hitting it, and I've had to use _lots_ of CPUs (60-160) doing
those NMIs at once to trigger the lockups.

Being able to trigger it with so few CPUs is interesting though.  I'll
try on my hardware.
