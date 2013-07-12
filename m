Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab3GLPjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:39:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:20805 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932979Ab3GLPjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:39:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,653,1367996400"; 
   d="scan'208";a="344601642"
Message-ID: <51E0230C.9010509@intel.com>
Date: Fri, 12 Jul 2013 08:38:52 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Dave Jones <davej@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Yet more softlockups.
References: <20130704015525.GA8486@redhat.com> <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com> <20130705143821.GB325@redhat.com> <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de> <20130705160043.GF325@redhat.com> <20130706072408.GA14865@gmail.com> <20130710151324.GA11309@redhat.com> <20130710152015.GA757@x4> <20130710154029.GB11309@redhat.com> <20130712103117.GA14862@gmail.com>
In-Reply-To: <20130712103117.GA14862@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 03:31 AM, Ingo Molnar wrote:
> * Dave Jones <davej@redhat.com> wrote:
>> On Wed, Jul 10, 2013 at 05:20:15PM +0200, Markus Trippelsdorf wrote:
>>  > On 2013.07.10 at 11:13 -0400, Dave Jones wrote:
>>  > > I get this right after booting..
>>  > > 
>>  > > [  114.516619] perf samples too long (4262 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
>>  > 
>>  > You can disable this warning by:
>>  > 
>>  > echo 0 > /proc/sys/kernel/perf_cpu_time_max_percent
>>
>> Yes, but why is this even being run when I'm not running perf ?
>>
>> The only NMI source running should be the watchdog.
> 
> The NMI watchdog is a perf event.
> 
> I've Cc:-ed Dave Hansen, the author of those changes - is this a false 
> positive or some real problem?

The warning comes from calling perf_sample_event_took(), which is only
called from one place: perf_event_nmi_handler().

So we can be pretty sure that the perf NMI is firing, or at least that
this handler code is running.

nmi_handle() says:
        /*
         * NMIs are edge-triggered, which means if you have enough
         * of them concurrently, you can lose some because only one
         * can be latched at any given time.  Walk the whole list
         * to handle those situations.
         */

perf_event_nmi_handler() probably gets _called_ when the watchdog NMI
goes off.  But, it should hit this check:

        if (!atomic_read(&active_events))
                return NMI_DONE;

and return quickly. This is before it has a chance to call
perf_sample_event_took().

Dave, for your case, my suspicion would be that it got turned on
inadvertently, or that we somehow have a bug which bumped up
perf_event.c's 'active_events' and we're running some perf code that we
don't have to.

But, I'm suspicious.  I was having all kinds of issues with perf and
NMIs taking hundreds of milliseconds.  I never isolated it to having a
real, single, cause.  I attributed it to my large NUMA system just being
slow.  Your description makes me wonder what I missed, though.
