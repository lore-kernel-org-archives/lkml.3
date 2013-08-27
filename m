Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab3H0Vf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:35:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42044 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3H0VfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:35:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Guy Briggs <rgb@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Eric Paris <eparis@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "Serge E. Hallyn" <serge@hallyn.com>
References: <cover.1377032086.git.rgb@redhat.com>
	<bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
	<20130822200555.GN31370@twins.programming.kicks-ass.net>
	<20130822214347.GB21110@madcap2.tricolour.ca>
	<20130823063621.GO31370@twins.programming.kicks-ass.net>
	<20130827023722.GB21098@madcap2.tricolour.ca>
	<20130827121133.GD10002@twins.programming.kicks-ass.net>
Date: Tue, 27 Aug 2013 14:35:11 -0700
In-Reply-To: <20130827121133.GD10002@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Tue, 27 Aug 2013 14:11:33 +0200")
Message-ID: <87ob8ihl68.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18DbKy8smg9kXYPDalABPJIluZ07fAbBDk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4553]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  1.0 XMSexyCombo_01 Sexy words in both body/subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Peter Zijlstra <peterz@infradead.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding task->pid and task->tgid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Mon, Aug 26, 2013 at 10:37:22PM -0400, Richard Guy Briggs wrote:
>> On Fri, Aug 23, 2013 at 08:36:21AM +0200, Peter Zijlstra wrote:
>> > Except that's not the case, with namespaces there's a clear hierarchy
>> > and the task_struct::pid is the one true value aka. root namespace.
>> 
>> Peter, I agonized over the access efficiency of dropping this one or the
>> duplicate in task_struct::pids and this one was far easier to drop in
>> terms of somehow always forcing
>> task->pids[PIDTYPE_PID].pid->numbers[0].nr to point to task->pid.
>
> You mean there's more than 1 site that sets task_struct::pid? I thought
> we only assign that thing once in fork.c someplace.

No there is not and that is not a concern.

Now I had thought given how the perf subsystem was constructed that only
the god like root was even allowed to use the code.  But it turns out
there is sysctl_perf_event_paranoid that can bet twiddled that in some
circumstance that unprivileged users are allowed to use perf.  Which
ultimately means perf will return the wrong data.

Meaning that perf is broken by design and perf has no excuse to be using
task->pid.  Similarly every other place in the kernel that has made the
same mistake.  I mention perf explicitly for two reasons.  perf gets the
namespace handling horribly wrong, perf is the only place in the kernel
where we are accessing pids frequently enough for an extra cache line
miss to be a concern.

When really pids in the kernel what we care about is not some stupid
number but the stuct pid which points to that tasks, process groups, and
sessions.  You know the object that a pid is the name for.

So yes as a long term direction task->pid and task->tgid need to be
killed because we keep getting subsystems like perf that return the
wrong data to userspace, or perform the wrong checks, because the
current structure makes it seem like it is ok to do the wrong thing.

Now that should not be Richard's fight.  Hopefully he can focus on
fixing audit.

> There's a few special cases, like the idle threads having pid-0 and
> 'simple' people like myself prefer to use task_struct::pid for debugging
> when we run our simple kernels without all this namespace stuff
> enabled.

Which is why a special printf format is likely a good idea because it
means you can easily print pids without needing to call ungainly helper
functions.

Of course you can't run kernels without this ``namespace'' stuff
enabled.  The best you can do is run kernels without the ability to
create new instances of the namespaces.

> The entire task->pids[PIDTYPE_PID].pid->numbers[0].nr thing just seems
> increddibly unwieldy and double dereferences, even if the lines are
> 'hot' are worse than single derefs.

But it is so much better than having to look up task->pid in a hash
table to get anything done, which is the previous state of affairs.

When the pid namespace support was merged except for a few overlooked
corner cases everything was converted except a bunch of printk
statements.  Now I look in the kernel and we have had subsystems added
that totally get the namespace handling wrong because it is easy and
apparently socially acceptable to mess up other peoples hard work.

Apparently even Linus yelling at people a few years back wasn't enough
for people to wake up and be responsible developers and use proper
abstractions.  So the only valid long term direction I can see is to
remove all of the abstractions that make getting pid handling wrong,
and to fix all of the code that gets it wrong today.  So that there are
no more bad examples in the kernel.

This isn't Richard's fight, and this isn't what needs to happen with
audit.  Audit just needs to be fixed so that so that it reports pid
numbers the audit daemon can make sense of, and to do that the audit
should use helper functions that are pid namespace aware and make it
clear that the proper pid namespace is being used.

In the long term ->pid and ->tgid must die, and take all of this wrong
think with it.

Eric

