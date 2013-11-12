Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121Ab3KLQTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:19:46 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:44451 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab3KLQTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:19:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAC9WiBj554c=B3ucq41yPR9oEtSFebUwJa5z0DuD_esDwvZQqw@mail.gmail.com>
References: <CAC9WiBj554c=B3ucq41yPR9oEtSFebUwJa5z0DuD_esDwvZQqw@mail.gmail.com>
Date: Tue, 12 Nov 2013 17:19:38 +0100
Message-ID: <CAC9WiBjA46h+Jab5PLE3O3OAhhrXVcHjDVaHU0fcLS8k77P5pg@mail.gmail.com>
Subject: Re: bcache: process get stucks when doing write IOs in writeback mode
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

It doesn't seem my initial post reached LKML, maybe that's due to the
dmesg file I initially attached. So I'm replying to this hoping that
this is going to be fixed (since the attached file is gone).

On Mon, Nov 11, 2013 at 6:45 PM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello,
>
> [ Resending this issue to LKML to reach a wider audience since I've
> got no answer so far on bcache mailing list and it seems a pretty
> major bug in that component ]
>
> I'm using bcache on a very basic setup: no MD or LVM involved.
> /dev/sda4 (900Mo) is the backing device while /dev/sdb (120G) is the
> cache device. On top of bcache0 I'm using ext4 and I'm using it as my
> root device.
>
> I initially created the bcache0 device with default using writethough
> mode. I haven't (yet) experienced any issues using this mode: I
> successfully installed my system (archlinux) on it.
>
> I decided to switch to writeback mode and encounter several times the
> same issue: after doing a lot of IOs (for example when installing new
> packages) one process is stuck in D state. Currently I can see this:
>
> # ps aux | grep D+
> root      1080  0.0  0.0  41796  5728 pts/0    D+   12:59   0:00 gtk-update-icon
>
> # cat /proc/1080/stack
> [<ffffffff8113270e>] sleep_on_page+0xe/0x20
> [<ffffffff811324bf>] wait_on_page_bit+0x7f/0x90
> [<ffffffff8113264b>] filemap_fdatawait_range+0x11b/0x1a0
> [<ffffffff81133d3f>] filemap_write_and_wait_range+0x3f/0x70
> [<ffffffffa02ad4da>] ext4_sync_file+0xba/0x390 [ext4]
> [<ffffffff811cde56>] do_fsync+0x56/0x80
> [<ffffffff811ce0e0>] SyS_fsync+0x10/0x20
> [<ffffffff814ea5dd>] system_call_fastpath+0x1a/0x1f
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> From that point I'm not really sure what I should do to restore the
> system without loosing or breaking badly my rootfs. Any advices are
> welcome.
>
> Please find below some additionnal information that might help to fix
> this issue:
>
> # mount | grep bcache
> /dev/bcache0 on / type ext4 (rw,relatime,data=ordered)
>
> # uname -r
> 3.11.6-1-ARCH
>
> # bcache-super-show /dev/sda4
> sb.magic        ok
> sb.first_sector        8 [match]
> sb.csum            F828E134D5AB890C [match]
> sb.version        1 [backing device]
>
> dev.label        (empty)
> dev.uuid        62839366-e5a9-43a9-9984-fc8f2aefe9de
> dev.sectors_per_block    1
> dev.sectors_per_bucket    1024
> dev.data.first_sector    16
> dev.data.cache_mode    1 [writeback]
> dev.data.cache_state    2 [dirty]
>
> cset.uuid        50485be4-15f7-424f-a01b-4c65fdf8487d
>
> # bcache-super-show /dev/sdb
> sb.magic        ok
> sb.first_sector        8 [match]
> sb.csum            692BB25984E31571 [match]
> sb.version        3 [cache device]
>
> dev.label        (empty)
> dev.uuid        a63ec68a-6a71-497e-86db-0dd71bbfb404
> dev.sectors_per_block    1
> dev.sectors_per_bucket    1024
> dev.cache.first_sector    1024
> dev.cache.cache_sectors    234439680
> dev.cache.total_sectors    234440704
> dev.cache.ordered    yes
> dev.cache.discard    yes
> dev.cache.pos        0
> dev.cache.replacement    0 [lru]
>
> cset.uuid        50485be4-15f7-424f-a01b-4c65fdf8487d
>
> I attached dmesg output which has been generated after doing "echo t
>>/proc/sysrq-trigger"
>
> Thanks
> --
> Francis
>
>
> --
> Francis



-- 
Francis
