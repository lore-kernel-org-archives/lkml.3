Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965307Ab3BMXUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:20:36 -0500
Received: from www.linutronix.de ([62.245.132.108]:33834 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965192Ab3BMXUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:20:35 -0500
Date: Thu, 14 Feb 2013 00:20:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@ftp.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [-rc7 regression] Block IO/VFS/ext3/timer spinlock lockup?
In-Reply-To: <CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1302140012460.22263@ionos>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com> <20130213111007.GA11367@gmail.com> <CA+55aFxrjsVkBwUdjmc4MYvEsjEyCJZ7AFpGrWvbbQFB3EVtHA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2013, Linus Torvalds wrote:

> On Wed, Feb 13, 2013 at 3:10 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >
> > Setting up Logical Volume Management: [   13.140000] BUG: spinlock lockup suspected on CPU#1, lvm.static/139
> > [   13.140000] BUG: spinlock lockup suspected on CPU#1, lvm.static/139
> > [   13.140000]  lock: 0x97fe9fc0, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
> > [   13.140000] Pid: 139, comm: lvm.static Not tainted 3.8.0-rc7 #216702
> > [   13.140000] Call Trace:
> > [   13.140000]  [<792b5e66>] spin_dump+0x73/0x7d
> > [   13.140000]  [<7916a347>] do_raw_spin_lock+0xb2/0xe8
> > [   13.140000]  [<792b9412>] _raw_spin_lock_irqsave+0x35/0x3e
> > [   13.140000]  [<790391e8>] prepare_to_wait+0x18/0x57
> 
> The wait-queue spinlock? That sounds *very* unlikely to deadlock due
> to any bugs in block layer or filesystems. There are never any
> downcalls to those from within that spinlock or any other locks taken
> inside of it.

The way more interesting information is:

[   13.140000]  lock: 0x97fe9fc0, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1

That lock is not contended, which makes no sense at all. The only
explanation for such a behaviour would be a tight spin_lock/unlock
loop on the other core which is exposed through the spinlock debugging
code (it uses trylocks instead of queueing in the ticket lock).

Ingo, can you provide the backtrace of CPU0 please?

Thanks,

	tglx

