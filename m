Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab3ANHP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 02:15:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50070 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3ANHPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 02:15:24 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
	<CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
	<CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
Date: Mon, 14 Jan 2013 15:15:21 +0800
Message-ID: <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
From: Ming Lei <ming.lei@canonical.com>
To: Alex Riesen <raa.lkml@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 11:47 AM, Ming Lei <ming.lei@canonical.com> wrote:
> On Mon, Jan 14, 2013 at 1:42 AM, Alex Riesen <raa.lkml@gmail.com> wrote:
> [   86.901367] io scheduler deadline registered (default)
> [  181.168487] INFO: task modprobe:2462 blocked for more than 90 seconds.
> [  181.175323] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  181.183624] modprobe        D c04f1920     0  2462   2461 0x00000000
> [  181.183685] [<c04f1920>] (__schedule+0x5fc/0x6d4) from [<c005eba4>]
> (async_synchronize_cookie_domain+0xdc/0x168)
> [  181.183715] [<c005eba4>] (async_synchronize_cookie_domain+0xdc/0x168) from [<c005ed04>] (async_synchronize_full+0x3c/0x60)
> [  181.183776] [<c005ed04>] (async_synchronize_full+0x3c/0x60) from [<c0085610>] (load_module+0x1aac/0x1cdc)
> [  181.183807] [<c0085610>] (load_module+0x1aac/0x1cdc) from [<c0085944>] (sys_init_module+0x104/0x110)
> [  181.183837] [<c0085944>] (sys_init_module+0x104/0x110) from
> [<c000dfe0>] (ret_fast_syscall+0x0/0x48)

The deadlock problem is caused by calling request_module() inside
async function of do_scan_async(), and it was introduced by Linus's
below commit:

commit d6de2c80e9d758d2e36c21699117db6178c0f517
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Apr 10 12:17:41 2009 -0700

    async: Fix module loading async-work regression

IMO, maybe the commit isn't a proper fix, considered the
below fact:

- it isn't good to allow async function to be marked as __init

- any user mode shouldn't expect that the device is ready just
after completing of 'insmod', and drivers should make
the device ready for user mode just after its async probing or
other kind of async initialization(done in work or kthread)
completes.

- from view of driver, introducing async_synchronize_full() after
do_one_initcall() inside do_init_module() is like a sync probe
for drivers built as module, and cause this kind of deadlock easily.

So could we revert the commit and fix the previous problems just
case by case? or other better fix?


Thanks,
--
Ming Lei
