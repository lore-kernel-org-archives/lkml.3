Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108Ab3CSQ2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:28:46 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:60627 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab3CSQ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:28:44 -0400
Message-ID: <51489242.9020801@gmail.com>
Date: Tue, 19 Mar 2013 12:28:50 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Hillf Danton <dhillf@gmail.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: use after free in sysfs_find_dirent
References: <20130307052854.GA23745@redhat.com> <20130307060230.GA31738@kroah.com> <20130307062626.GA25095@redhat.com> <51429D7A.30906@gmail.com> <5142ABD3.4040106@gmail.com> <CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com> <CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com> <51448AC9.7080105@gmail.com> <CACVXFVNDSRnG4avn7YdMQFXbQ7B_ONo79jmhWVGzjqEWGTMWYg@mail.gmail.com> <CACVXFVNCGBAYLbbpE1sBiXFNkJpRxVzY44y3Vok+GA9C0MKr3w@mail.gmail.com> <5144BB15.3020002@gmail.com> <CACVXFVOKi=wKsLP850XJ95P=e1B2z+CP=t0GATCZL0gNDOCwnA@mail.gmail.com> <5145D236.70203@gmail.com> <CACVXFVP7XHO8sT68ETam=R-+cbPjSGqz_xfnt30OiSPEuC4-Sg@mail.gmail.com> <5147C821.6070703@gmail.com> <CACVXFVNMtY5tvAvyqyAyYRwBzfTtZKkDambDUTUNYwd0Q3XkXA@mail.gmail.com> <CACVXFVPV3mq=k-AZ1bYkAMdxwXD96Ty7DYeh9H9J=yvA4m=rGA@mail.gmail.com>
In-Reply-To: <CACVXFVPV3mq=k-AZ1bYkAMdxwXD96Ty7DYeh9H9J=yvA4m=rGA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 07:54 AM, Ming Lei wrote:
> Hi Sasha,
> 
> On Tue, Mar 19, 2013 at 11:40 AM, Ming Lei <tom.leiming@gmail.com> wrote:
>> Hi Sasha,
>>
>> On Tue, Mar 19, 2013 at 10:06 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
>>> [  232.822703] sysfs_dir_pos-973 sysfs_dirent use after free: vx855(vx855)-bind, 0-25520352
>>
>> Looks filp->f_pos is changed as zero by llseek(), so may leave
>> filp->private_data
>> point to one refcount-balanced sysfs_dirent object, which will be put
>> again afterwards.
>>
>> Hope we are luck this time, please try the attachment patch.
> 
> Looks the better and simpler way is to hold the i_mutex for llseek.
> If you haven't test the v2, please ignore it and just test the attachment
> v3 patch.

With v3 of the patch:

[ 1275.665758] sysfs_dir_pos-973 sysfs_dirent use after free: tun(tun)-uevent, 2-1472641949
[ 1275.667234] release_sysfs_dirent-285 sysfs_dirent use after free: tun-uevent
[ 1275.668347] Pid: 13795, comm: trinity-child62 Tainted: G        W    3.9.0-rc3-next-20130319-sasha-00041-g22d0dce-dirty #305
[ 1275.696032] Call Trace:
[ 1275.696529]  [<ffffffff812fa373>] release_sysfs_dirent+0x53/0x120
[ 1275.697593]  [<ffffffff812fa53a>] sysfs_dir_pos+0x9a/0x140
[ 1275.698551]  [<ffffffff812fa6fd>] sysfs_readdir+0x11d/0x280
[ 1275.699512]  [<ffffffff8128ca00>] ? SyS_ioctl+0xa0/0xa0
[ 1275.700586]  [<ffffffff8128ca00>] ? SyS_ioctl+0xa0/0xa0
[ 1275.701482]  [<ffffffff8128cd78>] vfs_readdir+0x78/0xc0
[ 1275.702333]  [<ffffffff8128cedc>] SyS_getdents+0x8c/0x110
[ 1275.703242]  [<ffffffff83da13d8>] tracesys+0xe1/0xe6
[ 1275.710567] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 1275.711796] Dumping ftrace buffer:
[ 1275.712423]    (ftrace buffer empty)
[ 1275.712993] Modules linked in:
[ 1275.713518] CPU 0
[ 1275.713830] Pid: 13795, comm: trinity-child62 Tainted: G        W    3.9.0-rc3-next-20130319-sasha-00041-g22d0dce-dirty #305
[ 1275.717622] RIP: 0010:[<ffffffff819eccf3>]  [<ffffffff819eccf3>] rb_next+0x23/0x60
[ 1275.718775] RSP: 0018:ffff880065349e58  EFLAGS: 00010202
[ 1275.719618] RAX: 6b6b6b6b6b6b6b6b RBX: ffff8800af811ab0 RCX: ffff8800af811ab0
[ 1275.720046] RDX: 6b6b6b6b6b6b6b6b RSI: ffff8800afff8f40 RDI: ffff8800af811af8
[ 1275.720046] RBP: ffff880065349e58 R08: 2222222222222222 R09: 2222222222222222
[ 1275.720046] R10: 2222222222222222 R11: 0000000000000000 R12: ffff88009c642100
[ 1275.720046] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000009
[ 1275.720046] FS:  00007faf86d64700(0000) GS:ffff8800bb800000(0000) knlGS:0000000000000000
[ 1275.720046] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1275.720046] CR2: 0000000001e3b228 CR3: 000000007207e000 CR4: 00000000000406f0
[ 1275.720046] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1275.720046] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1275.720046] Process trinity-child62 (pid: 13795, threadinfo ffff880065348000, task ffff880065240000)
[ 1275.720046] Stack:
[ 1275.720046]  ffff880065349ec8 ffffffff812fa7f9 2222222222222222 222222220000000a
[ 1275.720046]  000000000000c3e5 ffffffff8128ca00 ffff880065349f28 ffff8800afff8f40
[ 1275.720046]  ffff8800a31c65d8 ffff88009c642100 ffff880065349f28 ffffffff8128ca00
[ 1275.720046] Call Trace:
[ 1275.720046]  [<ffffffff812fa7f9>] sysfs_readdir+0x219/0x280
[ 1275.720046]  [<ffffffff8128ca00>] ? SyS_ioctl+0xa0/0xa0
[ 1275.720046]  [<ffffffff8128ca00>] ? SyS_ioctl+0xa0/0xa0
[ 1275.720046]  [<ffffffff8128cd78>] vfs_readdir+0x78/0xc0
[ 1275.720046]  [<ffffffff8128cedc>] SyS_getdents+0x8c/0x110
[ 1275.720046]  [<ffffffff83da13d8>] tracesys+0xe1/0xe6
[ 1275.720046] Code: 85 d2 75 f4 5d c3 66 90 55 31 c0 48 8b 17 48 89 e5 48 39 d7 74 4a 48 8b 47 08 48 85 c0 75 0c eb 17 0f 1f 80 00
00 00 00 48 89 d0 <48> 8b 50 10 48 85 d2 75 f4 eb 2a 66 90 48 89 d1 48 83 e1 fc 74
[ 1275.720046] RIP  [<ffffffff819eccf3>] rb_next+0x23/0x60
[ 1275.720046]  RSP <ffff880065349e58>

Thanks,
Sasha
