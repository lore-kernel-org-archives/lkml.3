Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab3JATBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 15:01:14 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:42384 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3JATBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 15:01:11 -0400
Message-ID: <524B1AF6.8020406@linux.vnet.ibm.com>
Date: Wed, 02 Oct 2013 00:26:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
References: <20130925175055.GA25914@redhat.com> <20130928144720.GL15690@laptop.programming.kicks-ass.net> <20130928163104.GA23352@redhat.com> <7632387.20FXkuCITr@vostro.rjw.lan> <524B0233.8070203@linux.vnet.ibm.com> <20131001173615.GW3657@laptop.programming.kicks-ass.net> <524B111F.9060003@linux.vnet.ibm.com>
In-Reply-To: <524B111F.9060003@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100119-7014-0000-0000-000003B2B3ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 11:44 PM, Srivatsa S. Bhat wrote:
> On 10/01/2013 11:06 PM, Peter Zijlstra wrote:
>> On Tue, Oct 01, 2013 at 10:41:15PM +0530, Srivatsa S. Bhat wrote:
>>> However, as Oleg said, its definitely worth considering whether this proposed
>>> change in semantics is going to hurt us in the future. CPU_POST_DEAD has certainly
>>> proved to be very useful in certain challenging situations (commit 1aee40ac9c
>>> explains one such example), so IMHO we should be very careful not to undermine
>>> its utility.
>>
>> Urgh.. crazy things. I've always understood POST_DEAD to mean 'will be
>> called at some time after the unplug' with no further guarantees. And my
>> patch preserves that.
>>
>> Its not at all clear to me why cpufreq needs more; 1aee40ac9c certainly
>> doesn't explain it.
>>
> 
> Sorry if I was unclear - I didn't mean to say that cpufreq needs more guarantees
> than that. I was just saying that the cpufreq code would need certain additional
> changes/restructuring to accommodate the change in the semantics brought about
> by this patch. IOW, it won't work as it is, but it can certainly be fixed.
> 

And an important reason why this change can be accommodated with not so much
trouble is because you are changing it only in the suspend/resume path, where
userspace has already been frozen, so all hotplug operations are initiated by
the suspend path and that path *alone* (and so we enjoy certain "simplifiers" that
we know before-hand, eg: all of them are CPU offline operations, happening one at
a time, in sequence) and we don't expect any "interference" to this routine ;-).
As a result the number and variety of races that we need to take care of tend to
be far lesser. (For example, we don't have to worry about the deadlock caused by
sysfs-writes that 1aee40ac9c was talking about).

On the other hand, if the proposal was to change the regular hotplug path as well
on the same lines, then I guess it would have been a little more difficult to
adjust to it. For example, in cpufreq, _dev_prepare() sends a STOP to the governor,
whereas a part of _dev_finish() sends a START to it; so we might have races there,
due to which we might proceed with CPU offline with a running governor, depending
on the exact timing of the events. Of course, this problem doesn't occur in the
suspend/resume case, and hence I didn't bring it up in my previous mail.

So this is another reason why I'm a little concerned about POST_DEAD: since this
is a change in semantics, it might be worth asking ourselves whether we'd still
want to go with that change, if we happened to be changing regular hotplug as
well, rather than just the more controlled environment of suspend/resume.
Yes, I know that's not what you proposed, but I feel it might be worth considering
its implications while deciding how to solve the POST_DEAD issue.

Regards,
Srivatsa S. Bhat

