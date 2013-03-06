Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3CFW57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:57:59 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:61877 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab3CFW56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:57:58 -0500
MIME-Version: 1.0
In-Reply-To: <20130306171546.63471bc0@cuia.bos.redhat.com>
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>
	<20130306171546.63471bc0@cuia.bos.redhat.com>
Date: Wed, 6 Mar 2013 17:57:56 -0500
X-Google-Sender-Auth: jHU6YqkBhq8ZWL2Os4dHRikxvW8
Message-ID: <CA+55aFyivGLzW3hYKR7y_ATff49EOiBq4Tnyrv+WZRm4ks81vg@mail.gmail.com>
Subject: Re: [PATCH v2 7/4] ipc: fine grained locking for semtimedop
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 6, 2013 at 5:15 PM, Rik van Riel <riel@redhat.com> wrote:
>
> If the call is a semop manipulating just one semaphore in
> an array with multiple semaphores, the read/write lock for
> the semaphore array is taken in shared (read) mode, and the
> individual semaphore's lock is taken.

You know, we do something like this already elsewhere, and I think we
do it slightly better. See the mm_take_all_locks() logic in mm/mmap.c.

The optimal strategy if you have many items, and the *common* case is
that you need just one lock, is actually to only take that single lock
for the common case. No top-level lock at all.

Then, for the complex (but unlikely) case, you take a *separate*
top-level lock, and then you take the lower-level locks one by one,
while testing first if you already hold them (using a separate data
structure that is protected by the top-level lock).

This way, the common case only needs that single lock that protects
just that particular data structure.

That said, judging by your numbers, your read-write lock seems to work
fine too, even though I'd worry about cacheline ping-pong (but not
contention) on the readers. So it doesn't seem optimal, but it sure as
hell seems better than what we do now ;)

                Linus
