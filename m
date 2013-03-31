Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab3CaRLA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 13:11:00 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:64480 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab3CaRK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 13:10:59 -0400
MIME-Version: 1.0
In-Reply-To: <51583E01.5030106@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	<20130321141058.76e028e492f98f6ee6e60353@linux-foundation.org>
	<20130326192852.GA25899@redhat.com>
	<20130326124309.077e21a9f59aaa3f3355e09b@linux-foundation.org>
	<20130329161746.GA8391@redhat.com>
	<CA+55aFyKhgwYUMGs8MBLY5WDXhHwXP3dLWs40ayCYfgiwwncsQ@mail.gmail.com>
	<CA+55aFyT6jxC=+jfORJkymo4Eagzpz-SajmnCO_PjGAPE6o25A@mail.gmail.com>
	<CA+55aFygTH-tqhL1=FY32+HkjfqqpkX-nvb1c5f3V6S-iykS8A@mail.gmail.com>
	<CA+i8gK+NTCK6OUzobvxPj+UaCO-iit-ww9VGNzmdqDfRC_+SuA@mail.gmail.com>
	<1364609309.1818.8.camel@buesod1.americas.hpqcorp.net>
	<CA+i8gK+LP_4SU8GwLMau0QvyGswZ5sKqOYnJVPZNWXZY_W9dEA@mail.gmail.com>
	<CA+55aFzqzHa_6bHrqaa+6k3PZiibuJuDd1VwVD7jL047BjR=hA@mail.gmail.com>
	<CA+i8gKL3PCBW_KxkYSOKE7-PHdHVsP6eLUBTuYRtunBheALJMg@mail.gmail.com>
	<1364706119.6239.6.camel@buesod1.americas.hpqcorp.net>
	<51583E01.5030106@surriel.com>
Date: Sun, 31 Mar 2013 10:10:58 -0700
X-Google-Sender-Auth: 90P45DG9M1M3Prq0ZfwHCsUT-Xo
Message-ID: <CA+55aFwhDUr_NUFGa2QV3_VyqqN4dQDn9S_iOHf+AzD5ApBsAQ@mail.gmail.com>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@surriel.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Emmanuel Benisty <benisty.e@gmail.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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

On Sun, Mar 31, 2013 at 6:45 AM, Rik van Riel <riel@surriel.com> wrote:
>
> Should we use "semid" here, like Linus suggested, instead of "un->semid"?

As Davidlohr noted, in linux-next the rcu read-lock is held over the
whole thing, so no, un->semid should be stable once "un" has been
re-looked-up under the semaphore lock.

In mainline, the problem is that the "sem_lock_check()" is done with
"un->semid" *after* we've dropped the RCU read-lock, so "un" at that
point is not reliable (it could be free'd at any time underneath us).

That said, I really *really* hate what both mainline and linux-next do
with the RCU read lock, and linux-next is arguably worse.

The whole "take the RCU lock in one place, and release it in another"
is confusing and bug-prone as hell. And linux-next made it worse: now
sem_lock() no longer takes the read-lock (it expects the caller to
take it), but sem_unlock() still drops the read-lock. This is all just
f*cking crazy.

The rule should be that the rcu read-lock is always and released at
the same "level". For example, find_alloc_undo() should just be called
with (and unconditionaly return with) the rcu read-lock held, and if
it needs to actually do an allocation, it can drop the rcu lock for
the duration of the allocation.

This whole "conditional locking" depending on error returns and on
whether we have undo's etc is bug-prone and confusing. And when you
have totally different locking rules for "sem_lock()" vs
"sem_unlock()", you know you're confused.

                        Linus
