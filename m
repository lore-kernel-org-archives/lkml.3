Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab3IPVZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 17:25:29 -0400
Received: from www17.your-server.de ([213.133.104.17]:60707 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3IPVZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 17:25:25 -0400
Message-ID: <1379365850.3828.3.camel@localhost.localdomain>
Subject: 3.10.10-rt7: inconsistent lock state (iwlwifi)
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ilw <ilw@linux.intel.com>, linux-rt-users@vger.kernel.org
Date: Mon, 16 Sep 2013 23:10:50 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

lockdep complains about this:

[   92.041513] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   92.090910] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0

[   92.094779] =================================
[   92.094780] [ INFO: inconsistent lock state ]
[   92.094782] 3.10.10-rt7 #5 Not tainted
[   92.094783] ---------------------------------
[   92.094784] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[   92.094787] systemd-journal/1002 [HC1[1]:SC0[0]:HE0:SE1] takes:
[   92.094801]  (&trans_pcie->irq_lock){?.+...}, at: [<ffffffffa015587c>] iwl_pcie_isr_ict+0x2c/0x2d0 [iwlwifi]
[   92.094802] {HARDIRQ-ON-W} state was registered at:
[   92.094808]   [<ffffffff8107ea04>] __lock_acquire+0x5b4/0x1a60
[   92.094810]   [<ffffffff81080622>] lock_acquire+0x62/0x80
[   92.094814]   [<ffffffff81529360>] rt_spin_lock+0x40/0x50
[   92.094822]   [<ffffffffa015a49e>] iwl_trans_pcie_stop_hw+0x1e/0x150 [iwlwifi]
[   92.094830]   [<ffffffffa0265e84>] iwl_op_mode_dvm_start+0x244/0xc10 [iwldvm]
[   92.094836]   [<ffffffffa015062b>] iwl_opmode_register+0xcb/0xf0 [iwlwifi]
[   92.094840]   [<ffffffffa0288037>] acpi_cpufreq_cpu_exit+0x17/0x50 [acpi_cpufreq]
[   92.094843]   [<ffffffff810002a2>] do_one_initcall+0xf2/0x150
[   92.094848]   [<ffffffff8108b0cf>] load_module+0x18cf/0x2150
[   92.094851]   [<ffffffff8108ba96>] SyS_finit_module+0x76/0x80
[   92.094854]   [<ffffffff8152fa50>] system_call_fastpath+0x16/0x1b
[   92.094855] irq event stamp: 291624
[   92.094859] hardirqs last  enabled at (291623): [<ffffffff8152cef9>] __do_page_fault+0x79/0x5a0
[   92.094863] hardirqs last disabled at (291624): [<ffffffff8152a228>] common_interrupt+0x68/0x6d
[   92.094866] softirqs last  enabled at (0): [<ffffffff81033229>] copy_process.part.31+0x619/0x14f0
[   92.094868] softirqs last disabled at (0): [<          (null)>]           (null)
[   92.094869] 
other info that might help us debug this:
[   92.094870]  Possible unsafe locking scenario:

[   92.094870]        CPU0
[   92.094871]        ----
[   92.094872]   lock(&trans_pcie->irq_lock);
[   92.094873]   <Interrupt>
[   92.094875]     lock(&trans_pcie->irq_lock);
[   92.094875] 
 *** DEADLOCK ***

[   92.094877] 1 lock held by systemd-journal/1002:
[   92.094882]  #0:  (&mm->mmap_sem){+++++.}, at: [<ffffffff8152d04c>] __do_page_fault+0x1cc/0x5a0
[   92.094883] 
stack backtrace:
[   92.094885] CPU: 0 PID: 1002 Comm: systemd-journal Not tainted 3.10.10-rt7 #5
[   92.094887] Hardware name: Acer Aspire 1810T/JM11-MS, BIOS v1.3310 03/25/2010
[   92.094890]  ffffffff81fd95f0 ffffffff81a21cf0 ffffffff81525783 ffffffff81a21d40
[   92.094893]  ffffffff81522347 0000000000000000 ffff880100000000 ffffffff00000001
[   92.094895]  0000000000000002 ffff88013734d050 ffffffff8107d420 0000000000000000
[   92.094896] Call Trace:
[   92.094902]  <IRQ>  [<ffffffff81525783>] dump_stack+0x19/0x1b
[   92.094905]  [<ffffffff81522347>] print_usage_bug+0x1fb/0x20c
[   92.094909]  [<ffffffff8107d420>] ? check_usage_backwards+0x140/0x140
[   92.094912]  [<ffffffff8107de3a>] mark_lock+0x23a/0x2c0
[   92.094914]  [<ffffffff8107ec4f>] __lock_acquire+0x7ff/0x1a60
[   92.094918]  [<ffffffff8152d04c>] ? __do_page_fault+0x1cc/0x5a0
[   92.094920]  [<ffffffff81080622>] lock_acquire+0x62/0x80
[   92.094927]  [<ffffffffa015587c>] ? iwl_pcie_isr_ict+0x2c/0x2d0 [iwlwifi]
[   92.094930]  [<ffffffff81529360>] rt_spin_lock+0x40/0x50
[   92.094936]  [<ffffffffa015587c>] ? iwl_pcie_isr_ict+0x2c/0x2d0 [iwlwifi]
[   92.094943]  [<ffffffffa015587c>] iwl_pcie_isr_ict+0x2c/0x2d0 [iwlwifi]
[   92.094948]  [<ffffffff810a88d5>] handle_irq_event_percpu+0x55/0x180
[   92.094951]  [<ffffffff810a8a38>] handle_irq_event+0x38/0x60
[   92.094954]  [<ffffffff810aab7f>] handle_edge_irq+0x6f/0x140
[   92.094956]  [<ffffffff81003ae9>] handle_irq+0x19/0x30
[   92.094959]  [<ffffffff810039b5>] do_IRQ+0x45/0xb0
[   92.094962]  [<ffffffff8152a22d>] common_interrupt+0x6d/0x6d
[   92.094966]  <EOI>  [<ffffffff8152d04c>] ? __do_page_fault+0x1cc/0x5a0
[   92.094969]  [<ffffffff810806e0>] ? lock_release_non_nested+0xa0/0x300
[   92.094973]  [<ffffffff8106196d>] ? get_parent_ip+0xd/0x50
[   92.094976]  [<ffffffff8152a2c9>] ? retint_swapgs+0xe/0x13
[   92.094980]  [<ffffffff8123ed3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   92.094983]  [<ffffffff8152d429>] do_page_fault+0x9/0x10
[   92.094985]  [<ffffffff8152a502>] page_fault+0x22/0x30
[   92.288725] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
[   92.291849] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
[   92.422236] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready


