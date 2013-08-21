Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab3HUDVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 23:21:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41057 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab3HUDVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 23:21:36 -0400
X-IronPort-AV: E=Sophos;i="4.89,924,1367942400"; 
   d="scan'208";a="8256583"
Message-ID: <52143343.4090303@cn.fujitsu.com>
Date: Wed, 21 Aug 2013 11:25:55 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 5/8] rcu: eliminate deadlock for rcu read site
References: <1375871104-10688-1-git-send-email-laijs@cn.fujitsu.com> <1375871104-10688-6-git-send-email-laijs@cn.fujitsu.com> <20130808204020.GA31127@linux.vnet.ibm.com> <5205B6FF.7060502@cn.fujitsu.com> <20130810150715.GF29406@linux.vnet.ibm.com> <20130821031727.GA21711@linux.vnet.ibm.com>
In-Reply-To: <20130821031727.GA21711@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/21 11:19:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/21 11:19:49,
	Serialize complete at 2013/08/21 11:19:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 11:17 AM, Paul E. McKenney wrote:
> On Sat, Aug 10, 2013 at 08:07:15AM -0700, Paul E. McKenney wrote:
>> On Sat, Aug 10, 2013 at 11:43:59AM +0800, Lai Jiangshan wrote:
> 
> [ . . . ]
> 
>>> So I have to narrow the range of suspect locks. Two choices:
>>> A) don't call rt_mutex_unlock() from rcu_read_unlock(), only call it
>>>    from rcu_preempt_not_context_switch(). we need to rework these
>>>    two functions and it will add complexity to RCU, and it also still
>>>    adds some probability of deferring.
>>
>> One advantage of bh-disable locks is that enabling bh checks
>> TIF_NEED_RESCHED, so that there is no deferring beyond that
>> needed by bh disable.  The same of course applies to preempt_disable().
>>
>> So one approach is to defer when rcu_read_unlock_special() is entered
>> with either preemption or bh disabled.  Your current set_need_resched()
>> trick would work fine in this case.  Unfortunately, re-enabling interrupts
>> does -not- check TIF_NEED_RESCHED, which is why we have latency problems
>> in that case.  (Hence my earlier question about making self-IPI safe
>> on all arches, which would result in an interrupt as soon as interrupts
>> were re-enabled.)
>>
>> Another possibility is to defer only when preemption or bh are disabled
>> on entry ro rcu_read_unlock_special(), but to retain the current
>> (admittedly ugly) nesting rules for the scheduler locks.
> 
> Would you be willing to do a patch that deferred rt_mutex_unlock() in
> the preempt/bh cases?  This of course does not solve the irq-disable
> case, but it should at least narrow the problem to the scheduler locks.
> 
> Not a big hurry, given the testing required, this is 3.13 or 3.14 material,
> I think.
> 
> If you are busy, no problem, I can do it, just figured you have priority
> if you want it.
> 
> 	


I'm writing a special rt_mutex_unlock() for rcu deboost only.
I hope Steven accept it.

Thanks,
Lai
