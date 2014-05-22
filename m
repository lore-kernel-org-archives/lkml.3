Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaEVVlt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:41:49 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:59165 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaEVVls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:41:48 -0400
Message-ID: <537E6ED1.3000007@linux.vnet.ibm.com>
Date: Fri, 23 May 2014 03:10:33 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "Luck, Tony" <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
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
References: <1400750624-19238-1-git-send-email-bp@alien8.de> <537DC6D2.8040305@linux.vnet.ibm.com> <20140522100820.GE4383@pd.tnic> <537DE579.6000505@linux.vnet.ibm.com> <20140522123251.GU30445@twins.programming.kicks-ass.net> <20140522153006.GK4383@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F328133C0@ORSMSX114.amr.corp.intel.com> <20140522195538.GM4383@pd.tnic> <537E687B.9080300@linux.vnet.ibm.com> <20140522213107.GA20306@pd.tnic>
In-Reply-To: <20140522213107.GA20306@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052221-5490-0000-0000-00000021BE2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 03:01 AM, Borislav Petkov wrote:
> On Fri, May 23, 2014 at 02:43:31AM +0530, Srivatsa S. Bhat wrote:
>>>> After you move the cmci_rediscover() call, it is now in a place where we are
>>>> no longer ignoring frozen (i.e. the old placement did the rediscover even if the
>>>> CPU_TASKS_FROZEN bit was set - with the new placement we will skip rediscovery.
>>>>
>>
>> That's not quite true. The existing code already ignores FROZEN for all the cases,
>> by ignoring it at the top of the switch-case itself:
> 
> No, Tony's right and you got confused:
> 
> Before my change, the code did:
> 
> 	if (action == CPU_POST_DEAD) {
> 		/* intentionally ignoring frozen here */
> 		cmci_rediscover();
> 	}
> 
> which is only CPU_POST_DEAD *without* the CPU_TASKS_FROZEN bit.
> 
> If I move it in the switch-case, cmci_rediscover() *ignores the FROZEN
> bit and gets executed for both:
> 
> 	CPU_DEAD:
> 	CPU_DEAD_FROZEN:
> 
> because with the FROZEN bit masked out, they're the same.
> 
> But we don't want to execute it for the FROZEN bit - look for the other
> two tests for CPU_TASKS_FROZEN in mce.c for an example.
> 
> So, before we go and change the FROZEN aspect and break things in
> strange ways, let's keep the _FROZEN ignore. I certainly don't want to
> go down that road and chase why we needed FROZEN or not.
> 
> Ok?
> 

Right, I got confused about who meant what by the term 'ignore' -
ignore the FROZEN _bit_ as in execute all the time irrespective of that
bit being set or unset, or ignore the FROZEN _case_ as in don't execute
during suspend/resume.

Anyway, sorry for the confusion! Your latest code looks correct to me.

Regards,
Srivatsa S. Bhat

