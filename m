Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217AbaIXSfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:35:25 -0400
Received: from gloria.sntech.de ([95.129.55.99]:41397 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaIXSfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:35:22 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Joachim Eastwood <manabian@gmail.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kgene.kim@samsung.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, naushad@samsung.com,
        b29396@freescale.com, tomasz.figa@gmail.com, joshi@samsung.com,
        thomas.ab@samsung.com, Li.Xiubo@freescale.com,
        vikas.sajjan@samsung.com, chow.kim@samsung.com, lee.jones@linaro.org
Subject: Re: [PATCH v5] mfd: syscon: Decouple syscon interface from platform devices
Date: Wed, 24 Sep 2014 20:35:10 +0200
Message-ID: <13449286.k3JCbR2ABy@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAGhQ9VzZ8LadDT5RWUSX89q0WP3fGiQ8f=bWbRVfEz5Vy_zZKw@mail.gmail.com>
References: <1411360807-7750-1-git-send-email-pankaj.dubey@samsung.com> <CAGhQ9VzZ8LadDT5RWUSX89q0WP3fGiQ8f=bWbRVfEz5Vy_zZKw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pankaj, Joachim,

Am Dienstag, 23. September 2014, 20:12:50 schrieb Joachim Eastwood:
> On 22 September 2014 06:40, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> > Currently a syscon entity can be only registered directly through a
> > platform device that binds to a dedicated syscon driver. However in
> > certain use cases it is desirable to make a device used with another
> > driver a syscon interface provider.
> > 
> > For example, certain SoCs (e.g. Exynos) contain system controller
> > blocks which perform various functions such as power domain control,
> > CPU power management, low power mode control, but in addition contain
> > certain IP integration glue, such as various signal masks,
> > coprocessor power control, etc. In such case, there is a need to have
> > a dedicated driver for such system controller but also share registers
> > with other drivers. The latter is where the syscon interface is helpful.
> > 
> > In case of DT based platforms, this patch decouples syscon object from
> > syscon platform driver, and allows to create syscon objects first time
> > when it is required by calling of syscon_regmap_lookup_by APIs and keep
> > a list of such syscon objects along with syscon provider device_nodes
> > and regmap handles.
> > 
> > For non-DT based platforms, this patch keeps syscon platform driver
> > structure where is can be probed and such non-DT based drivers can use
> > syscon_regmap_lookup_by_pdev API and get access to regmap handles.
> > Once all users of "syscon_regmap_lookup_by_pdev" migrated to DT based,
> > we can completly remove platform driver of syscon, and keep only helper
> > functions to get regmap handles.
> > 
> > Suggested-by: Arnd Bergmann <arnd@arndb.de>
> > Suggested-by: Tomasz Figa <tomasz.figa@gmail.com>
> > Tested-by: Vivek Gautam <gautam.vivek@samsung.com>
> > Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> 
> I wrote a clk driver using syscon and your patch. clk driver uses
> CLK_OF_DECLARE, btw.
> 
> It works but I get a '(null): Failed to create debugfs directory'
> message in the boot log.
> 
> Tested-by: Joachim Eastwood <manabian@gmail.com>

on Rockchip platforms this syscon support also helps quite a bit, as the
pll lock-status is sitting in an external syscon register, so setting target
pll-rates through assigned-clocks is not easily doable without it.
Therefore I'm very much looking forward to this.


Similar to Joachim I get an error about debugfs from regmap, which seems
to be caused by
	name = dev_name(map->dev);
returning NULL in regmap_debugfs_init in regmap-debugfs.c for such an "early"
syscon.

[...]
__set_clk_rates: setting cpll from 384000000 to 891000000
rockchip_rk3066_pll_set_rate: trying to get grf
rockchip_rk3066_pll_set_rate: changing pll_cpll from 384000000 to 891000000 with a parent rate of 24000000
__set_clk_rates: cpll is now 891000000
Architected cp15 timer(s) running at 24.00MHz (virt).
[...]
regulator-dummy: no parameters
NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 5 [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc1+ #1184
task: ee069b40 ti: ee06a000 task.ti: ee06a000
PC is at strlen+0xc/0x20
LR is at __create_file+0x6c/0x1d0
pc : [<c01a02f8>]    lr : [<c01725f0>]    psr: 60000153
sp : ee06bea8  ip : 0000000e  fp : 00000000
r10: ee06a000  r9 : 00000000  r8 : 00000000
r7 : c07ecb20  r6 : edc02cc0  r5 : 000041ed  r4 : 00000000
r3 : 00000001  r2 : 00000000  r1 : a0000153  r0 : 00000000
Flags: nZCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387d  Table: 0000406a  DAC: 00000015
Process swapper/0 (pid: 1, stack limit = 0xee06a240)
Stack: (0xee06bea8 to 0xee06c000)
bea0:                   00000000 000041ed ee002400 c07efc60 00000000 c05a9e50
bec0: c058c510 c01727c8 00000000 edc02cc0 ee0024b0 c021d410 ee002400 00000000
bee0: ee02ff40 c0793494 c07ab080 c021d6b4 00000000 ee11bbc0 c0782c58 c058c518
bf00: 00000000 c0008970 ee0f7f00 c00f9f54 ee0f7f00 ee0f7c80 ee0f7c00 c03fddc4
bf20: c07cda04 00000000 c054c8a4 c00fa0e0 c0575514 ef7fccc5 00000000 c0034fd0
bf40: 00000000 00000000 c054c8a4 c054bcd4 000000bd 00000002 c0786394 00000002
bf60: c059e840 c07ab080 c05a9e50 000000bd 00000000 00000000 00000000 c0575c94
bf80: 00000002 00000002 c0575514 ee06a000 00000000 c03f38f8 00000000 00000000
bfa0: 00000000 c03f3900 00000000 c000e7f8 00000000 00000000 00000000 00000000
bfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
bfe0: 00000000 00000000 00000000 00000000 00000013 00000000 ffffffff ffffffff
[<c01a02f8>] (strlen) from [<c01725f0>] (__create_file+0x6c/0x1d0)
[<c01725f0>] (__create_file) from [<c01727c8>] (debugfs_create_dir+0x18/0x1c)
[<c01727c8>] (debugfs_create_dir) from [<c021d410>] (regmap_debugfs_init+0xd0/0x254)
[<c021d410>] (regmap_debugfs_init) from [<c021d6b4>] (regmap_debugfs_initcall+0x5c/0xbc)
[<c021d6b4>] (regmap_debugfs_initcall) from [<c058c518>] (regmap_initcall+0x8/0x10)
[<c058c518>] (regmap_initcall) from [<c0008970>] (do_one_initcall+0x110/0x1bc)
[<c0008970>] (do_one_initcall) from [<c0575c94>] (kernel_init_freeable+0xfc/0x1c8)
[<c0575c94>] (kernel_init_freeable) from [<c03f3900>] (kernel_init+0x8/0xe4)
[<c03f3900>] (kernel_init) from [<c000e7f8>] (ret_from_fork+0x14/0x3c)
Code: c040e4cc e1a03000 e1a02003 e2833001 (e5d21000) 
---[ end trace fa51dc7fc31bd989 ]---
