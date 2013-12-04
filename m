Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab3LDVO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:14:59 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58848 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214Ab3LDVO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:14:57 -0500
MIME-Version: 1.0
In-Reply-To: <20131204091903.GA18675@hostway.ca>
References: <CA+55aFyez7uZ6LeXrBRCqJzgJ=w4Xv+CV6QSYp5NkOJ2R9Xang@mail.gmail.com>
	<CA+55aFyhzvJrCiJOqUgL-98=MVutWePToQXaVfS2j6e5eetJSw@mail.gmail.com>
	<20131203085233.GA20179@gmail.com>
	<CA+55aFxhUYi6Lbrxfjgq7OqSDMF24wqvnGn_J_RAMY7y-AmRiQ@mail.gmail.com>
	<20131204091903.GA18675@hostway.ca>
Date: Wed, 4 Dec 2013 13:14:56 -0800
X-Google-Sender-Auth: gRxKL0JynfzsF_BLfNdm0sO0F5k
Message-ID: <CA+55aFwDaeYav1WGpmoHH4tTZ5xTWjkEO-46RvLb6DRYD_BnSg@mail.gmail.com>
Subject: Re: [PATCH] mutexes: Add CONFIG_DEBUG_MUTEX_FASTPATH=y debug variant
 to debug SMP races
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Simon Kirby <sim@hostway.ca>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <Waiman.Long@hp.com>, Ian Applegate <ia@cloudflare.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Lameter <cl@gentwo.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@fusionio.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 1:19 AM, Simon Kirby <sim@hostway.ca> wrote:
>
> Meanwhile, I still don't understand how moving the unlock _up_ to cover
> less of the code can solve the race, but I will stare at your long
> explanation more tomorrow.

The lock we're moving up isn't the lock that actually protects the
whole allocation logic (it's the lock that then protects the pipe
contents when a pipe is *used*). So it's a useless lock, and moving it
up is a good idea regardless (because it makes the locks only protect
the parts they are actually *supposed* to protect.

And while extraneous lock wouldn't normally hurt, the sleeping locks
(both mutexes and semaphores) aren't actually safe wrt de-allocation -
they protect anything *inside* the lock, but the lock data structure
itself is accessed racily wrt other lockers (in a way that still
leaves the locked region protected, but not the lock itself). If you
care about details, you can walk through my example.

         Linus
