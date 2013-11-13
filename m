Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275Ab3KMQrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:47:05 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:44327 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757430Ab3KMQq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:46:56 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1311121829220.29891@chino.kir.corp.google.com>
References: <CANMivWZFXYGB_95WqToKEUyMsKMS2nQ4p5a_-Lte-=bhCC5u2g@mail.gmail.com>
 <1384287812-3694-1-git-send-email-snanda@chromium.org> <alpine.DEB.2.02.1311121829220.29891@chino.kir.corp.google.com>
From: Sameer Nanda <snanda@chromium.org>
Date: Wed, 13 Nov 2013 08:46:35 -0800
X-Google-Sender-Auth: Zdn6poLno9oufbWvS3h5anEnmvo
Message-ID: <CANMivWaXE=bn4fhvGdz3cPwN+CZpWwrWqmU1BKX8o+vE2JawOw@mail.gmail.com>
Subject: Re: [PATCH v5] mm, oom: Fix race when selecting process to kill
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mhocko@suse.cz,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Luigi Semenzato <semenzato@google.com>,
        Vladimir Murzin <murzin.v@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Sergey Dyasly <dserrg@gmail.com>,
        "msb@chromium.org" <msb@chromium.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 6:33 PM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 12 Nov 2013, Sameer Nanda wrote:
>
>> The selection of the process to be killed happens in two spots:
>> first in select_bad_process and then a further refinement by
>> looking for child processes in oom_kill_process. Since this is
>> a two step process, it is possible that the process selected by
>> select_bad_process may get a SIGKILL just before oom_kill_process
>> executes. If this were to happen, __unhash_process deletes this
>> process from the thread_group list. This results in oom_kill_process
>> getting stuck in an infinite loop when traversing the thread_group
>> list of the selected process.
>>
>> Fix this race by adding a pid_alive check for the selected process
>> with tasklist_lock held in oom_kill_process.
>>
>> Change-Id: I62f9652a780863467a8174e18ea5e19bbcd78c31
>
> Is this needed?

No, it's not.  It's a side effect of using Chrome OS tools to manage
the patches.  I will make sure to remove it on the next version of the
patch.

>
>> Signed-off-by: Sameer Nanda <snanda@chromium.org>
>> ---
>>  mm/oom_kill.c | 42 +++++++++++++++++++++++++++++-------------
>>  1 file changed, 29 insertions(+), 13 deletions(-)
>>
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 6738c47..5108c2b 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -412,31 +412,40 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>>       static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
>>                                             DEFAULT_RATELIMIT_BURST);
>>
>> +     if (__ratelimit(&oom_rs))
>> +             dump_header(p, gfp_mask, order, memcg, nodemask);
>> +
>> +     task_lock(p);
>> +     pr_err("%s: Kill process %d (%s) score %d or sacrifice child\n",
>> +             message, task_pid_nr(p), p->comm, points);
>> +     task_unlock(p);
>> +
>> +     /*
>> +      * while_each_thread is currently not RCU safe. Lets hold the
>> +      * tasklist_lock across all invocations of while_each_thread (including
>> +      * the one in find_lock_task_mm) in this function.
>> +      */
>> +     read_lock(&tasklist_lock);
>> +
>>       /*
>>        * If the task is already exiting, don't alarm the sysadmin or kill
>>        * its children or threads, just set TIF_MEMDIE so it can die quickly
>>        */
>> -     if (p->flags & PF_EXITING) {
>> +     if (p->flags & PF_EXITING || !pid_alive(p)) {
>> +             pr_info("%s: Not killing process %d, just setting TIF_MEMDIE\n",
>> +                     message, task_pid_nr(p));
>
> That makes no sense in the kernel log to have
>
>         Out of Memory: Kill process 1234 (comm) score 50 or sacrifice child
>         Out of Memory: Not killing process 1234, just setting TIF_MEMDIE
>
> Those are contradictory statements (and will actually mess with kernel log
> parsing at Google) and nobody other than kernel developers are going to
> know what TIF_MEMDIE is.

Since the "Kill process" printk has now moved above the (p->flags &
PF_EXITING || !pid_alive(p)) check, it is possible that
oom_kill_process will emit the "Kill process" message but will not
actually try to kill the process or its child.  The new "Not killing
process" printk helps disambiguate this case from when a process is
actually killed by oom_kill_process.  However, since you are finding
it confusing, let me remove it.

>
>>               set_tsk_thread_flag(p, TIF_MEMDIE);
>>               put_task_struct(p);
>> +             read_unlock(&tasklist_lock);
>>               return;
>>       }
>>
>> -     if (__ratelimit(&oom_rs))
>> -             dump_header(p, gfp_mask, order, memcg, nodemask);
>> -
>> -     task_lock(p);
>> -     pr_err("%s: Kill process %d (%s) score %d or sacrifice child\n",
>> -             message, task_pid_nr(p), p->comm, points);
>> -     task_unlock(p);
>> -
>>       /*
>>        * If any of p's children has a different mm and is eligible for kill,
>>        * the one with the highest oom_badness() score is sacrificed for its
>>        * parent.  This attempts to lose the minimal amount of work done while
>>        * still freeing memory.
>>        */
>> -     read_lock(&tasklist_lock);
>>       do {
>>               list_for_each_entry(child, &t->children, sibling) {
>>                       unsigned int child_points;
>> @@ -456,12 +465,17 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>>                       }
>>               }
>>       } while_each_thread(p, t);
>> -     read_unlock(&tasklist_lock);
>>
>> -     rcu_read_lock();
>>       p = find_lock_task_mm(victim);
>> +
>> +     /*
>> +      * Since while_each_thread is currently not RCU safe, this unlock of
>> +      * tasklist_lock may need to be moved further down if any additional
>> +      * while_each_thread loops get added to this function.
>> +      */
>
> This comment should be moved to sched.h to indicate how
> while_each_thread() needs to be handled with respect to tasklist_lock,
> it's not specific to the oom killer.

OK.
>
>> +     read_unlock(&tasklist_lock);
>> +
>>       if (!p) {
>> -             rcu_read_unlock();
>>               put_task_struct(victim);
>>               return;
>>       } else if (victim != p) {
>> @@ -478,6 +492,8 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>>               K(get_mm_counter(victim->mm, MM_FILEPAGES)));
>>       task_unlock(victim);
>>
>> +     rcu_read_lock();
>> +
>>       /*
>>        * Kill all user processes sharing victim->mm in other thread groups, if
>>        * any.  They don't get access to memory reserves, though, to avoid
>
> Please move this rcu_read_lock() to be immediatley before the
> for_each_process() instead of before the comment.

OK.



-- 
Sameer
