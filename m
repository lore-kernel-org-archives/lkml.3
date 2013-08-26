Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3HZX4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 19:56:51 -0400
Received: from mga03.intel.com ([143.182.124.21]:18724 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221Ab3HZX4t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 19:56:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,963,1367996400"; 
   d="scan'208";a="287086195"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Eric Dumazet <eric.dumazet@gmail.com>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Fix the race between the fget() and close()
Thread-Topic: [PATCH] Fix the race between the fget() and close()
Thread-Index: AQHOok+ZYzcFj1pyI0yEsH0eN9pd9ZmoKKoA
Date: Mon, 26 Aug 2013 23:56:43 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01AEEE31@SHSMSX101.ccr.corp.intel.com>
References: <1377533569.26153.3.camel@cliu38-desktop-build>
 <20130826112946.GD27005@ZenIV.linux.org.uk>
In-Reply-To: <20130826112946.GD27005@ZenIV.linux.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Al and Eric,

Thanks your comments, please see the below comments.

> -----Original Message-----
> From: Al Viro [mailto:viro@ftp.linux.org.uk] On Behalf Of Al Viro
> Sent: Monday, August 26, 2013 7:30 PM
> To: Liu, Chuansheng
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] Fix the race between the fget() and close()
> 
> On Tue, Aug 27, 2013 at 12:12:49AM +0800, Chuansheng Liu wrote:
> >
> > When one thread is calling sys_ioctl(), and another thread is calling
> > sys_close(), current code has protected most cases.
> >
> > But for the below case, it will cause issue:
> > T1                                T2
> T3
> > sys_close(oldfile)                sys_open(newfile)
> sys_ioctl(oldfile)
> >  -> __close_fd()
> >    lock file_lock
> >     assign NULL file
> >     put fd to be unused
> >    unlock file_lock
> > 				   get new fd is same as old
> > 				   assign newfile to same fd
> > 								   fget_flight()
> >
> get the newfile!!!
> >     decrease file->f_count
> >      file->f_count == 0
> >       --> try to release file
> >
> > The race is when T1 try to close one oldFD, T3 is trying to ioctl the oldFD,
> > if currently the new T2 is trying to open a newfile, it maybe get the newFD is
> > same as oldFD.
> >
> > And normal case T3 should get NULL file pointer due to released by T1, but T3
> > get the newfile pointer, and continue the ioctl accessing.
> >
> > It maybe causes unexpectable error, we hit one system panic at
> do_vfs_ioctl().
> >
> > Here we can fix it that putting "put_unused_fd()" after filp_close(),
> > it can avoid this case.
> 
> NAK.  T3 getting the new file is valid (think what happens if T1 returns from
> close() before T2 enters open() and T3 hits ioctl() after both of those),
> the userland code is, at the very least, racy and no, moving put_unused_fd()
> around is not going to solve any problems - it might shift the race window,
> but that's it.
Yes, the fix is really insane, I realized it after sent it.
But I think the race is there, right?

