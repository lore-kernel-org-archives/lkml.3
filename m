Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746AbaKRU7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:59:14 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49378 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932175AbaKRU7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:59:07 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Zheng, Lv" <lv.zheng@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 1/6] ACPI/EC: Introduce STARTED/STOPPED flags to replace BLOCKED flag.
Date: Tue, 18 Nov 2014 22:20:11 +0100
Message-ID: <4486101.LWS7CexbAj@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141118132328.GA27428@node.dhcp.inet.fi>
References: <cover.1414988981.git.lv.zheng@intel.com> <1AE640813FDE7649BE1B193DEA596E8802689778@SHSMSX101.ccr.corp.intel.com> <20141118132328.GA27428@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 18, 2014 03:23:28 PM Kirill A. Shutemov wrote:
> On Wed, Nov 05, 2014 at 02:52:36AM +0000, Zheng, Lv wrote:

[cut]

> 
> Here's lockdep warning I see on -next:

Is patch [1/6] sufficient to trigger this or do you need all [1-4/6]?


> [    0.510159] ======================================================
> [    0.510171] [ INFO: possible circular locking dependency detected ]
> [    0.510185] 3.18.0-rc4-next-20141117-07404-g9dad2ab6df8b #66 Not tainted
> [    0.510197] -------------------------------------------------------
> [    0.510209] swapper/3/0 is trying to acquire lock:
> [    0.510219]  (&(&ec->lock)->rlock){-.....}, at: [<ffffffff814d533e>] acpi_ec_gpe_handler+0x21/0xfc
> [    0.510254] 
> [    0.510254] but task is already holding lock:
> [    0.510266]  (&(*(&acpi_gbl_gpe_lock))->rlock){-.....}, at: [<ffffffff814cd67e>] acpi_os_acquire_lock+0xe/0x10
> [    0.510296] 
> [    0.510296] which lock already depends on the new lock.
> [    0.510296] 
> [    0.510312] 
> [    0.510312] the existing dependency chain (in reverse order) is:
> [    0.510327] 
> [    0.510327] -> #1 (&(*(&acpi_gbl_gpe_lock))->rlock){-.....}:
> [    0.510344]        [<ffffffff81158f4f>] lock_acquire+0xdf/0x2d0
> [    0.510364]        [<ffffffff81b08010>] _raw_spin_lock_irqsave+0x50/0x70
> [    0.510381]        [<ffffffff814cd67e>] acpi_os_acquire_lock+0xe/0x10
> [    0.510398]        [<ffffffff814e31e8>] acpi_enable_gpe+0x22/0x68
> [    0.510416]        [<ffffffff814d5b24>] acpi_ec_start+0x66/0x87
> [    0.510432]        [<ffffffff81afc771>] ec_install_handlers+0x41/0xa4
> [    0.510449]        [<ffffffff823e72b9>] acpi_ec_ecdt_probe+0x1a9/0x1ea
> [    0.510466]        [<ffffffff823e6ae3>] acpi_init+0x8b/0x26e
> [    0.510480]        [<ffffffff81002148>] do_one_initcall+0xd8/0x210
> [    0.510496]        [<ffffffff8239f1dc>] kernel_init_freeable+0x1f5/0x282
> [    0.510513]        [<ffffffff81af1a1e>] kernel_init+0xe/0xf0
> [    0.510527]        [<ffffffff81b08cfc>] ret_from_fork+0x7c/0xb0
> [    0.510542] 
> [    0.510542] -> #0 (&(&ec->lock)->rlock){-.....}:
> [    0.510558]        [<ffffffff811585ef>] __lock_acquire+0x210f/0x2220
> [    0.510574]        [<ffffffff81158f4f>] lock_acquire+0xdf/0x2d0
> [    0.510589]        [<ffffffff81b08010>] _raw_spin_lock_irqsave+0x50/0x70
> [    0.510604]        [<ffffffff814d533e>] acpi_ec_gpe_handler+0x21/0xfc
> [    0.510620]        [<ffffffff814e02c2>] acpi_ev_gpe_dispatch+0xd2/0x143
> [    0.510636]        [<ffffffff814e03fb>] acpi_ev_gpe_detect+0xc8/0x10f
> [    0.510652]        [<ffffffff814e23b6>] acpi_ev_sci_xrupt_handler+0x22/0x38
> [    0.510669]        [<ffffffff814cc8ee>] acpi_irq+0x16/0x31
> [    0.510684]        [<ffffffff8116eccf>] handle_irq_event_percpu+0x6f/0x540
> [    0.510702]        [<ffffffff8116f1e1>] handle_irq_event+0x41/0x70
> [    0.510718]        [<ffffffff81171ef6>] handle_fasteoi_irq+0x86/0x140
> [    0.510733]        [<ffffffff81075a22>] handle_irq+0x22/0x40
> [    0.510748]        [<ffffffff81b0beaf>] do_IRQ+0x4f/0xf0
> [    0.510762]        [<ffffffff81b09bb2>] ret_from_intr+0x0/0x1a
> [    0.510777]        [<ffffffff8107e783>] default_idle+0x23/0x260
> [    0.510792]        [<ffffffff8107f35f>] arch_cpu_idle+0xf/0x20
> [    0.510806]        [<ffffffff8114a99b>] cpu_startup_entry+0x36b/0x5b0
> [    0.510821]        [<ffffffff810a8d04>] start_secondary+0x1a4/0x1d0
> [    0.510840] 
> [    0.510840] other info that might help us debug this:
> [    0.510840] 
> [    0.510856]  Possible unsafe locking scenario:
> [    0.510856] 
> [    0.510868]        CPU0                    CPU1
> [    0.510877]        ----                    ----
> [    0.510886]   lock(&(*(&acpi_gbl_gpe_lock))->rlock);
> [    0.510898]                                lock(&(&ec->lock)->rlock);
> [    0.510912]                                lock(&(*(&acpi_gbl_gpe_lock))->rlock);
> [    0.510927]   lock(&(&ec->lock)->rlock);
> [    0.510938] 
> [    0.510938]  *** DEADLOCK ***
> [    0.510938] 
> [    0.510953] 1 lock held by swapper/3/0:
> [    0.510961]  #0:  (&(*(&acpi_gbl_gpe_lock))->rlock){-.....}, at: [<ffffffff814cd67e>] acpi_os_acquire_lock+0xe/0x10
> [    0.510990] 
> [    0.510990] stack backtrace:
> [    0.511004] CPU: 3 PID: 0 Comm: swapper/3 Not tainted 3.18.0-rc4-next-20141117-07404-g9dad2ab6df8b #66
> [    0.511021] Hardware name: LENOVO 3460CC6/3460CC6, BIOS G6ET93WW (2.53 ) 02/04/2013
> [    0.511035]  ffffffff82cb2f70 ffff88011e2c3bb8 ffffffff81afc316 0000000000000011
> [    0.511055]  ffffffff82cb2f70 ffff88011e2c3c08 ffffffff81afae11 0000000000000001
> [    0.511074]  ffff88011e2c3c68 ffff88011e2c3c08 ffff8801193f92d0 ffff8801193f9b20
> [    0.511094] Call Trace:
> [    0.511101]  <IRQ>  [<ffffffff81afc316>] dump_stack+0x4c/0x6e
> [    0.511125]  [<ffffffff81afae11>] print_circular_bug+0x2b2/0x2c3
> [    0.511142]  [<ffffffff811585ef>] __lock_acquire+0x210f/0x2220
> [    0.511159]  [<ffffffff81158f4f>] lock_acquire+0xdf/0x2d0
> [    0.511176]  [<ffffffff814d533e>] ? acpi_ec_gpe_handler+0x21/0xfc
> [    0.511192]  [<ffffffff81b08010>] _raw_spin_lock_irqsave+0x50/0x70
> [    0.511209]  [<ffffffff814d533e>] ? acpi_ec_gpe_handler+0x21/0xfc
> [    0.511225]  [<ffffffff814ea192>] ? acpi_hw_write+0x4b/0x52
> [    0.511241]  [<ffffffff814d533e>] acpi_ec_gpe_handler+0x21/0xfc
> [    0.511258]  [<ffffffff814e02c2>] acpi_ev_gpe_dispatch+0xd2/0x143
> [    0.511274]  [<ffffffff814e03fb>] acpi_ev_gpe_detect+0xc8/0x10f
> [    0.511292]  [<ffffffff814e23b6>] acpi_ev_sci_xrupt_handler+0x22/0x38
> [    0.511309]  [<ffffffff814cc8ee>] acpi_irq+0x16/0x31
> [    0.511325]  [<ffffffff8116eccf>] handle_irq_event_percpu+0x6f/0x540
> [    0.511342]  [<ffffffff8116f1e1>] handle_irq_event+0x41/0x70
> [    0.511357]  [<ffffffff81171e98>] ? handle_fasteoi_irq+0x28/0x140
> [    0.511372]  [<ffffffff81171ef6>] handle_fasteoi_irq+0x86/0x140
> [    0.511388]  [<ffffffff81075a22>] handle_irq+0x22/0x40
> [    0.511402]  [<ffffffff81b0beaf>] do_IRQ+0x4f/0xf0
> [    0.511417]  [<ffffffff81b09bb2>] common_interrupt+0x72/0x72
> [    0.511428]  <EOI>  [<ffffffff810b8986>] ? native_safe_halt+0x6/0x10
> [    0.511454]  [<ffffffff81154f3d>] ? trace_hardirqs_on+0xd/0x10
> [    0.511468]  [<ffffffff8107e783>] default_idle+0x23/0x260
> [    0.511482]  [<ffffffff8107f35f>] arch_cpu_idle+0xf/0x20
> [    0.511496]  [<ffffffff8114a99b>] cpu_startup_entry+0x36b/0x5b0
> [    0.511512]  [<ffffffff810a8d04>] start_secondary+0x1a4/0x1d0
> 
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
