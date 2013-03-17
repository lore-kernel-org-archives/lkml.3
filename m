Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab3CQOYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 10:24:46 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:65248 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3CQOYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 10:24:43 -0400
Message-ID: <5145D236.70203@gmail.com>
Date: Sun, 17 Mar 2013 10:24:54 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Hillf Danton <dhillf@gmail.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: use after free in sysfs_find_dirent
References: <20130307052854.GA23745@redhat.com> <20130307060230.GA31738@kroah.com> <20130307062626.GA25095@redhat.com> <51429D7A.30906@gmail.com> <5142ABD3.4040106@gmail.com> <CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com> <CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com> <51448AC9.7080105@gmail.com> <CACVXFVNDSRnG4avn7YdMQFXbQ7B_ONo79jmhWVGzjqEWGTMWYg@mail.gmail.com> <CACVXFVNCGBAYLbbpE1sBiXFNkJpRxVzY44y3Vok+GA9C0MKr3w@mail.gmail.com> <5144BB15.3020002@gmail.com> <CACVXFVOKi=wKsLP850XJ95P=e1B2z+CP=t0GATCZL0gNDOCwnA@mail.gmail.com>
In-Reply-To: <CACVXFVOKi=wKsLP850XJ95P=e1B2z+CP=t0GATCZL0gNDOCwnA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2013 09:02 PM, Ming Lei wrote:
> On Sun, Mar 17, 2013 at 2:33 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
>>
>> I don't think it shows what we want it to show thought:
>>
>> [  327.416905] Pid: 10504, comm: trinity-child98 Tainted: G        W    3.9.0-rc2-next-20130315-sasha-00046-gecde602-dirty #301
>> [  327.418815] Call Trace:
>> [  327.419255]  [<ffffffff812f880e>] release_sysfs_dirent+0x4e/0x120
>> [  327.420595]  [<ffffffff812f89d2>] sysfs_dir_pos+0x92/0x130
>> [  327.421608]  [<ffffffff812f8b8d>] sysfs_readdir+0x11d/0x280
>> [  327.422562]  [<ffffffff8128b070>] ? SyS_ioctl+0xa0/0xa0
>> [  327.423441]  [<ffffffff8128b070>] ? SyS_ioctl+0xa0/0xa0
>> [  327.424314]  [<ffffffff8128b3e8>] vfs_readdir+0x78/0xc0
>> [  327.425263]  [<ffffffff8128b54c>] SyS_getdents+0x8c/0x110
>> [  327.426173]  [<ffffffff83d919d8>] tracesys+0xe1/0xe6
>>
> 
> Sasha, looks there is a race when sys_readdir() is run concurrently
> on same directory, and the below patch may fix the race, could you test the
> attachment patch to see if the use after free can be fixed?

I still see it going on with the patch applied:


[  521.881968] release_sysfs_dirent sysfs_dirent use after free: altera_jtaguart-bind
[  521.883202] Pid: 29624, comm: trinity-child51 Tainted: G        W    3.9.0-rc2-next-20130315-sasha-00046-gecde602-dirty #302
[  521.885030] Call Trace:
[  521.885503]  [<ffffffff812f880e>] release_sysfs_dirent+0x4e/0x120
[  521.886559]  [<ffffffff812f89d2>] sysfs_dir_pos+0x92/0x130
[  521.887514]  [<ffffffff812f8bd4>] sysfs_readdir+0x164/0x2c0
[  521.888403]  [<ffffffff8128b170>] ? filldir+0x100/0x100
[  521.889241]  [<ffffffff8128b170>] ? filldir+0x100/0x100
[  521.890222]  [<ffffffff8128b3e8>] vfs_readdir+0x78/0xc0
[  521.891028]  [<ffffffff8117999d>] ? trace_hardirqs_on+0xd/0x10
[  521.891976]  [<ffffffff8128b660>] SyS_getdents64+0x90/0x120
[  521.892831]  [<ffffffff83d91a18>] tracesys+0xe1/0xe6
[  526.910352] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  526.911625] Dumping ftrace buffer:
[  526.912158]    (ftrace buffer empty)
[  526.912715] Modules linked in:
[  526.913213] CPU 3
[  526.913521] Pid: 374, comm: trinity-child86 Tainted: G        W    3.9.0-rc2-next-20130315-sasha-00046-gecde602-dirty #302
[  526.915342] RIP: 0010:[<ffffffff812f8a10>]  [<ffffffff812f8a10>] sysfs_dir_pos+0xd0/0x130
[  526.916622] RSP: 0018:ffff88008caa9e18  EFLAGS: 00010202
[  526.917453] RAX: 6b6b6b6b6b6b6b6b RBX: ffff8800b417d128 RCX: ffff8800b417cb70
[  526.918525] RDX: 000000006b6b6b6b RSI: ffff8800b417c988 RDI: 0000000000000000
[  526.919579] RBP: ffff88008caa9e48 R08: 2222222222222222 R09: 2222222222222222
[  526.920058] R10: 2222222222222222 R11: 0000000000000000 R12: 0000000000000000
[  526.920058] R13: 0000000049619f4a R14: ffff8800b417c988 R15: 0000000000000000
[  526.920058] FS:  00007fd9e349b700(0000) GS:ffff8800bbe00000(0000) knlGS:0000000000000000
[  526.920058] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  526.920058] CR2: 0000000100000000 CR3: 0000000084c61000 CR4: 00000000000406e0
[  526.920058] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  526.920058] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  526.920058] Process trinity-child86 (pid: 374, threadinfo ffff88008caa8000, task ffff880082a63000)
[  526.920058] Stack:
[  526.920058]  ffff8800a4d26088 ffff88008dc7f180 ffff88008dc7f180 0000000000000000
[  526.920058]  ffff8800a4d26088 ffff8800a4d25fa0 ffff88008caa9eb8 ffffffff812f8bd4
[  526.920058]  2222222222222222 2222222222222222 ffff88008caa9e98 ffffffff8128b170
[  526.920058] Call Trace:
[  526.920058]  [<ffffffff812f8bd4>] sysfs_readdir+0x164/0x2c0
[  526.920058]  [<ffffffff8128b170>] ? filldir+0x100/0x100
[  526.920058]  [<ffffffff8128b170>] ? filldir+0x100/0x100
[  526.920058]  [<ffffffff8128b3e8>] vfs_readdir+0x78/0xc0
[  526.920058]  [<ffffffff8117999d>] ? trace_hardirqs_on+0xd/0x10
[  526.920058]  [<ffffffff8128b660>] SyS_getdents64+0x90/0x120
[  526.920058]  [<ffffffff83d91a18>] tracesys+0xe1/0xe6
[  526.920058] Code: 44 00 00 48 85 db 74 6d 4c 39 63 68 75 45 eb 65 0f 1f 00 49 81 fd fe ff ff 7f 7f 59 49 8b 86 88 00 00 00 48
85 c0 74 4d 0f 1f 00 <8b> 50 28 48 8d 58 b8 49 39 d5 7d 0c 48 8b 40 10 eb 0c 66 0f 1f
[  526.920058] RIP  [<ffffffff812f8a10>] sysfs_dir_pos+0xd0/0x130
[  526.920058]  RSP <ffff88008caa9e18>
[  526.946105] ---[ end trace ec3353999032c934 ]---
