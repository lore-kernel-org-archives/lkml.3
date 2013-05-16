Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab3EPSdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:33:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6062 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3EPSdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:33:01 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=3aLxPhj7Q5gA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=e7SmI9TJ9RsA:10 a=LoMvpzUKhRMZ-kvfNCUA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368729178.6828.105.camel@gandalf.local.home>
Subject: Re: [PATCH 1/2] nohz: Disable LOCKUP_DETECTOR when NO_HZ_FULL is
 enabled
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 16 May 2013 14:32:58 -0400
In-Reply-To: <20130516175602.GL19669@dyad.programming.kicks-ass.net>
References: <1368547372-21011-1-git-send-email-fweisbec@gmail.com>
	 <1368547372-21011-2-git-send-email-fweisbec@gmail.com>
	 <20130515083729.GC10510@laptop.programming.kicks-ass.net>
	 <20130515150652.GP23604@redhat.com>
	 <1368631622.6828.69.camel@gandalf.local.home>
	 <20130515165915.GE13916@laptop.home>
	 <1368637441.6828.70.camel@gandalf.local.home>
	 <20130516081027.GD19669@dyad.programming.kicks-ass.net>
	 <20130516150706.GY4442@linux.vnet.ibm.com>
	 <20130516175602.GL19669@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-16 at 19:56 +0200, Peter Zijlstra wrote:

> I suppose the fundamental question was: will receiving NMIs negate NO_HZ_FULL's
> functionality? That is, will the getting of NMIs make us drop out of NO_HZ_FULL
> and re-enable all sorts of things?

It shouldn't. The nmi_enter() notifies RCU that it can no longer ignore
this CPU, where as nmi_enter() tells it that it can ignore it, as it has
re-entered user space.

> 
> Because clearly RCU needs to exit from EQS, which might (or might not) mean
> leaving NO_HZ_FULL.

Yep, but the two are pretty much agnostic from each other.

We only need to leave NO_HZ_FULL if RCU (or anything for that matter)
required having a tick again. But as Paul said, getting an NMI in idle
wont restart the tick, so there's no need to restart it here either.

Now if an NMI were to do a call_rcu() then it would require a tick. But
NMIs doing call_rcu() has much bigger issues to worry about ;-)

-- Steve

> 
> I'm not entirely up-to-date on those details.


