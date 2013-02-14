Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672Ab3BNOpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:45:16 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:51903 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757726Ab3BNOpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:45:14 -0500
Date: Thu, 14 Feb 2013 15:45:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [-rc7 regression] Block IO/VFS/ext3/timer spinlock lockup?
Message-ID: <20130214144510.GC25282@gmail.com>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130213111007.GA11367@gmail.com>
 <CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com>
 <alpine.LFD.2.02.1302140012460.22263@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1302140012460.22263@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> On Wed, 13 Feb 2013, Linus Torvalds wrote:
> 
> > On Wed, Feb 13, 2013 at 3:10 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > >
> > >
> > > Setting up Logical Volume Management: [   13.140000] BUG: spinlock lockup suspected on CPU#1, lvm.static/139
> > > [   13.140000] BUG: spinlock lockup suspected on CPU#1, lvm.static/139
> > > [   13.140000]  lock: 0x97fe9fc0, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
> > > [   13.140000] Pid: 139, comm: lvm.static Not tainted 3.8.0-rc7 #216702
> > > [   13.140000] Call Trace:
> > > [   13.140000]  [<792b5e66>] spin_dump+0x73/0x7d
> > > [   13.140000]  [<7916a347>] do_raw_spin_lock+0xb2/0xe8
> > > [   13.140000]  [<792b9412>] _raw_spin_lock_irqsave+0x35/0x3e
> > > [   13.140000]  [<790391e8>] prepare_to_wait+0x18/0x57
> > 
> > The wait-queue spinlock? That sounds *very* unlikely to deadlock due
> > to any bugs in block layer or filesystems. There are never any
> > downcalls to those from within that spinlock or any other locks taken
> > inside of it.
> 
> The way more interesting information is:
> 
> [   13.140000]  lock: 0x97fe9fc0, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
> 
> That lock is not contended, which makes no sense at all. The only
> explanation for such a behaviour would be a tight spin_lock/unlock
> loop on the other core which is exposed through the spinlock debugging
> code (it uses trylocks instead of queueing in the ticket lock).
> 
> Ingo, can you provide the backtrace of CPU0 please?

CPU0 appears to be idle:

[  118.510000] Call Trace:
[  118.510000]  [<7900844b>] cpu_idle+0x86/0xb4
[  118.510000]  [<792a91df>] rest_init+0x103/0x108
[  118.510000]  [<794558cc>] start_kernel+0x2c7/0x2cc
[  118.510000]  [<7945528e>] i386_start_kernel+0x44/0x46

which suggests memory corruption - but, if then it's a special 
type of memory corruption because AFAIR I always saw similar 
patterns to the lockup, never other signs of memory corruption.

Thanks,

	Ingo
