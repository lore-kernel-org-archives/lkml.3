Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbaKTVd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:33:59 -0500
Received: from mta-out1.inet.fi ([62.71.2.195]:56305 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757000AbaKTVd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:33:58 -0500
Date: Thu, 20 Nov 2014 23:33:48 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 1/6] ACPI/EC: Introduce STARTED/STOPPED flags to replace
 BLOCKED flag.
Message-ID: <20141120213348.GA13221@node.dhcp.inet.fi>
References: <cover.1414988981.git.lv.zheng@intel.com>
 <1AE640813FDE7649BE1B193DEA596E8802689778@SHSMSX101.ccr.corp.intel.com>
 <20141118132328.GA27428@node.dhcp.inet.fi>
 <4486101.LWS7CexbAj@vostro.rjw.lan>
 <20141119121615.GA2514@node.dhcp.inet.fi>
 <1AE640813FDE7649BE1B193DEA596E88026A3D69@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88026A3D69@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 02:20:53AM +0000, Zheng, Lv wrote:
> Since you have environment to trigger this.
> Could you also help to check if the fix can work?
> I've just sent them as RFC to this thread.

With these two patchse on top of my -next snapshot I still see the issue:

[    0.324119] ======================================================
[    0.324125] [ INFO: possible circular locking dependency detected ]
[    0.324132] 3.18.0-rc5-next-20141119-07477-g4c45e54745b2 #80 Not tainted
[    0.324138] -------------------------------------------------------
[    0.324144] swapper/3/0 is trying to acquire lock:
[    0.324149]  (&(&ec->lock)->rlock){-.....}, at: [<ffffffff814cb803>] acpi_ec_gpe_handler+0x21/0xfc
[    0.324165] 
but task is already holding lock:
[    0.324171]  (&(*(&acpi_gbl_gpe_lock))->rlock){-.....}, at: [<ffffffff814c3b3e>] acpi_os_acquire_lock+0xe/0x10
[    0.324185] 
which lock already depends on the new lock.

[    0.324193] 
the existing dependency chain (in reverse order) is:
[    0.324200] 
-> #1 (&(*(&acpi_gbl_gpe_lock))->rlock){-.....}:
[    0.324209]        [<ffffffff81158f0f>] lock_acquire+0xdf/0x2d0
[    0.324218]        [<ffffffff81b004c0>] _raw_spin_lock_irqsave+0x50/0x70
[    0.324228]        [<ffffffff814c3b3e>] acpi_os_acquire_lock+0xe/0x10
[    0.324235]        [<ffffffff814d9945>] acpi_enable_gpe+0x27/0x75
[    0.324244]        [<ffffffff814cc960>] acpi_ec_start+0x67/0x88
[    0.324251]        [<ffffffff81af4ca9>] ec_install_handlers+0x41/0xa4
[    0.324258]        [<ffffffff823e4134>] acpi_ec_ecdt_probe+0x1a9/0x1ea
[    0.324267]        [<ffffffff823e395e>] acpi_init+0x8b/0x26e
[    0.324275]        [<ffffffff81002148>] do_one_initcall+0xd8/0x210
[    0.324283]        [<ffffffff8239c1dc>] kernel_init_freeable+0x1f5/0x282
[    0.324293]        [<ffffffff81aea0fe>] kernel_init+0xe/0xf0
[    0.324300]        [<ffffffff81b011bc>] ret_from_fork+0x7c/0xb0
[    0.324307] 
-> #0 (&(&ec->lock)->rlock){-.....}:
[    0.324315]        [<ffffffff811585af>] __lock_acquire+0x210f/0x2220
[    0.324323]        [<ffffffff81158f0f>] lock_acquire+0xdf/0x2d0
[    0.324330]        [<ffffffff81b004c0>] _raw_spin_lock_irqsave+0x50/0x70
[    0.324338]        [<ffffffff814cb803>] acpi_ec_gpe_handler+0x21/0xfc
[    0.324346]        [<ffffffff814d68e0>] acpi_ev_gpe_dispatch+0xb9/0x12e
[    0.324353]        [<ffffffff814d6a5a>] acpi_ev_gpe_detect+0x105/0x227
[    0.324360]        [<ffffffff814d8af5>] acpi_ev_sci_xrupt_handler+0x22/0x38
[    0.324368]        [<ffffffff814c2dae>] acpi_irq+0x16/0x31
[    0.324375]        [<ffffffff8116ecbf>] handle_irq_event_percpu+0x6f/0x540
[    0.324384]        [<ffffffff8116f1d1>] handle_irq_event+0x41/0x70
[    0.324392]        [<ffffffff81171ee6>] handle_fasteoi_irq+0x86/0x140
[    0.324399]        [<ffffffff81075a22>] handle_irq+0x22/0x40
[    0.324408]        [<ffffffff81b0436f>] do_IRQ+0x4f/0xf0
[    0.324416]        [<ffffffff81b02072>] ret_from_intr+0x0/0x1a
[    0.324423]        [<ffffffff8107e7a3>] default_idle+0x23/0x260
[    0.324430]        [<ffffffff8107f37f>] arch_cpu_idle+0xf/0x20
[    0.324438]        [<ffffffff8114a95b>] cpu_startup_entry+0x36b/0x5b0
[    0.324445]        [<ffffffff810a8d24>] start_secondary+0x1a4/0x1d0
[    0.324454] 
other info that might help us debug this:

[    0.324462]  Possible unsafe locking scenario:

