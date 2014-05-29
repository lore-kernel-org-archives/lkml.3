Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbaE2Kz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 06:55:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757218AbaE2KzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 06:55:24 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
References: <1400838223-30844-1-git-send-email-miklos@szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        neilb@suse.de, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        sedat.dilek@gmail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Subject: Kernel errors with overlay filesystem v22
Date: Thu, 29 May 2014 11:54:41 +0100
Message-ID: <27993.1401360881@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When I run my unionmount testsuite against overlayfs, I get the following
lockdep warning (unionmount is not in the kernel sources in this test):

================================================
[ BUG: lock held when returning to user space! ]
3.15.0-rc6-fsdevel+ #363 Tainted: G        W    
------------------------------------------------
mount/4183 is leaving the kernel with locks still held!
1 lock held by mount/4183:
 #0:  (sb_writers#8){.+.+.+}, at: [<ffffffff8112bf5b>] mnt_want_write+0x1c/0x40


The mounts involved look like:

lower_layer /lower tmpfs ro,seclabel,relatime 0 0
upper_layer /upper tmpfs rw,seclabel,relatime 0 0
overlayfs /mnt overlayfs rw,relatime,lowerdir=/lower,upperdir=/upper/upper,workdir=/upper/work 0 0

I get a busy inodes warning on unmounting /upper (/mnt unmounts okay):

BUG: Dentry ffff88002795feb8{i=2e8e,n=work}  still in use (1) [unmount of tmpfs tmpfs]
------------[ cut here ]------------
WARNING: CPU: 0 PID: 2981 at /data/fs/linux-2.6-fscache/fs/dcache.c:1262 umount_check+0x76/0x7a()
Modules linked in:
CPU: 0 PID: 2981 Comm: umount Tainted: G        W     3.15.0-rc6-fsdevel+ #363
Hardware name:                  /DG965RY, BIOS MQ96510J.86A.0816.2006.0716.2308 07/16/2006
 0000000000000000 ffff8800383b7d38 ffffffff8148b669 0000000000000000
 ffff8800383b7d70 ffffffff81038887 ffffffff81125407 ffff8800279368a0
 00000000000005d0 ffff88003b76f630 ffff88002795feb8 ffff8800383b7d80
Call Trace:
 [<ffffffff8148b669>] dump_stack+0x4d/0x66
 [<ffffffff81038887>] warn_slowpath_common+0x7a/0x93
 [<ffffffff81125407>] ? umount_check+0x76/0x7a
 [<ffffffff8103893f>] warn_slowpath_null+0x15/0x17
 [<ffffffff81125407>] umount_check+0x76/0x7a
 [<ffffffff811238bc>] d_walk+0x134/0x2ff
 [<ffffffff811251ab>] ? do_one_tree+0x21/0x34
 [<ffffffff81125391>] ? dget_parent+0x13f/0x13f
 [<ffffffff811251ab>] do_one_tree+0x21/0x34
 [<ffffffff81125dbf>] shrink_dcache_for_umount+0x42/0x6b
 [<ffffffff81112e73>] generic_shutdown_super+0x1c/0xe8
 [<ffffffff8111309b>] kill_anon_super+0xd/0x17
 [<ffffffff811130c3>] kill_litter_super+0x1e/0x21
 [<ffffffff8111344e>] deactivate_locked_super+0x27/0x48
 [<ffffffff81113ff5>] deactivate_super+0x39/0x3c
 [<ffffffff8112bc50>] mntput_no_expire+0x237/0x258
 [<ffffffff8112d001>] ? SyS_umount+0x3ba/0x3db
 [<ffffffff8112d001>] SyS_umount+0x3ba/0x3db
 [<ffffffff814923f4>] ? tracesys+0xdd/0xe2
 [<ffffffff8100d737>] ? syscall_trace_enter+0x197/0x1eb
 [<ffffffff814923f4>] tracesys+0xdd/0xe2
---[ end trace 11bb9aeb6ce29610 ]---
VFS: Busy inodes after unmount of tmpfs. Self-destruct in 5 seconds.  Have a nice day...
