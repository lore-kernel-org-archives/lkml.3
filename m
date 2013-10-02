Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3JBTch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 15:32:37 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:6601 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab3JBTcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 15:32:36 -0400
Message-ID: <524C74C3.4060908@hp.com>
Date: Wed, 02 Oct 2013 15:32:19 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Paul McKenney <paulmck@linux.vnet.ibm.com>, Jason Low <jason.low2@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v6 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
References: <cover.1380144003.git.tim.c.chen@linux.intel.com>  <1380147049.3467.67.camel@schen9-DESK>  <20130927152953.GA4464@linux.vnet.ibm.com>  <1380310733.3467.118.camel@schen9-DESK>  <20130927203858.GB9093@linux.vnet.ibm.com>  <1380322005.3467.186.camel@schen9-DESK>  <20130927230137.GE9093@linux.vnet.ibm.com>  <CAGQ1y=7YbB_BouYZVJwAZ9crkSMLVCxg8hoqcO_7sXHRrZ90_A@mail.gmail.com>  <20130928021947.GF9093@linux.vnet.ibm.com>  <CAGQ1y=5RnRsWdOe5CX6WYEJ2vUCFtHpj+PNC85NuEDH4bMdb0w@mail.gmail.com>  <52499E13.8050109@hp.com> <1380557440.14213.6.camel@j-VirtualBox>  <5249A8A4.9060400@hp.com> <1380646092.11046.6.camel@schen9-DESK>  <524B2A01.4080403@hp.com> <1380662188.11046.37.camel@schen9-DESK>  <524B75F0.2070005@hp.com> <1380739391.11046.73.camel@schen9-DESK>
In-Reply-To: <1380739391.11046.73.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2013 02:43 PM, Tim Chen wrote:
> On Tue, 2013-10-01 at 21:25 -0400, Waiman Long wrote:
>>
>> If the lock and unlock functions are done right, there should be no
>> overlap of critical section. So it is job of the lock/unlock functions
>> to make sure that critical section code won't leak out. There should be
>> some kind of memory barrier at the beginning of the lock function and
>> the end of the unlock function.
>>
>> The critical section also likely to have branches. The CPU may
>> speculatively execute code on the 2 branches, but one of them will be
>> discarded once the branch condition is known. Also
>> arch_mutex_cpu_relax() is a compiler barrier by itself. So we may not
>> need a barrier() after all. The while statement is a branch instruction,
>> any code after that can only be speculatively executed and cannot be
>> committed until the branch is done.
> But the condition code may be checked after speculative execution?
> The condition may not be true during speculative execution and only
> turns true when we check the condition, and take that branch?
>
> The thing that bothers me is without memory barrier after the while
> statement, we could speculatively execute before affirming the lock is
> in acquired state. Then when we check the lock, the lock is set
> to acquired state in the mean time.
> We could be loading some memory entry *before*
> the node->locked has been set true.  I think a smp_rmb (if not a
> smp_mb) should be set after the while statement.

Yes, I think a smp_rmb() make sense here to correspond to the smp_wmb() 
in the unlock path.

BTW, you need to move the node->locked = 0; statement before xchg() if 
you haven't done so.

-Longman


