Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201Ab3BLUuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:50:46 -0500
Received: from mail-yh0-f45.google.com ([209.85.213.45]:50809 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759029Ab3BLUuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:50:44 -0500
Date: Tue, 12 Feb 2013 12:50:38 -0800
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel J Blueman <daniel@quora.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [3.8-rc7] PCI hotplug wakeup oops
Message-ID: <20130212205038.GA9057@htj.dyndns.org>
References: <CAMVG2svG21yiM1wkH4_2pen2n+cr2-Zv7TbH3Gj+8MwevZjDbw@mail.gmail.com>
 <1843565.7Y1sC8j6FG@vostro.rjw.lan>
 <CAMVG2suQiG7viSFE3aTas4QEbyq+LBDxT_8C-n3J9BdX21BfkQ@mail.gmail.com>
 <2437657.3PbvdpUqxu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2437657.3PbvdpUqxu@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Rafael.

On Tue, Feb 12, 2013 at 09:53:08PM +0100, Rafael J. Wysocki wrote:
> This looks fishy, but I wonder if Tejun has any ideas.
> 
> Tejun, can you please have a look at the call trace below?  It looks like
> the workqueues code is involved heavily.
> > 
> > kworker/0:0/4 is trying to acquire lock:
> >  (name){++++.+}, at: [<ffffffff8105ac70>] flush_workqueue+0x0/0x4d0
> > 
> > but task is already holding lock:
> >  (name){++++.+}, at: [<ffffffff8105c7e0>] process_one_work+0x160/0x4e0

It's basically saying that a work item is trying to flush the
workqueue it's currently executing on, at least in lockdep's eyes.

> > stack backtrace:
> > Pid: 4, comm: kworker/0:0 Not tainted 3.8.0-rc7-ninja+ #21
> > Call Trace:
> >  [<ffffffff81090213>] validate_chain.isra.33+0xda3/0x1240
> >  [<ffffffff8109113c>] __lock_acquire+0x3ac/0xb30
> >  [<ffffffff81091d8a>] lock_acquire+0x5a/0x70
> >  [<ffffffff8105ad58>] flush_workqueue+0xe8/0x4d0
> >  [<ffffffff8105b1c8>] drain_workqueue+0x68/0x1f0
> >  [<ffffffff8105b363>] destroy_workqueue+0x13/0x160

And the flush is from workqueue destruction

> >  [<ffffffff8125ad0a>] pciehp_release_ctrl+0x3a/0x90
> >  [<ffffffff81257ca5>] pciehp_remove+0x25/0x30
> >  [<ffffffff81251f72>] pcie_port_remove_service+0x52/0x70
> >  [<ffffffff81302217>] __device_release_driver+0x77/0xe0
> >  [<ffffffff813022a9>] device_release_driver+0x29/0x40
> >  [<ffffffff81301cb1>] bus_remove_device+0xf1/0x140
> >  [<ffffffff812ff847>] device_del+0x127/0x1c0
> >  [<ffffffff812ff8f1>] device_unregister+0x11/0x20
> >  [<ffffffff81252125>] remove_iter+0x35/0x40
> >  [<ffffffff812fe716>] device_for_each_child+0x36/0x70
> >  [<ffffffff812526c1>] pcie_port_device_remove+0x21/0x40
> >  [<ffffffff81252908>] pcie_portdrv_remove+0x28/0x50
> >  [<ffffffff81246cb1>] pci_device_remove+0x41/0xc0
> >  [<ffffffff81302217>] __device_release_driver+0x77/0xe0
> >  [<ffffffff813022a9>] device_release_driver+0x29/0x40
> >  [<ffffffff81301cb1>] bus_remove_device+0xf1/0x140
> >  [<ffffffff812ff847>] device_del+0x127/0x1c0
> >  [<ffffffff812ff8f1>] device_unregister+0x11/0x20
> >  [<ffffffff81241b74>] pci_stop_bus_device+0xb4/0xc0
> >  [<ffffffff81241af5>] pci_stop_bus_device+0x35/0xc0
> >  [<ffffffff81241cd1>] pci_stop_and_remove_bus_device+0x11/0x20
> >  [<ffffffff81259021>] pciehp_unconfigure_device+0x91/0x190
> >  [<ffffffff81258921>] pciehp_disable_slot+0x71/0x220
> >  [<ffffffff81258bb6>] pciehp_power_thread+0xe6/0x110
> >  [<ffffffff8105c84a>] process_one_work+0x1ca/0x4e0

running from a workqueue which probably is at least transitively
related to the workqueue being destroyed.  Does this lead to an actual
deadlock?

Thanks.

-- 
tejun
