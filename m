Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbaLHJTY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:19:24 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:46479 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403AbaLHJTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:19:22 -0500
Message-ID: <54856CEB.2070100@hp.com>
Date: Mon, 08 Dec 2014 17:18:35 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Li, ZhenHua" <zhen-hual@hp.com>
Subject: call trace caused by iounmap and spin_lock_irqsave
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I meet a problem about ioremap/iounmap and spin_lock_irqsave
/spin_unlock_irqrestore , does anybody know how to fix this?

The code is like this:

void some_function(){
     void __iomem * virt_mem;
     ....

     spin_lock_irqsave(&iommu->lock, flags);
     virt_mem = ioremap(from, size);
     memcpy(to, virt_mem, size);
     ....
     iounmap(virt_mem);
     ....
     spin_unlock_irqrestore(&iommu->lock, flags);
}

The problem is : when iounmap is called between spin_lock_irqsave and
spin_unlock_irqrestore, there may happen some call trace dump.

[    8.651661] WARNING: CPU: 2 PID: 1 at kernel/smp.c:401 
smp_call_function_many+0xbd/0x290()
[    8.660937] Modules linked in:
[    8.664373] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc2.bp #113
[    8.671897]  0000000000000000 00000000fc89b093 ffff880035e83848 
ffffffff81691f2b
[    8.680230]  0000000000000000 0000000000000000 ffff880035e83888 
ffffffff81074d21
[    8.688564]  ffff880035e83868 ffffffff81065cc0 ffff880035e83928 
0000000000000002
[    8.696897] Call Trace:
[    8.699641]  [<ffffffff81691f2b>] dump_stack+0x46/0x58
[    8.705412]  [<ffffffff81074d21>] warn_slowpath_common+0x81/0xa0
[    8.712157]  [<ffffffff81065cc0>] ? 
rbt_memtype_copy_nth_element+0xc0/0xc0
[    8.719873]  [<ffffffff81074e3a>] warn_slowpath_null+0x1a/0x20
[    8.726419]  [<ffffffff810ef9bd>] smp_call_function_many+0xbd/0x290
[    8.733453]  [<ffffffff81065cc0>] ? 
rbt_memtype_copy_nth_element+0xc0/0xc0
[    8.741171]  [<ffffffff810efbf1>] on_each_cpu+0x31/0x60
[    8.747035]  [<ffffffff8106647d>] flush_tlb_kernel_range+0x7d/0x90
[    8.753978]  [<ffffffff811af2d7>] __purge_vmap_area_lazy+0x2c7/0x3a0
[    8.761112]  [<ffffffff81063610>] ? arch_pick_mmap_layout+0x280/0x280
[    8.768339]  [<ffffffff811af5bc>] free_vmap_area_noflush+0x7c/0x90
[    8.775276]  [<ffffffff811b0e2e>] remove_vm_area+0x5e/0x70
[    8.781432]  [<ffffffff81060047>] iounmap+0x67/0xa0
.... More trace ....


My question is: If we do not move iounmap out of this lock/unlock field, 
is there any fix for this WARNING?

Thanks
Zhenhua
