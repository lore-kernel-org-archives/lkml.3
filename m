Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab3COFEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:04:13 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:49273 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3COFEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:04:06 -0400
Message-ID: <5142ABD3.4040106@gmail.com>
Date: Fri, 15 Mar 2013 01:04:19 -0400
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130310 Thunderbird/17.0.4
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: use after free in sysfs_find_dirent
References: <20130307052854.GA23745@redhat.com> <20130307060230.GA31738@kroah.com> <20130307062626.GA25095@redhat.com> <51429D7A.30906@gmail.com>
In-Reply-To: <51429D7A.30906@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2013 12:03 AM, Sasha Levin wrote:
> On 03/07/2013 01:26 AM, Dave Jones wrote:
>> On Thu, Mar 07, 2013 at 02:02:30PM +0800, Greg Kroah-Hartman wrote:
>>  > On Thu, Mar 07, 2013 at 12:28:54AM -0500, Dave Jones wrote:
>>  > > general protection fault: 0000 [#1] PREEMPT SMP 
>>  > > Modules linked in: vmw_vsock_vmci_transport vmw_vmci vsock bnep fuse rfcomm hidp l2tp_ppp l2tp_core 8021q garp mrp dlci pppoe pppox ppp_generic slhc scsi_transport_iscsi rose caif_socket caif can_raw bridge af_key can_bcm llc2 stp can netrom phonet af_rxrpc nfnetlink ipt_ULOG x25 rds irda crc_ccitt ax25 ipx p8023 p8022 decnet atm appletalk psnap llc nfc lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm btusb snd_page_alloc bluetooth snd_timer snd microcode rfkill usb_debug serio_raw pcspkr edac_core soundcore vhost_net tun r8169 macvtap macvlan mii kvm_amd kvm
>>  > > CPU 0 
>>  > > Pid: 23476, comm: trinity-child1 Not tainted 3.9.0-rc1+ #69 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
>>  > > RIP: 0010:[<ffffffff812356b7>]  [<ffffffff812356b7>] sysfs_find_dirent+0x47/0xf0
>>  > > RSP: 0018:ffff88000585bd68  EFLAGS: 00010202
>>  > > RAX: 0000000094be55f6 RBX: 6b6b6b6b6b6b6b6b RCX: 000000006b6b6b6b
>>  > > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
>>  > > RBP: ffff88000585bd88 R08: 0000000000000000 R09: 0000000000000000
>>  > > R10: 0000000000000000 R11: 0000000000000000 R12: 000000000029c161
>>  > > R13: ffff8800a8918288 R14: 0000000000000000 R15: 0000000000000009
>>  > > FS:  00007fa12651e740(0000) GS:ffff88012ae00000(0000) knlGS:0000000000000000
>>  > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>  > > CR2: 0000000000000010 CR3: 000000001a128000 CR4: 00000000000007f0
>>  > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>  > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>  > > Process trinity-child1 (pid: 23476, threadinfo ffff88000585a000, task ffff8800cd454920)
>>  > > Stack:
>>  > >  ffff880128edc1e8 ffff8800a8918250 fffffffffffffffe ffff88012265f430
>>  > >  ffff88000585bdb8 ffffffff812357cd ffff8800a8918250 ffff8801226514d0
>>  > >  ffff88000585bf38 0000000000000000 ffff88000585bde8 ffffffff811bb30d
>>  > > Call Trace:
>>  > >  [<ffffffff812357cd>] sysfs_lookup+0x6d/0xe0
>>  > >  [<ffffffff811bb30d>] lookup_real+0x1d/0x60
>>  > >  [<ffffffff811bb528>] __lookup_hash+0x38/0x50
>>  > >  [<ffffffff811bb559>] lookup_hash+0x19/0x20
>>  > >  [<ffffffff811be993>] kern_path_create+0x93/0x170
>>  > >  [<ffffffff811bce46>] ? getname_flags.part.32+0x86/0x150
>>  > >  [<ffffffff811beaba>] user_path_create+0x4a/0x70
>>  > >  [<ffffffff811c1a09>] sys_mkdirat+0x39/0xe0
>>  > >  [<ffffffff816cd942>] system_call_fastpath+0x16/0x1b
>>  > > Code: 00 48 8b 9f 88 00 00 00 f6 c4 0f 0f 95 c0 48 85 f6 0f 95 c2 38 d0 75 79 4c 89 ee 4c 89 f7 e8 91 ef ff ff 41 89 c4 48 85 db 74 1d <8b> 4b 28 41 39 cc 74 21 44 89 e0 29 c8 83 f8 00 7c 2c 74 45 48 
>>  > > RIP  [<ffffffff812356b7>] sysfs_find_dirent+0x47/0xf0
>>  > >  RSP <ffff88000585bd68>
>>  > > ---[ end trace 4ba97703eaafbb8b ]---
>>  > 
>>  > Any hint as to what was happening here when this crashed?
>>
>> Given I haven't seen this (or the other sysfs bug) before today, I'm going
>> to assume it's due to one of the features I added to trinity today.
>>
>> 1. Instead of just relying on filenames it gathers from sysfs on startup,
>>    it now also generates mangled variants of them.
>>    (Appending a / followed by garbage for eg)
>>
>> 2. When a syscall wants a page of memory, it now sometimes hands it one
>>    filled with malformed UTF-8 characters.
>>
>> 3. A combo of the above, that garbage appended to a pathname may be unicode junk.
>>
>> Could be some of those that caused these bugs.
>>
>> I just retried rerunning the test a few times.  Every time I run for a while
>> I end up with different crashes.  It's raining bugs over here.
>> (Here's another sysfs one below)
>>
>> Running 'trinity -c mkdirat -V /sys' doesn't seem to trigger it, so it's an
>> interaction with something else maybe.
>>
>> The one common thing here is that 6b6b6b6b6b6b6b6b showing up in every trace,
>> suggesting a use-after-free bugs. They may all be different manifestations
>> of the same underlying bug if there's some kind of refcounting bug perhaps.
>> (This may also be why telling it to do just mkdirat isn't triggering it,
>>  if it's racing with some other operation)
>>
>> Getting this stuff easily reproducable is pretty hard. The best I can offer
>> right now is that it seems to trigger *something* bad quickly, even if it's
>> not necessarily the exact same trace.
> 
> I've hit something similar, but I suspect it's the same issue:
> 
> [  350.140100] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [  350.141468] Dumping ftrace buffer:
> [  350.142048]    (ftrace buffer empty)
> [  350.142619] Modules linked in:
> [  350.143128] CPU 0
> [  350.143434] Pid: 25064, comm: trinity-child14 Tainted: G        W    3.9.0-rc2-next-20130314-sasha-00046-g3897511 #295
> [  350.145415] RIP: 0010:[<ffffffff819ebfb3>]  [<ffffffff819ebfb3>] rb_next+0x23/0x60
> [  350.146680] RSP: 0018:ffff88007b9dde48  EFLAGS: 00010202
> [  350.147528] RAX: 6b6b6b6b6b6b6b6b RBX: ffff8800b8524b70 RCX: ffff8800b8524b70
> [  350.148738] RDX: 6b6b6b6b6b6b6b6b RSI: ffff8800b63b96e0 RDI: ffff8800b8524bb8
> [  350.149939] RBP: ffff88007b9dde48 R08: 2222222222222222 R09: 2222222222222222
> [  350.150035] R10: 2222222222222222 R11: 0000000000000000 R12: ffff88008c5cb180
> [  350.150035] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000010
> [  350.150035] FS:  00007fec4eae2700(0000) GS:ffff8800bb800000(0000) knlGS:0000000000000000
> [  350.150035] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  350.150035] CR2: 0000000000000001 CR3: 000000007c32d000 CR4: 00000000000406f0
> [  350.150035] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  350.150035] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  350.150035] Process trinity-child14 (pid: 25064, threadinfo ffff88007b9dc000, task ffff880096413000)
> [  350.150035] Stack:
> [  350.150035]  ffff88007b9ddeb8 ffffffff812fa959 2222222222222222 2222222200000008
> [  350.150035]  000000000000293e ffffffff8128cca0 ffff88007b9ddf28 ffff8800b63b96e0
> [  350.150035]  ffff8800a14e9b78 ffff88008c5cb180 ffff88007b9ddf28 ffffffff8128cca0
> [  350.150035] Call Trace:
> [  350.150035]  [<ffffffff812fa959>] sysfs_readdir+0x219/0x280
> [  350.150035]  [<ffffffff8128cca0>] ? filldir+0x100/0x100
> [  350.150035]  [<ffffffff8128cca0>] ? filldir+0x100/0x100
> [  350.150035]  [<ffffffff8128cf18>] vfs_readdir+0x78/0xc0
> [  350.150035]  [<ffffffff8117ad3d>] ? trace_hardirqs_on+0xd/0x10
> [  350.150035]  [<ffffffff8128d190>] SyS_getdents64+0x90/0x120
> [  350.150035]  [<ffffffff83d946d8>] tracesys+0xe1/0xe6
> [  350.150035] Code: 85 d2 75 f4 5d c3 66 90 55 31 c0 48 8b 17 48 89 e5 48 39 d7 74 4a 48 8b 47 08 48 85 c0 75 0c eb 17 0f 1f 80
> 00 00 00 00 48 89 d0 <48> 8b 50 10 48 85 d2 75 f4 eb 2a 66 90 48 89 d1 48 83 e1 fc 74
> [  350.150035] RIP  [<ffffffff819ebfb3>] rb_next+0x23/0x60
> [  350.150035]  RSP <ffff88007b9dde48>
> [  350.179705] ---[ end trace a39f58a515b594d5 ]---

