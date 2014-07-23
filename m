Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbaGWPV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:21:57 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:44498 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbaGWPVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:21:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAJhHMCA-FbnXuxK9VT_ed2S_WPap_y+nnH5-a96ekPdyXRvtVQ@mail.gmail.com>
References: <1406092194-13004-1-git-send-email-bobby.prani@gmail.com>
 <1406092194-13004-5-git-send-email-bobby.prani@gmail.com> <20140723120907.GG11241@linux.vnet.ibm.com>
 <CAJhHMCAQ7+HzXfH7E3LNbUVG_zf-1edj6yPBHQ9wtbTrBAoa7A@mail.gmail.com>
 <20140723134116.GP11241@linux.vnet.ibm.com> <CAJhHMCAgrnxPTqTJjQ+Yw8LFgQBM3VHm6yWNf_Ct0nvAw-CmoQ@mail.gmail.com>
 <20140723141424.GT11241@linux.vnet.ibm.com> <CAJhHMCA-FbnXuxK9VT_ed2S_WPap_y+nnH5-a96ekPdyXRvtVQ@mail.gmail.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 23 Jul 2014 11:21:24 -0400
Message-ID: <CAJhHMCCTjEM6qNj=VffHno11F5jV9xYxwM=_KMUyoVJx5jrJ=A@mail.gmail.com>
Subject: Re: [PATCH 04/16] rcu: Remove redundant check for an online CPU
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 11:07 AM, Pranith Kumar <bobby.prani@gmail.com> wrote:
> On Wed, Jul 23, 2014 at 10:14 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
>> On Wed, Jul 23, 2014 at 10:01:14AM -0400, Pranith Kumar wrote:
>>> On Wed, Jul 23, 2014 at 9:41 AM, Paul E. McKenney
>>> <paulmck@linux.vnet.ibm.com> wrote:
>>> > On Wed, Jul 23, 2014 at 09:23:47AM -0400, Pranith Kumar wrote:
>>> >> On Wed, Jul 23, 2014 at 8:09 AM, Paul E. McKenney
>>> >> <paulmck@linux.vnet.ibm.com> wrote:
>>> >> > On Wed, Jul 23, 2014 at 01:09:41AM -0400, Pranith Kumar wrote:
>>> >> >> rcu_prcess_callbacks() is the softirq handler for RCU which is raised from
>>> >> >> invoke_rcu_core() which is called from __call_rcu_core().
>>> >> >>
>>> >> >> Each of these three functions checks if the cpu is online. We can remove the
>>> >> >> redundant ones. This commit removes one of these redundant check.
>>> >> >>
>>> >> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>>> >> >
>>> >> > Sorry, but no.  There can be a long delay between raise_softirq() and
>>> >> > this function starting, particularly if ksoftirqd gets involved.  The
>>> >> > CPU could easily go offline in the meantime.
>>> >> >
>>> >>
>>> >> That makes sense. I guess one of the other two checks in
>>> >> __call_rcu_core() or invoke_rcu_core() can go then?
>>> >
>>> > What would have to be the case for this suggested change to be safe?
>>> > Does that condition in fact hold?
>>> >
>>>
>>> The only scenario which is unsafe is when this thread is preempted and
>>> scheduled on a dying CPU. In that case we should turn off interrupts.
>>>
>>> Actually, checking the code, I see that interrupts are turned off
>>> already before we call _call_rcu_core(). So I am not sure such a case
>>> will happen. On the other hand invoke_rcu_core() will be a one line
>>> function which might as well be in-lined to avoid the double cpu
>>> online check.
>>>
>>> What am I missing?
>>
>> I am not sure.  Perhaps the fact that __call_rcu_core() doesn't call
>> invoke_rcu_core() unless the condition holds (which means that you
>> cannnot remove the check from __call_rcu_core()) or maybe the fact that
>> invoke_rcu_core() is called from many other places, which means that
>> you might not be able to remove the check from invoke_rcu_core().
>>
>
> OK, since invoke_rcu_core() is being called from multiple places, we
> cannot remove the check there.
>
> But we can remove the check from __call_rcu_core(). Since we are going
> to check again in invoke_rcu_core(), no? We will call
> invoke_rcu_core() but we will return if the check if false.
>
> The trade-off here is between a function call and an extra
> smp_processor_id(). The only reason I am trying to do this is because
> smp_processor_id() disables and enables interrupts which is costly and
> we can avoid one such check.
>

Ah, I just checked and the above is not true. We don't disable
interrupts, we do a this_cpu_read().

How many newbie cards do I have left :)

-- 
Pranith