[    0.324468]        CPU0                    CPU1
[    0.324473]        ----                    ----
[    0.324477]   lock(&(*(&acpi_gbl_gpe_lock))->rlock);
[    0.324483]                                lock(&(&ec->lock)->rlock);
[    0.324490]                                lock(&(*(&acpi_gbl_gpe_lock))->rlock);
[    0.324498]   lock(&(&ec->lock)->rlock);
[    0.324503] 
 *** DEADLOCK ***

[    0.324510] 1 lock held by swapper/3/0:
[    0.324514]  #0:  (&(*(&acpi_gbl_gpe_lock))->rlock){-.....}, at: [<ffffffff814c3b3e>] acpi_os_acquire_lock+0xe/0x10
[    0.324528] 
stack backtrace:
[    0.324535] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.18.0-rc5-next-20141119-07477-g4c45e54745b2 #80
[    0.324543] Hardware name: LENOVO 3460CC6/3460CC6, BIOS G6ET93WW (2.53 ) 02/04/2013
[    0.324550]  ffffffff82cae120 ffff88011e2c3ba8 ffffffff81af484e 0000000000000011
[    0.324560]  ffffffff82cae120 ffff88011e2c3bf8 ffffffff81af3361 0000000000000001
[    0.324569]  ffff88011e2c3c58 ffff88011e2c3bf8 ffff8801193f92b0 ffff8801193f9b00
[    0.324579] Call Trace:
[    0.324582]  <IRQ>  [<ffffffff81af484e>] dump_stack+0x4c/0x6e
[    0.324593]  [<ffffffff81af3361>] print_circular_bug+0x2b2/0x2c3
[    0.324601]  [<ffffffff811585af>] __lock_acquire+0x210f/0x2220
[    0.324609]  [<ffffffff81158f0f>] lock_acquire+0xdf/0x2d0
[    0.324616]  [<ffffffff814cb803>] ? acpi_ec_gpe_handler+0x21/0xfc
[    0.324624]  [<ffffffff81b004c0>] _raw_spin_lock_irqsave+0x50/0x70
[    0.324631]  [<ffffffff814cb803>] ? acpi_ec_gpe_handler+0x21/0xfc
[    0.324640]  [<ffffffff814e08f7>] ? acpi_hw_write+0x4b/0x52
[    0.324646]  [<ffffffff814cb803>] acpi_ec_gpe_handler+0x21/0xfc
[    0.324653]  [<ffffffff814d68e0>] acpi_ev_gpe_dispatch+0xb9/0x12e
[    0.324660]  [<ffffffff814d6a5a>] acpi_ev_gpe_detect+0x105/0x227
[    0.324668]  [<ffffffff814d8af5>] acpi_ev_sci_xrupt_handler+0x22/0x38
[    0.324675]  [<ffffffff814c2dae>] acpi_irq+0x16/0x31
[    0.324683]  [<ffffffff8116ecbf>] handle_irq_event_percpu+0x6f/0x540
[    0.324691]  [<ffffffff8116f1d1>] handle_irq_event+0x41/0x70
[    0.324698]  [<ffffffff81171e88>] ? handle_fasteoi_irq+0x28/0x140
[    0.324705]  [<ffffffff81171ee6>] handle_fasteoi_irq+0x86/0x140
[    0.324712]  [<ffffffff81075a22>] handle_irq+0x22/0x40
[    0.324719]  [<ffffffff81b0436f>] do_IRQ+0x4f/0xf0
[    0.324725]  [<ffffffff81b02072>] common_interrupt+0x72/0x72
[    0.324731]  <EOI>  [<ffffffff810b8986>] ? native_safe_halt+0x6/0x10
[    0.324743]  [<ffffffff81154efd>] ? trace_hardirqs_on+0xd/0x10
[    0.324750]  [<ffffffff8107e7a3>] default_idle+0x23/0x260
[    0.324757]  [<ffffffff8107f37f>] arch_cpu_idle+0xf/0x20
[    0.324763]  [<ffffffff8114a95b>] cpu_startup_entry+0x36b/0x5b0
[    0.324771]  [<ffffffff810a8d24>] start_secondary+0x1a4/0x1d0


> 
> Thanks and best regards
> -Lv
> 
> > From: Kirill A. Shutemov [mailto:kirill@shutemov.name]
> > Sent: Wednesday, November 19, 2014 8:16 PM
> > To: Rafael J. Wysocki
> > Cc: Zheng, Lv; Wysocki, Rafael J; Brown, Len; Lv Zheng; linux-kernel@vger.kernel.org; linux-acpi@vger.kernel.org
> > Subject: Re: [PATCH 1/6] ACPI/EC: Introduce STARTED/STOPPED flags to replace BLOCKED flag.
> > 
> > On Tue, Nov 18, 2014 at 10:20:11PM +0100, Rafael J. Wysocki wrote:
> > > On Tuesday, November 18, 2014 03:23:28 PM Kirill A. Shutemov wrote:
> > > > On Wed, Nov 05, 2014 at 02:52:36AM +0000, Zheng, Lv wrote:
> > >
> > > [cut]
> > >
> > > >
> > > > Here's lockdep warning I see on -next:
> > >
> > > Is patch [1/6] sufficient to trigger this or do you need all [1-4/6]?
> > 
> > I only saw it on -next. I've tried to apply patches directly on -rc5 and
> > don't see the warning. I don't have time for proper bisecting, sorry.
> > 
> > --
> >  Kirill A. Shutemov

-- 
 Kirill A. Shutemov
