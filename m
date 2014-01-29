Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaA2Kri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 05:47:38 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:45715 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaA2Krf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:47:35 -0500
MIME-Version: 1.0
In-Reply-To: <20140121101407.GD30706@mudshark.cambridge.arm.com>
References: <CAJ8eaTzT4Os5RjtTu5gWpA=t-8Gg9rwmthEHVUOf+3+XhRpu6Q@mail.gmail.com>
	<20140120102051.GB16496@mudshark.cambridge.arm.com>
	<CAJ8eaTwH3kov0Bo_sCDvgxzQWtRB2tKit=_rKFBhQ6jBZcND-A@mail.gmail.com>
	<20140121101407.GD30706@mudshark.cambridge.arm.com>
Date: Wed, 29 Jan 2014 16:17:35 +0530
Message-ID: <CAJ8eaTwa28M4sdSaH02kfw8Ey9cidxowu4H=zkWgDy0c7oSWUg@mail.gmail.com>
Subject: Re: BUG: spinlock lockup
From: naveen yadav <yad.naveen@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Will,


Thanks for your input. We debug by adding print as below and found
very big value difference between next and owner(more then 1000). So
it seams memory corruption.



linux/lib/spinlock_debug.c

 		msg, raw_smp_processor_id(),
 		current->comm, task_pid_nr(current));
 	printk(KERN_EMERG " lock: %pS, .magic: %08x, .owner: %s/%d, "
-			".owner_cpu: %d\n",
+		".owner_cpu: %d raw_lock.tickets.next %u raw_lock.tickets.owner %u \n",
 		lock, lock->magic,
 		owner ? owner->comm : "<none>",
 		owner ? task_pid_nr(owner) : -1,
-		lock->owner_cpu);
+		lock->owner_cpu,
+		lock->raw_lock.tickets.next,
+		lock->raw_lock.tickets.owner);
 	dump_stack();
 }


I have one request, is it possible to change like below, if any
corruption, it is easy to debug .
if magic is corrupt, we can find quickly.

typedef struct raw_spinlock {

#ifdef CONFIG_DEBUG_SPINLOCK
        unsigned int magic, owner_cpu;
        void *owner;
#endif

        arch_spinlock_t raw_lock;
#ifdef CONFIG_GENERIC_LOCKBREAK
        unsigned int break_lock;
#endif
#ifdef CONFIG_DEBUG_LOCK_ALLOC
        struct lockdep_map dep_map;
#endif
} raw_spinlock_t;

So if this structure got corrupt,
On Tue, Jan 21, 2014 at 3:44 PM, Will Deacon <will.deacon@arm.com> wrote:
> On Tue, Jan 21, 2014 at 06:37:31AM +0000, naveen yadav wrote:
>> Thanks for your reply,
>>
>> We are using Cortex A15.
>> yes,  this is with ticket lock.
>>
>> We will check value of arch_spinlock_t and share it. It is bit
>> difficult to reproduce this scenario.
>>
>> If you have some idea ,please suggest how to reproduce it.
>
> You could try enabling lockdep and see if it catches anything earlier
> on.
>
> Will
