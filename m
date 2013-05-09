Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab3EIO2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 10:28:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab3EIO2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 10:28:21 -0400
Message-ID: <518BB278.7060505@redhat.com>
Date: Thu, 09 May 2013 11:28:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-edac <linux-edac@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: BUG: key ffff880436f00330 not in .data!
References: <20130509110101.GD27333@pd.tnic>
In-Reply-To: <20130509110101.GD27333@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

Em 09-05-2013 08:01, Borislav Petkov escreveu:
> This is on current linus:
>
> [    3.806733] EDAC sbridge: Seeking for: dev 0d.6 PCI ID 8086:3cf5
> [    3.807455] EDAC sbridge: Seeking for: dev 0d.6 PCI ID 8086:3cf5
> [    3.808317] BUG: key ffff880436f00330 not in .data!
> [    3.808843] ------------[ cut here ]------------
> [    3.809571] WARNING: at kernel/lockdep.c:2987 lockdep_init_map+0x555/0x590()
> [    3.810274] DEBUG_LOCKS_WARN_ON(1)
> [    3.810279] Modules linked in: sb_edac(+) edac_core acpi_cpufreq mperf ehci_hcd gf128mul ablk_helper iTCO_wdt iTCO_vendor_support evdev l
> pc_ich button pcspkr usbcore snd cryptd mfd_core usb_common soundcore processor microcode
> [    3.811776] CPU: 7 PID: 718 Comm: modprobe Not tainted 3.9.0+ #5
> [    3.812516] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
> [    3.813271]  0000000000000009 ffff880434421858 ffffffff815e97c6 ffff880434421898
> [    3.814009]  ffffffff8103e210 ffff880434421888 ffff88043b200110 ffffffff8181062e
> [    3.814758]  0000000000000000 ffff880436f00330 0000000000000000 ffff8804344218f8
> [    3.815518] Call Trace:
> [    3.816249]  [<ffffffff815e97c6>] dump_stack+0x19/0x1b
> [    3.816977]  [<ffffffff8103e210>] warn_slowpath_common+0x70/0xa0
> [    3.817675]  [<ffffffff8103e2f6>] warn_slowpath_fmt+0x46/0x50
> [    3.818394]  [<ffffffff810954c5>] lockdep_init_map+0x555/0x590
> [    3.819119]  [<ffffffff810998ed>] ? trace_hardirqs_on_caller+0x10d/0x1d0
> [    3.819837]  [<ffffffff810999bd>] ? trace_hardirqs_on+0xd/0x10
> [    3.820536]  [<ffffffff81093ea8>] debug_mutex_init+0x38/0x50
> [    3.821223]  [<ffffffff81068b91>] __mutex_init+0x61/0x70
> [    3.821916]  [<ffffffff8142a495>] bus_register+0x175/0x2e0
> [    3.822579]  [<ffffffffa00ce645>] edac_create_sysfs_mci_device+0x55/0x540 [edac_core]

This is likely on this part of edac_mc_sysfs.c:
	mci->bus.name = kasprintf(GFP_KERNEL, "mc%d", mci->mc_idx);
         if (!mci->bus.name)
                 return -ENOMEM;
         edac_dbg(0, "creating bus %s\n", mci->bus.name);
         err = bus_register(&mci->bus);
         if (err < 0)
                 return err;


> [    3.823249]  [<ffffffff810999bd>] ? trace_hardirqs_on+0xd/0x10
> [    3.823938]  [<ffffffffa00cc5e3>] edac_mc_add_mc+0x103/0x270 [edac_core]

This is likely at this part of sb_edac.c driver:

         /* add this new MC control structure to EDAC's list of MCs */
         if (unlikely(edac_mc_add_mc(mci))) {
                 edac_dbg(0, "MC: failed edac_mc_add_mc()\n");
                 rc = -EINVAL;
                 goto fail0;
         }

What I suspect is that it is trying to create more than one bus with the
same name.

So, either there are two EDAC drivers trying to register at the edac core,
or sb_edac is not incrementing mci->mc_idx.

I suspect that it is the former condition, like having both ghes_edac
and sb_edac trying to register.

In thesis, changeset 80cc7d8 should be preventing it to happen.

Could you please check if ghes_edac also got registered there?

Thanks!
Mauro
