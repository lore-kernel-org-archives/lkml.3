Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236AbaEaOSL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 10:18:11 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:32874 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbaEaOSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 10:18:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140530171408.GT18016@ZenIV.linux.org.uk>
References: <CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
	<20140529154454.GK18016@ZenIV.linux.org.uk>
	<20140529162307.GL18016@ZenIV.linux.org.uk>
	<CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
	<20140529165351.GM18016@ZenIV.linux.org.uk>
	<20140529185201.GN18016@ZenIV.linux.org.uk>
	<20140530081238.GA1957@lahna.fi.intel.com>
	<20140530152151.GR18016@ZenIV.linux.org.uk>
	<CA+55aFxLNvBDYtiq92DvuVqUk7byWeYiL1svbNQdXg7MRtbBcQ@mail.gmail.com>
	<20140530164815.GS18016@ZenIV.linux.org.uk>
	<20140530171408.GT18016@ZenIV.linux.org.uk>
Date: Sat, 31 May 2014 10:18:07 -0400
X-Google-Sender-Auth: rtha86ZTLT-Svn6JhOiEImUrhao
Message-ID: <CA+5PVA5EmAkoZnWNUtXCPu5JZ=6Q4jFrjoqHZdtBVdbxwPe6Tw@mail.gmail.com>
Subject: Re: [git pull] Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for
 22s! [systemd-udevd:1667]
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 1:14 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, May 30, 2014 at 05:48:16PM +0100, Al Viro wrote:
>> On Fri, May 30, 2014 at 08:31:30AM -0700, Linus Torvalds wrote:
>> > On Fri, May 30, 2014 at 8:21 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > >
>> > > Linus, how would you prefer it to be handled?
>> >
>> > I'll just have to do an rc8. I really hoped to avoid it, because we're
>> > going on our family vacation when school is out in two weeks, and it
>> > causes problems for the merge window, but it's not like there is much
>> > choice - I can't do a 3.15 release with a known regression like that.
>>
>> Sorry about that... ;-/
>>
>> > So just send me the pull request, and I'll pull it. I'll probably do
>> > the "let's increase the x86-64 stack size to 16kB" too, to close
>> > _that_ issue as well.
>>
>> OK, here it is:
>>
>> Fixes for livelocks in shrink_dentry_list() introduced by fixes to shrink
>> list corruption; the root cause was that trylock of parent's ->d_lock could
>> be disrupted by d_walk() happening on other CPUs, resulting in
>> shrink_dentry_list() making no progress *and* the same d_walk() being called
>> again and again for as long as shrink_dentry_list() doesn't get past that
>> mess.  Solution is to have shrink_dentry_list() treat that trylock failure not
>> as "try to do the same thing again", but "lock them in the right order".
>> Please, pull from
>> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus-2
>
> *GYAH*
>
> Shortlog and diffstat are from the local branch that has two more cleanups
> on top what's been pushed to vfs.git (and what had been tested).  Ones
> matching what's really in that branch are here:
> Shortlog:
> Al Viro (6):
>       lift the "already marked killed" case into shrink_dentry_list()
>       split dentry_kill()
>       expand dentry_kill(dentry, 0) in shrink_dentry_list()
>       shrink_dentry_list(): take parent's ->d_lock earlier
>       dealing with the rest of shrink_dentry_list() livelock
>       dentry_kill() doesn't need the second argument now
>
> Diffstat:
>  fs/dcache.c |  153 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------
>  1 file changed, 107 insertions(+), 46 deletions(-)
>
> My apologies - the script I'm using to generate shortlogs takes branch
> name as an argument, defaulting to HEAD, which was two commits past
> vfs/for-linus-2.  And no, I'm _not_ planning to push that followup stuff
> until the merge window.  Just to make sure: the branch to pull should have
> head at 8cbf74da435d1bd13dbb790f94c7ff67b2fb6af4 and have the same tree
> as vfs.git#for-linus, which is what got testing.

One of my machines got the lockdep report below when booting a kernel
that contained these patches.  This corresponds to Linux
v3.15-rc7-102-g1487385edb55.

josh

[   11.205628] usbcore: registered new interface driver btusb
[   11.212994] systemd-journald[430]: Received request to flush
runtime journal from PID 1
[   11.230780] audit: type=1305 audit(1401544447.755:4): audit_pid=661
old=0 auid=4294967295 ses=4294967295
subj=system_u:system_r:auditd_t:s0 res=1
[   11.233853] usb 2-1.8.1.1: USB disconnect, device number 6

