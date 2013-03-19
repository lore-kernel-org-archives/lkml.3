Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab3CSCGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:06:18 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:45924 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab3CSCGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:06:16 -0400
Message-ID: <5147C821.6070703@gmail.com>
Date: Mon, 18 Mar 2013 22:06:25 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Hillf Danton <dhillf@gmail.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: use after free in sysfs_find_dirent
References: <20130307052854.GA23745@redhat.com> <20130307060230.GA31738@kroah.com> <20130307062626.GA25095@redhat.com> <51429D7A.30906@gmail.com> <5142ABD3.4040106@gmail.com> <CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com> <CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com> <51448AC9.7080105@gmail.com> <CACVXFVNDSRnG4avn7YdMQFXbQ7B_ONo79jmhWVGzjqEWGTMWYg@mail.gmail.com> <CACVXFVNCGBAYLbbpE1sBiXFNkJpRxVzY44y3Vok+GA9C0MKr3w@mail.gmail.com> <5144BB15.3020002@gmail.com> <CACVXFVOKi=wKsLP850XJ95P=e1B2z+CP=t0GATCZL0gNDOCwnA@mail.gmail.com> <5145D236.70203@gmail.com> <CACVXFVP7XHO8sT68ETam=R-+cbPjSGqz_xfnt30OiSPEuC4-Sg@mail.gmail.com>
In-Reply-To: <CACVXFVP7XHO8sT68ETam=R-+cbPjSGqz_xfnt30OiSPEuC4-Sg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2013 12:23 PM, Ming Lei wrote:
> On Sun, Mar 17, 2013 at 10:24 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>>
>> I still see it going on with the patch applied:
> 
> Looks the previous patch still has the race problem, so could you just
> apply the attachment patch and cancel all previous patches for the
> test? If there is still the problem, please post out the log.
> 
> BTW, the attachment patch is only for verifying if the current problem
> is caused by 'filp->private_data' race, and not for merge.

