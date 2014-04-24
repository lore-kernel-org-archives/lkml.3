Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbaDXRl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:41:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:20470 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758492AbaDXRlY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:41:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,920,1389772800"; 
   d="scan'208";a="527606846"
From: "Luck, Tony" <tony.luck@intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Bugfix] sched: fix possible invalid memory access caused by
 CPU hot-addition
Thread-Topic: [Bugfix] sched: fix possible invalid memory access caused by
 CPU hot-addition
Thread-Index: AQHPXes1Qjl1X5tgj0C+YUEy+BJBwpsdv3yAgAE2H4CAAC6pgIAABUiAgABRbRCAAREHgIAAUHKAgAAiapA=
Date: Thu, 24 Apr 2014 17:41:20 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F327EC694@ORSMSX114.amr.corp.intel.com>
References: <1398144435-26271-1-git-send-email-jiang.liu@linux.intel.com>
 <20140422081515.GF11182@twins.programming.kicks-ass.net>
 <53572939.7020509@linux.intel.com>
 <20140423053213.GV26782@laptop.programming.kicks-ass.net>
 <20140423055107.GB1429@laptop.programming.kicks-ass.net>
 <3908561D78D1C84285E8C5FCA982C28F327EB605@ORSMSX114.amr.corp.intel.com>
 <53587E21.5070507@linux.intel.com>
 <20140424074741.GA26782@laptop.programming.kicks-ass.net>
In-Reply-To: <20140424074741.GA26782@laptop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 	The BIOS always sends CPU hot-addition events before memory
>> hot-addition events, so it's hard to change the order.
>> 	And we couldn't completely solve this performance penalty because the
>> affected code tries to allocate memory for all possible
>> CPUs instead of onlined CPUs.
>
> So the BIOS is fucked, news at 11, one would have hoped Intel would have
> _some_ say in it, but alas. So how about instead you force memory online
> when you online the first CPU, screw whatever the BIOS does or does not?

Certainly an interesting implementation choice by the BIOS. The only logical
order to use to bring components of a modern cpu online is:

1) Memory - so we have a place to allocate structure needed for following steps
2) Cores - so we have a place to direct interrupts from next step
3) I/O

We should log a bug against the BIOS ... but systems are already shipping so we will
have to deal with this.

Either we use your existing patch - and systems with silly BIOS will work, but with a
small NUMA penalty for objects allocated remotely

or ... we implement some crazy queuing scheme ... where we delay bringing cores
online for a while to see whether more things like memory and I/O start showing
up too.  We can't wait forever - people sometimes do configure systems with
memory-less nodes.

I think your existing solution is the better choice ... the penalties probably aren't
all that big ... so extensive workarounds for BIOS bugs seem like the wrong direction.

Maybe a one-time printk() so the user knows they have a buggy BIOS might help
provide back pressure to BIOS teams to do this right in the future? But it isn't
a bug for the memory-less node case.

-Tony
