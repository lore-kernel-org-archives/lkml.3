Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaINSfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 14:35:47 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:60848 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbaINSfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 14:35:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140914140639.GO5387@tassilo.jf.intel.com>
References: <20140913143534.16912.9015.stgit@zurg> <20140914140639.GO5387@tassilo.jf.intel.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sun, 14 Sep 2014 11:35:25 -0700
Message-ID: <CACT4Y+aJomhGe5qbffVCj43UroinYDGcQFKeAd7RMNv=cVX=cw@mail.gmail.com>
Subject: Re: [PATCH RFC] x86_64: per-cpu memory for user-space
To: Andi Kleen <ak@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        Andrew Hunter <ahh@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 7:06 AM, Andi Kleen <ak@linux.intel.com> wrote:
> On Sat, Sep 13, 2014 at 06:35:34PM +0400, Konstantin Khlebnikov wrote:
>> This patch implements user-space per-cpu memory in the same manner as in
>> kernel-space: each cpu has its own %gs base address. On x86_64 %fs is used
>> for thread local storage, %gs usually is free.
>>
>> User-space application cannot prevent preemption but x86 read-modify-write
>> operations are atomic against interrupts and context switches. Thus percpu
>> counters, ring-buffer cursors, per-cpu locks and other cool things might
>> be implemented in a very efficient way.
>
> Do you have some concrete examples for the more complex operations?


Hi Andy,

I've showed how to implement a per-cpu freelist in a previous email.

Here is how you can do a per-cpu logging system, multiple threads
enqueue messages, a single thread polls all per-cpu queues (not tested
as well):


struct elem_t
{
        uint32  lap;
        T       data;
};

struct percpu_queue_t
{
        uint64  enqueue_pos_cpu;
        uint32  dequeue_pos;
        elem_t  buf[N];
};

bool percpu_queue_enqueue(T *data)
{
        percpu_queue_t *q;
        uint32 enqueue_pos;
        elem_t *e;
        uint64 old;

        for (;;) {
                q = (percpu_queue_t*)&GS[OFF];
                old = atomic_load(&q->enqueue_pos_cpu, memory_order_relaxed);
                enqueue_pos = (uint32)(old >> 32);
                if (enqueue_pos - atomic32_load(&q->dequeue_pos,
memory_order_acquire) >= N)
                        return false;  // full
                if (CMPXCHG16B(&GS[OFF], old, old+1))  // w/o LOCK prefix
                        return p;
                e = &q->buf[enqueue_pos%N];
                e->data = *data;
                atomic_store(&e->lap, enqueue_pos/N + 1, memory_order_release);
                return true;
        }
}

bool percpu_queue_dequeue(percpu_queue_t *q, T *data)
{
        elem_t *e;
        uint32 dequeue_pos;

        dequeue_pos = q->dequeue_pos;
        e = q->buf[dequeue_pos%N];
        if (atomic_load(&e->lap, memory_order_acquire) != dequeue_pos/N+1)
                return false;  // empty
        *data = e->data;
        atomic_store(&q->dequeue_pos, dequeue_pos+1, memory_order_release);
        return true;
}


This is a simple version. It can be modified to do variable-size
messages, batch updates of dequeue_pos to reduce write sharing, or
split both enqueue and dequeue in prepare and commit phases to do
zero-copy communication.

So, generally, if you can reduce per-cpu state modification to a
single CAS, then you pair the data with cpu number and include it into
CAS. This allows you do CAS loop on per-cpu state w/o LOCK prefix.

And in the freelist code, the line:
                if (CMPXCHG16B(fl, old, new))
needs to be replaced with (we want to ensure that we are still on the same cpu):
               if (CMPXCHG16B(&GS[OFF], old, new))


For more complex data structures (e.g. doubly-linked list), I
*suspect* that it's possible to do something like transaction
journalling approach. Namely, there is a single per-cpu slot for
current transaction. If it's empty, then a thread installs own
transaction descriptor with a CAS w/o lock prefix; executes it and
uninstalls the trx descriptor. If it's not empty, then a thread first
helps to execute the pending transaction and uninstalls the trx
descriptor. All mutations in transactions are done with CAS w/o lock
prefix (both when executed by the issuing thread and during helping).
Care must be taken to ensure that threads do not operate on stale data
and on wrong cpu; probably all data slots must be accompanied by aba
counter and/or cpu number.
I've done this in the context of robust shared memory data structures.
I have not worked out all the details for per-cpu data structures, but
I think that it can work.



> It seems to me the limitation to a simple instruction will be very limiting
> for anything more complicated than a counter. Also it's not even
> clear how someone would implement retry (short of something like kuchannel)

What is retry/kuchannel?


> Of course it wouldn't be a problem with TSX transactions, but it's not
> clear they need it.

As far as I know (had not have a change to try), commit of a TSX
transaction includes a trailing store-load style fence. And the whole
point of this change is to eliminate the cost of the store-load fence.
Otherwise, you just query any approximation of the current cpu and do
either TSX or LOCK-prefixed RWM on the current cpu state.


> The other problem with the approach is, how would cpu hotplug
> be handled?
>
>> By the way, newer Intel cpus have even faster instructions for
>> changing %fs/%gs, but they are still not supported by the kernel.
>
> Patch kits are pending.
>
> -Andi
