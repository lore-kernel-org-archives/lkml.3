Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbaJGWAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:00:08 -0400
Received: from relay.parallels.com ([195.214.232.42]:47591 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaJGWAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:00:05 -0400
Date: Wed, 8 Oct 2014 02:00:00 +0400
From: Andrew Vagin <avagin@parallels.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH] umount:  Do not allow unmounting rootfs.
Message-ID: <20141007215959.GA4622@paralelels.com>
References: <1412683212-28077-1-git-send-email-avagin@openvz.org>
 <20141007132431.GF7996@ZenIV.linux.org.uk>
 <20141007134011.GA569@paralelels.com>
 <87vbnv3cl1.fsf_-_@x220.int.ebiederm.org>
 <20141007195307.GA23694@paralelels.com>
 <87iojvvbqe.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <87iojvvbqe.fsf@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.24.24.32]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 01:58:01PM -0700, Eric W. Biederman wrote:
> Andrew Vagin <avagin@parallels.com> writes:
> 
> > On Tue, Oct 07, 2014 at 12:27:06PM -0700, Eric W. Biederman wrote:
> >> 
> >> Which in practice is totally uninteresting.  Only the global root user can
> >> do it, and it is just a stupid thing to do.
> >> 
> >> However that is no excuse to allow a silly way to oops the kernel.
> >> 
> >> We can avoid this silly problem by setting MNT_LOCKED on the rootfs
> >> mount point and thus avoid needing any special cases in the unmount
> >> code.
> >
> > I had this idea too, but it doesn't work.
> >
> > MNT_LOCKED isn't inherited, if the privileged user creates a new mount
> > namespace.
> >
> > So "unshame -m ./nsenter" reproduces the same BUG.
> 
> Which broken tree do you have where MNT_LOCKED is not inherited?

It is Linus' tree with your patch.

I commented out one line and the BUG isn't triggered any more.