[  232.822703] sysfs_dir_pos-973 sysfs_dirent use after free: vx855(vx855)-bind, 0-25520352
[  232.824100] release_sysfs_dirent-285 sysfs_dirent use after free: vx855-bind
[  232.825297] Pid: 22751, comm: trinity-child99 Tainted: G        W    3.9.0-rc2-next-20130318-sasha-00041-g7b66226-dirty #304
[  232.827141] Call Trace:
[  232.827566]  [<ffffffff812fa0a3>] release_sysfs_dirent+0x53/0x120
[  232.828545]  [<ffffffff812fa26a>] sysfs_dir_pos+0x9a/0x140
[  232.829498]  [<ffffffff812fa41b>] sysfs_readdir+0x10b/0x230
[  232.830765]  [<ffffffff8128c900>] ? filldir+0x100/0x100
[  232.831644]  [<ffffffff8128c900>] ? filldir+0x100/0x100
[  232.832490]  [<ffffffff8128cb78>] vfs_readdir+0x78/0xc0
[  232.833327]  [<ffffffff8117ac7d>] ? trace_hardirqs_on+0xd/0x10
[  232.834313]  [<ffffffff8128cdf0>] SyS_getdents64+0x90/0x120
[  232.835242]  [<ffffffff83d94d98>] tracesys+0xe1/0xe6
[  233.906761] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  233.907976] Dumping ftrace buffer:
[  233.908522]    (ftrace buffer empty)
[  233.909186] Modules linked in:
[  233.909741] CPU 2
[  233.910037] Pid: 17193, comm: trinity-child57 Tainted: G        W    3.9.0-rc2-next-20130318-sasha-00041-g7b66226-dirty #304
[  233.910037] RIP: 0010:[<ffffffff812fab70>]  [<ffffffff812fab70>] sysfs_find_dirent+0xa0/0x120
[  233.910037] RSP: 0018:ffff880099211bf8  EFLAGS: 00010202
[  233.910037] RAX: 000000009651d576 RBX: 0000000000000000 RCX: 0000000000000000
[  233.910037] RDX: 000000009651d576 RSI: 0000000000000000 RDI: 0000000001bd40e1
[  233.910037] RBP: ffff880099211c28 R08: 0000000000000000 R09: 0000000000000000
[  233.910037] R10: 2222222222222222 R11: 0000000000000000 R12: 6b6b6b6b6b6b6b6b
[  233.910037] R13: 0000000001bd40e1 R14: ffff8800b12eb4f8 R15: ffff8800817bfc58
[  233.910037] FS:  00007f7dd41f8700(0000) GS:ffff8800bbc00000(0000) knlGS:0000000000000000
[  233.910037] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  233.910037] CR2: 0000000000000008 CR3: 000000009ceb4000 CR4: 00000000000406e0
[  233.910037] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  233.910037] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  233.910037] Process trinity-child57 (pid: 17193, threadinfo ffff880099210000, task ffff88009c1eb000)
[  233.910037] Stack:
[  233.910037]  fffffffffffffffe ffff8800817bfc20 ffff8800a5d79540 ffff8800b12ea3d0
[  233.910037]  fffffffffffffffe 0000000000000000 ffff880099211c58 ffffffff812fac59
[  233.910037]  ffff8800817bfc20 ffff8800a5d6f530 ffff8800a5d6f530 0000000000000000
[  233.910037] Call Trace:
[  233.910037]  [<ffffffff812fac59>] sysfs_lookup+0x69/0xf0
[  233.910037]  [<ffffffff81283abe>] lookup_real+0x2e/0x60
[  233.910037]  [<ffffffff81283ea3>] __lookup_hash+0x33/0x40
[  233.910037]  [<ffffffff83d02bcd>] lookup_slow+0x42/0xa8
[  233.910037]  [<ffffffff81285175>] ? getname_flags+0x55/0x1a0
[  233.910037]  [<ffffffff812864b2>] path_lookupat+0xf2/0x770
[  233.910037]  [<ffffffff83d0177c>] ? __slab_alloc.isra.34+0x2ed/0x31f
[  233.910037]  [<ffffffff8117ac38>] ? trace_hardirqs_on_caller+0x168/0x1a0
[  233.910037]  [<ffffffff81286b5f>] filename_lookup+0x2f/0xc0
[  233.910037]  [<ffffffff81285175>] ? getname_flags+0x55/0x1a0
[  233.910037]  [<ffffffff81286c9d>] do_path_lookup+0x2d/0x30
[  233.910037]  [<ffffffff81286f05>] kern_path+0x25/0x50
[  233.910037]  [<ffffffff812851a3>] ? getname_flags+0x83/0x1a0
[  233.910037]  [<ffffffff812b6387>] lookup_bdev+0x27/0x90
[  233.910037]  [<ffffffff812852cd>] ? getname+0xd/0x10
[  233.910037]  [<ffffffff812e2d53>] quotactl_block+0x33/0xf0
[  233.910037]  [<ffffffff812e3793>] SyS_quotactl+0xe3/0x150
[  233.910037]  [<ffffffff83d94d98>] tracesys+0xe1/0xe6
[  233.910037] Code: 8e 00 00 00 0f 1f 80 00 00 00 00 4c 89 fe 48 89 df 45 31 f6 e8 f2 ee ff ff 4d 85 e4 41 89 c5 74 71 66 2e 0f
1f 84 00 00 00 00 00 <41> 8b 44 24 28 4d 8d 74 24 b8 41 39 c5 74 11 44 89 ea 29 c2 89
[  233.910037] RIP  [<ffffffff812fab70>] sysfs_find_dirent+0xa0/0x120
[  233.910037]  RSP <ffff880099211bf8>
[  233.973905] ---[ end trace a80e42d248abaa1f ]---


Thanks,
Sasha
