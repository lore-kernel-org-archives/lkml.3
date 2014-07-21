Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbaGURls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:41:48 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:56968 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363AbaGURlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:41:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140721132937.GF12921@htj.dyndns.org>
References: <CAKbGBLjYWrooGZjZS_MaDe9kxacoaL9dHJM1oDe7_a-vQuhsJw@mail.gmail.com>
	<20140721132937.GF12921@htj.dyndns.org>
Date: Mon, 21 Jul 2014 10:41:45 -0700
Message-ID: <CAKbGBLj4c_bbN-GV-DTJWT7+iKLBauxvvu0uDvtQQOLMmx4N5A@mail.gmail.com>
Subject: Re: general protection fault on 3.15.6
From: Steven Noonan <steven@uplinklabs.net>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 6:29 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Steven.
>
> On Sun, Jul 20, 2014 at 09:27:42PM -0700, Steven Noonan wrote:
>> My router/storage box suddenly stopped responding (originally noticed
>> because dnsmasq wasn't responding) and I had to reboot it. I checked
>> the systemd journal when it came back and these were the last thing in
>> there for the previous boot. Any ideas about pinning down the cause?
>>
>> general protection fault: 0000 [#1] SMP
> ...
>> CPU: 3 PID: 8881 Comm: systemd Tainted: P        WC O  3.15.6 #1
>> Hardware name: Shuttle Inc. SH67H/FH67H, BIOS 2.04 04/10/2013
>> task: ffff8802f473d880 ti: ffff8802f0abc000 task.ti: ffff8802f0abc000
>> RIP: 0010:[<ffffffff811ad226>]  [<ffffffff811ad226>]
>> __kmalloc_track_caller+0x86/0x260
>
> So, GFP in kmalloc,
>
>> Call Trace:
>>  [<ffffffff8116fb11>] kstrdup+0x31/0x60
>
> called from kstrdup()
>
>>  [<ffffffff8123a4f4>] __kernfs_new_node+0x34/0xf0
>>  [<ffffffff8123b386>] kernfs_new_node+0x26/0x50
>
> which was invoked to copy the node name while creating a new kernfs
> node.
>
>>  [<ffffffff8123cc59>] __kernfs_create_file+0x39/0xa0
>>  [<ffffffff810edb60>] cgroup_addrm_files+0x110/0x250
>>  [<ffffffff810ee9ab>] cgroup_mkdir+0x21b/0x540
>>  [<ffffffff8125ca36>] ? security_inode_notifysecctx+0x16/0x20
>>  [<ffffffff8123b30a>] kernfs_iop_mkdir+0x5a/0x90
>>  [<ffffffff811d3120>] vfs_mkdir+0xe0/0x180
>>  [<ffffffff811d7bea>] SyS_mkdirat+0xaa/0xe0
>>  [<ffffffff811d7c39>] SyS_mkdir+0x19/0x20
>>  [<ffffffff8151496d>] system_call_fastpath+0x1a/0x1f
>> Code: 25 88 dd 00 00 49 8b 50 08 4d 8b 20 4d 85 e4 0f 84 50 01 00 00
>> 49 83 78 10 00 0f 84 45 01 00 00 49 63 47 20 48 8d 4a 01 4d 8b 07 <49>
>> 8b 1c 04 4c 89 e0 65 49 0f c7 08 0f 94 c0 84 c0 74 bb 49 63
>> RIP  [<ffffffff811ad226>] __kmalloc_track_caller+0x86/0x260
>>  RSP <ffff8802f0abfc88>
>
> followed by another GPF
>
>> general protection fault: 0000 [#2] SMP
> ...
>> RIP: 0010:[<ffffffff811aa26a>]  [<ffffffff811aa26a>] __kmalloc+0x8a/0x280
>
> in __kmalloc()
>
>>  [<ffffffff8132d81f>] acpi_ns_internalize_name+0x68/0xad
>
> called from acpi to copy a different name.
>
> I don't think the problem is anything cgroup / kernfs specific.  The
> allocator is GPFing inside it from multiple callers and it's not even
> using a caller-provided cache.  It looks like something screwed up the
> memory allocator and it's now faulting on unrelated callers.  Most
> likely illegal free or use-after-free.
>
> Steven, can you please post the full kernel log from boot till reboot?
> It usually is a good idea to include full log when reporting bugs as
> it's very easy to exclude the actually relevant part.
>

I would if I could, but I've had to set up some rather draconian
limits on my systemd journal sizes because of some incessant kernel
messages filling up the logs (related to 6to4 SIT tunnels) -- this has
unfortunately truncated most of the log. Are there any particular
kernel config options I should enable to make tracking this down
easier if it comes up again?

- Steven
