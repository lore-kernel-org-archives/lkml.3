Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab3BCDWp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 22:22:45 -0500
Received: from mail-vb0-f47.google.com ([209.85.212.47]:45547 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3BCDWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 22:22:42 -0500
MIME-Version: 1.0
In-Reply-To: <20130102143950.26df393d.akpm@linux-foundation.org>
References: <1356922034-25165-1-git-send-email-walken@google.com>
	<20130102143950.26df393d.akpm@linux-foundation.org>
Date: Sat, 2 Feb 2013 19:22:40 -0800
Message-ID: <CANN689GNtPi5d6KoGZMGP72w_HGe2Eoq_WuBjZvkm3Cwga0Z2A@mail.gmail.com>
Subject: Re: [PATCH 0/2] extend synchro-test module to test spinlocks too
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 2:39 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 30 Dec 2012 18:47:12 -0800
> Michel Lespinasse <walken@google.com> wrote:
>
>> I'm not sure whats' the back story with synchro-test though - they seem
>> to have been stuck in andrew's tree for a very long time now. Is there
>> any reason delaying their inclusion or is it just that nobody's been
>> pushing for them ?
>
> iirc, we decided that synchro-test wasn't valuable/important enough to
> put into mainline.  So it has been living in -mm for, umm, seven years.
>
> Let's revisit that decision.  What do you think is the case for inclusion?

Sorry for the late reply. I agree that this isn't useful on an
everyday basis, however such a test could be useful whenever some
locking discussions come up, such as with the spinlock performance
discussions when I started this thread, or the rwsem write lock
stealing right now. Also, I think we've accepted a lot more
non-core-kernel things over the last 7 years, so the bar may be lower
now.

> Here it is.  It will need a full re-review.

I think the first thing we may want to do is ask David if he has an
updated version - if he's been making changes, it would be rude to him
to check in a 7 year old version of his code.

> From: David Howells <dhowells@redhat.com>
> Subject: mutex subsystem, synchro-test module
>
> The attached patch adds a module for testing and benchmarking mutexes,
> semaphores and R/W semaphores.
>
> Using it is simple:
>
>         insmod synchro-test.ko <args>
>
> It will exit with error ENOANO after running the tests and printing the
> results to the kernel console log.
>
> The available arguments are:
>
>  (*) mx=N
>
>         Start up to N mutex thrashing threads, where N is at most 20. All will
>         try and thrash the same mutex.

Actually N is at most 64

>  (*) sm=N
>
>         Start up to N counting semaphore thrashing threads, where N is at most
>         20. All will try and thrash the same semaphore.

N is at most 64

>  (*) ism=M
>
>         Initialise the counting semaphore with M, where M is any positive
>         integer greater than zero. The default is 4.
>
>  (*) rd=N
>  (*) wr=O
>  (*) dg=P
>
>         Start up to N reader thrashing threads, O writer thrashing threads and
>         P downgrader thrashing threads, where N, O and P are at most 20
>         apiece. All will try and thrash the same read/write semaphore.

N, O and P are at most 64

>  (*) elapse=N
>
>         Run the tests for N seconds. The default is 5.
>
>  (*) load=N
>
>         Each thread delays for N uS whilst holding the lock. The dfault is 0.

default is 2 (I had actually sent a change to correct the doc here)

>  (*) interval=N
>
>         Each thread delays for N uS whilst not holding the lock. The default
>         is 0.

default is 2 (I had actually sent a change to correct the doc here)

>  (*) do_sched=1
>
>         Each thread will call schedule if required after each iteration.
>
>  (*) v=1
>
>         Print more verbose information, including a thread iteration
>         distribution list.
>
> The module should be enabled by turning on CONFIG_DEBUG_SYNCHRO_TEST to "m".
>
> [randy.dunlap@oracle.com: fix build errors, add <sched.h> header file]
> [akpm@linux-foundation.org: remove smp_lock.h inclusion]
> [viro@ZenIV.linux.org.uk: kill daemonize() calls]
> [rdunlap@xenotime.net: fix printk format warrnings]
> [walken@google.com: add spinlock test]
> [walken@google.com: document default load and interval values]
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Michel Lespinasse <walken@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  Documentation/synchro-test.txt |   59 +++
>  kernel/Makefile                |    1
>  kernel/synchro-test.c          |  586 +++++++++++++++++++++++++++++++
>  lib/Kconfig.debug              |   14
>  4 files changed, 660 insertions(+)

It's unclear if synchro-test.c should be in kernel/ - I think similar
tests nowadays tend to be in lib/ instead, though not always :)

> diff -puN /dev/null Documentation/synchro-test.txt
> --- /dev/null
> +++ a/Documentation/synchro-test.txt
> @@ -0,0 +1,59 @@
> +The synchro-test.ko module can be used for testing and benchmarking mutexes,
> +semaphores and R/W semaphores.
> +
> +The module is compiled by setting CONFIG_DEBUG_SYNCHRO_TEST to "m" when
> +configuring the kernel.
> +
> +Using it is simple:
> +
> +       insmod synchro-test.ko <args>
> +
> +It will exit with error ENOANO after running the tests and printing the
> +results to the kernel console log.
> +
> +The available arguments are:
> +
> + (*) mx=N
> +
> +       Start up to N mutex thrashing threads, where N is at most 20. All will
> +       try and thrash the same mutex.

max 64

> + (*) sm=N
> +
> +       Start up to N counting semaphore thrashing threads, where N is at most
> +       20. All will try and thrash the same semaphore.

max 64

> + (*) ism=M
> +
> +       Initialise the counting semaphore with M, where M is any positive
> +       integer greater than zero. The default is 4.
> +
> + (*) rd=N
> + (*) wr=O
> + (*) dg=P
> +
> +       Start up to N reader thrashing threads, O writer thrashing threads and
> +       P downgrader thrashing threads, where N, O and P are at most 20
> +       apiece. All will try and thrash the same read/write semaphore.

max 64

> + (*) elapse=N
> +
> +       Run the tests for N seconds. The default is 5.
> +
> + (*) load=N
> +
> +       Each thread delays for N uS whilst holding the lock. The default is 2.
> +
> + (*) interval=N
> +
> +       Each thread delays for N uS whilst not holding the lock. The default
> +       is 2.
> +
> + (*) do_sched=1
> +
> +       Each thread will call schedule if required after each iteration.
> +
> + (*) v=1
> +
> +       Print more verbose information, including a thread iteration
> +       distribution list.

Other than that I'm happy enough with the rest of this code :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
