Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab3C3CJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 22:09:23 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:43707 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381Ab3C3CJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 22:09:22 -0400
MIME-Version: 1.0
In-Reply-To: <CA+i8gK+NTCK6OUzobvxPj+UaCO-iit-ww9VGNzmdqDfRC_+SuA@mail.gmail.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>
	<CA+55aFyT6jxC=+jfORJkymo4Eagzpz-SajmnCO_PjGAPE6o25A@mail.gmail.com>
	<CA+55aFygTH-tqhL1=FY32+HkjfqqpkX-nvb1c5f3V6S-iykS8A@mail.gmail.com>
	<CA+i8gK+NTCK6OUzobvxPj+UaCO-iit-ww9VGNzmdqDfRC_+SuA@mail.gmail.com>
Date: Fri, 29 Mar 2013 19:09:21 -0700
X-Google-Sender-Auth: Tvbn06eEGdE_wtmi75bq62o-AIA
Message-ID: <CA+55aFyksNnZJTL2WSV87s2CUBXouF9KVxDddYp9r1radBfFAA@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        hhuang@redhat.com, "Low, Jason" <jason.low2@hp.com>,
        Michel Lespinasse <walken@google.com>,
        Larry Woodman <lwoodman@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 6:36 PM, Emmanuel Benisty <benisty.e@gmail.com> wrote:
>
> I had to slightly modify the patch since it wouldn't match the changes
> introduced by 7-7-ipc-sem-fine-grained-locking-for-semtimedop.patch,
> hope that was the right thing to do. So, what I tried was: original 7
> patches + the one liner + your patch blindly modified by me on the top
> of 3.9-rc4 and I'm still having twilight zone issues.

Ok, please send your patch so that I can double-check what you did,
but it was simple enough that you probably did the right thing.

Sad. Your case definitely looks like a double rcu-free, as shown by
the fact that when you enabled SLUB debugging the oops happened with
the use-after-free pattern (it's __rcu_reclaim() doing the
"head->func(head);" thing, and "func" is 0x6b6b6b6b6b6b6b6b, so "head"
has already been free'd once).

So ipc_rcu_putref() and a refcounting error looked very promising.as a
potential explanation.

The 'un' undo structure is also free'd with rcu, but the locking
around that seems much more robust. The undo entry is on two lists
(sma->list_id, under sma->sem_perm.lock and ulp->list_proc, under
ulp->lock). But those locks are actually tested with
assert_spin_locked() in all the relevant places, and the code actually
looks sane. So I had high hopes for ipc_rcu_putref()...

Hmm. Except for exit_sem() that does odd things. You have preemption
enabled, don't you? exit_sem() does a lookup of the first list_proc
entry under tcy_read_lock to lookup un->semid, and then it drops the
rcu read lock. At which point "un" is no longer reliable, I think. But
then it still uses "un->semid", rather than the stable value it looked
up under the rcu read lock. Which looks bogus.

So I'd like you to test a few more things:

 (a) In exit_sem(), can you change the

         sma = sem_lock_check(tsk->nsproxy->ipc_ns, un->semid);

     to use just "semid" rather than "un->semid", because I don't
think "un" is stable here.

 (b) does the problem go away if you change disable CONFIG_PREEMPT
(perhaps to PREEMPT_NONE or PREEMPT_VOLUNTARY?)

             Linus
