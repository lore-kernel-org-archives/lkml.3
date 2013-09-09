Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab3IIRHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:07:09 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58493 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751342Ab3IIRHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:07:07 -0400
Message-ID: <522E0037.3090107@sgi.com>
Date: Mon, 09 Sep 2013 10:07:03 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] x86/UV: Add ability to disable UV NMI handler
References: <20130905225032.879120272@asylum.americas.sgi.com> <20130905225034.343366161@asylum.americas.sgi.com> <20130909124349.GY31370@twins.programming.kicks-ass.net>
In-Reply-To: <20130909124349.GY31370@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 9/9/2013 5:43 AM, Peter Zijlstra wrote:
> On Thu, Sep 05, 2013 at 05:50:41PM -0500, Mike Travis wrote:
>> For performance reasons, the NMI handler may be disabled to lessen the
>> performance impact caused by the multiple perf tools running concurently.
>> If the system nmi command is issued when the UV NMI handler is disabled,
>> the "Dazed and Confused" messages occur for all cpus.  The NMI handler is
>> disabled by setting the nmi disabled variable to '1'.  Setting it back to
>> '0' will re-enable the NMI handler.
> 
> I'm not entirely sure why this is still needed now that you've moved all
> really expensive bits into the UNKNOWN handler.
> 

Yes, it could be considered optional.  My primary use was to isolate
new bugs I found to see if my NMI changes were causing them.  But it
appears that they are not since the problems occur with or without
using the NMI entry into KDB.  So it can be safely removed.

(The basic problem is that if you hang out in KDB too long the machine
locks up.  Other problems like the rcu stall detector does not have a
means to be "touched" like the nmi_watchdog_timer so it fires off a
few to many, many messages.  Another, any network connections will time
out if you are in KDB more than say 20 or 30 seconds.)

One other problem is with the perf tool.  It seems running more than
about 2 or 3 perf top instances on a medium (1k cpu threads) sized
system, they start behaving badly with a bunch of NMI stackdumps
appearing on the console.  Eventually the system become unusable.

On a large system (4k), the perf tools get an error message (sorry
don't have it handy at the moment) the basically implies that the
perf config option is not set.  Again, I wanted to remove the new
NMI handler to insure that it wasn't doing something weird, and
it wasn't.

Thanks,
Mike
