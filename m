Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965130Ab3GLRTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 13:19:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964889Ab3GLRTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 13:19:11 -0400
Date: Fri, 12 Jul 2013 13:18:08 -0400
From: Dave Jones <davej@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: Yet more softlockups.
Message-ID: <20130712171808.GD1537@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Ahern <dsahern@gmail.com>,
	Dave Hansen <dave.hansen@intel.com>, Ingo Molnar <mingo@kernel.org>,
	Markus Trippelsdorf <markus@trippelsdorf.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
References: <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de>
 <20130705160043.GF325@redhat.com>
 <20130706072408.GA14865@gmail.com>
 <20130710151324.GA11309@redhat.com>
 <20130710152015.GA757@x4>
 <20130710154029.GB11309@redhat.com>
 <20130712103117.GA14862@gmail.com>
 <51E0230C.9010509@intel.com>
 <20130712154521.GD1020@redhat.com>
 <51E038ED.7050600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E038ED.7050600@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 11:12:13AM -0600, David Ahern wrote:
 > On 7/12/13 9:45 AM, Dave Jones wrote:
 > > Here's a fun trick:
 > >
 > > trinity -c perf_event_open -C4 -q -l off
 > >
 > > Within about a minute, that brings any of my boxes to its knees.
 > > The softlockup detector starts going nuts, and then the box wedges solid.
 > 
 > I tried that in a VM running latest Linus tree. I see trinity children 
 > getting nuked regularly from oom.

Weird. I'm curious what the backtrace looks like in those cases.
Where is it trying to allocate memory ?
(Though that isn't usually too helpful in most cases, but in absense of
 anything else..)

 > I was dumping Vm elements using:
 > 
 > while [ 1 ]; do echo $(date) $(egrep Vm /proc/$pid/status); sleep 1; done
 > 
 > And right before the process is killed was the line:
 > 
 > Fri Jul 12 11:00:19 MDT 2013 VmPeak: 2867472 kB VmSize: 2867472 kB 
 > VmLck: 0 kB VmPin: 0 kB VmHWM: 1493092 kB VmRSS: 1493092 kB VmData: 
 > 2857944 kB VmStk: 136 kB VmExe: 100 kB VmLib: 1844 kB VmPTE: 5628 kB 
 > VmSwap: 0 kB
 > 
 > The VmData is growing fairly steadily and strace shows a lot of brk 
 > calls. Is that normal for trinity - or this command line?
 
Hmm, there are a few known leaks in trinity that I still haven't got
around to fixing, but none that should be triggered from this.

I wonder if something about being virtualised is perturbing its behaviour
somehow. Though I can't think what would matter. 

 > Looking at the perf_event_open calls I see a lot of E2BIG errors in 
 > addition to EINVAL. e.g,
 > 
 > ...
 > perf_event_open(0xba9000, 0, 0x4c, 0xcc, 0) = -1 EINVAL (Invalid argument)
 > alarm(0)                                = 1
 > getppid()                               = 9031
 > alarm(1)                                = 0
 > perf_event_open(0xba9000, 0x2a6e, 0xe, 0xfd, 0) = -1 E2BIG (Argument 
 > list too long)
 > alarm(0)                                = 1
 > getppid()                               = 9031
 > alarm(1)                                = 0

Yep, that'll happen.

Perhaps try CONFIG_MEMLEAK ?

	Dave

