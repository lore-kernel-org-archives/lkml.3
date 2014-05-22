Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaEVVbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:31:13 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40772 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaEVVbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:31:11 -0400
Date: Thu, 22 May 2014 23:31:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] x86, MCE: Kill CPU_POST_DEAD
Message-ID: <20140522213107.GA20306@pd.tnic>
References: <1400750624-19238-1-git-send-email-bp@alien8.de>
 <537DC6D2.8040305@linux.vnet.ibm.com>
 <20140522100820.GE4383@pd.tnic>
 <537DE579.6000505@linux.vnet.ibm.com>
 <20140522123251.GU30445@twins.programming.kicks-ass.net>
 <20140522153006.GK4383@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F328133C0@ORSMSX114.amr.corp.intel.com>
 <20140522195538.GM4383@pd.tnic>
 <537E687B.9080300@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <537E687B.9080300@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 02:43:31AM +0530, Srivatsa S. Bhat wrote:
> >> After you move the cmci_rediscover() call, it is now in a place where we are
> >> no longer ignoring frozen (i.e. the old placement did the rediscover even if the
> >> CPU_TASKS_FROZEN bit was set - with the new placement we will skip rediscovery.
> >>
> 
> That's not quite true. The existing code already ignores FROZEN for all the cases,
> by ignoring it at the top of the switch-case itself:

No, Tony's right and you got confused:

Before my change, the code did:

	if (action == CPU_POST_DEAD) {
		/* intentionally ignoring frozen here */
		cmci_rediscover();
	}

which is only CPU_POST_DEAD *without* the CPU_TASKS_FROZEN bit.

If I move it in the switch-case, cmci_rediscover() *ignores the FROZEN
bit and gets executed for both:

	CPU_DEAD:
	CPU_DEAD_FROZEN:

because with the FROZEN bit masked out, they're the same.

But we don't want to execute it for the FROZEN bit - look for the other
two tests for CPU_TASKS_FROZEN in mce.c for an example.

So, before we go and change the FROZEN aspect and break things in
strange ways, let's keep the _FROZEN ignore. I certainly don't want to
go down that road and chase why we needed FROZEN or not.

Ok?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
