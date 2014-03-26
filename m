Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaCZSdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 14:33:38 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:54954 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaCZSde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 14:33:34 -0400
MIME-Version: 1.0
In-Reply-To: <1395858127-18730-1-git-send-email-s.nawrocki@samsung.com>
References: <1395858127-18730-1-git-send-email-s.nawrocki@samsung.com>
Date: Wed, 26 Mar 2014 15:33:25 -0300
Message-ID: <CAOMZO5DJPKvha7A-foktsB2dEw9xGXL_++uBXj_3ScAPTXNOkw@mail.gmail.com>
Subject: Re: [PATCH] clk: register fixed-clock only if #clock-cells property
 is present
From: Fabio Estevam <festevam@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, t.figa@samsung.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Kevin Hilman <khilman@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,

On Wed, Mar 26, 2014 at 3:22 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> After commit 1771b10d605d26ccee771a7fb4b08718c124097a
> "clk: respect the clock dependencies in of_clk_init"
> the order of registering clock providers and their corresponding
> clocks may change. This commit currently causes a regression
> on Exynos4 platforms, where fixed clocks are now being registered
> through the standard "fixed-clock" compatible device driver, rather
> than through a custom mechanism within the clk-exynos4 driver.
> Then any attempts to register the fixed clocks in clk-exynos4
> fail, since clocks named "xxti", "xusbxti" are already registered.
> This means that some clock specifiers do not work any more, i.e.
> those with phandle to the main clock controller node and fixed
> indexes. This in turn causes wrong frequency of the root clocks
> and various division by zero errors.
>
> Hence for old dtbs, where #clock-cells property is missing in the
> fixed-clock DT nodes for exynos4 this patch has a positive side
> effect that the fixed clocks will not get registered through the
> standard mechanism and the required clock names won't be taken
> at the time the main clock controller driver's init callback is
> called.
>
> To make exynos use the standard fixed-clock registration mechanism,
> related dts files could be updated, i.e. #clock-cells property
> added together with required dependencies, that is a 'clocks'
> property with phandles to the fixed clock nodes listed in it.
> The dependencies specified in devicetree would then ensure proper
> order of clocks registration.
>
> Now the issue is that this patch affects not only exynos, but also
> imx and at91 platforms. However, those use a custom compatible
> string in addition to "fixed-clock" and I suspect registering
> fixed clocks through the drivers/clk/clk-fixed-rate.c driver has
> been  failing silently for them anyway. This patch could be
> actually fixing similar issue as for exynos, seen after commit
> "clk: respect the clock dependencies in of_clk_init".
>
> There is one board that will likely break after this patch, i.e.
> arch/arm/boot/dts/vf610-twr.dts. Nonetheless, it doesn't specify
> the #clock-cells property, which is documented as mandatory in
> Documentation/devicetree/bindings/clock/fixed-clock.txt.
> So perhaps we could add the missing property to dts as a fix.
>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Still not able to boot with this patch applied:

Starting kernel ...

Uncompressing Linux... done, booting the kernel.
Booting Linux on physical CPU 0x0
Linux version 3.14.0-rc8-next-20140326+ (fabio@fabio-Latitude-E6410)
(gcc version 4.7.3 (Ubuntu/Linaro 4.7.3-1ubuntu1) ) #948 SMP Wed
Mar 26 15:30:47 BRT 2014
CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=10c5387d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
Machine model: Wandboard i.MX6 Quad Board
bootconsole [earlycon0] enabled
Memory policy: Data cache writealloc
PERCPU: Embedded 8 pages/cpu @ee7a4000 s8960 r8192 d15616 u32768
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520720
Kernel command line: console=ttymxc0,115200 root=/dev/nfs ip=dhcp
nfsroot=192.168.0.2:/tftpboot/rfs,v3,tcp earlyprintk
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 262144 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 131072 (order: 7, 524288 bytes)
Memory: 2063904K/2097152K available (6455K kernel code, 402K rwdata,
2200K rodata, 320K init, 5513K bss, 33248K reserved, 270336K high
mem)
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
    lowmem  : 0x80000000 - 0xef800000   (1784 MB)
    pkmap   : 0x7fe00000 - 0x80000000   (   2 MB)
    modules : 0x7f000000 - 0x7fe00000   (  14 MB)
      .text : 0x80008000 - 0x8087bfdc   (8656 kB)
      .init : 0x8087c000 - 0x808cc300   ( 321 kB)
      .data : 0x808ce000 - 0x80932980   ( 403 kB)
       .bss : 0x80932988 - 0x80e950f8   (5514 kB)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:16 nr_irqs:16 16
