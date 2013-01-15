Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab3AOSFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:05:48 -0500
Received: from io.pccl.info ([212.100.254.164]:47988 "EHLO io.pccl.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118Ab3AOSFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:05:47 -0500
X-Greylist: delayed 2655 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2013 13:05:46 EST
Date: Tue, 15 Jan 2013 17:17:56 +0000
From: Andrew Clayton <andrew@digital-domain.net>
To: Rik van Riel <riel@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: qemu-kvm hangs at start up under 3.8.0-rc3-00074-gb719f43
 (works with CONFIG_LOCKDEP)
Message-ID: <20130115171756.36566374@zeus.pccl.info>
In-Reply-To: <50F58867.6010507@redhat.com>
References: <20130113222958.64840242@omega.digital-domain.net>
	<20130114132736.GA12489@redhat.com>
	<20130114182449.5a163101@omega.digital-domain.net>
	<50F58867.6010507@redhat.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2013 11:48:39 -0500, Rik van Riel wrote:

> On 01/14/2013 01:24 PM, Andrew Clayton wrote:

[snip]

> >
> > bash            S ffff88013b2b0d00     0  3203   3133 0x00000000
> >   ffff880114dabe58 0000000000000082 8000000113558065
> > ffff880114dabfd8 ffff880114dabfd8 0000000000004000 ffff88013b0c5b00
> > ffff88013b2b0d00 ffff880114dabd88 ffffffff8109067d ffffea0004536670
> > ffffea0004536640 Call Trace:
> >   [<ffffffff8109067d>] ? default_wake_function+0xd/0x10
> >   [<ffffffff8108a315>] ? atomic_notifier_call_chain+0x15/0x20
> >   [<ffffffff8133d84f>] ? tty_get_pgrp+0x3f/0x50
> >   [<ffffffff810819ac>] ? pid_vnr+0x2c/0x30
> >   [<ffffffff8133fe54>] ? tty_ioctl+0x7b4/0xbd0
> >   [<ffffffff8106bf62>] ? wait_consider_task+0x102/0xaf0
> >   [<ffffffff815c00e4>] schedule+0x24/0x70
> >   [<ffffffff8106cb24>] do_wait+0x1d4/0x200
> >   [<ffffffff8106d9cb>] sys_wait4+0x9b/0xf0
> >   [<ffffffff8106b9f0>] ? task_stopped_code+0x50/0x50
> >   [<ffffffff815c1ad2>] system_call_fastpath+0x16/0x1b
> >
> > qemu-kvm        D ffff88011ab8c8b8     0  3345   3203 0x00000000
> >   ffff880112129cd8 0000000000000082 ffff880112129c50
> > ffff880112129fd8 ffff880112129fd8 0000000000004000 ffff88013b04ce00
> > ffff880139da1a00 0000000000000000 00000000000280da ffff880112129d38
> > ffffffff810d3300 Call Trace:
> >   [<ffffffff810d3300>] ? __alloc_pages_nodemask+0xf0/0x7c0
> >   [<ffffffff811273c6>] ? touch_atime+0x66/0x170
> >   [<ffffffff810cdabf>] ? generic_file_aio_read+0x5bf/0x730
> >   [<ffffffff815c00e4>] schedule+0x24/0x70
> >   [<ffffffff815c0cdd>] rwsem_down_failed_common+0xbd/0x150
> >   [<ffffffff815c0da3>] rwsem_down_write_failed+0x13/0x15
> >   [<ffffffff812d1be3>] call_rwsem_down_write_failed+0x13/0x20
> >   [<ffffffff815bf4dd>] ? down_write+0x2d/0x34
> >   [<ffffffff810f0724>] vma_adjust+0xe4/0x610
> >   [<ffffffff810f0fa4>] vma_merge+0x1b4/0x270
> >   [<ffffffff810f1fa6>] do_brk+0x196/0x330
> >   [<ffffffff810f2217>] sys_brk+0xd7/0x130
> >   [<ffffffff815c1ad2>] system_call_fastpath+0x16/0x1b
> 
> This looks like qemu-kvm getting stuck trying to get the anon_vma
> lock.
> 
> That leads to the obvious question: what is holding the lock, and/or
> failed to release it?
> 
> Do you have any other (qemu-kvm?) processes on your system that have
> any code in the VM (or strace/ptrace/...) in the backtrace, that might
> be holding this lock?

I don't think so. The above was done having just logged into
gnome-shell and opened up a couple of gnome-terminals.
 
> Do you have anything in your dmesg showing threads that had a BUG_ON
> (and exited) while holding the lock?

I never noticed anything like that.

The interesting thing is that if I use basically the same kernel but
with CONFIG_LOCKDEP enabled, it works fine.

Hmm, I wonder if it's the same as this?
http://lkml.indiana.edu/hypermail/linux/kernel/1301.1/02810.html

When I get home, I'll try a kernel with those two patches reverted.
They seem to be

572043c90db65b45a4efd959db7458edcf6411ad
1b963c81b14509e330e0fe3218b645ece2738dc5

in Linus' tree.

CC'd Jiri as well.

Cheers,
Andrew
