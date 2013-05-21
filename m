Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab3EUVDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 17:03:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58641 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab3EUVDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 17:03:49 -0400
Date: Tue, 21 May 2013 14:03:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com
Subject: Re: lockdep spew from tty
Message-ID: <20130521210348.GA30422@kroah.com>
References: <1369099320.6387.33.camel@pasglop>
 <1369121464.6387.58.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369121464.6387.58.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 05:31:04PM +1000, Benjamin Herrenschmidt wrote:
> On Tue, 2013-05-21 at 11:22 +1000, Benjamin Herrenschmidt wrote:
> > Hi Greg !
> 
> Adding Jiri...

I'll let Jiri work it out, but I think this is a known issue, and can be
ignored, right?

thanks,

greg k-h

> 
> > Caught that on a console today running some 3.10-almost-rc2
> > (based on ec50f2a97a4a7098a81b40030e0bfe28bdc43740). Right now I don't
> > have the bandwidth to investigate but I though you might be
> > interested :-)
> > 
> > I'll take another peek if it happens again.
> > 
> > ======================================================
> > [ INFO: possible circular locking dependency detected ]
> > 3.10.0-rc1-test #19 Not tainted
> > -------------------------------------------------------
> > kworker/24:1/1089 is trying to acquire lock:
> >  (&ldata->output_lock){+.+...}, at: [<c00000000037aa0c>] .process_echoes+0x34/0x2ec
> > 
> > but task is already holding lock:
> >  ((&buf->work)){+.+...}, at: [<c0000000000778b4>] .process_one_work+0x1f8/0x43c
> > 
> > which lock already depends on the new lock.
> > 
> > 
> > the existing dependency chain (in reverse order) is:
> > 
> > -> #2 ((&buf->work)){+.+...}:
> >        [<c00000000007714c>] .flush_work+0x38/0x258
> >        [<c0000000000781e4>] .__cancel_work_timer+0xe0/0x140
> >        [<c0000000003820c4>] .tty_port_destroy+0x14/0x2c
> >        [<c000000000390d88>] .vc_deallocate+0xfc/0x128
> >        [<c000000000385d8c>] .vt_ioctl+0xae4/0x13a4
> >        [<c00000000037a218>] .tty_ioctl+0xd1c/0xe68
> >        [<c0000000001403b0>] .vfs_ioctl+0x44/0x6c
> >        [<c000000000140e54>] .do_vfs_ioctl+0x614/0x6ac
> >        [<c000000000140f30>] .SyS_ioctl+0x44/0x70
> >        [<c000000000009ca4>] syscall_exit+0x0/0x98
> > 
> > -> #1 (console_lock){+.+.+.}:
> >        [<c00000000005aeec>] .console_lock+0x80/0x98
> >        [<c00000000039180c>] .do_con_write.part.16+0x3c/0x1fb0
> >        [<c0000000003937ec>] .con_write+0x28/0x40
> >        [<c00000000037b344>] .n_tty_write+0x28c/0x424
> >        [<c000000000377c84>] .tty_write+0x184/0x238
> >        [<c00000000012f0ec>] .vfs_write+0xd4/0x1cc
> >        [<c00000000012f5d0>] .SyS_write+0x48/0x7c
> >        [<c000000000009ca4>] syscall_exit+0x0/0x98
> > 
> > -> #0 (&ldata->output_lock){+.+...}:
> >        [<c0000000000a4dc4>] .lock_acquire+0x54/0x70
> >        [<c000000000705780>] .mutex_lock_nested+0x9c/0x4d4
> >        [<c00000000037aa0c>] .process_echoes+0x34/0x2ec
> >        [<c00000000037cc04>] .n_tty_receive_buf+0xc64/0xf90
> >        [<c000000000380d3c>] .flush_to_ldisc+0x110/0x1ac
> >        [<c00000000007793c>] .process_one_work+0x280/0x43c
> >        [<c000000000077d10>] .worker_thread+0x1e0/0x324
> >        [<c00000000007e360>] .kthread+0xc8/0xd4
> >        [<c000000000009fac>] .ret_from_kernel_thread+0x5c/0xb0
> > 
> > other info that might help us debug this:
> > 
> > Chain exists of:
> >   &ldata->output_lock --> console_lock --> (&buf->work)
> > 
> >  Possible unsafe locking scenario:
> > 
> >        CPU0                    CPU1
> >        ----                    ----
> >   lock((&buf->work));
> >                                lock(console_lock);
> >                                lock((&buf->work));
> >   lock(&ldata->output_lock);
> > 
> >  *** DEADLOCK ***
> > 
> > 2 locks held by kworker/24:1/1089:
> >  #0:  (events){.+.+.+}, at: [<c0000000000778b4>] .process_one_work+0x1f8/0x43c
> >  #1:  ((&buf->work)){+.+...}, at: [<c0000000000778b4>] .process_one_work+0x1f8/0x43c
> > 
> > stack backtrace:
> > CPU: 24 PID: 1089 Comm: kworker/24:1 Not tainted 3.10.0-rc1-test #19
> > Workqueue: events .flush_to_ldisc
> > Call Trace:
> > [c000003ed7c37350] [c000000000011b18] .show_stack+0x50/0x14c (unreliable)
> > [c000003ed7c37420] [c00000000070eb90] .dump_stack+0x28/0x3c
> > [c000003ed7c37490] [c00000000070b16c] .print_circular_bug+0x364/0x374
> > [c000003ed7c37540] [c0000000000a4088] .__lock_acquire+0x14d8/0x1d08
> > [c000003ed7c37690] [c0000000000a4dc4] .lock_acquire+0x54/0x70
> > [c000003ed7c37720] [c000000000705780] .mutex_lock_nested+0x9c/0x4d4
> > [c000003ed7c37830] [c00000000037aa0c] .process_echoes+0x34/0x2ec
> > [c000003ed7c378f0] [c00000000037cc04] .n_tty_receive_buf+0xc64/0xf90
> > [c000003ed7c37aa0] [c000000000380d3c] .flush_to_ldisc+0x110/0x1ac
> > [c000003ed7c37b60] [c00000000007793c] .process_one_work+0x280/0x43c
> > [c000003ed7c37c20] [c000000000077d10] .worker_thread+0x1e0/0x324
> > [c000003ed7c37cd0] [c00000000007e360] .kthread+0xc8/0xd4
> > 
> > Cheers,
> > Ben.
> > 
> 
