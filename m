Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3J0UUu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 16:20:50 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:37734 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab3J0UUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 16:20:48 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxw1Hm4QVeEigkByP5RppSL30oHnLoR16C=henf-a=uFQ@mail.gmail.com>
References: <525BD08C.2080101@t-online.de>
	<CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
	<CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
	<alpine.DEB.2.02.1310251221310.5266@ionos.tec.linutronix.de>
	<CA+55aFxw1Hm4QVeEigkByP5RppSL30oHnLoR16C=henf-a=uFQ@mail.gmail.com>
Date: Sun, 27 Oct 2013 20:20:47 +0000
X-Google-Sender-Auth: C-lWlci0DWmyE-BO-XVSIsjtWhw
Message-ID: <CA+55aFyb72qoZ1Tjpb+=q-6+GmwoOXjfntY_zZnf300gg3d1Hg@mail.gmail.com>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>, Alasdair G Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Neil Brown <neilb@suse.de>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 11:48 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Yes, but nobody has actually been able to trigger it with those. It's
> pretty rare, and the debug options are so expensive that they aren't
> reasonable to enable generally...
>
> So we need to try to figure out how to trigger it, or narrow things
> down some way..

Ok, still trying to figure this out, and I do have another bug as a
result. I don't think this one is really the fundamental one either
that caused my crash during "yum upgrade", nor necessarily Knut's
problem during shutdown, but I'll keep looking.

And who knows.. Maybe this *does* explain Knut's issue.

Appended is a warning I get with DEBUG_TIMER_OBJECTS. Seems to be a
device-mapper issue. Alasdair, Neil, comments? It looks like
dm_destroy() is freeing an delayed_work entry that is still active...

I don't know exactly which field in the 'struct mapped_device' has
that delayed-work thing, but I assume it's the kobject.. Somebody who
knows this code better, please take a look!

                   Linus

---
[    8.258139] ------------[ cut here ]------------
[    8.258145] WARNING: CPU: 1 PID: 257 at lib/debugobjects.c:260
debug_print_object+0x83/0xa0()
[    8.258150] ODEBUG: free active (active state 0) object type:
timer_list hint: delayed_work_timer_fn+0x0/0x20
[    8.258153] Modules linked in: dm_crypt crc32_pclmul crc32c_intel
i915 i2c_algo_bit drm_kms_helper ghash_clmulni_intel drm i2c_core
video
[    8.258164] CPU: 1 PID: 257 Comm: systemd-cryptse Not tainted
3.12.0-rc6-00331-ga2ff82065b5b #2
[    8.258166] Hardware name: Sony Corporation SVP11213CXB/VAIO, BIOS
R0270V7 05/17/2013
[    8.258168]  0000000000000009 ffff8800d65f3b28 ffffffff8160d4a2
ffff8800d65f3b70
[    8.258172]  ffff8800d65f3b60 ffffffff810514e8 ffff8800372cb078
ffffffff81c365e0
[    8.258176]  ffffffff819f9133 ffffffff81f3d3f0 0000000000000003
ffff8800d65f3bc0
[    8.258180] Call Trace:
[    8.258186]  [<ffffffff8160d4a2>] dump_stack+0x45/0x56
[    8.258191]  [<ffffffff810514e8>] warn_slowpath_common+0x78/0xa0
[    8.258195]  [<ffffffff81051557>] warn_slowpath_fmt+0x47/0x50
[    8.258198]  [<ffffffff812f8883>] debug_print_object+0x83/0xa0
[    8.258202]  [<ffffffff8106aa90>] ? execute_in_process_context+0x90/0x90
[    8.258205]  [<ffffffff812f99fb>] debug_check_no_obj_freed+0x20b/0x250
[    8.258210]  [<ffffffff814b564c>] ? __dm_destroy+0x1ec/0x250
[    8.258214]  [<ffffffff8115db59>] kfree+0x89/0x160
[    8.258217]  [<ffffffff814b564c>] __dm_destroy+0x1ec/0x250
[    8.258221]  [<ffffffff814b626e>] dm_destroy+0xe/0x10
[    8.258224]  [<ffffffff814bba6a>] dev_remove+0x9a/0x130
[    8.258226]  [<ffffffff814bb9d0>] ? __hash_remove+0xd0/0xd0
[    8.258229]  [<ffffffff814bbed0>] ctl_ioctl+0x250/0x500
[    8.258234]  [<ffffffff81184201>] ? do_last+0x511/0x1220
[    8.258238]  [<ffffffff814bc18e>] dm_ctl_ioctl+0xe/0x20
[    8.258242]  [<ffffffff811879ad>] do_vfs_ioctl+0x2cd/0x4a0
[    8.258246]  [<ffffffff81177419>] ? ____fput+0x9/0x10
[    8.258249]  [<ffffffff81187c01>] SyS_ioctl+0x81/0xa0
[    8.258254]  [<ffffffff8161b9a2>] system_call_fastpath+0x16/0x1b
[    8.258256] ---[ end trace 25f53c192da70824 ]---
