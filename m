Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3KFQ7J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:59:09 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40151 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3KFQ7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:59:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAA25o9Q-HvjQ_5pFJgYNeutaCoYgPu=e=k7EHq=6-+jeEuhzoA@mail.gmail.com>
References: <1383693987-14171-1-git-send-email-snanda@chromium.org>
 <alpine.DEB.2.02.1311051715090.29471@chino.kir.corp.google.com>
 <CAA25o9SFZW7JxDQGv+h43EMSS3xH0eXy=LoHO_Psmk_n3dxqoA@mail.gmail.com>
 <alpine.DEB.2.02.1311051727090.29471@chino.kir.corp.google.com>
 <CANMivWZrefY1bbgpJgABqcUwKfqOR9HQtGNY6cWdutcMASeo2A@mail.gmail.com>
 <CAA25o9QG2BOmV5MoXCH73sadKoRD6wPivKq6TLvEem8GhZeXGg@mail.gmail.com> <CAA25o9Q-HvjQ_5pFJgYNeutaCoYgPu=e=k7EHq=6-+jeEuhzoA@mail.gmail.com>
From: Sameer Nanda <snanda@chromium.org>
Date: Wed, 6 Nov 2013 08:58:44 -0800
X-Google-Sender-Auth: MLyGlEReOb4EcPGoPsAeWZCwcCM
Message-ID: <CANMivWZhNRGW6DPcqpYiUBjOX23LRZ_kJ9DzzfS7VdRpm075ZA@mail.gmail.com>
Subject: Re: [PATCH] mm, oom: Fix race when selecting process to kill
To: Luigi Semenzato <semenzato@google.com>
Cc: msb@facebook.com, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, mhocko@suse.cz,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding back context from thread history)
On Tue, Nov 5, 2013 at 5:18 PM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 5 Nov 2013, Sameer Nanda wrote:
>
>> The selection of the process to be killed happens in two spots -- first
>> in select_bad_process and then a further refinement by looking for
>> child processes in oom_kill_process. Since this is a two step process,
>> it is possible that the process selected by select_bad_process may get a
>> SIGKILL just before oom_kill_process executes. If this were to happen,
>> __unhash_process deletes this process from the thread_group list. This
>> then results in oom_kill_process getting stuck in an infinite loop when
>> traversing the thread_group list of the selected process.
>>
>> Fix this race by holding the tasklist_lock across the calls to both
>> select_bad_process and oom_kill_process.
>>
>> Change-Id: I8f96b106b3257b5c103d6497bac7f04f4dff4e60
>> Signed-off-by: Sameer Nanda <snanda@chromium.org>
>
> Nack, we had to avoid taking tasklist_lock for this duration since it
> stalls out forks and exits on other cpus trying to take the writeside with
> irqs disabled to avoid watchdog problems.
>

David -- I think we can make the duration that the tasklist_lock is
held smaller by consolidating the process selection logic that is
currently split across select_bad_process and oom_kill_process into
one place in select_bad_process.  The tasklist_lock would then need to
be held only when the thread lists are being traversed.  Would you be
ok with that?  I can re-spin the patch if that sounds like a workable
option.

> What kernel version are you patching?  If you check the latest Linus tree,
> we hold a reference to the task_struct of the chosen process before
> calling oom_kill_process() so the hypothesis would seem incorrect.


On Tue, Nov 5, 2013 at 11:17 PM, Luigi Semenzato <semenzato@google.com> wrote:
> Regarding other fixes: would it be possible to have the thread
> iterator insert a dummy marker element in the thread list before the
> scan?  There would be one such dummy element per CPU, so that multiple
> CPUs can scan the list in parallel.  The loop would skip such
> elements, and each dummy element would be removed at the end of each
> scan.
>
> I think this would work, i.e. it would have all the right properties,
> but I don't have a sense of whether the performance impact is
> acceptable.  Probably not, or it would have been proposed earlier.
>
>
>
> On Tue, Nov 5, 2013 at 8:45 PM, Luigi Semenzato <semenzato@google.com> wrote:
>> It's interesting that this was known for 3+ years, but nobody bothered
>> adding a small warning to the code.
>>
>> We noticed this because it's actually happening on Chromebooks in the
>> field.  We try to minimize OOM kills, but we can deal with them.  Of
>> course, a hung kernel we cannot deal with.
>>
>> On Tue, Nov 5, 2013 at 7:04 PM, Sameer Nanda <snanda@chromium.org> wrote:
>>>
>>>
>>>
>>> On Tue, Nov 5, 2013 at 5:27 PM, David Rientjes <rientjes@google.com> wrote:
>>>>
>>>> On Tue, 5 Nov 2013, Luigi Semenzato wrote:
>>>>
>>>> > It's not enough to hold a reference to the task struct, because it can
>>>> > still be taken out of the circular list of threads.  The RCU
>>>> > assumptions don't hold in that case.
>>>> >
>>>>
>>>> Could you please post a proper bug report that isolates this at the cause?
>>>
>>>
>>> We've been running into this issue on Chrome OS. crbug.com/256326 has
>>> additional
>>> details.  The issue manifests itself as a soft lockup.
>>>
>>> The kernel we've been seeing this on is 3.8.
>>>
>>> We have a pretty consistent repro currently.  Happy to try out other
>>> suggestions
>>> for a fix.
>>>
>>>>
>>>>
>>>> Thanks.
>>>
>>>
>>>
>>>
>>> --
>>> Sameer



-- 
Sameer
