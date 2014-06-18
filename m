Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaFRPhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:37:22 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:49206
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750962AbaFRPhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:37:19 -0400
Date: Wed, 18 Jun 2014 08:36:52 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Harini Katakam <harini.katakam@xilinx.com>
CC: <linus.walleij@linaro.org>, <gnurou@gmail.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <michal.simek@xilinx.com>,
        <linux-gpio@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <harinikatakamlinux@gmail.com>,
        Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH v2 1/2] gpio: Add driver for Zynq GPIO controller
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <5cc8b89b-20ff-4fa9-92dd-bb2f6d3512d8@BY2FFO11FD030.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(164054003)(199002)(189002)(81542001)(92566001)(31696002)(33646001)(23676002)(81342001)(74502001)(74662001)(46102001)(31966008)(76482001)(86362001)(4396001)(74316001)(70736001)(92726001)(95666004)(83506001)(77982001)(21056001)(85306003)(102836001)(76176999)(54356999)(99396002)(50986999)(6806004)(79102001)(83322001)(44976005)(85852003)(1496007)(87936001)(50466002)(104016002)(85202002)(83072002)(80022001)(53416004)(47776003)(85182001)(20776003)(64706001)(77096002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB061;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02462830BE
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I did some of the changes for this v2 and a few things are not clear to
me.

The first is, how is userspace supposed to find the correct offset for a
GPIO pin. E.g. let's say GPIO 10 of this SOC-internal GPIO controller is
something I want to control. So, I'd export GPIO (chip-base + 10). But
this chip-base seems pretty variable. v1 of this patch had it hardcoded
to 0, which resulted in a predictable offset, but apparently was utterly
wrong. Now I see an offset of 138 for this chip when using my config.
And when I use multi_v7_defconfig the offset is somewhere in the 800s,
IIRC. The best I found was the 'label' in the gpiochip's sysfs entry,
but documentation says that is not necessarily unique, and parsing labes
seems sub-optimal too.

The second issue is a stack trace (below) I see when triggering
interrupts (e.g. echo rising > edge; and then pushing the connected
button). Looking at the stack trace, I don't see an obvious error (I
think I pretty much copied the IRQ registration from the gpio-pl061.c
driver you mentioned). Is this an issue in this driver or the core code?
This happens on Linus' latest tip. Despite all this chatter the system
still works and doesn't not seem to lock up.

