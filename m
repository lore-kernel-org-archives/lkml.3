Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbaE2RaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:30:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372AbaE2RaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:30:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <27993.1401360881@warthog.procyon.org.uk>
References: <27993.1401360881@warthog.procyon.org.uk> <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@gmail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Re: Kernel errors with overlay filesystem v22
Date: Thu, 29 May 2014 18:29:36 +0100
Message-ID: <29283.1401384576@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's another lockdep report for you.  If you hard link a file, the attached
occurs.

=============================================
[ INFO: possible recursive locking detected ]
3.15.0-rc6-fsdevel+ #367 Tainted: G        W    
---------------------------------------------
ln/2974 is trying to acquire lock:
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

7 locks held by ln/2974:
 #0:  (sb_writers#15){.+.+.+}, at: [<ffffffff8112bf5b>] mnt_want_write+0x1c/0x40
 #1:  (&sb->s_type->i_mutex_key#17/1){+.+.+.}, at: [<ffffffff8111c928>] kern_path_create+0x76/0x121
 #2:  (&sb->s_type->i_mutex_key#17){+.+.+.}, at: [<ffffffff8111adfd>] vfs_link+0xf3/0x269
 #3:  (sb_writers#8){.+.+.+}, at: [<ffffffff8112bf5b>] mnt_want_write+0x1c/0x40
 #4:  (&type->s_vfs_rename_key){+.+.+.}, at: [<ffffffff8111cef5>] lock_rename+0x3b/0xdc
 #5:  (&sb->s_type->i_mutex_key#9/1){+.+.+.}, at: [<ffffffff8111cf78>] lock_rename+0xbe/0xdc
 #6:  (&sb->s_type->i_mutex_key#9/2){+.+.+.}, at: [<ffffffff8111cf8d>] lock_rename+0xd3/0xdc

stack backtrace:
CPU: 1 PID: 2974 Comm: ln Tainted: G        W     3.15.0-rc6-fsdevel+ #367
Hardware name:                  /DG965RY, BIOS MQ96510J.86A.0816.2006.0716.2308 07/16/2006
 0000000000000000 ffff8800383399c0 ffffffff8148b779 ffffffff81ffa7a0
 ffff880038339a80 ffffffff81074b0e ffff880038339a00 ffff880038339a80
 0000000000000000 0000000000000000 ffff880000000006 ffffffff00000000
Call Trace:
 [<ffffffff8148b779>] dump_stack+0x4d/0x66
 [<ffffffff81074b0e>] __lock_acquire+0x75a/0x1861
 [<ffffffff810762b6>] lock_acquire+0x9c/0x112
 [<ffffffff81137121>] ? generic_file_splice_write+0x88/0x154
 [<ffffffff811fb909>] ? avc_has_perm+0x1d/0x13b
 [<ffffffff8148e5cf>] mutex_lock_nested+0x60/0x2ff
 [<ffffffff81137121>] ? generic_file_splice_write+0x88/0x154
 [<ffffffff81137121>] generic_file_splice_write+0x88/0x154
 [<ffffffff8113777e>] direct_splice_actor+0x31/0x33
 [<ffffffff81137329>] splice_direct_to_actor+0xc6/0x188
 [<ffffffff8113774d>] ? opipe_prep.part.8+0x9e/0x9e
 [<ffffffff8113745e>] do_splice_direct+0x73/0x9b
 [<ffffffff811e3375>] ovl_copy_up_one+0x509/0x586
 [<ffffffff811e3490>] ovl_copy_up+0x9e/0xd3
 [<ffffffff811e2063>] ovl_link+0x1f/0x55
 [<ffffffff8111ae70>] vfs_link+0x166/0x269
 [<ffffffff8111f4fd>] SyS_linkat+0x103/0x21d
 [<ffffffff814924f4>] tracesys+0xdd/0xe2

