Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965533AbaCSPpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 11:45:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43324 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933543AbaCSPo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 11:44:57 -0400
Date: Wed, 19 Mar 2014 12:44:34 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Len Brown <len.brown@intel.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Austin <jonathan.austin@arm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sricharan R <r.sricharan@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Russ Dill <Russ.Dill@ti.com>,
        Nicolas Pitre <nico@linaro.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [PATCH v7 2/2] ARM hibernation / suspend-to-disk
Message-ID: <20140319154434.GA3488@arch.cereza>
References: <1394016605-24120-1-git-send-email-sebastian.capella@linaro.org>
 <1394016605-24120-3-git-send-email-sebastian.capella@linaro.org>
 <20140316070917.GA3094@arch.cereza>
 <CADHgK6s58EJyJxB-47K8w26H8ZCBFQ2zu7PGAQU9O+2g7=fPwA@mail.gmail.com>
 <20140317204410.GA1118@arch.cereza>
 <CADHgK6tHngKVZS=jo=VYt3Nt3dhiEmiWr28iDy7q_uR9goBj=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADHgK6tHngKVZS=jo=VYt3Nt3dhiEmiWr28iDy7q_uR9goBj=Q@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 17, Sebastian Capella wrote:
[..]
> 
> Thanks, I've added it like this in arch/arm/Kconfig.  I'm sure you
> know, but this way also takes care of the CPU_FEROCEON in the default
> list since SUSPEND_POSSIBLE already contains it.
> 
> config ARCH_HIBERNATION_POSSIBLE
>         bool
>         depends on MMU
>         default y if ARCH_SUSPEND_POSSIBLE
> 
> Does this look ok?
> 

I applied this change on top of your patches and tested it on a Kirkwood
Openblocks A6 board, using a resume=/dev/sda2 kernel parameter (iow, without
any U-Boot assistance to resume). Seems to work fine (as you can see here
http://sprunge.us/BJRV). I guess you can add a:

Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

On the other side, this board has no pm_power_off() support, which means
kernel_halt() is called after kernel_power_off().

I'm not sure if a NULL pm_power_off() is supported, but this makes my kernel
crash in a reboot notifier that's called twice (first in kernel_power_off
and then in kernel_halt):

Unable to handle kernel paging request at virtual address 00100104
pgd = df634000
[00100104] *pgd=1f5c3831, *pte=00000000, *ppte=00000000
Internal error: Oops: 817 [#1] PREEMPT ARM
CPU: 0 PID: 565 Comm: sh Not tainted 3.14.0-rc6-00002-g06da70a-dirty #24
task: df4d5440 ti: df666000 task.ti: df666000
PC is at led_trigger_unregister+0x3c/0xcc
LR is at led_trigger_unregister+0x20/0xcc
pc : [<c0273090>]    lr : [<c0273074>]    psr: 60000093
sp : df667e50  ip : 00100100  fp : 000ab294
r10: 00000002  r9 : 00000000  r8 : c0459a6c
r7 : c046c87c  r6 : c046c964  r5 : c03ee198  r4 : c046c964
r3 : 00200200  r2 : 00100100  r1 : 00200200  r0 : c046c8e4
Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 0005397f  Table: 1f634000  DAC: 00000015
Process sh (pid: 565, stack limit = 0xdf6661c0)
Stack: (0xdf667e50 to 0xdf668000)
7e40:                                     00000000 c046c964 c03ee198 00000000
7e60: 00000000 c0273ae0 c0273ab4 c046c94c ffffffff c0036698 c04546c8 ffffffff
7e80: 00000000 00000002 c0446800 c04550e8 df5270c8 c0036b24 00000000 c034cce0
7ea0: c03c4b18 c04550e8 df666018 00000000 c0476f60 c0036b54 00000000 c04550e8
7ec0: df5270c8 c00378ec 00000001 c034cc64 c0455288 c0044cac 0000006b df4270d8
7ee0: df53f480 00000005 00000004 df53f480 00000005 c0042dc4 00000005 df4270d8
7f00: df53f480 00000005 df667f80 df53f480 df5270c0 c01a2bf4 00000005 c0108dd0
7f20: c0108d8c 00000000 00000000 c010c090 00000000 00000000 df4dd280 000acb10
7f40: df667f80 00000005 00000000 00000005 00000000 c00af2b8 fffffff6 c0019d9c
7f60: 00000003 00000000 00000000 df4dd280 000acb10 00000000 00000005 c00af448
7f80: 00000000 00000000 00200200 000aa8b0 00000001 000acb10 00000004 c0009424
7fa0: df666000 c00092c0 000aa8b0 00000001 00000001 000acb10 00000005 00000000
7fc0: 000aa8b0 00000001 000acb10 00000004 00000020 000ab2a8 000ab274 000ab294
7fe0: 00000005 befbd738 0000e1f0 b6edeb4c 60000010 00000001 1fffd831 1fffdc31
[<c0273090>] (led_trigger_unregister) from [<c0273ae0>] (heartbeat_reboot_notifier+0x2c/0x40)
[<c0273ae0>] (heartbeat_reboot_notifier) from [<c0036698>] (notifier_call_chain+0x48/0x9c)
[<c0036698>] (notifier_call_chain) from [<c0036b24>] (__blocking_notifier_call_chain+0x48/0x60)
[<c0036b24>] (__blocking_notifier_call_chain) from [<c0036b54>] (blocking_notifier_call_chain+0x18/0x20)
[<c0036b54>] (blocking_notifier_call_chain) from [<c00378ec>] (kernel_halt+0x14/0x58)
[<c00378ec>] (kernel_halt) from [<c034cc64>] (power_down+0x8c/0xac)
[<c034cc64>] (power_down) from [<c0044cac>] (hibernate+0x1a8/0x1ec)
[<c0044cac>] (hibernate) from [<c0042dc4>] (state_store+0xac/0xb8)
[<c0042dc4>] (state_store) from [<c01a2bf4>] (kobj_attr_store+0x14/0x20)
[<c01a2bf4>] (kobj_attr_store) from [<c0108dd0>] (sysfs_kf_write+0x44/0x48)
[<c0108dd0>] (sysfs_kf_write) from [<c010c090>] (kernfs_fop_write+0xb4/0x14c)
[<c010c090>] (kernfs_fop_write) from [<c00af2b8>] (vfs_write+0xac/0x188)
[<c00af2b8>] (vfs_write) from [<c00af448>] (SyS_write+0x3c/0x78)
[<c00af448>] (SyS_write) from [<c00092c0>] (ret_fast_syscall+0x0/0x2c)
Code: e3a03602 e2822c01 e2833c02 e59f7084 (e58c1004) 
---[ end trace 72dd5ccae5489f38 ]---

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
