Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbbAIV7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:59:00 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:37070 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbbAIV66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:58:58 -0500
Message-ID: <54B04F1A.1060401@de.ibm.com>
Date: Fri, 09 Jan 2015 22:58:50 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com,
        Pranith Kumar <bobby.prani@gmail.com>
Subject: Re: [PATCH tip/core/rcu 01/14] rcu: Protect rcu_boost() lockless
 accesses with ACCESS_ONCE()
References: <20150107173215.GA897@linux.vnet.ibm.com> <1420651953-2651-1-git-send-email-paulmck@linux.vnet.ibm.com> <20150108094102.GD29390@twins.programming.kicks-ass.net> <20150108152230.GL5280@linux.vnet.ibm.com> <1420785714.25454.1.camel@stgolabs.net> <20150109134954.GO5280@linux.vnet.ibm.com> <20150109135614.GI29390@twins.programming.kicks-ass.net>
In-Reply-To: <20150109135614.GI29390@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15010921-0021-0000-0000-0000027C2682
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.01.2015 um 14:56 schrieb Peter Zijlstra:
> On Fri, Jan 09, 2015 at 05:49:54AM -0800, Paul E. McKenney wrote:
>>> That reminds me, I think the new conversion for stores will most likely
>>> introduce silly arg bugs:
>>>
>>> -       ACCESS_ONCE(a) = b;
>>> +       ASSIGN_ONCE(b, a);
>>
>> I was planning to do mine by hand for this sort of reason.
>>
>> Or are you thinking of something more subtle than the case where
>> "b" is an unparenthesized comma-separated expression?
> 
> I think he's revering to the wrong way around-ness of the thing.
> 
> Its a bit of a mixed bag on assignments, but for instance
> rcu_assign_pointer() takes them the right way around, as does
> atomic_set().
> 
> So yes, I think the ASSIGN_ONCE() thing got the arguments the wrong way
> around.
> 
> We could maybe still change it, before its in too long ?

Linus initial proposal was inspired by put_user model which is (val, ptr) and I took that.
As my focus was on avoiding the volatile bug, all my current conversions are READ_ONCE as no potential ASSIGN_ONCE user was done on a non-scalar type, so I have no first hand experience. I am fine with changing that, though, both ways have pros and cons. Last time I checked in Linus tree there was no ASSIGN_ONCE user.

When we talk about changing the parameters it might make sense to also think about some comments from George Spelvin and consider a rename to WRITE_ONCE or STORE_ONCE (READ_ONCE --> LOAD_ONCE). Unfortunately there doesnt seem to be a variant that is fool proof (in the sense of Rustys guideline that a good interface cannot be used wrong). So any proposal in that regard would be very welcome.

Christian

