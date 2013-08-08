Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab3HHBNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 21:13:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53656 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757321Ab3HHBNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 21:13:06 -0400
X-IronPort-AV: E=Sophos;i="4.89,836,1367942400"; 
   d="scan'208";a="8148902"
Message-ID: <5202F198.2060806@cn.fujitsu.com>
Date: Thu, 08 Aug 2013 09:17:12 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Carsten Emde <C.Emde@osadl.org>
CC: paulmck@linux.vnet.ibm.com, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] rcu: Ensure rcu read site is deadlock-immunity
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com> <20130807123827.GB4306@linux.vnet.ibm.com> <5202A003.7000903@osadl.org>
In-Reply-To: <5202A003.7000903@osadl.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 09:11:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/08 09:11:40,
	Serialize complete at 2013/08/08 09:11:40
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 03:29 AM, Carsten Emde wrote:
> Hi Paul,
> 
>>> Although all articles declare that rcu read site is deadlock-immunity.
>>> It is not true for rcu-preempt, it will be deadlock if rcu read site
>>> overlaps with scheduler lock.
>>
>> The real rule is that if the scheduler does its outermost rcu_read_unlock()
>> with one of those locks held, it has to have avoided enabling preemption
>> through the entire RCU read-side critical section.
>>
>> That said, avoiding the need for this rule would be a good thing.
>>
>> How did you test this?  The rcutorture tests will not exercise this.
>> (Intentionally so, given that it can deadlock!)
>>
>>> ec433f0c, 10f39bb1 and 016a8d5b just partially solve it. But rcu read site
>>> is still not deadlock-immunity. And the problem described in 016a8d5b
>>> is still existed(rcu_read_unlock_special() calls wake_up).
>>>
>>> The problem is fixed in patch5.
>>
>> This is going to require some serious review and testing.  One requirement
>> is that RCU priority boosting not persist significantly beyond the
>> re-enabling of interrupts associated with the irq-disabled lock.  To do
>> otherwise breaks RCU priority boosting.  At first glance, the added
>> set_need_resched() might handle this, but that is part of the review
>> and testing required.
>>
>> Steven, would you and Carsten be willing to try this and see if it
>> helps with the issues you are seeing in -rt?  (My guess is "no", since
>> a deadlock would block forever rather than waking up after a couple
>> thousand seconds, but worth a try.)
> Your guess was correct, applying this patch doesn't heal the NO_HZ_FULL+PREEMPT_RT_FULL 3.10.4 based system; it still is hanging at -> synchronize_rcu -> wait_rcu_gp.
> 
>     -Carsten.
> 

I didn't find the problem you reported, could you give me a url?

Thanx,
Lai
