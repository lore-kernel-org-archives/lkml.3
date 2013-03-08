Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab3CHVPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 16:15:47 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:34531 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab3CHVPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 16:15:46 -0500
MIME-Version: 1.0
In-Reply-To: <20130308204113.GA15334@kroah.com>
References: <CA+ydwtqqLZykdJXRPcd0_6UoNQJmTb2VeVKheHYDA+8-4wkW1g@mail.gmail.com>
	<20130308204113.GA15334@kroah.com>
Date: Fri, 8 Mar 2013 23:15:45 +0200
Message-ID: <CA+ydwto53YGVRtzRjXdX_Vrmx+XLTg_9UvVEOVDBf_VAnmWqzw@mail.gmail.com>
Subject: Re: kernel BUG at fs/sysfs/group.c:65!
From: Tommi Rantala <tt.rantala@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/8 Greg KH <gregkh@linuxfoundation.org>:
> On Fri, Mar 08, 2013 at 09:35:17PM +0200, Tommi Rantala wrote:
>> [  205.043027] kernel BUG at /home/ttrantal/git/linux-2.6/fs/sysfs/group.c:65!
>
> And now we crash.  For a loop device we are trying to add.
>
> Ick.
>
> I'm guessing that the caller of whom ever tried to create the duplicate
> sysfs device, didn't check the return value, and then tried to add a
> sysfs group to that object.
>
> So we crashed, as I'm betting sysfs_create_group() was called with a
> NULL kobject.
>
> I think that BUG() for such a stupid thing is flat out wrong, we should
> be returning an error instead, so I'll go fix that.  If you change the
> line that this BUG() call is, from:
>         BUG_ON(!kobj || (!update && !kobj->sd));
> to
>         BUG_ON(!update && !kobj->sd);
>
> does it still crash?

Yes:

[   31.419720] kernel BUG at /home/ttrantal/git/linux-2.6/fs/sysfs/group.c:65!
[   31.419746] invalid opcode: 0000 [#1] SMP
[   31.419746] CPU 0
[   31.419746] Pid: 3396, comm: trinity-child0 Tainted: G        W
3.9.0-rc1+ #104 Bochs Bochs
[   31.419746] RIP: 0010:[<ffffffff81224886>]  [<ffffffff81224886>]
internal_create_group+0x26/0x220
[   31.419746] RSP: 0018:ffff88007935fd08  EFLAGS: 00010246
[   31.419746] RAX: ffff880077264520 RBX: ffff8800792ea800 RCX: 0000000000000006
[   31.419746] RDX: ffffffff82849980 RSI: 0000000000000000 RDI: ffff8800792ea880
[   31.419746] RBP: ffff88007935fd58 R08: 0000000000000070 R09: 0000000000000001
[   31.419746] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007a92bae8
[   31.419746] R13: ffffffff82849980 R14: 0000000000000000 R15: ffff8800792ea870
[   31.419746] FS:  00007f2d1ba2c700(0000) GS:ffff88007f800000(0000)
knlGS:0000000000000000
[   31.419746] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   31.419746] CR2: 00007f10bef71350 CR3: 0000000079351000 CR4: 00000000000006f0
[   31.419746] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   31.419746] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   31.419746] Process trinity-child0 (pid: 3396, threadinfo
ffff88007935e000, task ffff880077264520)
[   31.419746] Stack:
[   31.419746]  ffff88007935fd28 ffff8800792ea880 ffff88007a92c230
ffff88007a92bae8
[   31.419746]  ffff88007935fd38 ffff8800792ea800 ffff88007a92bae8
ffff8800792ea800
[   31.419746]  ffff8800792ea870 ffff8800792ea870 ffff88007935fd68
ffffffff81224a8e
[   31.419746] Call Trace:
[   31.419746]  [<ffffffff81224a8e>] sysfs_create_group+0xe/0x10
[   31.419746]  [<ffffffff8113f2a4>] blk_trace_init_sysfs+0x14/0x20
[   31.419746]  [<ffffffff81345320>] blk_register_queue+0x100/0x130
[   31.419746]  [<ffffffff8134ca68>] add_disk+0x358/0x4b0
[   31.419746]  [<ffffffff814f7a27>] loop_add+0x1d7/0x220
[   31.419746]  [<ffffffff814f9295>] loop_control_ioctl+0x65/0x170
[   31.419746]  [<ffffffff811b9542>] do_vfs_ioctl+0x522/0x570
[   31.419746]  [<ffffffff8130a4b3>] ? file_has_perm+0x83/0xa0
[   31.419746]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
[   31.419746]  [<ffffffff813663fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   31.419746]  [<ffffffff81faed69>] system_call_fastpath+0x16/0x1b
[   31.419746] Code: 00 00 00 66 90 55 48 89 e5 41 57 41 56 41 89 f6
41 55 49 89 d5 41 54 53 48 83 ec 28 85 f6 48 89 7d b8 75 11 48 83 7f
30 00 75 19 <0f> 0b 0f 1f 84 00 00 00 00 00 48 8b 45 b8 48 83 78 30 00
0f 84
[   31.419746] RIP  [<ffffffff81224886>] internal_create_group+0x26/0x220
[   31.419746]  RSP <ffff88007935fd08>
[   31.471213] ---[ end trace f722dfd576c9fd94 ]---


> I'd rather just warn there anyway, sysfs shouldn't be calling BUG on
> anything, it should always be able to recover and just return errors.
>
> thanks,
>
> greg k-h
