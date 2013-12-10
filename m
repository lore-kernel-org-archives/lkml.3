Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561Ab3LJUGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:06:05 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:47281 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab3LJUGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:06:03 -0500
MIME-Version: 1.0
Date: Tue, 10 Dec 2013 15:06:01 -0500
X-Google-Sender-Auth: pDcHDQk3VvhfUNbjkJdGeLR9EA4
Message-ID: <CA+5PVA56s68i_Ad+FiT_8_OHZt3BeZdpqdzc6RVbgOx68=MaOQ@mail.gmail.com>
Subject: SELinux change in 3.13 causes sync hang
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Eric Paris <eparis@redhat.com>, Anand Avati <avati@redhat.com>
Cc: James Morris <jmorris@namei.org>, Eric Sandeen <sandeen@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've had a report[1] in Fedora of sync(1) hanging after logging into
GNOME and running the command in a terminal.  I was able to recreate
this on my local system and did a git bisect.  The bisect blames:

commit 102aefdda4d8275ce7d7100bc16c88c74272b260
Author: Anand Avati <avati@redhat.com>
Date:   Tue Apr 16 18:56:19 2013 -0400

    selinux: consider filesystem subtype in policies

Looking at the backtrace via sysrq-t gets us the backtraces below, and
the lock accounting information.  The fusermount process involved
seems to be doing e.g.:

 1455 ?        S      0:00 fusermount -o
rw,nosuid,nodev,subtype=gvfsd-fuse -- /run/user/1000/gvfs

and I don't see /run/user/1000/gvfs/ listed in /proc/self/mounts

Thoughts on this?  It seems the change does something subtle with FUSE
mounts that cause them to hang, and then a manual sync(1) hangs on
iterate_supers.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=1033965

[  152.923866] fusermount      S ffff88031cee5c00  4176  1420   1401 0x00000080
[  152.923869]  ffff880309367c10 0000000000000046 00000000001d5140
ffff880309367fd8
[  152.923873]  ffff880309367fd8 00000000001d5140 ffff88030954ae00
ffff8803090d67b0
[  152.923876]  ffff880309367c50 ffff8803090d69b0 0000000000000000
ffff88030954ae00
[  152.923880] Call Trace:
[  152.923883]  [<ffffffff81705959>] schedule+0x29/0x70
[  152.923888]  [<ffffffffa0661d15>] __fuse_get_req+0x185/0x270 [fuse]
[  152.923892]  [<ffffffff81096850>] ? wake_up_bit+0x30/0x30
[  152.923896]  [<ffffffffa0661e10>] fuse_get_req+0x10/0x20 [fuse]
[  152.923900]  [<ffffffffa06651df>] fuse_getxattr+0x4f/0x160 [fuse]
[  152.923903]  [<ffffffff812eb4b5>] sb_finish_set_opts+0x215/0x340
[  152.923906]  [<ffffffff812eb841>] selinux_set_mnt_opts+0x261/0x610
[  152.923909]  [<ffffffff812e5e2a>] ? selinux_parse_opts_str+0x1ba/0x2a0
[  152.923912]  [<ffffffff812ebc77>] selinux_sb_kern_mount+0x87/0x150
[  152.923916]  [<ffffffff812e0cf6>] security_sb_kern_mount+0x16/0x20
[  152.923919]  [<ffffffff811da20a>] mount_fs+0x8a/0x1b0
[  152.923922]  [<ffffffff811f7aa3>] vfs_kern_mount+0x63/0xf0
[  152.923925]  [<ffffffff811fa36e>] do_mount+0x23e/0xa20
[  152.923928]  [<ffffffff81166964>] ? __get_free_pages+0x14/0x50
[  152.923931]  [<ffffffff811f9fb6>] ? copy_mount_options+0x36/0x170
[  152.923934]  [<ffffffff811fabd3>] SyS_mount+0x83/0xc0
[  152.923937]  [<ffffffff81711499>] system_call_fastpath+0x16/0x1b

[  152.936687] sync            D ffff88031cee1700  4176  2023   1987 0x00000080
[  152.936691]  ffff8802fc507e48 0000000000000046 00000000001d5140
ffff8802fc507fd8
[  152.936694]  ffff8802fc507fd8 00000000001d5140 ffff8802da9e9700
ffff8802da9e9700
[  152.936697]  ffff8803090d11b0 fffffffeffffffff ffff8803090d11b8
ffffffff81209340
[  152.936701] Call Trace:
[  152.936704]  [<ffffffff81209340>] ? generic_write_sync+0x70/0x70
[  152.936708]  [<ffffffff81705959>] schedule+0x29/0x70
[  152.936710]  [<ffffffff81706f5d>] rwsem_down_read_failed+0xbd/0x120
[  152.936714]  [<ffffffff81357de4>] call_rwsem_down_read_failed+0x14/0x30
[  152.936717]  [<ffffffff81704b53>] ? down_read+0x83/0xa0
[  152.936721]  [<ffffffff811d9b5c>] ? iterate_supers+0x9c/0x110
[  152.936724]  [<ffffffff811d9b5c>] iterate_supers+0x9c/0x110
[  152.936727]  [<ffffffff812095c5>] sys_sync+0x35/0x90
[  152.936730]  [<ffffffff81711499>] system_call_fastpath+0x16/0x1b


Showing all locks held in the system:
[  152.938636] 2 locks held by fusermount/1420:
[  152.938637]  #0:  (&type->s_umount_key#44/1){+.+.+.}, at:
[<ffffffff811d919a>] sget+0x2ca/0x660
[  152.938646]  #1:  (&sbsec->lock){+.+.+.}, at: [<ffffffff812eb654>]
selinux_set_mnt_opts+0x74/0x610
[  152.938668] 1 lock held by sync/2023:
[  152.938669]  #0:  (&type->s_umount_key#50){.+.+..}, at:
[<ffffffff811d9b5c>] iterate_supers+0x9c/0x110
