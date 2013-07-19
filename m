Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022Ab3GSJBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:01:11 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:50994 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3GSJBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:01:07 -0400
Message-ID: <51E8FF76.5030706@linux.vnet.ibm.com>
Date: Fri, 19 Jul 2013 14:27:26 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        bhelgaas@google.com
Subject: Re: workqueue, pci: INFO: possible recursive locking detected
References: <51E55B7D.2040209@linux.vnet.ibm.com> <51E66CCC.9010600@cn.fujitsu.com> <51E84EDC.5090502@linux.vnet.ibm.com> <51E89ABB.20808@cn.fujitsu.com>
In-Reply-To: <51E89ABB.20808@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071908-5140-0000-0000-0000038BAF82
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 07:17 AM, Lai Jiangshan wrote:
> On 07/19/2013 04:23 AM, Srivatsa S. Bhat wrote:
>>
>> ---
>>
>>  kernel/workqueue.c |    6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index f02c4a4..07d9a67 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -4754,7 +4754,13 @@ long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
>>  {
>>  	struct work_for_cpu wfc = { .fn = fn, .arg = arg };
>>  
>> +#ifdef CONFIG_LOCKDEP
>> +	static struct lock_class_key __key;
> 
> Sorry, this "static" should be removed.
> 

That didn't help either :-( Because it makes lockdep unhappy,
since the key isn't persistent.

This is the patch I used:

---

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f02c4a4..7967e3b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4754,7 +4754,13 @@ long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
 {
 	struct work_for_cpu wfc = { .fn = fn, .arg = arg };

+#ifdef CONFIG_LOCKDEP
+	struct lock_class_key __key;
+	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
+	lockdep_init_map(&wfc.work.lockdep_map, "&wfc.work", &__key, 0);
+#else
 	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
+#endif
 	schedule_work_on(cpu, &wfc.work);
 	flush_work(&wfc.work);
 	return wfc.ret;


And here are the new warnings:


Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
BUG: key ffff881039557b98 not in .data!
------------[ cut here ]------------
WARNING: CPU: 8 PID: 1 at kernel/lockdep.c:2987 lockdep_init_map+0x168/0x170()
DEBUG_LOCKS_WARN_ON(1)
Modules linked in:
CPU: 8 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc1-wq-fix3-a #12
Hardware name: IBM  -[8737R2A]-/00Y2738, BIOS -[B2E120RUS-1.20]- 11/30/2012
 0000000000000bab ffff881039557a58 ffffffff81619069 ffffffff819f6dce
 ffff881039557aa8 ffff881039557a98 ffffffff8104e6ac ffff881039557b98
 ffff881039557b58 0000000000000000 ffff881039557b58 0000000000000000
Call Trace:
 [<ffffffff81619069>] dump_stack+0x59/0x80
 [<ffffffff8104e6ac>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff8104e796>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff810bfbb8>] lockdep_init_map+0x168/0x170
 [<ffffffff81077326>] work_on_cpu+0x96/0xd0
 [<ffffffff8106f940>] ? wqattrs_hash+0x190/0x190
 [<ffffffff812d1ee0>] ? pci_pm_prepare+0x60/0x60
 [<ffffffff812d200a>] __pci_device_probe+0x9a/0xe0
 [<ffffffff8161efa0>] ? _raw_spin_unlock_irq+0x30/0x50
 [<ffffffff812d3312>] ? pci_dev_get+0x22/0x30
 [<ffffffff812d335a>] pci_device_probe+0x3a/0x60
 [<ffffffff8161efa0>] ? _raw_spin_unlock_irq+0x30/0x50
 [<ffffffff81398bec>] really_probe+0x6c/0x320
 [<ffffffff81398ee7>] driver_probe_device+0x47/0xa0
 [<ffffffff81398feb>] __driver_attach+0xab/0xb0
 [<ffffffff81398f40>] ? driver_probe_device+0xa0/0xa0
 [<ffffffff81398f40>] ? driver_probe_device+0xa0/0xa0
 [<ffffffff81396bf4>] bus_for_each_dev+0x94/0xb0
 [<ffffffff813988ae>] driver_attach+0x1e/0x20
 [<ffffffff81398258>] bus_add_driver+0x208/0x290
 [<ffffffff81399597>] driver_register+0x77/0x160
 [<ffffffff81d66b9e>] ? dmi_pcie_pme_disable_msi+0x21/0x21
 [<ffffffff812d3464>] __pci_register_driver+0x64/0x70
 [<ffffffff81d66c07>] pcie_portdrv_init+0x69/0x7a
 [<ffffffff810002c2>] do_one_initcall+0xf2/0x1a0
 [<ffffffff8107b0d6>] ? parse_args+0x156/0x2f0
 [<ffffffff81d32b80>] ? kernel_init_freeable+0x28a/0x28a
 [<ffffffff81d328d8>] do_basic_setup+0x9d/0xbb
 [<ffffffff81d32b80>] ? kernel_init_freeable+0x28a/0x28a
 [<ffffffff81d32b00>] kernel_init_freeable+0x20a/0x28a
 [<ffffffff81611c40>] ? rest_init+0x180/0x180
 [<ffffffff81611c4e>] kernel_init+0xe/0xf0
 [<ffffffff81628e5c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81611c40>] ? rest_init+0x180/0x180
---[ end trace 41047d25544a3721 ]---
pcieport 0000:00:01.0: irq 88 for MSI/MSI-X
BUG: key ffff881039557b98 not in .data!
pcieport 0000:00:02.0: irq 89 for MSI/MSI-X
BUG: key ffff881039557b98 not in .data!
pcieport 0000:00:02.2: irq 90 for MSI/MSI-X
BUG: key ffff881039557b98 not in .data!
pcieport 0000:00:03.0: irq 91 for MSI/MSI-X
BUG: key ffff881039557b98 not in .data!
pcieport 0000:00:11.0: irq 92 for MSI/MSI-X
BUG: key ffff881039557b98 not in .data!
pcieport 0000:00:1c.0: irq 93 for MSI/MSI-X
BUG: key ffff881039557b98 not in .data!
pcieport 0000:00:1c.4: irq 94 for MSI/MSI-X
BUG: key ffff881039557b98 not in .data!
BUG: key ffff881039557b98 not in .data!
BUG: key ffff881039557b98 not in .data!
BUG: key ffff881039557b98 not in .data!
BUG: key ffff881039557b98 not in .data!
pcieport 0000:80:00.0: irq 95 for MSI/MSI-X
BUG: key ffff881039557b98 not in .data!
pcieport 0000:80:01.0: irq 96 for MSI/MSI-X
BUG: key ffff881039557b98 not in .data!
pcieport 0000:80:01.1: irq 97 for MSI/MSI-X
BUG: key ffff881039557b98 not in .data!
pcieport 0000:80:02.0: irq 98 for MSI/MSI-X
BUG: key ffff881039557b98 not in .data!
pcieport 0000:80:02.2: irq 99 for MSI/MSI-X
BUG: key ffff881039557b98 not in .data!
pcieport 0000:80:03.0: irq 100 for MSI/MSI-X
pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded

<many more instances of "BUG: key ... not in .data!">

Regards,
Srivatsa S. Bhat

