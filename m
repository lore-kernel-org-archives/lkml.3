Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab3CFXKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:10:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab3CFXKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:10:48 -0500
Message-ID: <5137CCB2.4050506@redhat.com>
Date: Wed, 06 Mar 2013 18:09:38 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, hhuang@redhat.com
Subject: Re: [PATCH v2 7/4] ipc: fine grained locking for semtimedop
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net> <20130306171546.63471bc0@cuia.bos.redhat.com> <CA+55aFyivGLzW3hYKR7y_ATff49EOiBq4Tnyrv+WZRm4ks81vg@mail.gmail.com>
In-Reply-To: <CA+55aFyivGLzW3hYKR7y_ATff49EOiBq4Tnyrv+WZRm4ks81vg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 05:57 PM, Linus Torvalds wrote:
> On Wed, Mar 6, 2013 at 5:15 PM, Rik van Riel <riel@redhat.com> wrote:
>>
>> If the call is a semop manipulating just one semaphore in
>> an array with multiple semaphores, the read/write lock for
>> the semaphore array is taken in shared (read) mode, and the
>> individual semaphore's lock is taken.
>
> You know, we do something like this already elsewhere, and I think we
> do it slightly better. See the mm_take_all_locks() logic in mm/mmap.c.

That would work. If we are about to do one of the uncommon operations,or 
sma->complex_count is set, we need to take the outer lock and all of the
inner locks.

The only complication would be interactions with the non-semaphore code
in ipc/util.c, which manipulates the kern_ipc_perm structures, which are
part of the sem_array structure.

> That said, judging by your numbers, your read-write lock seems to work
> fine too, even though I'd worry about cacheline ping-pong (but not
> contention) on the readers. So it doesn't seem optimal, but it sure as
> hell seems better than what we do now ;)

I can take a stab at implementing the take_all_locks approach tomorrow.

If things turn out to be easier than I fear, I will send an updated
patch.  If the resulting changes to the rest of ipc/ turn out to be
too ugly to live, the rwsem performance is likely to be good enough
for a while, and I'll just send an email without a patch :)