diff --git a/fs/namespace.c b/fs/namespace.c
index 15676e9..eacfcad 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1494,7 +1494,7 @@ struct mount *copy_tree(struct mount *mnt, struct dentry *dentry,
        if (IS_ERR(q))
                return q;
 
-       q->mnt.mnt_flags &= ~MNT_LOCKED;
+//     q->mnt.mnt_flags &= ~MNT_LOCKED;
        q->mnt_mountpoint = mnt->mnt_mountpoint;
 
        p = mnt;

> 
> That case fails to reproduce the BUG for me.
> 
> The semantics of MNT_LOCKED are that you aren't allowed to see what is
> beneath.  So if you can get under there even by unsharing the mount
> namespace it is an implementation bug in MNT_LOCKED.

I have applied your patch to the Linus' tree. Look at this:

[avagin@localhost linux-cr]$ git log --pretty=oneline | head -n 5
4da63ceb9069993435deb16b017c9419ddbc5ac1 umount: Do not allow unmounting rootfs.
bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9 Linux 3.17
ef0a59924a795ccb4ced0ae1722a337745a1b045 Merge tag 'scsi-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi
7b6ea43d3f90ba1db87883126c2c09777f51d3d6 Merge tag 'tiny/kconfig-for-3.17' of https://git.kernel.org/pub/scm/linux/kernel/git/josh/linux
62b4d2041117f35ab2409c9f5c4b8d3dc8e59d0f init/Kconfig: Fix HAVE_FUTEX_CMPXCHG to not break up the EXPERT menu
[avagin@localhost linux-cr]$ git show 4da63ceb9069993435deb16b017c9419ddbc5ac1 | head -n 4
commit 4da63ceb9069993435deb16b017c9419ddbc5ac1
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Tue Oct 7 12:27:06 2014 -0700

naavagin@ubuntu:~$ uname -a
Linux ubuntu 3.17.0-00001-g4da63ce #58 SMP Wed Oct 8 01:29:11 MSK 2014 x86_64 x86_64 x86_64 GNU/Linux
avagin@ubuntu:~$ cat nsenter.c 
#define _GNU_SOURCE             /* See feature_test_macros(7) */
#include <sched.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mount.h>

int main(int argc, char **argv)
{
	int fd;

	fd = open("/proc/self/ns/mnt", O_RDONLY);
	if (fd < 0)
		return 1;
	umount2("/", MNT_DETACH);
	if (setns(fd, CLONE_NEWNS))
		return 1;
	umount2("/", MNT_DETACH);

	return 0;
}

root@ubuntu:/home/avagin# gcc -Wall -o nsenter nsenter.c
root@ubuntu:/home/avagin# unshare -m ./nsenter

[   77.723836] ------------[ cut here ]------------
[   77.724018] kernel BUG at fs/pnode.c:372!
[   77.724018] invalid opcode: 0000 [#1] SMP 
[   77.724018] Modules linked in: microcode joydev virtio_balloon i2c_piix4 i2c_core nfsd nfs lockd sunrpc fscache fuse virtio_blk virtio_net floppy
[   77.724018] CPU: 0 PID: 1050 Comm: nsenter Not tainted 3.17.0-00001-g4da63ce #58
[   77.724018] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   77.724018] task: ffff88003a87c4a0 ti: ffff880035a58000 task.ti: ffff880035a58000
[   77.724018] RIP: 0010:[<ffffffff81208c03>]  [<ffffffff81208c03>] propagate_umount+0x153/0x160
[   77.724018] RSP: 0018:ffff880035a5be60  EFLAGS: 00010246
[   77.724018] RAX: ffff88003a9c36e0 RBX: 0000000000000000 RCX: dead000000200200
[   77.724018] RDX: ffff88003a9c36e0 RSI: ffff880035a5be98 RDI: ffff880035a5be98
[   77.724018] RBP: ffff880035a5be88 R08: ffff88003a9c36e0 R09: 0000000000000000
[   77.724018] R10: ffff88003a87c4a0 R11: ffff88003a87cd10 R12: ffff88003a9c3680
[   77.724018] R13: ffff88003a9c3680 R14: ffff88003a9c3680 R15: 0000000000000000
[   77.724018] FS:  00007ff0e55f6740(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[   77.724018] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   77.724018] CR2: 00007ff0e5109e90 CR3: 00000000350b9000 CR4: 00000000000406f0
[   77.724018] Stack:
[   77.724018]  0000000000000246 0000000000000000 0000000000000002 ffff88003a9c36e0
[   77.724018]  ffff88003a9c3680 ffff880035a5bec0 ffffffff811fbda1 ffff88003a9c3680
[   77.724018]  00000000bbc7c04f 0000000000000002 ffff88003a9c36a0 ffff88003e01ef60
[   77.724018] Call Trace:
[   77.724018]  [<ffffffff811fbda1>] umount_tree+0x251/0x260
[   77.724018]  [<ffffffff811fbf52>] do_umount+0x1a2/0x3a0
[   77.724018]  [<ffffffff811fc7bc>] ? SyS_umount+0xec/0x110
[   77.724018]  [<ffffffff811e4f49>] ? putname+0x29/0x40
[   77.724018]  [<ffffffff811fc7bc>] SyS_umount+0xec/0x110
[   77.724018]  [<ffffffff816ea7e9>] system_call_fastpath+0x16/0x1b
[   77.724018] Code: 8b 50 08 48 89 02 49 89 45 08 e9 46 ff ff ff 66 0f 1f 84 00 00 00 00 00 4c 89 e6 4c 89 e7 e8 05 f7 ff ff 48 89 c3 e9 09 ff ff ff <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 90 66 66 66 66 90 55 b8 01 
[   77.724018] RIP  [<ffffffff81208c03>] propagate_umount+0x153/0x160
[   77.724018]  RSP <ffff880035a5be60>
[   77.761968] ---[ end trace 94fc755aefee9186 ]---

> 
> Eric
