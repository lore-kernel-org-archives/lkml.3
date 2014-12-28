Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaL1OvG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 09:51:06 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:63178 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbaL1OvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 09:51:03 -0500
MIME-Version: 1.0
In-Reply-To: <549EDF47.6050903@gmail.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-16-git-send-email-namhyung@kernel.org> <549EDF47.6050903@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Sun, 28 Dec 2014 23:50:42 +0900
X-Google-Sender-Auth: 0XXEmp40D4b8Aiv2tQe_SxqBh0w
Message-ID: <CAM9d7chrHpOs-zN0o4WH=L=h8RPQEKa9dQFvGebRaUQFLNfNmA@mail.gmail.com>
Subject: Re: [PATCH 15/37] perf tools: Introduce machine__find*_thread_time()
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2014 at 1:33 AM, David Ahern <dsahern@gmail.com> wrote:
> On 12/24/14 12:15 AM, Namhyung Kim wrote:
>>
>> @@ -61,12 +61,12 @@ static int unwind_entry(struct unwind_entry *entry,
>> void *arg)
>>   __attribute__ ((noinline))
>>   static int unwind_thread(struct thread *thread)
>>   {
>> -       struct perf_sample sample;
>> +       struct perf_sample sample = {
>> +               .time = -1ULL,
>> +       };
>
>
> 1-liner like the others?

Did you mean this?

        struct perf_sample sample = { .time = -1ULL, };

>
>
>
>> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
>> index 582e011adc92..2cc088d71922 100644
>> --- a/tools/perf/util/machine.c
>> +++ b/tools/perf/util/machine.c
>> @@ -431,6 +431,103 @@ struct thread *machine__find_thread(struct machine
>> *machine, pid_t pid,
>>         return __machine__findnew_thread(machine, pid, tid, false);
>>   }
>>
>> +static void machine__remove_thread(struct machine *machine, struct thread
>> *th);
>
>
> Why is this declaration needed?

It seems like a leftover from previous changes, will remove.


>
>> +
>> +static struct thread *__machine__findnew_thread_time(struct machine
>> *machine,
>> +                                                    pid_t pid, pid_t tid,
>> +                                                    u64 timestamp, bool
>> create)
>> +{
>> +       struct thread *curr, *pos, *new;
>> +       struct thread *th = NULL;
>> +       struct rb_node **p;
>> +       struct rb_node *parent = NULL;
>> +       bool initial = timestamp == (u64)0;
>> +
>> +       curr = __machine__findnew_thread(machine, pid, tid, initial);
>
>
> What if create arg is false? Should initial arg also be false?

Nop, the create arg adds the thread to the dead thread tree (or
missing thread tree later).  And the initial flag adds it to the
normal threads tree like in case of synthesized events.  This was
because I firstly used the *_findnew_thread_time() for the meta event
processing, but then I realized that using *_findnew_thread() makes
the processing much easier since the meta events are processed
sequencially.  And this *_findnew_thread_time() is used only for
sample processing.  Maybe we can use 'false' instead of the
'initial'..


>
>> +       if (curr && timestamp >= curr->start_time)
>> +               return curr;
>> +
>> +       p = &machine->dead_threads.rb_node;
>> +       while (*p != NULL) {
>> +               parent = *p;
>> +               th = rb_entry(parent, struct thread, rb_node);
>> +
>> +               if (th->tid == tid) {
>> +                       list_for_each_entry(pos, &th->node, node) {
>> +                               if (timestamp >= pos->start_time &&
>> +                                   pos->start_time > th->start_time) {
>> +                                       th = pos;
>> +                                       break;
>> +                               }
>> +                       }
>> +
>> +                       if (timestamp >= th->start_time) {
>> +                               machine__update_thread_pid(machine, th,
>> pid);
>> +                               return th;
>> +                       }
>> +                       break;
>> +               }
>> +
>> +               if (tid < th->tid)
>> +                       p = &(*p)->rb_left;
>> +               else
>> +                       p = &(*p)->rb_right;
>> +       }
>
>
> Can the dead_threads search be put in a separate function --
> machine__find_dead_thread?

Okay, I can do it.


>
>> +
>> +       if (!create)
>> +               return NULL;
>> +
>> +       if (!curr)
>> +               return __machine__findnew_thread(machine, pid, tid, true);
>> +
>> +       new = thread__new(pid, tid);
>> +       if (new == NULL)
>> +               return NULL;
>> +
>> +       new->start_time = timestamp;
>> +
>> +       if (*p) {
>> +               list_for_each_entry(pos, &th->node, node) {
>> +                       /* sort by time */
>> +                       if (timestamp >= pos->start_time) {
>> +                               th = pos;
>> +                               break;
>> +                       }
>> +               }
>> +               list_add_tail(&new->node, &th->node);
>> +       } else {
>> +               rb_link_node(&new->rb_node, parent, p);
>> +               rb_insert_color(&new->rb_node, &machine->dead_threads);
>> +       }
>
>
> Why insert this unknown tid on the dead_threads list?

Well, mostly the search will be succeeded, and if it failed it's
either newly created thread so curr = NULL and adds it to the normal
tree.  Otherwise (rarely) there might be a missing fork event and the
sample is for an older thread in that any timestamp didn't match to
existing (current and dead) threads.  So I added it to the dead thread
tree.  But with multi-thread support enabled, it'll be added to the
new missing threads tree which is protected by a mutex.


>
>> +
>> +       /*
>> +        * We have to initialize map_groups separately
>> +        * after rb tree is updated.
>> +        *
>> +        * The reason is that we call machine__findnew_thread
>> +        * within thread__init_map_groups to find the thread
>> +        * leader and that would screwed the rb tree.
>> +        */
>> +       if (thread__init_map_groups(new, machine)) {
>> +               thread__delete(new);
>> +               return NULL;
>> +       }
>> +
>> +       return new;
>> +}
>
>
> ---8<---
>
>> @@ -1265,6 +1362,16 @@ static void machine__remove_thread(struct machine
>> *machine, struct thread *th)
>>                 pos = rb_entry(parent, struct thread, rb_node);
>>
>>                 if (pos->tid == th->tid) {
>> +                       struct thread *old;
>> +
>> +                       /* sort by time */
>> +                       list_for_each_entry(old, &pos->node, node) {
>> +                               if (th->start_time >= old->start_time) {
>> +                                       pos = old;
>> +                                       break;
>> +                               }
>> +                       }
>> +
>
>
> this change seems unrelated to the patch subject --
> machine__find*_thread_time.

It searchs a thread in the dead threads tree based on timestamp value.
So the list should be sorted by time order.  But yes, I agree that
this change should be moved to the dead thread conversion patch.

Thanks,
Namhyung