And on the bright side, unlike in Dave's case, similar issues reproduce rather easily
over here:

[  117.001400] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  117.007659] Dumping ftrace buffer:
[  117.008300]    (ftrace buffer empty)
[  117.008885] Modules linked in:
[  117.009397] CPU 0
[  117.009700] Pid: 9168, comm: trinity-child11 Tainted: G        W    3.9.0-rc2-next-20130314-sasha-00046-g3897511 #295
[  117.010041] RIP: 0010:[<ffffffff812fa6e0>]  [<ffffffff812fa6e0>] sysfs_dir_pos+0xa0/0x100
[  117.010041] RSP: 0018:ffff8800796dde18  EFLAGS: 00010202
[  117.010041] RAX: 6b6b6b6b6b6b6b6b RBX: 0000000000000000 RCX: ffff8800b853d8c8
[  117.010041] RDX: 0000000051932d51 RSI: 000000006b6b6b6b RDI: 0000000000000000
[  117.010041] RBP: ffff8800796dde48 R08: 2222222222222222 R09: 2222222222222222
[  117.010041] R10: 2222222222222222 R11: 0000000000000000 R12: 0000000000000000
[  117.010041] R13: 0000000000000000 R14: ffff8800a4a4b0b8 R15: ffff8800a4a4afd0
[  117.010041] FS:  00007f943990a700(0000) GS:ffff8800bb800000(0000) knlGS:0000000000000000
[  117.010041] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  117.010041] CR2: 0000000000000000 CR3: 000000007bea7000 CR4: 00000000000406f0
[  117.010041] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  117.010041] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  117.010041] Process trinity-child11 (pid: 9168, threadinfo ffff8800796dc000, task ffff88008120b000)
[  117.010041] Stack:
[  117.010041]  ffff8800a4a4b0b8 ffff8800a4a4afd0 ffff8800796dde48 ffffffff83d87edf
[  117.010041]  ffff8800b853d6e0 ffff8800aa27d340 ffff8800796ddeb8 ffffffff812fa85d
[  117.010041]  2222222222222222 2222222222222222 ffff8800796dde98 ffffffff8128cca0
[  117.010041] Call Trace:
[  117.010041]  [<ffffffff83d87edf>] ? mutex_lock_nested+0x3f/0x50
[  117.010041]  [<ffffffff812fa85d>] sysfs_readdir+0x11d/0x280
[  117.010041]  [<ffffffff8128cca0>] ? filldir+0x100/0x100
[  117.010041]  [<ffffffff8128cca0>] ? filldir+0x100/0x100
[  117.010041]  [<ffffffff8128cf18>] vfs_readdir+0x78/0xc0
[  117.010041]  [<ffffffff8117ad3d>] ? trace_hardirqs_on+0xd/0x10
[  117.010041]  [<ffffffff8128d190>] SyS_getdents64+0x90/0x120
[  117.010041]  [<ffffffff83d946d8>] tracesys+0xe1/0xe6
[  117.010041] Code: 00 00 00 48 85 c9 74 6d 48 39 59 68 75 45 eb 65 0f 1f 00 48 81 fa fe ff ff 7f 7f 59 48 8b 86 88 00 00 00 48
85 c0 74 4d 0f 1f 00 <8b> 70 28 48 8d 48 b8 48 39 f2 7d 0c 48 8b 40 10 eb 0c 66 0f 1f
[  117.010041] RIP  [<ffffffff812fa6e0>] sysfs_dir_pos+0xa0/0x100
[  117.010041]  RSP <ffff8800796dde18>
[  117.058487] ---[ end trace 1a817146a00445c0 ]---


Thanks,
Sasha
