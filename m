Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab3IQGBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 02:01:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:15783 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab3IQGA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 02:00:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,920,1371106800"; 
   d="scan'208";a="361535758"
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ilw <ilw@linux.intel.com>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: RE: [Ilw] 3.10.10-rt7: inconsistent lock state (iwlwifi)
Thread-Topic: [Ilw] 3.10.10-rt7: inconsistent lock state (iwlwifi)
Thread-Index: AQHOsyNJ8bUgZCxMZkyUVL1GjuiAsJnJbpHw
Date: Tue, 17 Sep 2013 06:00:54 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301DB078F@HASMSX103.ger.corp.intel.com>
References: <1379365850.3828.3.camel@localhost.localdomain>
In-Reply-To: <1379365850.3828.3.camel@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.184.70.12]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8H61WVV009569

> 
> lockdep complains about this:
 
> 
> [   92.094870]        CPU0
> [   92.094871]        ----
> [   92.094872]   lock(&trans_pcie->irq_lock);
> [   92.094873]   <Interrupt>
> [   92.094875]     lock(&trans_pcie->irq_lock);
> [   92.094875]
>  *** DEADLOCK ***

Sorry by I am not aware of all the details of RT kernels.
What I see here is that we always disable interrupts when we take trans_pcie->irq_lock so I don't see how this flow is possible - at least not in the world I know. Can you please elaborate on why this is possible in the RT world?

Thanks.

> 
> [   92.094877] 1 lock held by systemd-journal/1002:
> [   92.094882]  #0:  (&mm->mmap_sem){+++++.}, at: [<ffffffff8152d04c>]
> __do_page_fault+0x1cc/0x5a0
> [   92.094883]
> stack backtrace:
> [   92.094885] CPU: 0 PID: 1002 Comm: systemd-journal Not tainted 3.10.10-
> rt7 #5
> [   92.094887] Hardware name: Acer Aspire 1810T/JM11-MS, BIOS v1.3310
> 03/25/2010
> [   92.094890]  ffffffff81fd95f0 ffffffff81a21cf0 ffffffff81525783
> ffffffff81a21d40
> [   92.094893]  ffffffff81522347 0000000000000000 ffff880100000000
> ffffffff00000001
> [   92.094895]  0000000000000002 ffff88013734d050 ffffffff8107d420
> 0000000000000000
> [   92.094896] Call Trace:
> [   92.094902]  <IRQ>  [<ffffffff81525783>] dump_stack+0x19/0x1b
> [   92.094905]  [<ffffffff81522347>] print_usage_bug+0x1fb/0x20c
> [   92.094909]  [<ffffffff8107d420>] ? check_usage_backwards+0x140/0x140
> [   92.094912]  [<ffffffff8107de3a>] mark_lock+0x23a/0x2c0
> [   92.094914]  [<ffffffff8107ec4f>] __lock_acquire+0x7ff/0x1a60
> [   92.094918]  [<ffffffff8152d04c>] ? __do_page_fault+0x1cc/0x5a0
> [   92.094920]  [<ffffffff81080622>] lock_acquire+0x62/0x80
> [   92.094927]  [<ffffffffa015587c>] ? iwl_pcie_isr_ict+0x2c/0x2d0 [iwlwifi]
> [   92.094930]  [<ffffffff81529360>] rt_spin_lock+0x40/0x50
> [   92.094936]  [<ffffffffa015587c>] ? iwl_pcie_isr_ict+0x2c/0x2d0 [iwlwifi]
> [   92.094943]  [<ffffffffa015587c>] iwl_pcie_isr_ict+0x2c/0x2d0 [iwlwifi]
> [   92.094948]  [<ffffffff810a88d5>] handle_irq_event_percpu+0x55/0x180
> [   92.094951]  [<ffffffff810a8a38>] handle_irq_event+0x38/0x60
> [   92.094954]  [<ffffffff810aab7f>] handle_edge_irq+0x6f/0x140
> [   92.094956]  [<ffffffff81003ae9>] handle_irq+0x19/0x30
> [   92.094959]  [<ffffffff810039b5>] do_IRQ+0x45/0xb0
> [   92.094962]  [<ffffffff8152a22d>] common_interrupt+0x6d/0x6d
> [   92.094966]  <EOI>  [<ffffffff8152d04c>] ? __do_page_fault+0x1cc/0x5a0
> [   92.094969]  [<ffffffff810806e0>] ? lock_release_non_nested+0xa0/0x300
> [   92.094973]  [<ffffffff8106196d>] ? get_parent_ip+0xd/0x50
> [   92.094976]  [<ffffffff8152a2c9>] ? retint_swapgs+0xe/0x13
> [   92.094980]  [<ffffffff8123ed3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [   92.094983]  [<ffffffff8152d429>] do_page_fault+0x9/0x10
> [   92.094985]  [<ffffffff8152a502>] page_fault+0x22/0x30
> [   92.288725] iwlwifi 0000:02:00.0: L1 Enabled; Disabling L0S
> [   92.291849] iwlwifi 0000:02:00.0: Radio type=0x1-0x2-0x0
> [   92.422236] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> 
> 
> _______________________________________________
> ilw mailing list
> ilw@linux.intel.com
> http://linux.intel.com/mailman/listinfo/ilw
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
