Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3H3FHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 01:07:20 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43668 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab3H3FHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 01:07:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
References: <20130829211114.GA20726@sergelap> <87mwo0xb9p.fsf@xmission.com>
	<20130830011058.GA12720@mail.hallyn.com>
Date: Thu, 29 Aug 2013 22:07:07 -0700
In-Reply-To: <20130830011058.GA12720@mail.hallyn.com> (Serge E. Hallyn's
	message of "Fri, 30 Aug 2013 01:10:58 +0000")
Message-ID: <87bo4fwyv8.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/nc3P6/Y/trvwZOthiOePeWmTwvtCwQE4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2971]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Make sure to wake reaper
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> Serge Hallyn <serge.hallyn@ubuntu.com> writes:
>> 
>> > Since commit af4b8a83add95ef40716401395b44a1b579965f4 it's been
>> > possible to get into a situation where a pidns reaper is
>> > <defunct>, reparented to host pid 1, but never reaped.  How to
>> > reproduce this is documented at
>> >
>> > https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/1168526
>> > (and see
>> > https://bugs.launchpad.net/ubuntu/+source/lxc/+bug/1168526/comments/13)
>> > In short, run repeated starts of a container whose init is
>> >
>> > Process.exit(0);
>> >
>> > sysrq-t when such a task is playing zombie shows:
>> >
>> > [  131.132978] init            x ffff88011fc14580     0  2084   2039 0x00000000
>> > [  131.132978]  ffff880116e89ea8 0000000000000002 ffff880116e89fd8 0000000000014580
>> > [  131.132978]  ffff880116e89fd8 0000000000014580 ffff8801172a0000 ffff8801172a0000
>> > [  131.132978]  ffff8801172a0630 ffff88011729fff0 ffff880116e14650 ffff88011729fff0
>> > [  131.132978] Call Trace:
>> > [  131.132978]  [<ffffffff816f6159>] schedule+0x29/0x70
>> > [  131.132978]  [<ffffffff81064591>] do_exit+0x6e1/0xa40
>> > [  131.132978]  [<ffffffff81071eae>] ? signal_wake_up_state+0x1e/0x30
>> > [  131.132978]  [<ffffffff8106496f>] do_group_exit+0x3f/0xa0
>> > [  131.132978]  [<ffffffff810649e4>] SyS_exit_group+0x14/0x20
>> > [  131.132978]  [<ffffffff8170102f>] tracesys+0xe1/0xe6
>> >
>> > Further debugging showed that every time this happened, zap_pid_ns_processes()
>> > started with nr_hashed being 3, while we were expecting it to drop to 2.
>> > Any time it didn't happen, nr_hashed was 1 or 2.  So the reaper was
>> > waiting for nr_hashed to become 2, but free_pid() only wakes the reaper
>> > if nr_hashed hits 1.  This patch makes free_pid() wake the reaper any
>> > time the reaper is PF_EXITING, to force it to re-test the
>> > pidns->nr_hashed = init_pids test.  Note that this is more like what
>> > __unhash_process() used to do before
>> > af4b8a83add95ef40716401395b44a1b579965f4.
>> >
>> > Signed-off-by: Serge Hallyn <serge.hallyn@ubuntu.com>
>> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>> > ---
>> >  kernel/pid.c | 4 ++++
>> >  1 file changed, 4 insertions(+)
>> >
>> > diff --git a/kernel/pid.c b/kernel/pid.c
>> > index 0db3e79..6b312c4 100644
>> > --- a/kernel/pid.c
>> > +++ b/kernel/pid.c
>> > @@ -274,6 +274,10 @@ void free_pid(struct pid *pid)
>> >  		case 0:
>> >  			schedule_work(&ns->proc_work);
>> >  			break;
>> > +		default:
>> > +			if (ns->child_reaper->flags & PF_EXITING)
>> > +				wake_up_process(ns->child_reaper);
>> > +			break;
>> >  		}
>> >  	}
>> >  	spin_unlock_irqrestore(&pidmap_lock, flags);
>> 
>> qSo I think the change that we actually want is just to send a wake-up
>> when we have two pids in the pid namespace as well as one pid.
>> 
>> - That can send one extraneous wake-up but that is relatively harmless.
>
> Would more than one extraneous wake-up be more harmful?

