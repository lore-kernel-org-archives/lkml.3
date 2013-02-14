Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761374Ab3BNAYV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 19:24:21 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:51082 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab3BNAYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 19:24:20 -0500
MIME-Version: 1.0
Date: Wed, 13 Feb 2013 16:24:19 -0800
X-Google-Sender-Auth: neX6UouqQVLrB6TNefdWmGljnbk
Message-ID: <CAGXu5jLmhjNHNajO-BNn_39LU6xsA9nw1mB_p=9SudX0kEMFjg@mail.gmail.com>
Subject: BUG: bd_set_size NULL deref
From: Kees Cook <keescook@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: j-nomura@ce.jp.nec.com, Andi Kleen <ak@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Alan Curry <pacman@kosh.dhis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've encountered the same bug as described here:
http://lkml.indiana.edu/hypermail/linux/kernel/1208.0/01804.html

[93652.097167] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000398
[93652.097197] IP: [<ffffffff810fdc67>] bd_set_size+0x10/0x6f
...
[93652.102098]  [<ffffffff812d31c7>] loop_clr_fd+0x15e/0x201
[93652.102114]  [<ffffffff812d3ce0>] lo_ioctl+0x462/0x5e1
[93652.102133]  [<ffffffff811c9d2c>] __blkdev_driver_ioctl+0x28/0x2a
[93652.102150]  [<ffffffff811ca644>] blkdev_ioctl+0x66c/0x684
[93652.102165]  [<ffffffff810fdd06>] block_ioctl+0x40/0x44
[93652.102183]  [<ffffffff810e1b9c>] do_vfs_ioctl+0x469/0x4aa
[93652.102201]  [<ffffffff810d7911>] ? sys_newfstat+0x2a/0x33
[93652.102216]  [<ffffffff810e1c33>] sys_ioctl+0x56/0x7b
[93652.102234]  [<ffffffff8145f512>] system_call_fastpath+0x16/0x1b

It looks like bdev->bd_disk is NULL while running loop_clr_fd with a
non-NULL bdev. Looking around at things that clear bd_disk, it's not
obvious what could be racing this. It happens while cleaning up a
loopback used under dm-crypt -- are there delayed cleanups happening
on release that could possibly race the loop_clr_fd call?

I've had a hard time reproducing the problem too, unfortunately. Does
anyone have ideas on what this could be?

Thanks,

-Kees

--
Kees Cook
Chrome OS Security
