Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab3CPPHo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 11:07:44 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65476 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab3CPPHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 11:07:43 -0400
Message-ID: <51448AC9.7080105@gmail.com>
Date: Sat, 16 Mar 2013 11:07:53 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Hillf Danton <dhillf@gmail.com>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: use after free in sysfs_find_dirent
References: <20130307052854.GA23745@redhat.com> <20130307060230.GA31738@kroah.com> <20130307062626.GA25095@redhat.com> <51429D7A.30906@gmail.com> <5142ABD3.4040106@gmail.com> <CAJd=RBAQ9hxY64R7bn_3-jJ2ey8hMGa+Tm2hQVAosgLdRRtd9g@mail.gmail.com> <CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com>
In-Reply-To: <CACVXFVN5GOa3wLsVgNu2hyymgMtB9aWMPyKzNsAV+9c8=fxM7A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2013 09:30 AM, Ming Lei wrote:
> On Sat, Mar 16, 2013 at 8:39 PM, Hillf Danton <dhillf@gmail.com> wrote:
>> init rb node before use due to empty node checked by rb_next().
>>
>> --- a/fs/sysfs/dir.c    Sat Mar 16 20:12:16 2013
>> +++ b/fs/sysfs/dir.c    Sat Mar 16 20:37:10 2013
>> @@ -396,6 +396,7 @@ struct sysfs_dirent *sysfs_new_dirent(co
>>
>>         atomic_set(&sd->s_count, 1);
>>         atomic_set(&sd->s_active, 0);
>> +       rb_init_node(&sd->s_rb);
> 
> Looks there is no the symbol in linus tree, and not necessary since
> rb_link_node() may initialize the node correctly.
> 
> Also I can't reproduce the problem on my Pandaboard with trinity, maybe
> the below debug code can find the name of the affected node if anyone
> would like to test it.

Hi Ming,

With your patch:


[ 1525.874312] release_sysfs_dirent sysfs_dirent use after free: ptysb-uevent
[ 1529.025850] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 1529.027158] Dumping ftrace buffer:
[ 1529.028070]    (ftrace buffer empty)
[ 1529.028964] Modules linked in:
[ 1529.029524] CPU 1
[ 1529.029870] Pid: 3945, comm: trinity-child55 Tainted: G        W    3.9.0-rc2-next-20130315-sasha-00046-gecde602-dirty #300
[ 1529.030039] RIP: 0010:[<ffffffff812f9300>]  [<ffffffff812f9300>] sysfs_find_dirent+0xa0/0x120
[ 1529.030039] RSP: 0018:ffff88009693dbf8  EFLAGS: 00010202
[ 1529.030039] RAX: 00000000144bc5af RBX: 0000000000000000 RCX: 0000000000000000
[ 1529.030039] RDX: 00000000144bc5af RSI: 0000000000000000 RDI: 00000000ffb7311a
[ 1529.030039] RBP: ffff88009693dc28 R08: 0000000000000000 R09: 0000000000000000
[ 1529.030039] R10: 2222222222222222 R11: 0000000000000000 R12: 6b6b6b6b6b6b6b6b
[ 1529.030039] R13: 000000007fb7311a R14: ffff8800b4a443d0 R15: ffff88006db60978
[ 1529.030039] FS:  00007ff6ccfd1700(0000) GS:ffff8800bba00000(0000) knlGS:0000000000000000
[ 1529.030039] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1529.030039] CR2: 0000000000000000 CR3: 000000006dcef000 CR4: 00000000000406e0
[ 1529.030039] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1529.030039] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1529.030039] Process trinity-child55 (pid: 3945, threadinfo ffff88009693c000, task ffff880085683000)
[ 1529.030039] Stack:
[ 1529.030039]  fffffffffffffffe ffff88006db60940 ffff8800a39f3fc0 ffff8800b4a45ab0
[ 1529.030039]  fffffffffffffffe 0000000000000078 ffff88009693dc58 ffffffff812f93e9
[ 1529.030039]  ffff88006db60940 ffff8800a39fa9a0 ffff8800a39fa9a0 0000000000000000
[ 1529.030039] Call Trace:
[ 1529.030039]  [<ffffffff812f93e9>] sysfs_lookup+0x69/0xf0
[ 1529.030039]  [<ffffffff8128232e>] lookup_real+0x2e/0x60
[ 1529.030039]  [<ffffffff81282713>] __lookup_hash+0x33/0x40
[ 1529.030039]  [<ffffffff83cff60d>] lookup_slow+0x42/0xa8
[ 1529.030039]  [<ffffffff812839e5>] ? getname_flags+0x55/0x1a0
[ 1529.030039]  [<ffffffff81284d22>] path_lookupat+0xf2/0x770
[ 1529.030039]  [<ffffffff83cfe1bc>] ? __slab_alloc.isra.34+0x2ed/0x31f
[ 1529.030039]  [<ffffffff81179958>] ? trace_hardirqs_on_caller+0x168/0x1a0
[ 1529.030039]  [<ffffffff812853cf>] filename_lookup+0x2f/0xc0
[ 1529.030039]  [<ffffffff812839e5>] ? getname_flags+0x55/0x1a0
[ 1529.030039]  [<ffffffff8128550d>] do_path_lookup+0x2d/0x30
[ 1529.030039]  [<ffffffff81285775>] kern_path+0x25/0x50
[ 1529.030039]  [<ffffffff81283a13>] ? getname_flags+0x83/0x1a0
[ 1529.030039]  [<ffffffff812b4af7>] lookup_bdev+0x27/0x90
[ 1529.030039]  [<ffffffff81283b3d>] ? getname+0xd/0x10
[ 1529.030039]  [<ffffffff812e14c3>] quotactl_block+0x33/0xf0
[ 1529.030039]  [<ffffffff812e1f03>] SyS_quotactl+0xe3/0x150
[ 1529.030039]  [<ffffffff83d919d8>] tracesys+0xe1/0xe6
[ 1529.030039] Code: 8e 00 00 00 0f 1f 80 00 00 00 00 4c 89 fe 48 89 df 45 31 f6 e8 d2 ee ff ff 4d 85 e4 41 89 c5 74 71 66 2e 0f
1f 84 00 00 00 00 00 <41> 8b 44 24 28 4d 8d 74 24 b8 41 39 c5 74 11 44 89 ea 29 c2 89
[ 1529.030039] RIP  [<ffffffff812f9300>] sysfs_find_dirent+0xa0/0x120
[ 1529.030039]  RSP <ffff88009693dbf8>


Thanks,
Sasha
