Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbaE2Qpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:45:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756902AbaE2Qpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:45:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140529163629.GN17233@tucsk.piliscsaba.szeredi.hu>
References: <20140529163629.GN17233@tucsk.piliscsaba.szeredi.hu> <CAJfpeguyE0cg+RAEwOR89=qTGnr2OZFuhZ4tmAfkMLn5-DP_wg@mail.gmail.com> <27993.1401360881@warthog.procyon.org.uk> <1400838223-30844-1-git-send-email-miklos@szeredi.hu> <28313.1401362925@warthog.procyon.org.uk> <20140529120734.GM17233@tucsk.piliscsaba.szeredi.hu> <22475.1401380602@warthog.procyon.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, Sedat Dilek <sedat.dilek@gmail.com>,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: More kernel errors with overlay filesystem v22
Date: Thu, 29 May 2014 17:44:58 +0100
Message-ID: <28536.1401381898@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> generic_file_splice_write() uses I_MUTEX_CHILD.  Not sure why, though, parent
> shouldn't be locked.  Maybe it's some remaining thing from the days when pipes
> used the i_mutex on the pipe inode.  Probably should just remove that notation
> and things will work.

You should be so lucky! ;-)

=============================================
[ INFO: possible recursive locking detected ]
3.15.0-rc6-fsdevel+ #367 Tainted: G        W    
---------------------------------------------
open-file/3284 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#9/2){+.+.+.}, at: [<ffffffff81137121>] generic_file_splice_write+0x88/0x154

but task is already holding lock:
 (&sb->s_type->i_mutex_key#9/2){+.+.+.}, at: [<ffffffff8111cf8d>] lock_rename+0xd3/0xdc

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&sb->s_type->i_mutex_key#9/2);
  lock(&sb->s_type->i_mutex_key#9/2);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by open-file/3284:
 #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff8112bf5b>] mnt_want_write+0x1c/0x40
 #1:  (&type->s_vfs_rename_key){+.+.+.}, at: [<ffffffff8111cef5>] lock_rename+0x3b/0xdc
 #2:  (&sb->s_type->i_mutex_key#9/1){+.+.+.}, at: [<ffffffff8111cf78>] lock_rename+0xbe/0xdc
 #3:  (&sb->s_type->i_mutex_key#9/2){+.+.+.}, at: [<ffffffff8111cf8d>] lock_rename+0xd3/0xdc

stack backtrace:
CPU: 0 PID: 3284 Comm: open-file Tainted: G        W     3.15.0-rc6-fsdevel+ #367
Hardware name:                  /DG965RY, BIOS MQ96510J.86A.0816.2006.0716.2308 07/16/2006
 0000000000000000 ffff88002219d7e0 ffffffff8148b779 ffffffff81ff9d80
 ffff88002219d8a0 ffffffff81074b0e ffff88002219d820 ffff88002219d8a0
 0000000000000000 0000000000000000 ffff880000000003 ffffffff00000000
Call Trace:
 [<ffffffff8148b779>] dump_stack+0x4d/0x66
 [<ffffffff81074b0e>] __lock_acquire+0x75a/0x1861
 [<ffffffff810762b6>] lock_acquire+0x9c/0x112
 [<ffffffff81137121>] ? generic_file_splice_write+0x88/0x154
 [<ffffffff8148e5cf>] mutex_lock_nested+0x60/0x2ff
 [<ffffffff81137121>] ? generic_file_splice_write+0x88/0x154
 [<ffffffff81074399>] ? debug_check_no_locks_freed+0x11b/0x136
 [<ffffffff81137121>] generic_file_splice_write+0x88/0x154
 [<ffffffff8113777e>] direct_splice_actor+0x31/0x33
 [<ffffffff81137329>] splice_direct_to_actor+0xc6/0x188
 [<ffffffff8113774d>] ? opipe_prep.part.8+0x9e/0x9e
 [<ffffffff8113745e>] do_splice_direct+0x73/0x9b
 [<ffffffff811e3375>] ovl_copy_up_one+0x509/0x586
 [<ffffffff811e3490>] ovl_copy_up+0x9e/0xd3
 [<ffffffff811e0ba7>] ovl_dentry_open+0xbf/0xce
 [<ffffffff8110fba8>] vfs_open+0x24/0x41
 [<ffffffff8111d9fe>] do_last+0x943/0xbc9
 [<ffffffff8111b9cd>] ? link_path_walk+0x64/0x744
 [<ffffffff8111dec1>] path_openat+0x23d/0x61d
 [<ffffffff8111ef52>] do_filp_open+0x35/0x7a
 [<ffffffff8149114f>] ? _raw_spin_unlock+0x22/0x2d
 [<ffffffff8112a0fc>] ? __alloc_fd+0xe5/0xf4
 [<ffffffff81110aee>] do_sys_open+0x142/0x1d1
 [<ffffffff8100d737>] ? syscall_trace_enter+0x197/0x1eb
 [<ffffffff81110b96>] SyS_open+0x19/0x1b
 [<ffffffff814924f4>] tracesys+0xdd/0xe2