An extraneous wake-up is a waste of time but not a correctness issue.
Anything that sleeps needs to be able to handle extraneous wake-ups.

>> - We can detect the condition race free.
>> - With only two pids remaining we are guaranteed that which ever task is
>>   the child_reaper will persist through zap_pid_ns_processes.
>
> My problem is I don't really understand the assumptions behind nr_hashed.
> I *thought* it was simply >1 if the init was threaded - but are threads
> in init limited to 2?  Or am I totally wrong about what the 2 means?

nr_hashed if fundamentally the number of pids in the pid hash table of a
pid namespace.  So if init has 2 thread ids nr_hashed is greather than one.

> If init *is* threaded, and the pid_ns->child_reaper exits but the other
> thread is still alive, then find_new_reaper should set pid_ns->child_reaper
> to the not-PF_EXITING task using
>
>     509         while_each_thread(father, thread) {
>     510                 if (thread->flags & PF_EXITING)
>     511                         continue;
>     512                 if (unlikely(pid_ns->child_reaper == father))
>     513                         pid_ns->child_reaper = thread;
>     514                 return thread;
>     515         }
>
> right?

Yes.

> Which seems to suggest that checking for pid_ns->child_reaper->flags &
> PF_EXITING should always give us the right answer in free_pid().

I don't know that it is wrong, but we don't always have the task_lock
which protects PF_EXITING.  In particular when we are called from
change_pid.

Even more the task_lock protects pid_ns->child_reaper.

The thread_group_leader of any process may not be reaped until all of
the other threads are dead.  All of the other threads of a
multi-threaded process self reap when they exit.

Which means before we are reduced to nr_threads == 2 it is possible
that child_reaper will be a thread that will self reap and free it's
data structures before we are done waking it up and/or testing
PF_EXITING.

>>   There are 3 cases.
>>   init-tgleader other -- Single threaded init so of course we won't free the task
>>   init-tgleader-dead init-thread -- The last living init thread will call zap_pid_ns_processes.
>
> right,
>
>>   init-tgleader init-thread -- An init with two living threads child_reaper must be the init thread group leader
>> 
>> Which means at the cost of an extra wake-up we are guaranteed not to
>> have races.
>> 
>> Serge does that look good to you?
>
> I may just need to spend a few hours going back over the old commits
> and related email threads pertaining to multi-threaded inits.  I now
> regret not having paid enough attention at the time :)

Multi-threaded inits are indeed strange, and de_thread in fs/exec.c
that implements the rule that after exec the thread group id and
the thread id are always the same is the most annoying of the bunch.
If we did not have that guarantee we could remove a lot of the special
cases.  Sigh.

>> diff --git a/kernel/pid.c b/kernel/pid.c
>> index 17755ae..ab75add 100644
>> --- a/kernel/pid.c
>> +++ b/kernel/pid.c
>> @@ -265,6 +265,7 @@ void free_pid(struct pid *pid)
>>                 struct pid_namespace *ns = upid->ns;
>>                 hlist_del_rcu(&upid->pid_chain);
>>                 switch(--ns->nr_hashed) {
>> +               case 2:
>>                 case 1:
>>                         /* When all that is left in the pid namespace
>>                          * is the reaper wake up the reaper.  The reaper
>
> I considered this, but I wasn't quite sure...  I have two concersn about
> the 2.  First, why can't it be 3 (3 PF_EXITING init-threads).

You can have 3 PF_EXITING init threads, but at least one of them will
self reap and then you will have only two.

> Second, what if nr_hashed is 2 but init in fact wasn't exiting?  Oh, that's
> the one you're saying isn't an issue, just a spurious extra wakeup?
> Right.

Yes.  In fact that will be the common case where we send the spurious
extra wakeup.

My primary concern with the analsysis was to guarantee that child_reaper
is guaranteed to point to a valid process with only the pidmap_lock's
protection.  With nr_hashed == 3 I can't see a way to guarantee that as
the thread group leader may be dead, and the current init thread may be
exiting, and a third init thread may be the thread that calls
zap_pid_ns_processes.

And that weird case is what makes me nervous about testing PF_EXITING.
What if the child_reaper is freed while we are testing the bits.

Eric

