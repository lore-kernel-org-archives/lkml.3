Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289Ab3GLPqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:46:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932970Ab3GLPqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:46:08 -0400
Date: Fri, 12 Jul 2013 11:45:21 -0400
From: Dave Jones <davej@redhat.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Yet more softlockups.
Message-ID: <20130712154521.GD1020@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
References: <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
 <20130705143821.GB325@redhat.com>
 <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de>
 <20130705160043.GF325@redhat.com>
 <20130706072408.GA14865@gmail.com>
 <20130710151324.GA11309@redhat.com>
 <20130710152015.GA757@x4>
 <20130710154029.GB11309@redhat.com>
 <20130712103117.GA14862@gmail.com>
 <51E0230C.9010509@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E0230C.9010509@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 08:38:52AM -0700, Dave Hansen wrote:
 
 > The warning comes from calling perf_sample_event_took(), which is only
 > called from one place: perf_event_nmi_handler().
 > 
 > So we can be pretty sure that the perf NMI is firing, or at least that
 > this handler code is running.
 > 
 > nmi_handle() says:
 >         /*
 >          * NMIs are edge-triggered, which means if you have enough
 >          * of them concurrently, you can lose some because only one
 >          * can be latched at any given time.  Walk the whole list
 >          * to handle those situations.
 >          */
 > 
 > perf_event_nmi_handler() probably gets _called_ when the watchdog NMI
 > goes off.  But, it should hit this check:
 > 
 >         if (!atomic_read(&active_events))
 >                 return NMI_DONE;
 > 
 > and return quickly. This is before it has a chance to call
 > perf_sample_event_took().
 > 
 > Dave, for your case, my suspicion would be that it got turned on
 > inadvertently, or that we somehow have a bug which bumped up
 > perf_event.c's 'active_events' and we're running some perf code that we
 > don't have to.
 
What do you 'inadvertantly' ? I see this during bootup every time.
Unless systemd or something has started playing with perf, (which afaik it isn't)

 > But, I'm suspicious.  I was having all kinds of issues with perf and
 > NMIs taking hundreds of milliseconds.  I never isolated it to having a
 > real, single, cause.  I attributed it to my large NUMA system just being
 > slow.  Your description makes me wonder what I missed, though.

Here's a fun trick:

trinity -c perf_event_open -C4 -q -l off

Within about a minute, that brings any of my boxes to its knees.
The softlockup detector starts going nuts, and then the box wedges solid.

(You may need to bump -C depending on your CPU count. I've never seen it happen
 with a single process, but -C2 seems to be a minimum)

That *is* using perf though, so I kind of expect bad shit to happen when there are bugs.
The "during bootup" case is still a head-scratcher.

	Dave

