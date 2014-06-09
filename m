Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaFICLF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 22:11:05 -0400
Received: from ns.horizon.com ([71.41.210.147]:31760 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754207AbaFICK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 22:10:56 -0400
Date: 8 Jun 2014 22:10:54 -0400
Message-ID: <20140609021054.1614.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: [RFC PATCH] drivers/char/random.c: Is reducing locking range like this safe?
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140609013553.GA1167@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Which writer are you worried about, specifically?  A userspace write
> to /dev/random from rgnd?

Actually, the part I'm actually worried about is latency in
add_interrupt_randomness.

But I may have not understood how the locking works.  There's a per-CPU
fast pool which isn't locked at all, which feeds the input_pool, and
the add to the input pool would be slow if it were locked, but it
seems hard for user space to force a lot of locking activity on
the input_pool.

A bulk read will drain the secondary pool, but random_min_urandom_seed
will prevent reseeding, so lock contention on input_pool will be
almost nil.

Maybe I need to turn this into a documentation patch explaining all of this.

> And have you measured this to be something significant, or is this a
> theoretical concern.  If you've measured it, what's the conditions
> where this is stalling an entropy mixer a significant amount of time?

It's a theoretical extrapolation from timing of user-space writes.
Some time comparisons (on a multicore machine so the two threads should run
on separate processors, and with scaling_governor = performance):

$ dd if=/dev/zero of=/dev/random count=65536
65536+0 records in
65536+0 records out
33554432 bytes (34 MB) copied, 0.356898 s, 94.0 MB/s
$ dd if=/dev/zero of=/dev/random count=65536
65536+0 records in
65536+0 records out
33554432 bytes (34 MB) copied, 0.357693 s, 93.8 MB/s

$ dd if=/dev/urandom of=/dev/null count=16384 & dd if=/dev/zero of=/dev/random count=65536 ; sleep 4
65536+0 records in
65536+0 records out
33554432 bytes (34 MB) copied, 0.505941 s, 66.3 MB/s
16384+0 records in
16384+0 records out
8388608 bytes (8.4 MB) copied, 0.715132 s, 11.7 MB/s
$ dd if=/dev/urandom of=/dev/null count=16384 & dd if=/dev/zero of=/dev/random count=65536 ; sleep 4
65536+0 records in
65536+0 records out
33554432 bytes (34 MB) copied, 0.509075 s, 65.9 MB/s
16384+0 records in
16384+0 records out
8388608 bytes (8.4 MB) copied, 0.734479 s, 11.4 MB/s

$ dd if=/dev/urandom of=/dev/null count=16384 & dd if=/dev/urandom of=/dev/null count=16384 & dd if=/dev/zero of=/dev/random count=65536
65536+0 records in
65536+0 records out
33554432 bytes (34 MB) copied, 0.66224 s, 50.7 MB/s
16384+0 records in
16384+0 records out
8388608 bytes (8.4 MB) copied, 0.894693 s, 9.4 MB/s
16384+0 records in
16384+0 records out
8388608 bytes (8.4 MB) copied, 0.895628 s, 9.4 MB/s
$ dd if=/dev/urandom of=/dev/null count=16384 & dd if=/dev/urandom of=/dev/null count=16384 & dd if=/dev/zero of=/dev/random count=65536 ; sleep 4
65536+0 records in
65536+0 records out
33554432 bytes (34 MB) copied, 0.657055 s, 51.1 MB/s
16384+0 records in
16384+0 records out
8388608 bytes (8.4 MB) copied, 0.908407 s, 9.2 MB/s
16384+0 records in
16384+0 records out
8388608 bytes (8.4 MB) copied, 0.908989 s, 9.2 MB/s

Summarizing that, time to feed in 32 MiB of zeros (from user-space):

0 concurrent reads:  0.356898 0.357693
1 concurrent read:   0.505941 0.509075	(+42%)
2 concurrent reads:  0.662240 0.657055	(+84%)

... so it seems like there are some noticeable contention effects.


And then I started thinking, and realized that the out[] parameter wasn't
doing anything useful at all, and even if we don't change anything else
at all, maybe it should be deleted and de-clutter the code?

It dates back to the days when entropy adding tried to be lockless,
but that was a long time ago.  And once you have locking, it no longer
serves any function.

It's a bit of meandering stream of consciousness, sorry.  The latency
issue is where I started, but the general uselessness of out[] is what
I felt really needed discussing before I proposed a patch to dike it out.
