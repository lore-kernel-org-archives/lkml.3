Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab3HAUfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:35:51 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:65380 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab3HAUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:35:49 -0400
Date: Thu, 1 Aug 2013 23:34:59 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] n_tty: change lock ordering in n_tty_read() (v2)
Message-ID: <20130801203459.GE3109@swordfish>
References: <20130801193146.GA3109@swordfish>
 <20130801194610.GC3109@swordfish>
 <51FABE84.1090006@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FABE84.1090006@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/01/13 16:01), Peter Hurley wrote:
> On 08/01/2013 03:46 PM, Sergey Senozhatsky wrote:
> >Acquire atomic_read_lock before termios_rwsem rw-lock in n_tty_read().
> >termios_rwsem is getting released and re-acquired, while remaining
> >readers are blocked on atomic_read_lock mutex, in case when process
> >must wait for input_available_p(), making lockdep unhappy:
> 
> Thanks for the report. This is a regression in lockdep.

Thanks for the update. I was thinkg about that. There is no read/write
termios_rwsem cross-locking on read path with atomic_read_lock being involved,
but the thing that stopped me is that if lockdep has a regression then I would
probably see warnings from different places, not just tty.
Feel free to ask for any help or testing (if need).

thanks,
	-ss

> >[  463.542463] ======================================================
> >[  463.542464] [ INFO: possible circular locking dependency detected ]
> >[  463.542466] 3.11.0-rc3-next-20130801-dbg-dirty #5 Not tainted
> >[  463.542467] -------------------------------------------------------
> >[  463.542469] agetty/2075 is trying to acquire lock:
> >[  463.542484]  (&tty->termios_rwsem){++++..}, at: [<ffffffff81398660>] n_tty_read+0x460/0xab0
> >[  463.542484]
> >but task is already holding lock:
> >[  463.542496]  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff81398959>] n_tty_read+0x759/0xab0
> >[  463.542497]
> >which lock already depends on the new lock.
> >
> >[  463.542497]
> >the existing dependency chain (in reverse order) is:
> >[  463.542502]
> >-> #1 (&ldata->atomic_read_lock){+.+...}:
> >[  463.542508]        [<ffffffff810b9394>] lock_acquire+0xa4/0x200
> >[  463.542514]        [<ffffffff8160a787>] mutex_lock_interruptible_nested+0x77/0x4e0
> >[  463.542518]        [<ffffffff81398959>] n_tty_read+0x759/0xab0
> >[  463.542524]        [<ffffffff81393e8d>] tty_read+0x8d/0x100
> >[  463.542528]        [<ffffffff8117987a>] vfs_read+0x9a/0x170
> >[  463.542531]        [<ffffffff8117a05c>] SyS_read+0x4c/0xa0
> >[  463.542536]        [<ffffffff81610c7e>] tracesys+0xd0/0xd5
> >[  463.542540]
> >-> #0 (&tty->termios_rwsem){++++..}:
> >[  463.542543]        [<ffffffff810b84e6>] __lock_acquire+0x1756/0x1d20
> >[  463.542547]        [<ffffffff810b9394>] lock_acquire+0xa4/0x200
> >[  463.542550]        [<ffffffff8160c1b7>] down_read+0x47/0x60
> >[  463.542554]        [<ffffffff81398660>] n_tty_read+0x460/0xab0
> >[  463.542557]        [<ffffffff81393e8d>] tty_read+0x8d/0x100
> >[  463.542560]        [<ffffffff8117987a>] vfs_read+0x9a/0x170
> >[  463.542563]        [<ffffffff8117a05c>] SyS_read+0x4c/0xa0
> >[  463.542566]        [<ffffffff81610c7e>] tracesys+0xd0/0xd5
> >[  463.542567]
> >other info that might help us debug this:
> >
> >[  463.542569]  Possible unsafe locking scenario:
> >
> >[  463.542570]        CPU0                    CPU1
> >[  463.542570]        ----                    ----
> >[  463.542573]   lock(&ldata->atomic_read_lock);
> >[  463.542575]                                lock(&tty->termios_rwsem);
> >[  463.542577]                                lock(&ldata->atomic_read_lock);
> >[  463.542579]   lock(&tty->termios_rwsem);
> >[  463.542580]
> >  *** DEADLOCK ***
> 
> False positive.
> 
> This deadlock is not possible because CPU1 only holds a read lock
> which cannot prevent CPU0 from obtaining a read lock on the same
> read/write semaphore.
> 
> I'll be only too happy to track down where the regression was
> introduced as soon as I fix an actual lock order problem in
> the nouveau driver which disables lockdep :)
> 
> Regards,
> Peter Hurley
> 
> >[  463.542582] 2 locks held by agetty/2075:
> >[  463.542590]  #0:  (&tty->ldisc_sem){++++++}, at: [<ffffffff8139c130>] tty_ldisc_ref_wait+0x20/0x50
> >[  463.542597]  #1:  (&ldata->atomic_read_lock){+.+...}, at: [<ffffffff81398959>] n_tty_read+0x759/0xab0
> >[  463.542598]
> >stack backtrace:
> >[  463.542602] CPU: 0 PID: 2075 Comm: agetty Not tainted 3.11.0-rc3-next-20130801-dbg-dirty #5
> >[  463.542603] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
> >[  463.542609]  ffffffff82236010 ffff88009af67c28 ffffffff8160630a ffffffff82236010
> >[  463.542613]  ffff88009af67c68 ffffffff816031b7 ffff880151ac0000 ffff880151ac0790
> >[  463.542617]  000000073469e1bd ffff880151ac0768 ffff880151ac0790 ffff880151ac0000
> >[  463.542618] Call Trace:
> >[  463.542625]  [<ffffffff8160630a>] dump_stack+0x4e/0x82
> >[  463.542630]  [<ffffffff816031b7>] print_circular_bug+0x2b6/0x2c5
> >[  463.542634]  [<ffffffff810b84e6>] __lock_acquire+0x1756/0x1d20
> >[  463.542638]  [<ffffffff810b9394>] lock_acquire+0xa4/0x200
> >[  463.542642]  [<ffffffff81398660>] ? n_tty_read+0x460/0xab0
> >[  463.542645]  [<ffffffff8160c1b7>] down_read+0x47/0x60
> >[  463.542649]  [<ffffffff81398660>] ? n_tty_read+0x460/0xab0
> >[  463.542653]  [<ffffffff81398660>] n_tty_read+0x460/0xab0
> >[  463.542661]  [<ffffffff81085020>] ? wake_up_process+0x40/0x40
> >[  463.542665]  [<ffffffff81393e8d>] tty_read+0x8d/0x100
> >[  463.542668]  [<ffffffff8117987a>] vfs_read+0x9a/0x170
> >[  463.542671]  [<ffffffff8117a05c>] SyS_read+0x4c/0xa0
> >[  463.542674]  [<ffffffff81610c7e>] tracesys+0xd0/0xd5
> >
> >v2: correct subject typo.
> >
> >Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> >
> >---
> >
> >  drivers/tty/n_tty.c | 15 ++++++---------
> >  1 file changed, 6 insertions(+), 9 deletions(-)
> >
> >diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
> >index dd8ae0c..03bd6e8 100644
> >--- a/drivers/tty/n_tty.c
> >+++ b/drivers/tty/n_tty.c
> >@@ -2122,8 +2122,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
> >  	if (c < 0)
> >  		return c;
> >
> >-	down_read(&tty->termios_rwsem);
> >-
> >  	minimum = time = 0;
> >  	timeout = MAX_SCHEDULE_TIMEOUT;
> >  	if (!ldata->icanon) {
> >@@ -2145,16 +2143,15 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
> >  	 *	Internal serialization of reads.
> >  	 */
> >  	if (file->f_flags & O_NONBLOCK) {
> >-		if (!mutex_trylock(&ldata->atomic_read_lock)) {
> >-			up_read(&tty->termios_rwsem);
> >+		if (!mutex_trylock(&ldata->atomic_read_lock))
> >  			return -EAGAIN;
> >-		}
> >  	} else {
> >-		if (mutex_lock_interruptible(&ldata->atomic_read_lock)) {
> >-			up_read(&tty->termios_rwsem);
> >+		if (mutex_lock_interruptible(&ldata->atomic_read_lock))
> >  			return -ERESTARTSYS;
> >-		}
> >  	}
> >+
> >+	down_read(&tty->termios_rwsem);
> >+
> >  	packet = tty->packet;
> >
> >  	add_wait_queue(&tty->read_wait, &wait);
> >@@ -2248,7 +2245,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
> >  		if (time)
> >  			timeout = time;
> >  	}
> >-	mutex_unlock(&ldata->atomic_read_lock);
> >  	remove_wait_queue(&tty->read_wait, &wait);
> >
> >  	if (!waitqueue_active(&tty->read_wait))
> >@@ -2260,6 +2256,7 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
> >
> >  	n_tty_set_room(tty);
> >  	up_read(&tty->termios_rwsem);
> >+	mutex_unlock(&ldata->atomic_read_lock);
> >  	return retval;
> >  }
> >
> >
> 
