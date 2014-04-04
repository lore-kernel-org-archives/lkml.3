Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaDDLIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 07:08:46 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:44483 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaDDLIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:08:42 -0400
MIME-Version: 1.0
In-Reply-To: <CABt9es_uq1ixwcyHcL8ptYi2fXQjVFHvaOp71uu2epoQk_ToPw@mail.gmail.com>
References: <CABt9es_uq1ixwcyHcL8ptYi2fXQjVFHvaOp71uu2epoQk_ToPw@mail.gmail.com>
Date: Fri, 4 Apr 2014 15:08:41 +0400
Message-ID: <CALFYKtAGBizs8gDariQH2NJACjoRD=2-1u-zwnPfo7D5bVvy3Q@mail.gmail.com>
Subject: Re: Crash in rbd, need advice
From: Ilya Dryomov <ilya.dryomov@inktank.com>
To: Hannes Landeholm <hannes@jumpstarter.io>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@inktank.com>, Sage Weil <sage@newdream.net>,
        Alex Elder <elder@inktank.com>, Yehuda Sadeh <yehuda@hq.newdream.net>,
        Thorwald Lundqvist <thorwald@jumpstarter.io>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 12:18 AM, Hannes Landeholm <hannes@jumpstarter.io> wrote:
> Hello,
>
> We're running a couple of Arch Linux servers of version 3.13.5-1 in
> production and suddenly one of them had a strange problem after
> running for a few days. One process (pid 319) was running with a few
> threads, one of those threads (pid 322) was eating 100% cpu. I assumed
> it was stuck in an infinite loop (this was our own software so I
> assumed we had a bug) so I sent a SIGKILL to 319 which caused all
> other threads to exit and it turning into a zombie, but thread 322 was
> still running. After trying to stop some other services and failing I
> realized that sending any signals to any process now didn't work at
> all in the system.
>
> This was the process stack output:
>
> $ cat /proc/319/stack
> [<ffffffff810642fa>] do_exit+0x73a/0xa80
> [<ffffffff810646bf>] do_group_exit+0x3f/0xa0
> [<ffffffff81073295>] get_signal_to_deliver+0x295/0x5f0
> [<ffffffff810144a8>] do_signal+0x48/0x950
> [<ffffffff81014e18>] do_notify_resume+0x68/0xa0
> [<ffffffff8152326a>] int_signal+0x12/0x17
> [<ffffffffffffffff>] 0xffffffffffffffff
> $ cat /proc/319/task/322/stack
> [<ffffffff8151c11a>] error_exit+0x2a/0x60
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> We're using ceph + rbd and this happened right after doing a rbd
> mapping (mounting it) or during the mapping itself, so we suspected
> rbd.
>
> A few days later (today) we had a server crash in another server, same
> version+distro and it had also just been running a few days as well.
> After starting it again we found the following in the system log:
>
> hostname kernel: BUG: unable to handle kernel paging request at ffff87fff75ad450
> hostname kernel: IP: [<ffffffffa018c196>] rbd_img_request_fill+0x126/0x930 [rbd]

Can you try gdb'ing that exact rbd.ko and

(gdb) list *rbd_img_request_fill+0x126

Also, the entire stack trace pertaining to rbd_img_request_fill would
help.

Thanks,

                Ilya
