Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaFCKed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:34:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbaFCKec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:34:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAJfpegtobxoMs+RRrPYLFRPOVSfr_uqZs+HJFLRif3svHGyQwA@mail.gmail.com>
References: <CAJfpegtobxoMs+RRrPYLFRPOVSfr_uqZs+HJFLRif3svHGyQwA@mail.gmail.com> <1400838223-30844-1-git-send-email-miklos@szeredi.hu> <28592.1401382081@warthog.procyon.org.uk> <11446.1401420931@jrobl> <7184.1401439773@warthog.procyon.org.uk> <CA+icZUV5P=fVwe_MJJHixwBOBoj7HoKSFuySLdS6AU5L++S=4g@mail.gmail.com> <15839.1401786056@warthog.procyon.org.uk> <CA+icZUUiirxYnoL7pg5TvFEy6pQ+5Q3CuJ0jonJMXTOwhT-LDw@mail.gmail.com> <CA+icZUU8BqGUoQdtuqt403NdCBnJnH1-k64bxTM0b_GSfQr1hQ@mail.gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Sedat Dilek <sedat.dilek@gmail.com>,
        "J. R. Okajima" <hooanon05g@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robo Bot <apw@canonical.com>, Felix Fietkau <nbd@openwrt.org>,
        Neil Brown <neilb@suse.de>, Jordi Pujol <jordipujolp@gmail.com>,
        ezk@fsl.cs.sunysb.edu, "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: Unionmount and overlayfs testsuite
Date: Tue, 03 Jun 2014 11:33:54 +0100
Message-ID: <10013.1401791634@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Fix now pushed to overlayfs.v22/overlayfs.current.

I ran my testscript, which leaves a clean set up and mounted overlay fs
behind.  I then ran:

	for ((i=100; i<=129; i++)); do mv /mnt/a/foo$i /mnt/a/bar$i; done
	for ((i=100; i<=129; i++)); do mv /mnt/a/dir$i /mnt/a/dir2$i; done

leading to:

=============================================
[ INFO: possible recursive locking detected ]
3.15.0-rc6-fsdevel+ #382 Tainted: G        W    
---------------------------------------------
mv/27935 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<ffffffff8111e555>] vfs_rmdir+0x59/0xe8

but task is already holding lock:
 (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<ffffffff811e12a9>] ovl_clear_empty+0x175/0x1eb

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&sb->s_type->i_mutex_key#9);
  lock(&sb->s_type->i_mutex_key#9);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

5 locks held by mv/27935:
 #0:  (sb_writers#15){.+.+.+}, at: [<ffffffff8112c06c>] mnt_want_write+0x1c/0x40
 #1:  (&sb->s_type->i_mutex_key#17/1){+.+.+.}, at: [<ffffffff8111eb96>] do_rmdir+0x9f/0x152
 #2:  (&sb->s_type->i_mutex_key#17){+.+.+.}, at: [<ffffffff8111e555>] vfs_rmdir+0x59/0xe8
 #3:  (sb_writers#8){.+.+.+}, at: [<ffffffff8112c06c>] mnt_want_write+0x1c/0x40
 #4:  (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<ffffffff811e12a9>] ovl_clear_empty+0x175/0x1eb

stack backtrace:
CPU: 1 PID: 27935 Comm: mv Tainted: G        W     3.15.0-rc6-fsdevel+ #382
Hardware name:                  /DG965RY, BIOS MQ96510J.86A.0816.2006.0716.2308 07/16/2006
 0000000000000000 ffff880038ac9af0 ffffffff8148b889 ffffffff81fda190
 ffff880038ac9bb0 ffffffff81074b0e 0000000000000002 ffff88003823c890
 0000000000000000 ffff880000000000 ffff880000000004 ffff880000000000
Call Trace:
 [<ffffffff8148b889>] dump_stack+0x4d/0x66
 [<ffffffff81074b0e>] __lock_acquire+0x75a/0x1861
 [<ffffffff810762b6>] lock_acquire+0x9c/0x112
 [<ffffffff8111e555>] ? vfs_rmdir+0x59/0xe8
 [<ffffffff8148e6df>] mutex_lock_nested+0x60/0x2ff
 [<ffffffff8111e555>] ? vfs_rmdir+0x59/0xe8
 [<ffffffff8111e555>] vfs_rmdir+0x59/0xe8
 [<ffffffff811e0fbe>] ovl_cleanup+0x1d/0x40
 [<ffffffff811e12b4>] ovl_clear_empty+0x180/0x1eb
 [<ffffffff811e1360>] ovl_check_empty_and_clear+0x41/0x5c
 [<ffffffff81058fcc>] ? creds_are_invalid+0x18/0x45
 [<ffffffff811e1aca>] ovl_do_remove+0x17c/0x35e
 [<ffffffff811e1cbd>] ovl_rmdir+0x11/0x13
 [<ffffffff8111e584>] vfs_rmdir+0x88/0xe8
 [<ffffffff8111ebdd>] do_rmdir+0xe6/0x152
 [<ffffffff810af5b4>] ? __audit_syscall_entry+0xa1/0xc3
 [<ffffffff8100d737>] ? syscall_trace_enter+0x197/0x1eb
 [<ffffffff8111f414>] SyS_unlinkat+0x16/0x29
 [<ffffffff814925f4>] tracesys+0xdd/0xe2