> 
> It certainly does not affect the possibility of panics in do_vfs_ioctl()
> you are seeing and I would really like to see the details on those instead of
> this kind of voodoo "fixes".
The whole panic stack is below, and my kernel code is:
int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
             unsigned long arg)
{
        int error = 0;
        int __user *argp = (int __user *)arg;
        struct inode *inode = filp->f_path.dentry->d_inode;
=== > Panic here, due to filp->f_path.dentry == NULL, then accessing 0x20 failed.

Could you share some scenario for this case? Thanks.

<1>[  392.448004] BUG: unable to handle kernel NULL pointer dereference at 00000020
<1>[  392.456626] IP: [<c132c043>] do_vfs_ioctl+0x23/0x570
<4>[  392.462545] *pde = 00000000 
<4>[  392.466101] Oops: 0000 [#1] PREEMPT SMP 
<4>[  392.471284] Modules linked in: atomisp lm3554 ov2722 imx1x5 atmel_mxt_ts vxd392 videobuf_vmalloc videobuf_core hdmi_audio bcm_bt_lpm bcm43241(O) kct_daemon(O)
<4>[  392.489564] 
<4>[  392.491397] Pid: 3625, comm: Binder_4 Tainted: G           O 3.4.43-187546-g85c9adb #1  
<4>[  392.501069] EIP: 0060:[<c132c043>] EFLAGS: 00010296 CPU: 0
<4>[  392.507379] EIP is at do_vfs_ioctl+0x23/0x570
<4>[  392.512539] EAX: 00000000 EBX: e7fb8cc0 ECX: c0186201 EDX: c0186201
<4>[  392.519721] ESI: 00000009 EDI: 79022b9c EBP: db30df90 ESP: db30df1c
<4>[  392.527040]  DS: 007b ES: 007b FS: 00d8 GS: 003b SS: 0068
<4>[  392.533253] CR0: 80050033 CR2: 00000020 CR3: 2765a000 CR4: 001007d0
<4>[  392.540558] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
<4>[  392.547752] DR6: ffff0ff0 DR7: 00000400
<0>[  392.552336] Process Binder_4 (pid: 3625, ti=db30c000 task=e7602c00 task.ti=db30c000)
<0>[  392.561177] Stack:
<4>[  392.563707]  db30df00 c14d8344 00000000 00000001 00000001 f1204910 00000000 c7db3320
<4>[  392.573881]  76f4feb4 00000000 00000002 00000000 00000000 00000000 00000000 e7a1bd88
<4>[  392.584192]  00000002 00000001 00000000 76f4feb4 db30dfac c128aad0 00000000 e7fb8cc0
<0>[  392.594362] Call Trace:
<4>[  392.597272]  [<c14d8344>] ? security_file_permission+0x24/0xb0
<4>[  392.603979]  [<c128aad0>] ? sys_futex+0x80/0x130
<4>[  392.609428]  [<c131dd14>] ? fget_light+0x44/0xe0
<4>[  392.614764]  [<c132c5f8>] sys_ioctl+0x68/0x80
<4>[  392.619930]  [<c1a89331>] syscall_call+0x7/0xb
<0>[  392.625066] Code: ff ff f3 90 eb 8e 66 90 55 89 e5 83 ec 74 89 5d f4 89 75 f8 89 7d fc 3e 8d 74 26 00 89 c3 8b 40 0c 81 f9 52 54 00 00 89 d6 89 ca <8b> 78 20 0f 84 74 03 00 00 76 72 81 f9 77 58 04 c0 0f 84 c6 02 
<0>[  392.656788] EIP: [<c132c043>] do_vfs_ioctl+0x23/0x570 SS:ESP 0068:db30df1c
<4>[  392.664976] CR2: 0000000000000020
<1>[  392.669816] BUG: unable to handle kernel NULL pointer dereference at 00000020
<1>[  392.678055] IP: [<c131c8a7>] vfs_read+0x97/0x160
<4>[  392.683460] *pde = 00000000 
<4>[  392.686835] Oops: 0000 [#2] PREEMPT SMP 
<4>[  392.691545] Modules linked in: atomisp lm3554 ov2722 imx1x5 atmel_mxt_ts vxd392 videobuf_vmalloc videobuf_core hdmi_audio bcm_bt_lpm bcm43241(O) kct_daemon(O)
<4>[  392.708638] 
<4>[  392.710379] Pid: 345, comm: adbd Tainted: G           O 3.4.43-187546-g85c9adb #1  
<4>[  392.719179] EIP: 0060:[<c131c8a7>] EFLAGS: 00010206 CPU: 0
<4>[  392.725449] EIP is at vfs_read+0x97/0x160
<4>[  392.730015] EAX: 00000018 EBX: f108a6c0 ECX: 00000000 EDX: 00000000
<4>[  392.737154] ESI: 00000001 EDI: 00000018 EBP: f0e23f8c ESP: f0e23f6c
<4>[  392.744251]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
<4>[  392.750424] CR0: 8005003b CR2: 00000020 CR3: 30cc6000 CR4: 001007d0
<4>[  392.757517] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
<4>[  392.764658] DR6: ffff0ff0 DR7: 00000400
<0>[  392.769022] Process adbd (pid: 345, ti=f0e22000 task=f1806880 task.ti=f0e22000)
<0>[  392.777329] Stack:
<4>[  392.779657]  f0e23f9c 00000000 f108a6c0 c17df320 c131dd14 f108a6c0 080b7440 00000018
<4>[  392.789056]  f0e23fac c131c9ad f0e23f9c 00000001 00000000 00000000 00000006 080b7440
<4>[  392.798400]  f0e22000 c1a89331 00000006 080ba17c 00000018 080b7440 00000018 40310d48
<0>[  392.807831] Call Trace:
<4>[  392.810647]  [<c17df320>] ? mtp_ioctl+0x410/0x410
<4>[  392.816034]  [<c131dd14>] ? fget_light+0x44/0xe0
<4>[  392.821282]  [<c131c9ad>] sys_read+0x3d/0x70
<4>[  392.826145]  [<c1a89331>] syscall_call+0x7/0xb
<4>[  392.831246]  [<c1a80000>] ? uncompress_inline.isra.42+0x86/0xff
<0>[  392.837950] Code: 89 f2 8b 40 08 89 45 ec 85 c0 8b 45 08 89 04 24 89 d8 0f 84 b4 00 00 00 8b 75 ec ff d6 89 c7 85 ff 7e 6c 8b 53 0c be 01 00 00 00 <8b> 42 20 89 45 f0 0f b7 00 66 25 00 f0 66 3d 00 40 b8 01 00 00 
<0>[  392.864457] EIP: [<c131c8a7>] vfs_read+0x97/0x160 SS:ESP 0068:f0e23f6c
<4>[  392.872059] CR2: 0000000000000020
<4>[  392.877014] ---[ end trace ed88a6d4a6a2b4b7 ]---
<0>[  392.882285] Kernel panic - not syncing: Fatal exception