[   11.253251] =============================================
[   11.253254] [ INFO: possible recursive locking detected ]
[   11.253257] 3.15.0-0.rc7.git4.1.fc21.x86_64 #1 Not tainted
[   11.253259] ---------------------------------------------
[   11.253261] systemd-udevd/448 is trying to acquire lock:
[   11.253264]  (&(&dentry->d_lockref.lock)->rlock){+.+...}, at:
[<ffffffff817d66c1>] lock_parent.part.21+0x59/0x69
[   11.253291]
but task is already holding lock:
[   11.253295]  (&(&dentry->d_lockref.lock)->rlock){+.+...}, at:
[<ffffffff817d669e>] lock_parent.part.21+0x36/0x69
[   11.253308]
other info that might help us debug this:
[   11.253312]  Possible unsafe locking scenario:

[   11.253317]        CPU0
[   11.253319]        ----
[   11.253322]   lock(&(&dentry->d_lockref.lock)->rlock);
[   11.253327]   lock(&(&dentry->d_lockref.lock)->rlock);
[   11.253332]
 *** DEADLOCK ***

[   11.253337]  May be due to missing lock nesting notation

[   11.253342] 1 lock held by systemd-udevd/448:
[   11.253345]  #0:  (&(&dentry->d_lockref.lock)->rlock){+.+...}, at:
[<ffffffff817d669e>] lock_parent.part.21+0x36/0x69
[   11.253359]
stack backtrace:
[   11.253366] CPU: 1 PID: 448 Comm: systemd-udevd Not tainted
3.15.0-0.rc7.git4.1.fc21.x86_64 #1
[   11.253371] Hardware name: Apple Inc.
MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS
MBP102.88Z.0106.B03.1211161133 11/16/2012
[   11.253375]  0000000000000000 00000000652a059c ffff88025f71b978
ffffffff817d7dd3
[   11.253384]  ffffffff825a8c60 ffff88025f71ba50 ffffffff810f9084
ffff88003f83d8d8
[   11.253393]  ffffffff825a8c60 0000000000000000 0000000000000000
ffff880200000000
[   11.253402] Call Trace:
[   11.253411]  [<ffffffff817d7dd3>] dump_stack+0x4d/0x66
[   11.253422]  [<ffffffff810f9084>] __lock_acquire+0x16e4/0x1ca0
[   11.253434]  [<ffffffff81023595>] ? native_sched_clock+0x35/0xa0
[   11.253443]  [<ffffffff810f9e32>] lock_acquire+0xa2/0x1d0
[   11.253452]  [<ffffffff817d66c1>] ? lock_parent.part.21+0x59/0x69
[   11.253462]  [<ffffffff817e0aae>] _raw_spin_lock+0x3e/0x80
[   11.253470]  [<ffffffff817d66c1>] ? lock_parent.part.21+0x59/0x69
[   11.253478]  [<ffffffff817d66c1>] lock_parent.part.21+0x59/0x69
[   11.253487]  [<ffffffff8124b518>] shrink_dentry_list+0x258/0x2a0
[   11.253495]  [<ffffffff8124d2ef>] check_submounts_and_drop+0x8f/0xd0
[   11.253505]  [<ffffffff812bc278>] kernfs_dop_revalidate+0x68/0xe0
[   11.253514]  [<ffffffff8123d881>] lookup_fast+0x331/0x380
[   11.253523]  [<ffffffff8123ef03>] link_path_walk+0x1b3/0x8c0
[   11.253531]  [<ffffffff8123f655>] ? path_lookupat+0x45/0x7b0
[   11.253539]  [<ffffffff8123f67b>] path_lookupat+0x6b/0x7b0
[   11.253549]  [<ffffffff8120d69a>] ? kmem_cache_alloc+0x10a/0x320
[   11.253557]  [<ffffffff8123e22f>] ? getname_flags+0x4f/0x1a0
[   11.253565]  [<ffffffff8123fdeb>] filename_lookup+0x2b/0xc0
[   11.253574]  [<ffffffff81244307>] user_path_at_empty+0x67/0xc0
[   11.253583]  [<ffffffff8123e1b2>] ? final_putname+0x22/0x50
[   11.253591]  [<ffffffff8123e459>] ? putname+0x29/0x40
[   11.253599]  [<ffffffff81244312>] ? user_path_at_empty+0x72/0xc0
[   11.253607]  [<ffffffff81244371>] user_path_at+0x11/0x20
[   11.253614]  [<ffffffff81236fc3>] vfs_fstatat+0x63/0xc0
[   11.253622]  [<ffffffff8123755e>] SYSC_newstat+0x2e/0x60
[   11.253629]  [<ffffffff817eb9d5>] ? sysret_check+0x22/0x5d
[   11.253637]  [<ffffffff810f7525>] ? trace_hardirqs_on_caller+0x105/0x1d0
[   11.253645]  [<ffffffff813d1bfe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   11.253653]  [<ffffffff8123783e>] SyS_newstat+0xe/0x10
[   11.253662]  [<ffffffff817eb9a9>] system_call_fastpath+0x16/0x1b
[   11.364999] usb 2-1.8.1.2: USB disconnect, device number 7