L310 cache controller enabled
l2x0: 16 ways, CACHE_ID 0x410000c7, AUX_CTRL 0x32070000, Cache size: 1024 kB
Switching to timer-based delay loop
Division by zero in kernel.
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326+ #948
Backtrace:
[<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
 r6:00000000 r5:00000000 r4:00000000 r3:00000000
[<80011e58>] (show_stack) from [<8064cc90>] (dump_stack+0x88/0xa4)
[<8064cc08>] (dump_stack) from [<80011a94>] (__div0+0x18/0x20)
 r5:00000000 r4:00000000
[<80011a7c>] (__div0) from [<8029582c>] (Ldiv0_64+0x8/0x18)
[<8007e854>] (clocks_calc_mult_shift) from [<8089a8d0>]
(sched_clock_register+0x60/0x238)
 r10:f0018074 r9:00000000 r8:80020ba0 r7:00000020 r6:00000000 r5:80932eac
 r4:00000000
[<8089a870>] (sched_clock_register) from [<80884588>]
(mxc_timer_init+0xf8/0x190)
 r10:f0018074 r9:00000000 r8:00000057 r7:f0020024 r6:ee022b80 r5:80932eac
 r4:00000000
[<80884490>] (mxc_timer_init) from [<808910b0>]
(imx6q_clocks_init+0x2c00/0x2d24)
 r8:00000004 r7:809334d0 r6:808c7310 r5:ee7ccbe8 r4:f0020000
[<8088e4b0>] (imx6q_clocks_init) from [<808b024c>] (of_clk_init+0xd8/0x198)
 r10:80923594 r9:809234d4 r8:00000000 r7:ee002ac0 r6:ee002b00 r5:ee7ce5b0
 r4:00000001
[<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
 r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd790 r6:ffffffff r5:809329c0
 r4:00000001
[<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
[<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
 r10:00000000 r8:1000406a r7:808db644 r6:808bd78c r5:808d692c r4:10c5387d
sched_clock: 32 bits at 0 Hz, resolution 0ns, wraps every 0ns
Division by zero in kernel.
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326+ #948
Backtrace:
[<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
 r6:ee011a00 r5:00000000 r4:00000000 r3:00000000
[<80011e58>] (show_stack) from [<8064cc90>] (dump_stack+0x88/0xa4)
[<8064cc08>] (dump_stack) from [<80011a94>] (__div0+0x18/0x20)
 r5:00000000 r4:00000000
[<80011a7c>] (__div0) from [<8029582c>] (Ldiv0_64+0x8/0x18)
[<8007ea84>] (__clocksource_updatefreq_scale) from [<8007ec3c>]
(__clocksource_register_scale+0x14/0x54)
 r10:000000c8 r9:00000000 r8:f0020024 r7:807b3e58 r6:ee0119c0 r5:00000000
 r4:ee011a00
[<8007ec28>] (__clocksource_register_scale) from [<808ae6f8>]
(clocksource_mmio_init+0x8c/0xa8)
 r4:ffffffff r3:00000001
[<808ae66c>] (clocksource_mmio_init) from [<808845ac>]
(mxc_timer_init+0x11c/0x190)
 r10:f0018074 r8:00000057 r7:f0020024 r6:ee022b80 r5:80932eac r4:808dc900
[<80884490>] (mxc_timer_init) from [<808910b0>]
(imx6q_clocks_init+0x2c00/0x2d24)
 r8:00000004 r7:809334d0 r6:808c7310 r5:ee7ccbe8 r4:f0020000
[<8088e4b0>] (imx6q_clocks_init) from [<808b024c>] (of_clk_init+0xd8/0x198)
 r10:80923594 r9:809234d4 r8:00000000 r7:ee002ac0 r6:ee002b00 r5:ee7ce5b0
 r4:00000001
[<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
 r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd790 r6:ffffffff r5:809329c0
 r4:00000001
[<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
[<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
 r10:00000000 r8:1000406a r7:808db644 r6:808bd78c r5:808d692c r4:10c5387d
Division by zero in kernel.
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326+ #948
Backtrace:
[<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
 r6:ee011a00 r5:00000000 r4:00000000 r3:00000000
[<80011e58>] (show_stack) from [<8064cc90>] (dump_stack+0x88/0xa4)
[<8064cc08>] (dump_stack) from [<80011a94>] (__div0+0x18/0x20)
 r5:00000000 r4:00000000
[<80011a7c>] (__div0) from [<8029582c>] (Ldiv0_64+0x8/0x18)
[<8007e854>] (clocks_calc_mult_shift) from [<8007eb28>]
(__clocksource_updatefreq_scale+0xa4/0x1a4)
 r10:00000001 r9:a3d70a3d r8:70a3d70a r7:0000000b r6:ee011a00 r5:00000001
 r4:00000001
[<8007ea84>] (__clocksource_updatefreq_scale) from [<8007ec3c>]
(__clocksource_register_scale+0x14/0x54)
 r10:000000c8 r9:00000000 r8:f0020024 r7:807b3e58 r6:ee0119c0 r5:00000000
 r4:ee011a00
[<8007ec28>] (__clocksource_register_scale) from [<808ae6f8>]
(clocksource_mmio_init+0x8c/0xa8)
 r4:ffffffff r3:00000001
[<808ae66c>] (clocksource_mmio_init) from [<808845ac>]
(mxc_timer_init+0x11c/0x190)
 r10:f0018074 r8:00000057 r7:f0020024 r6:ee022b80 r5:80932eac r4:808dc900
[<80884490>] (mxc_timer_init) from [<808910b0>]
(imx6q_clocks_init+0x2c00/0x2d24)
 r8:00000004 r7:809334d0 r6:808c7310 r5:ee7ccbe8 r4:f0020000
[<8088e4b0>] (imx6q_clocks_init) from [<808b024c>] (of_clk_init+0xd8/0x198)
 r10:80923594 r9:809234d4 r8:00000000 r7:ee002ac0 r6:ee002b00 r5:ee7ce5b0
 r4:00000001
[<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
 r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd790 r6:ffffffff r5:809329c0
 r4:00000001
[<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
[<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
 r10:00000000 r8:1000406a r7:808db644 r6:808bd78c r5:808d692c r4:10c5387d
Division by zero in kernel.
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326+ #948
Backtrace:
[<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
 r6:ee022b80 r5:00000000 r4:00000000 r3:00000000
[<80011e58>] (show_stack) from [<8064cc90>] (dump_stack+0x88/0xa4)
[<8064cc08>] (dump_stack) from [<80011a94>] (__div0+0x18/0x20)
 r5:808dc900 r4:00000000
[<80011a7c>] (__div0) from [<8029582c>] (Ldiv0_64+0x8/0x18)
[<80082314>] (clockevents_config) from [<800823b4>]
(clockevents_config_and_register+0x1c/0x28)
 r5:80932eac r4:808dc900
[<80082398>] (clockevents_config_and_register) from [<808845d8>]
(mxc_timer_init+0x148/0x190)
 r4:808dc900 r3:fffffffe
[<80884490>] (mxc_timer_init) from [<808910b0>]
(imx6q_clocks_init+0x2c00/0x2d24)
 r8:00000004 r7:809334d0 r6:808c7310 r5:ee7ccbe8 r4:f0020000
[<8088e4b0>] (imx6q_clocks_init) from [<808b024c>] (of_clk_init+0xd8/0x198)
 r10:80923594 r9:809234d4 r8:00000000 r7:ee002ac0 r6:ee002b00 r5:ee7ce5b0
 r4:00000001
[<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
 r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd790 r6:ffffffff r5:809329c0
 r4:00000001
[<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
[<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
 r10:00000000 r8:1000406a r7:808db644 r6:808bd78c r5:808d692c r4:10c5387d
------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at kernel/time/clockevents.c:44 cev_delta2ns+0xe8/0x104()
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326+ #948
Backtrace:
[<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
 r6:80081cb8 r5:00000000 r4:00000000 r3:00000000
[<80011e58>] (show_stack) from [<8064cc90>] (dump_stack+0x88/0xa4)
[<8064cc08>] (dump_stack) from [<80028f78>] (warn_slowpath_common+0x70/0x94)
 r5:00000009 r4:00000000
[<80028f08>] (warn_slowpath_common) from [<80028fc0>]
(warn_slowpath_null+0x24/0x2c)
 r8:000000ff r7:000000ff r6:00000000 r5:808dc900 r4:00000000
[<80028f9c>] (warn_slowpath_null) from [<80081cb8>] (cev_delta2ns+0xe8/0x104)
[<80081bd0>] (cev_delta2ns) from [<80082374>] (clockevents_config+0x60/0x84)
 r9:00000000 r8:00000057 r7:f0020024 r6:ee022b80 r5:808dc900 r4:00000000
[<80082314>] (clockevents_config) from [<800823b4>]
(clockevents_config_and_register+0x1c/0x28)
 r5:80932eac r4:808dc900
[<80082398>] (clockevents_config_and_register) from [<808845d8>]
(mxc_timer_init+0x148/0x190)
 r4:808dc900 r3:fffffffe
[<80884490>] (mxc_timer_init) from [<808910b0>]
(imx6q_clocks_init+0x2c00/0x2d24)
 r8:00000004 r7:809334d0 r6:808c7310 r5:ee7ccbe8 r4:f0020000
[<8088e4b0>] (imx6q_clocks_init) from [<808b024c>] (of_clk_init+0xd8/0x198)
 r10:80923594 r9:809234d4 r8:00000000 r7:ee002ac0 r6:ee002b00 r5:ee7ce5b0
 r4:00000001
[<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
 r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd790 r6:ffffffff r5:809329c0
 r4:00000001
[<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
[<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
 r10:00000000 r8:1000406a r7:808db644 r6:808bd78c r5:808d692c r4:10c5387d
---[ end trace 3406ff24bd97382e ]---
clk: missing #clock-cells property at /clocks/osc
clk: missing #clock-cells property at /clocks/ckih1
clk: missing #clock-cells property at /clocks/ckil
