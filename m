Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760364Ab3JPJ0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:26:08 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:39606 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760179Ab3JPJ0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:26:07 -0400
Date: Wed, 16 Oct 2013 11:26:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Christoph Lameter <cl@linux.com>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/6] net: ip4_datagram_connect: Use correct form of
 statistics update
Message-ID: <20131016092601.GB23440@gmail.com>
References: <20131015174722.615394057@linux.com>
 <20131015174745.197380080@linux.com>
 <20131016083545.GP10651@twins.programming.kicks-ass.net>
 <1381914869.2045.112.camel@edumazet-glaptop.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381914869.2045.112.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On Wed, 2013-10-16 at 10:35 +0200, Peter Zijlstra wrote:
> > On Tue, Oct 15, 2013 at 12:47:23PM -0500, Christoph Lameter wrote:
> > > ip4_datagram_connect is called with BH processing enabled. Therefore
> > > we cannot use IP_INC_STATS_BH but must use IP_INC_STATS which disables
> > > BH handling before incrementing the counter.
> > > 
> > > The following trace is triggered without this patch:
> > > 
> > > [ 9293.806634] __this_cpu_add operation in preemptible [00000000] code: ntpd/2150
> > 
> > You lost the BUG there; that really needs to be there:
> > 
> >  - BUG makes people pay attention
> >  - This was an actual BUG wasn't it?
> > 
> > Sure there can be false positives, but in all cases people should 
> > amend the code. Sometimes with a comment explaining why the raw 
> > primitive should be used; sometimes to fix an actual bug, but a patch 
> > needs to be written. Therefore BUG!
> 
> Yep this is a real BUG for linux 2.6.36+ on 32bit arches,
> 
> The effect of this bug is that on 32bit arches, we might corrupt a 
> seqcount : Later, we can spin forever on it.

Ouch, that's a pretty serious bug ...

The patch title should reflect this fact.

> In linux 2.6.36 we converted IP mib from 32 to 64 bits, therefore this 
> fix should be backported up to 2.6.36
> 
> Prior to 2.6.36, the bug was that some increments of SNMP stat could be 
> lost, because two cpus could access the same location, hardly a 
> problem...

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
