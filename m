Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3BVBeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 20:34:22 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41114 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab3BVBeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 20:34:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Huang Ying <ying.huang@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG bisected]: apei_hest_parse explosion
Date: Fri, 22 Feb 2013 02:40:58 +0100
Message-ID: <3310807.g9DvzzvEFn@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQXV43emyjjCb=D=xFLz-n6q0Eu0uQmVhAA470A=FGRhww@mail.gmail.com>
References: <alpine.LFD.2.02.1302220002040.22263@ionos> <1447813.geP1BIVYu5@vostro.rjw.lan> <CAE9FiQXV43emyjjCb=D=xFLz-n6q0Eu0uQmVhAA470A=FGRhww@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 21, 2013 05:23:19 PM Yinghai Lu wrote:
> On Thu, Feb 21, 2013 at 4:15 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Friday, February 22, 2013 12:56:01 AM Thomas Gleixner wrote:
> >> Just booted linus head on one of my old kvm based testing systems and
> >> got the following splat:
> >>
> >> [    0.531910] BUG: unable to handle kernel NULL pointer dereference at 0000000000000024
> >> [    0.532173] IP: [<ffffffff812f1bd2>] apei_hest_parse+0xd2/0xf0
> >> [    0.532173] PGD 0
> >> [    0.532173] Oops: 0000 [#1] PREEMPT SMP
> >> [    0.532173] Modules linked in:
> >> [    0.532173] CPU 3
> >> [    0.532173] Pid: 1, comm: swapper/0 Not tainted 3.8.0+ #195 Bochs Bochs
> >> [    0.532173] RIP: 0010:[<ffffffff812f1bd2>]  [<ffffffff812f1bd2>] apei_hest_parse+0xd2/0xf0
> >> [    0.532173] RSP: 0000:ffff88021685be78  EFLAGS: 00010206
> >> [    0.532173] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> >> [    0.532173] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000028
> >> [    0.532173] RBP: ffff88021685be98 R08: 00000000804efb06 R09: 0000000000000000
> >> [    0.532173] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff81af3d40
> >> [    0.532173] R13: ffffffff812bcb23 R14: 0000000000000000 R15: 0000000000000000
> >> [    0.532173] FS:  0000000000000000(0000) GS:ffff88021fcc0000(0000) knlGS:0000000000000000
> >> [    0.532173] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [    0.532173] CR2: 0000000000000024 CR3: 0000000001a0c000 CR4: 00000000000406a0
> >> [    0.532173] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >> [    0.532173] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> >> [    0.532173] Process swapper/0 (pid: 1, threadinfo ffff88021685a000, task ffff8802168c0000)
> >> [    0.532173] Stack:
> >> [    0.532173]  00000000fffffffa ffffffff81af3d40 0000000000000000 000000001fb3f55a
> >> [    0.532173]  ffff88021685bea8 ffffffff812bcbe4 ffff88021685bec8 ffffffff81af3d5c
> >> [    0.532173]  0000000000000030 0000000000000030 ffff88021685bef8 ffffffff8100023b
> >> [    0.532173] Call Trace:
> >> [    0.532173]  [<ffffffff81af3d40>] ? pcie_portdrv_init+0x7a/0x7a
> >> [    0.532173]  [<ffffffff812bcbe4>] aer_acpi_firmware_first+0x20/0x30
> >> [    0.532173]  [<ffffffff81af3d5c>] aer_service_init+0x1c/0x35
> >> [    0.532173]  [<ffffffff8100023b>] do_one_initcall+0x57/0x13c
> >> [    0.532173]  [<ffffffff81ad2d39>] kernel_init_freeable+0x142/0x1d1
> >> [    0.532173]  [<ffffffff81ad254f>] ? loglevel+0x31/0x31
> >> [    0.532173]  [<ffffffff815a8cef>] ? rest_init+0xc3/0xc3
> >> [    0.532173]  [<ffffffff815a8cfd>] kernel_init+0xe/0xd6
> >> [    0.532173]  [<ffffffff815bc73c>] ret_from_fork+0x7c/0xb0
> >> [    0.532173]  [<ffffffff815a8cef>] ? rest_init+0xc3/0xc3
> >> [    0.532173] Code: 14 0f b7 77 02 31 c0 48 c7 c7 65 c1 83 81 e8 35 1a 2c 00 eb 23 4c 89 f6 41 ff d5 85 c0 75 1e 4c 89 e7 ff c3 48 8b 05 a6 5b 7c 00 <3b> 58 24 0f 82 5a ff ff ff 31 c0 eb 05 b8 ea ff ff ff 5b 41 5c
> >>
> >> git bisect identified the following commit:
> >>
> >> commit 92ef2a25c763338905dce8344a0584606f842920
> >> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> Date:   Fri Dec 21 00:36:40 2012 +0100
> >>
> >>     ACPI: Change the ordering of PCI root bridge driver registrarion
> >>
> >> A revert is impossible w/o major surgery, so I'm going to bed and let
> >> the involved folks think about it.
> >
> > Can you please post a dmesg boot log from v3.8 on the same system?
> >
> 
> looks at the code flow, acpi_hest_init() is called early correctly.
> 
> later aer_acpi_firmware_first() should not hit hest_tab is NULL, but
> hest_disable is not set.
> 
> could be some data corruption.. near hest_disable or hest_tab.

Yes, that's really odd.

It looks like the hest_tab memory mapping is unmapped between acpi_hest_init()
and aer_acpi_firmware_first(), but I have no idea what may be responsible for
that.

And the only relevant difference between now and before the commit above seems
to be the change of the acpi_hest_init() ordering (which now is called earlier).

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
