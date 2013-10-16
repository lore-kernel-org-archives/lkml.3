Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760469Ab3JPJOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:14:35 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:64643 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757547Ab3JPJOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:14:31 -0400
Message-ID: <1381914869.2045.112.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH 1/6] net: ip4_datagram_connect: Use correct form of
 statistics update
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
Date: Wed, 16 Oct 2013 02:14:29 -0700
In-Reply-To: <20131016083545.GP10651@twins.programming.kicks-ass.net>
References: <20131015174722.615394057@linux.com>
	 <20131015174745.197380080@linux.com>
	 <20131016083545.GP10651@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 10:35 +0200, Peter Zijlstra wrote:
> On Tue, Oct 15, 2013 at 12:47:23PM -0500, Christoph Lameter wrote:
> > ip4_datagram_connect is called with BH processing enabled. Therefore
> > we cannot use IP_INC_STATS_BH but must use IP_INC_STATS which disables
> > BH handling before incrementing the counter.
> > 
> > The following trace is triggered without this patch:
> > 
> > [ 9293.806634] __this_cpu_add operation in preemptible [00000000] code: ntpd/2150
> 
> You lost the BUG there; that really needs to be there:
> 
>  - BUG makes people pay attention
>  - This was an actual BUG wasn't it?
> 
> Sure there can be false positives, but in all cases people should amend
> the code. Sometimes with a comment explaining why the raw primitive
> should be used; sometimes to fix an actual bug, but a patch needs to be
> written. Therefore BUG!

Yep this is a real BUG for linux 2.6.36+ on 32bit arches,

The effect of this bug is that on 32bit arches, we might corrupt
a seqcount : Later, we can spin forever on it.

In linux 2.6.36 we converted IP mib from 32 to 64 bits, therefore this
fix should be backported up to 2.6.36

Prior to 2.6.36, the bug was that some increments of SNMP stat could be
lost, because two cpus could access the same location, hardly a
problem...

Thanks


