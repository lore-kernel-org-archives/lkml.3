Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaACBxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 20:53:09 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:18356 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751487AbaACBxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 20:53:07 -0500
Date: Thu, 2 Jan 2014 20:53:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, pmladek@suse.cz,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/9] printk: Release lockbuf_lock before calling
 console_trylock_for_printk()
Message-ID: <20140102205305.3c607926@gandalf.local.home>
In-Reply-To: <1387831171-5264-7-git-send-email-jack@suse.cz>
References: <1387831171-5264-1-git-send-email-jack@suse.cz>
 <1387831171-5264-7-git-send-email-jack@suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Dec 2013 21:39:27 +0100
Jan Kara <jack@suse.cz> wrote:

> There's no reason to hold lockbuf_lock when entering
> console_trylock_for_printk(). The first thing this function does is
> calling down_trylock(console_sem) and if that fails it immediately
> unlocks lockbuf_lock. So lockbuf_lock isn't needed for that branch.
> When down_trylock() succeeds, the rest of console_trylock() is OK
> without lockbuf_lock (it is called without it from other places), and
> the only remaining thing in console_trylock_for_printk() is
> can_use_console() call. For that call console_sem is enough (it
> iterates all consoles and checks CON_ANYTIME flag).
> 
> So we drop logbuf_lock before entering console_trylock_for_printk()
> which simplifies the code.

I'm very nervous about this change. The interlocking between console
lock and logbuf_lock seems to be very subtle. Especially the comment
where logbuf_lock is defined:

/*
 * The logbuf_lock protects kmsg buffer, indices, counters. It is also
 * used in interesting ways to provide interlocking in console_unlock();
 */

Unfortunately, it does not specify what those "interesting ways" are.


Now what I think this does is to make sure whoever wrote to the logbuf
first, does the flushing. With your change we now have:

	CPU 0				CPU 1
	-----				-----
   printk("blah");
   lock(logbuf_lock);

				printk("bazinga!");
				lock(logbuf_lock);
				<blocked>

   unlock(logbuf_lock);
   < NMI comes in delays CPU>

				<get logbuf_lock>
				unlock(logbuf_lock)
				console_trylock_for_printk()
				console_unlock();
				< dumps output >

  
Now is this a bad thing? I don't know. But the current locking will
make sure that the first writer into logbuf_lock gets to do the
dumping, and all the others will just add onto that writer.

Your change now lets the second or third or whatever writer into printk
be the one that dumps the log.

Again, this may not be a big deal, but as printk is such a core part of
the Linux kernel, and this is a very subtle change, I rather be very
cautious here and try to think what can go wrong when this happens.

-- Steve
