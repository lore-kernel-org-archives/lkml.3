Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3I3QNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:13:54 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:32972 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab3I3QNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:13:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130930104408.GW3081@twins.programming.kicks-ass.net>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	<CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	<20130928074144.GA17773@gmail.com>
	<CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
	<20130928192123.GA8228@gmail.com>
	<CA+55aFyZqV_wJTpd9OVw=kM157Q45byW2F3kjhr5ML5Npz84OA@mail.gmail.com>
	<20130930104408.GW3081@twins.programming.kicks-ass.net>
Date: Mon, 30 Sep 2013 09:13:52 -0700
X-Google-Sender-Auth: rJC9LSmhfgHzwB2mAU6gAJERGCM
Message-ID: <CA+55aFwTCCXaD4S4OPGmwf=fhOwWdxr8NU9uFvdf_nRx0Nk0_w@mail.gmail.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 3:44 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sat, Sep 28, 2013 at 12:33:36PM -0700, Linus Torvalds wrote:
>> The old rwlock's really have been a disappointment - they are slower
>> than spinlocks, and seldom/never end up scaling any better.  Their
>> main advantage was literally the irq behavior - allowing readers to
>> happen without the expense of worrying about irq's.
>
> So in part that is fundamental to the whole rw-spinlock concept.

No, I agree. But it's really just that our rwlock implementation isn't
very good. It's neither really high-performing nor fair, and the
premise of a rw-lock is that it should scale better than a spinlock.

And yes, under heavy reader activity *does* work out for that (ok, you
get cacheline bouncing, but at least you don't get the spinning when
you have tons of readers), the extreme unfairness towards writers
under heavy reader activity makes it often simply unacceptable.

So unlike a lot of other "let's try to make our locking fancy" that I
dislike because it tends to hide the fundamental problem of
contention, the rwlock patches make me go "those actually _fix_ a
fundamental problem".

                Linus