Here the stack trace:
# echo rising > edge
  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:586
  in_atomic(): 1, irqs_disabled(): 128, pid: 0, name: swapper/0
  no locks held by swapper/0/0.
  irq event stamp: 55488
  hardirqs last  enabled at (55485): [<c03bf10c>] cpuidle_enter_state+0x60/0xec
  hardirqs last disabled at (55486): [<c0014374>] __irq_svc+0x34/0x78
  softirqs last  enabled at (55488): [<c002fc40>] _local_bh_enable+0x58/0x64
  softirqs last disabled at (55487): [<c0030534>] irq_enter+0x48/0x88
  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-xilinx-00021-gf5ddad957172 #88
  [<c0017840>] (unwind_backtrace) from [<c0013770>] (show_stack+0x20/0x24)
  [<c0013770>] (show_stack) from [<c04d94a0>] (dump_stack+0x8c/0xd0)
  [<c04d94a0>] (dump_stack) from [<c005d5e4>] (__might_sleep+0x1ac/0x1e4)
  [<c005d5e4>] (__might_sleep) from [<c04dc19c>] (mutex_lock_nested+0x40/0x46c)
  [<c04dc19c>] (mutex_lock_nested) from [<c019df34>] (kernfs_notify+0xac/0x148)
  [<c019df34>] (kernfs_notify) from [<c02d89e0>] (gpio_sysfs_irq+0x1c/0x24)
  [<c02d89e0>] (gpio_sysfs_irq) from [<c008588c>] (handle_irq_event_percpu+0xa8/0x3c0)
  [<c008588c>] (handle_irq_event_percpu) from [<c0085bf0>] (handle_irq_event+0x4c/0x6c)
  [<c0085bf0>] (handle_irq_event) from [<c0088a28>] (handle_simple_irq+0xac/0xbc)
  [<c0088a28>] (handle_simple_irq) from [<c0084fec>] (generic_handle_irq+0x30/0x40)
  [<c0084fec>] (generic_handle_irq) from [<c02de3fc>] (zynq_gpio_irqhandler+0xe8/0x130)
  [<c02de3fc>] (zynq_gpio_irqhandler) from [<c0084fec>] (generic_handle_irq+0x30/0x40)
  [<c0084fec>] (generic_handle_irq) from [<c000fd24>] (handle_IRQ+0x78/0xa0)
  [<c000fd24>] (handle_IRQ) from [<c000868c>] (gic_handle_irq+0x4c/0x70)
  [<c000868c>] (gic_handle_irq) from [<c0014384>] (__irq_svc+0x44/0x78)
  Exception stack(0xc0755ec8 to 0xc0755f10)
  5ec0:                   00000001 00000004 00000000 c075fb70 00000001 edfc9310
  5ee0: 8ed05707 0000001d 9e7f7ffa 0000001d c0752308 c0755f44 c0755ee0 c0755f10
  5f00: c0077340 c03bf110 200d0013 ffffffff
  [<c0014384>] (__irq_svc) from [<c03bf110>] (cpuidle_enter_state+0x64/0xec)
  [<c03bf110>] (cpuidle_enter_state) from [<c03bf2a0>] (cpuidle_enter+0x24/0x28)
  [<c03bf2a0>] (cpuidle_enter) from [<c0071d94>] (cpu_idle_loop+0x2e0/0x6fc)
  [<c0071d94>] (cpu_idle_loop) from [<c00721cc>] (cpupri_find+0x0/0x108)
  
  =================================
  [ INFO: inconsistent lock state ]
  3.16.0-rc1-xilinx-00021-gf5ddad957172 #88 Not tainted
  ---------------------------------
  inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
  swapper/0/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
   (kernfs_mutex){?.+.+.}, at: [<c019df34>] kernfs_notify+0xac/0x148
  {HARDIRQ-ON-W} state was registered at:
    [<c0079a08>] lock_acquire+0xfc/0x21c
    [<c04dc1e0>] mutex_lock_nested+0x84/0x46c
    [<c019d668>] kernfs_activate+0x2c/0xf8
    [<c019d9b8>] kernfs_create_root+0xbc/0xe0
    [<c070edac>] sysfs_init+0x20/0x5c
    [<c070cef4>] mnt_init+0x108/0x258
    [<c070caa8>] vfs_caches_init+0x9c/0x110
    [<c06f5c3c>] start_kernel+0x364/0x3fc
    [<00008074>] 0x8074
  irq event stamp: 55488
  hardirqs last  enabled at (55485): [<c03bf10c>] cpuidle_enter_state+0x60/0xec
  hardirqs last disabled at (55486): [<c0014374>] __irq_svc+0x34/0x78
  softirqs last  enabled at (55488): [<c002fc40>] _local_bh_enable+0x58/0x64
  softirqs last disabled at (55487): [<c0030534>] irq_enter+0x48/0x88
  
  other info that might help us debug this:
   Possible unsafe locking scenario:
  
         CPU0
         ----
    lock(kernfs_mutex);
    <Interrupt>
      lock(kernfs_mutex);
  
   *** DEADLOCK ***
  
  no locks held by swapper/0/0.
  
  stack backtrace:
  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1-xilinx-00021-gf5ddad957172 #88
  [<c0017840>] (unwind_backtrace) from [<c0013770>] (show_stack+0x20/0x24)
  [<c0013770>] (show_stack) from [<c04d94a0>] (dump_stack+0x8c/0xd0)
  [<c04d94a0>] (dump_stack) from [<c0076a50>] (print_usage_bug+0x254/0x2c4)
  [<c0076a50>] (print_usage_bug) from [<c0076e6c>] (mark_lock+0x3ac/0x674)
  [<c0076e6c>] (mark_lock) from [<c0078024>] (__lock_acquire+0x934/0x1b58)
  [<c0078024>] (__lock_acquire) from [<c0079a08>] (lock_acquire+0xfc/0x21c)
  [<c0079a08>] (lock_acquire) from [<c04dc1e0>] (mutex_lock_nested+0x84/0x46c)
  [<c04dc1e0>] (mutex_lock_nested) from [<c019df34>] (kernfs_notify+0xac/0x148)
  [<c019df34>] (kernfs_notify) from [<c02d89e0>] (gpio_sysfs_irq+0x1c/0x24)
  [<c02d89e0>] (gpio_sysfs_irq) from [<c008588c>] (handle_irq_event_percpu+0xa8/0x3c0)
  [<c008588c>] (handle_irq_event_percpu) from [<c0085bf0>] (handle_irq_event+0x4c/0x6c)
  [<c0085bf0>] (handle_irq_event) from [<c0088a28>] (handle_simple_irq+0xac/0xbc)
  [<c0088a28>] (handle_simple_irq) from [<c0084fec>] (generic_handle_irq+0x30/0x40)
  [<c0084fec>] (generic_handle_irq) from [<c02de3fc>] (zynq_gpio_irqhandler+0xe8/0x130)
  [<c02de3fc>] (zynq_gpio_irqhandler) from [<c0084fec>] (generic_handle_irq+0x30/0x40)
  [<c0084fec>] (generic_handle_irq) from [<c000fd24>] (handle_IRQ+0x78/0xa0)
  [<c000fd24>] (handle_IRQ) from [<c000868c>] (gic_handle_irq+0x4c/0x70)
  [<c000868c>] (gic_handle_irq) from [<c0014384>] (__irq_svc+0x44/0x78)
  Exception stack(0xc0755ec8 to 0xc0755f10)
  5ec0:                   00000001 00000004 00000000 c075fb70 00000001 edfc9310
  5ee0: 8ed05707 0000001d 9e7f7ffa 0000001d c0752308 c0755f44 c0755ee0 c0755f10
  5f00: c0077340 c03bf110 200d0013 ffffffff
  [<c0014384>] (__irq_svc) from [<c03bf110>] (cpuidle_enter_state+0x64/0xec)
  [<c03bf110>] (cpuidle_enter_state) from [<c03bf2a0>] (cpuidle_enter+0x24/0x28)
  [<c03bf2a0>] (cpuidle_enter) from [<c0071d94>] (cpu_idle_loop+0x2e0/0x6fc)
  [<c0071d94>] (cpu_idle_loop) from [<c00721cc>] (cpupri_find+0x0/0x108)

	Thanks,
	Sören

