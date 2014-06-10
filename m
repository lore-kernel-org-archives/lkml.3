Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaFJR44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:56:56 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56429 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaFJR4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:56:53 -0400
Message-ID: <539746E0.6020505@colorfullife.com>
Date: Tue, 10 Jun 2014 19:56:48 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        davidlohr.bueso@hp.com
Subject: Re: ipc/sem.c: change perform_atomic_semop parameters
References: <20140606235006.342B5660FCD@gitolite.kernel.org> <20140610141933.GA16263@redhat.com>
In-Reply-To: <20140610141933.GA16263@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 06/10/2014 04:19 PM, Dave Jones wrote:
> On Fri, Jun 06, 2014 at 11:50:06PM +0000, Linux Kernel wrote:
>   > Gitweb:     http://git.kernel.org/linus/;a=commit;h=d198cd6d6d02d0a335af2deacb60816ebb4719d1
>   > Commit:     d198cd6d6d02d0a335af2deacb60816ebb4719d1
>   > Parent:     2f2ed41dcaec34f2d6f224aa84efcc5a9dd8d5c3
>   > Refname:    refs/heads/next
>   > Author:     Manfred Spraul <manfred@colorfullife.com>
>   > AuthorDate: Fri Jun 6 14:37:49 2014 -0700
>   > Committer:  Linus Torvalds <torvalds@linux-foundation.org>
>   > CommitDate: Fri Jun 6 16:08:15 2014 -0700
>   >
>   >     ipc/sem.c: change perform_atomic_semop parameters
>   >
>   >     Right now, perform_atomic_semop gets the content of sem_queue as
>   >     individual fields.  Changes that, instead pass a pointer to sem_queue.
>   >
>   >     This is a preparation for the next patch: it uses sem_queue to store the
>   >     reason why a task must sleep.
>   >
>   >     Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
>   >     Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
>   >     Cc: Michael Kerrisk <mtk.manpages@gmail.com>
>   >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>   >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> After this patch, coverity started complaining about a potential deref
> after null check. (It may have been a problem before, but the code motion
> causes a new 'event')
>
>      	33. var_compare_op: Comparing un to null implies that un might be null.
> 1878        if (un && un->semid == -1)
> 1879                goto out_unlock_free;
> 1880
> 1881        queue.sops = sops;
> 1882        queue.nsops = nsops;
Correct, un can be NULL.

But only if sem_flg & SEM_UNDO is false for every operation:
from semtimedop():
>>                if (sop->sem_flg & SEM_UNDO)
>>                         undos = 1;
>> [...]
>>         if (undos) {
>>                 /* On success, find_alloc_undo takes the 
>> rcu_read_lock */
>>                 un = find_alloc_undo(ns, semid);
>>                 if (IS_ERR(un)) {
>>                         error = PTR_ERR(un);
>>                         goto out_free;
>>                 }
>>         } else {
>>                 un = NULL;
>>                 rcu_read_lock();
>>         }


>      	34. alias_transfer: Assigning: queue.undo = un.
> 1883        queue.undo = un;
> 1884        queue.pid = task_tgid_vnr(current);
> 1885        queue.alter = alter;
> 1886
Correct.
>      	
> CID 1222114 (#1 of 1): Dereference after null check (FORWARD_NULL)
> 35. var_deref_model: Passing &queue to perform_atomic_semop, which dereferences null queue.undo. [show details]
> 1887        error = perform_atomic_semop(sma, &queue);
Passing &queue to perform_atomic_semop (correct),
which dereferences null queue.undo: Incorrect. queue.undo is only 
dereferenced if sem_flg&SEM_UNDO is true.

Thus: As far as I can see it's a false alarm.

And - even more simply: queue.un=NULL is the common case.

--
     Manfred
