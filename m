Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaEZP1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:27:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48592 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaEZP1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:27:05 -0400
Date: Mon, 26 May 2014 16:27:03 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>, linux-fsdevel@vger.kernel.org
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s!
 [systemd-udevd:1667]
Message-ID: <20140526152703.GN18016@ZenIV.linux.org.uk>
References: <20140526093741.GA1765@lahna.fi.intel.com>
 <20140526135746.GM18016@ZenIV.linux.org.uk>
 <20140526142948.GA1685@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526142948.GA1685@lahna.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 05:29:48PM +0300, Mika Westerberg wrote:

> I attached the dmesg with 'echo t > /proc/sysrq-trigger' included.


> [  133.826957] usb 3-10.3: USB disconnect, device number 7
> [  159.326769] BUG: soft lockup - CPU#6 stuck for 22s! [systemd-udevd:1824]
> [  159.326809] CPU: 6 PID: 1824 Comm: systemd-udevd Tainted: G          I   3.15.0-rc7 #55
> [  159.326810] Hardware name: Gigabyte Technology Co., Ltd. Z87X-UD7 TH/Z87X-UD7 TH-CF, BIOS F4 03/18/2014
> [  159.326812] task: ffff880472854a80 ti: ffff8804747ec000 task.ti: ffff8804747ec000
[snip]
> [  159.326834] Call Trace:
> [  159.326838]  [<ffffffff811e74e6>] dentry_kill+0x36/0x280
> [  159.326840]  [<ffffffff811e793a>] shrink_dentry_list+0x8a/0x110
> [  159.326842]  [<ffffffff811e81c4>] check_submounts_and_drop+0x74/0xa0
> [  159.326845]  [<ffffffff81245c5d>] kernfs_dop_revalidate+0x5d/0xd0
> [  159.326847]  [<ffffffff811dba4d>] lookup_fast+0x26d/0x2c0
> [  159.326849]  [<ffffffff811dd2b5>] path_lookupat+0x155/0x780
> [  159.326851]  [<ffffffff811dc152>] ? final_putname+0x22/0x50
> [  159.326853]  [<ffffffff811e198f>] ? user_path_at_empty+0x5f/0x90
> [  159.326856]  [<ffffffff811b6eb5>] ? kmem_cache_alloc+0x35/0x1f0
> [  159.326858]  [<ffffffff811dc1cf>] ? getname_flags+0x4f/0x1a0
> [  159.326860]  [<ffffffff811dd90b>] filename_lookup+0x2b/0xc0
> [  159.326862]  [<ffffffff811e1984>] user_path_at_empty+0x54/0x90
> [  159.326865]  [<ffffffff811d65ff>] ? SYSC_newstat+0x1f/0x40
> [  159.326867]  [<ffffffff811d69ec>] SyS_readlink+0x4c/0x130
> [  159.326870]  [<ffffffff81113c76>] ? __audit_syscall_exit+0x1f6/0x2a0
> [  159.326872]  [<ffffffff816ade69>] system_call_fastpath+0x16/0x1b


That's the livelock.  OK.  But in the stack traces below
	a) that systemd-udevd instance is happily running in userland
and
	b) the only traces of dentry_kill() in the stack are noise
in stacks of gdbus and dbus-daemon.

*grumble*  I wonder if we should instrument d_shrink_add()/d_lru_shrink_mode()
so that they would tag dentry with pointer to current, allowing us to report
something useful in select_collect()...

What's really strange is that the same livelock seems to repeat at least
once more; dentries involved the first time around should've been dead
and buried by then.  And AFAICS, in the log you've originally posted
exactly that has happened - both times to the same process...

Do these livelocks keep happening indefinitely, once triggered?  IOW,
is that a buggered state of dcache and/or kernfs, or is it a transient pileup
that happens when we invalidate a subtree there?
