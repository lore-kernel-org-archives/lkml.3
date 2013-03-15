Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3COQ1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 12:27:39 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44678 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3COQ1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 12:27:38 -0400
Message-ID: <51434C07.9050407@gmail.com>
Date: Fri, 15 Mar 2013 12:27:51 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: use after free in sysfs_find_dirent
References: <20130307052854.GA23745@redhat.com> <20130307060230.GA31738@kroah.com> <20130307062626.GA25095@redhat.com> <51429D7A.30906@gmail.com> <5142ABD3.4040106@gmail.com> <CACVXFVOZ=3WwnTPbi66Crgg1azqHMMYiRQ9YcEgrh_e65MLH1Q@mail.gmail.com>
In-Reply-To: <CACVXFVOZ=3WwnTPbi66Crgg1azqHMMYiRQ9YcEgrh_e65MLH1Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 03:38 AM, Ming Lei wrote:
> Hi,
> 
> On Fri, Mar 15, 2013 at 1:04 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>> On 03/15/2013 12:03 AM, Sasha Levin wrote:
>>>
>>> [  350.140100] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>>> [  350.141468] Dumping ftrace buffer:
>>> [  350.142048]    (ftrace buffer empty)
>>> [  350.142619] Modules linked in:
>>> [  350.143128] CPU 0
>>> [  350.143434] Pid: 25064, comm: trinity-child14 Tainted: G        W    3.9.0-rc2-next-20130314-sasha-00046-g3897511 #295
>>> [  350.145415] RIP: 0010:[<ffffffff819ebfb3>]  [<ffffffff819ebfb3>] rb_next+0x23/0x60
>>> [  350.146680] RSP: 0018:ffff88007b9dde48  EFLAGS: 00010202
>>> [  350.147528] RAX: 6b6b6b6b6b6b6b6b RBX: ffff8800b8524b70 RCX: ffff8800b8524b70
>>> [  350.148738] RDX: 6b6b6b6b6b6b6b6b RSI: ffff8800b63b96e0 RDI: ffff8800b8524bb8
>>> [  350.149939] RBP: ffff88007b9dde48 R08: 2222222222222222 R09: 2222222222222222
>>> [  350.150035] R10: 2222222222222222 R11: 0000000000000000 R12: ffff88008c5cb180
>>> [  350.150035] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000010
>>> [  350.150035] FS:  00007fec4eae2700(0000) GS:ffff8800bb800000(0000) knlGS:0000000000000000
>>> [  350.150035] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  350.150035] CR2: 0000000000000001 CR3: 000000007c32d000 CR4: 00000000000406f0
>>> [  350.150035] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [  350.150035] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> [  350.150035] Process trinity-child14 (pid: 25064, threadinfo ffff88007b9dc000, task ffff880096413000)
>>> [  350.150035] Stack:
>>> [  350.150035]  ffff88007b9ddeb8 ffffffff812fa959 2222222222222222 2222222200000008
>>> [  350.150035]  000000000000293e ffffffff8128cca0 ffff88007b9ddf28 ffff8800b63b96e0
>>> [  350.150035]  ffff8800a14e9b78 ffff88008c5cb180 ffff88007b9ddf28 ffffffff8128cca0
>>> [  350.150035] Call Trace:
>>> [  350.150035]  [<ffffffff812fa959>] sysfs_readdir+0x219/0x280
>>> [  350.150035]  [<ffffffff8128cca0>] ? filldir+0x100/0x100
>>> [  350.150035]  [<ffffffff8128cca0>] ? filldir+0x100/0x100
>>> [  350.150035]  [<ffffffff8128cf18>] vfs_readdir+0x78/0xc0
>>> [  350.150035]  [<ffffffff8117ad3d>] ? trace_hardirqs_on+0xd/0x10
>>> [  350.150035]  [<ffffffff8128d190>] SyS_getdents64+0x90/0x120
>>> [  350.150035]  [<ffffffff83d946d8>] tracesys+0xe1/0xe6
>>> [  350.150035] Code: 85 d2 75 f4 5d c3 66 90 55 31 c0 48 8b 17 48 89 e5 48 39 d7 74 4a 48 8b 47 08 48 85 c0 75 0c eb 17 0f 1f 80
>>> 00 00 00 00 48 89 d0 <48> 8b 50 10 48 85 d2 75 f4 eb 2a 66 90 48 89 d1 48 83 e1 fc 74
>>> [  350.150035] RIP  [<ffffffff819ebfb3>] rb_next+0x23/0x60
>>> [  350.150035]  RSP <ffff88007b9dde48>
>>> [  350.179705] ---[ end trace a39f58a515b594d5 ]---
>>
>> And on the bright side, unlike in Dave's case, similar issues reproduce rather easily
>> over here:
> 
> Could you share how to reproduce that easily?

Reproduces easily with trinity, didn't look into manually doing it yet.

Thought it looks like the dir is going away while we're listing the directory,
so I assume it would be easy to reproduce if we put a short delay into sysfs_dir_next_pos
and remove the directory underneath? I can try that later today/tomorrow.


Thanks,
Sasha

