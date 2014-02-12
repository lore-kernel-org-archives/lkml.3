Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaBLCwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 21:52:21 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:40157 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaBLCwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 21:52:20 -0500
MIME-Version: 1.0
In-Reply-To: <20140212010941.GM18016@ZenIV.linux.org.uk>
References: <20140211172707.GA1749@redhat.com>
	<20140211210841.GM13647@dastard>
	<52FA9ADA.9040803@sandeen.net>
	<20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
Date: Tue, 11 Feb 2014 18:52:19 -0800
X-Google-Sender-Auth: AAAZddWX80Xi9pNTx8jDrkdACsY
Message-ID: <CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Eric Sandeen <sandeen@sandeen.net>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 5:09 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Slap the check in vfs_create(), see if interrupts had been disabled by it or
> by something in ->create().  Since it's reproducible...

path_openat() starts off with a get_empty_filp(), which allocates a
file pointer with GFP_KERNEL. So that should have triggered the
might_sleep warning if irq's were already disabled at that point.

So it's not before that - in particular, it's not in the signal
handling or do_coredump() paths.

Also, at least xfs_buf_lock() - which is much deeper in that chain -
does a down(&bp->b_sema). I'm disguested that that doesn't have a
might_sleep() in it.

Dave, mind adding a "might_sleep()" to the top of
"down[_interruptible]()". It's silly to not have coverage of semaphore
use in bad contexts.

             Linus
