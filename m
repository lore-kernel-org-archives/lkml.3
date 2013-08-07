Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152Ab3HGUD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:03:27 -0400
Received: from toro.web-alm.net ([62.245.132.31]:39588 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932963Ab3HGUDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:03:24 -0400
X-Greylist: delayed 1471 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Aug 2013 16:03:23 EDT
Message-ID: <5202A003.7000903@osadl.org>
Date: Wed, 07 Aug 2013 21:29:07 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] rcu: Ensure rcu read site is deadlock-immunity
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com> <20130807123827.GB4306@linux.vnet.ibm.com>
In-Reply-To: <20130807123827.GB4306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

>> Although all articles declare that rcu read site is deadlock-immunity.
>> It is not true for rcu-preempt, it will be deadlock if rcu read site
>> overlaps with scheduler lock.
>
> The real rule is that if the scheduler does its outermost rcu_read_unlock()
> with one of those locks held, it has to have avoided enabling preemption
> through the entire RCU read-side critical section.
>
> That said, avoiding the need for this rule would be a good thing.
>
> How did you test this?  The rcutorture tests will not exercise this.
> (Intentionally so, given that it can deadlock!)
>
>> ec433f0c, 10f39bb1 and 016a8d5b just partially solve it. But rcu read site
>> is still not deadlock-immunity. And the problem described in 016a8d5b
>> is still existed(rcu_read_unlock_special() calls wake_up).
>>
>> The problem is fixed in patch5.
>
> This is going to require some serious review and testing.  One requirement
> is that RCU priority boosting not persist significantly beyond the
> re-enabling of interrupts associated with the irq-disabled lock.  To do
> otherwise breaks RCU priority boosting.  At first glance, the added
> set_need_resched() might handle this, but that is part of the review
> and testing required.
>
> Steven, would you and Carsten be willing to try this and see if it
> helps with the issues you are seeing in -rt?  (My guess is "no", since
> a deadlock would block forever rather than waking up after a couple
> thousand seconds, but worth a try.)
Your guess was correct, applying this patch doesn't heal the 
NO_HZ_FULL+PREEMPT_RT_FULL 3.10.4 based system; it still is hanging at 
-> synchronize_rcu -> wait_rcu_gp.

	-Carsten.
