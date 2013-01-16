Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab3APAgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:36:24 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:34717 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab3APAgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:36:21 -0500
MIME-Version: 1.0
In-Reply-To: <3905799.Wx2ixLIOL7@vostro.rjw.lan>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
	<CAE9FiQW-efB2s1gdmVTy8k9NLSayAxfkTFvtzQhzL6MFBFSoWQ@mail.gmail.com>
	<2102023.Itn3WlmlaN@vostro.rjw.lan>
	<3905799.Wx2ixLIOL7@vostro.rjw.lan>
Date: Tue, 15 Jan 2013 16:36:19 -0800
X-Google-Sender-Auth: HDvQRBlw02yaQiMLYrQdG_yFHJc
Message-ID: <CAE9FiQUivk3d0L8UENMBgoqeaC3pGAg=mobjsRupHFhH0VGp7Q@mail.gmail.com>
Subject: Re: [PATCH v8 14/22] ACPI: update ej_event interface to take acpi_device
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 4:22 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, January 16, 2013 12:55:20 AM Rafael J. Wysocki wrote:
>> On Tuesday, January 15, 2013 03:43:17 PM Yinghai Lu wrote:
>> > On Tue, Jan 15, 2013 at 3:26 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > > On Monday, January 14, 2013 10:55:49 PM Yinghai Lu wrote:
> [...]
>> >
>> >
>> > looks like:
>> >
>> > acpi_device_release+0x30
>> > 0xffffffff81536e2f is in acpi_device_release (drivers/acpi/scan.c:524).
>> > 519 static void acpi_free_power_resources_lists(struct acpi_device *device)
>> > 520 {
>> > 521         int i;
>> > 522
>> > 523         acpi_power_resources_list_free(&device->wakeup.resources);
>> > 524         if (!device->flags.power_manageable)
>> > 525                 return;
>> > 526
>> > 527         for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
>> > 528                 struct acpi_device_power_state *ps = &device->power.states[i];
>> >
>> > wakeup.resources has problem?
>>
>> Yes, it seems to.
>>
>> Thanks for the report, looking into it.
>
> Found a bug, fixed it and updated the tree (device->flags.wakeup.valid should
> be checked before the acpi_power_resources_list_free(&device->wakeup.resources),
> otherwise the list may not be initialized).
>

still have problems:

[   63.971903] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000010
[   63.972708] IP: [<ffffffff8153bf53>] acpi_power_off_list+0x19/0x53
[   63.972708] PGD 0
[   63.972708] Oops: 0000 [#1] SMP
[   63.972708] Modules linked in:
[   63.972708] CPU 0
[   63.972708] Pid: 4, comm: kworker/0:0 Not tainted
3.8.0-rc3-yh-00703-g5955587-dirty #1132 Bochs Bochs
[   63.972708] RIP: 0010:[<ffffffff8153bf53>]  [<ffffffff8153bf53>]
acpi_power_off_list+0x19/0x53
[   63.972708] RSP: 0018:ffff8801964bba78  EFLAGS: 00010203
[   63.972708] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000001810000e5
[   63.972708] RDX: 00000001810000e6 RSI: 0000000000000004 RDI: ffff8801965de8e0
[   63.972708] RBP: ffff8801964bba98 R08: 0000000000000002 R09: ffff8801993d64b0
[   63.972708] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8801965de8e0
[   63.972708] R13: 0000000000000001 R14: 0000000000000000 R15: ffff880196466528
[   63.972708] FS:  0000000000000000(0000) GS:ffff880199200000(0000)
knlGS:0000000000000000
[   63.972708] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   63.972708] CR2: 0000000000000010 CR3: 000000017f10a000 CR4: 00000000000006f0
[   63.972708] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   63.972708] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   63.972708] Process kworker/0:0 (pid: 4, threadinfo
ffff8801964ba000, task ffff880196580000)
[   63.972708] Stack:
[   63.972708]  ffff8801965de800 0000000000000004 ffff8801965de800
0000000000000001
[   63.972708]  ffff8801964bbab8 ffffffff8153c65e ffff8801965de800
ffff8801965de9d0
[   63.972708]  ffff8801964bbae8 ffffffff815367fa ffff8801964bbb08
0000000000000001
[   63.972708] Call Trace:
[   63.972708]  [<ffffffff8153c65e>] acpi_power_transition+0x6c/0x98
[   63.972708]  [<ffffffff815367fa>] acpi_device_unregister+0x16f/0x177
[   63.972708]  [<ffffffff8153682d>] acpi_bus_remove+0x2b/0x2f
[   63.972708]  [<ffffffff815601cc>] acpi_ns_walk_namespace+0x114/0x250
[   63.972708]  [<ffffffff81536802>] ? acpi_device_unregister+0x177/0x177
[   63.972708]  [<ffffffff81536802>] ? acpi_device_unregister+0x177/0x177
[   63.972708]  [<ffffffff815607cd>] acpi_walk_namespace+0xee/0x137
[   63.972708]  [<ffffffff81536921>] acpi_bus_trim+0x64/0x7c
[   63.972708]  [<ffffffff815369b2>] acpi_bus_hot_remove_device+0x79/0x16d
[   63.972708]  [<ffffffff81196dc2>] ? kmem_cache_alloc_trace+0x42/0x150
[   63.972708]  [<ffffffff81539c20>] _handle_hotplug_event_root+0x108/0x149
[   63.972708]  [<ffffffff810a8b20>] ? process_one_work+0x270/0x560
[   63.972708]  [<ffffffff810a8b8d>] process_one_work+0x2dd/0x560
[   63.972708]  [<ffffffff810a8b20>] ? process_one_work+0x270/0x560
[   63.972708]  [<ffffffff810a9679>] ? worker_thread+0x59/0x3a0
[   63.972708]  [<ffffffff81539b18>] ? acpi_pci_find_root+0x3f/0x3f
[   63.972708]  [<ffffffff810a989a>] worker_thread+0x27a/0x3a0
[   63.972708]  [<ffffffff810e9f4d>] ? trace_hardirqs_on+0xd/0x10
[   63.972708]  [<ffffffff810a9620>] ? manage_workers+0x280/0x280
[   63.972708]  [<ffffffff810af088>] kthread+0xe8/0xf0
[   63.972708]  [<ffffffff810aefa0>] ? __init_kthread_worker+0x70/0x70
[   63.972708]  [<ffffffff8216d61c>] ret_from_fork+0x7c/0xb0
[   63.972708]  [<ffffffff810aefa0>] ? __init_kthread_worker+0x70/0x70
[   63.972708] Code: 08 4c 39 e3 75 ee 41 5a 5b 41 5c 44 89 e8 41 5d
5d c3 0f 1f 44 00 00 55 48 89 e5 41 55 41 54 53 41 54 49 89 fc 48 8b
5f 08 eb 14 <48> 8b 7b 10 e8 22 fd ff ff 85 c0 41 89 c5 75 17 48 8b 5b
08 4c
