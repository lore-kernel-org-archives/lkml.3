Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaEURjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:39:48 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39277 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaEURjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:39:47 -0400
Date: Wed, 21 May 2014 10:39:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Francesco Ruggeri <fruggeri@arista.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Francesco Ruggeri <fruggeri@aristanetworks.com>
Subject: Re: pci: kernel crash in bus_find_device
Message-ID: <20140521173932.GA31583@roeck-us.net>
References: <CA+HUmGjvHgWB3vcPnXAEVFdFuy9sOaB1BjaDW1-7ai933XEGWQ@mail.gmail.com>
 <20140520195041.GA28913@roeck-us.net>
 <CA+HUmGg4mE5RDxShNCK78yLi9gdX_FnHtWPKfGD4LaEqrCdj2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+HUmGg4mE5RDxShNCK78yLi9gdX_FnHtWPKfGD4LaEqrCdj2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 03:35:15PM -0700, Francesco Ruggeri wrote:
> Hi Guenter,
> thank you for your reply. I will check out the changes that you pointed to.
> The problem we are seeing is a race condition between for_each_pci_dev
> (or similar) and device_unregisters. I am not sure if use of the new
> lock should be extended to all code using for_each_pci_dev as well.
> 
> pci_scan is a kernel thread that I used for testing purposes, to
> mimick the dynamics that we saw in our crashes in
> edac_pci_clear_parity_errors:
> 
>         for (;;) {
>                 pci_dev = NULL;
>                 while ((pci_dev = pci_get_device(PCI_ANY_ID,
> PCI_ANY_ID, pci_dev)) != NULL)
>                         ;
>         }
> 
> It keeps traversing klist_devices in pci_bus_type using
> bus_find_device, costantly resuming its search for the next element
> starting from the one it got in the previous round.
> There are several loops of this kind in linux. In case of this thread
> no action is taken on the elements as they are "found".
> 
> The race condition occurs when bus_find_device resumes its search from
> a device that has been unregistered. Because device_unregister resets
> klist_bus in the device, bus_find device cannot resume from where it
> left off in the klist.
> The sequence is device_unregister, device_del, bus_remove_device,
> klist_del(&dev->p->knode_bus.).
> 

Problem is confirmed to exist in 3.14, and can be reproduced easily
with the following dummy driver, courtesy to Francesco. I added
usleep_range() to make it easier to reproduce. It took only about
half a dozen hot insertion/removal events to make it happen.

Here are the tracebacks:

------------[ cut here ]------------
WARNING: at /home/p2020/linux-freescale/include/linux/kref.h:47
Modules linked in: jnx_connector leds_gpio sam_flash gpio_sam i2c_sam sam_core uio_pci_hostif pci_scan [last unloaded: sam_core]
CPU: 0 PID: 2641 Comm: pci_scan Not tainted 3.14.4-juniper-00422-gf428c34 #47
task: e7ce8ea0 ti: e73e6000 task.ti: e73e6000
NIP: c04e0988 LR: c02baa28 CTR: c0268ca4
REGS: e73e7da0 TRAP: 0700   Not tainted (3.14.4-juniper-00422-gf428c34)
MSR: 00029000 <CE,EE,ME>  CR: 24038382  XER: 00000000
GPR00: c0268b38 e73e7e50 e7ce8ea0 e7c96f94 e73e7e58 e725a264 c0268a38 eedaa2c0 
GPR08: 00000002 00000001 00000000 00021000 2403d382 00000000 c00576f8 e7377750 
GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
GPR24: 00000000 00000000 f170f000 00000000 c056c33c c0268a38 e73e7ea8 eedaa2c0 
NIP [c04e0988] klist_iter_init_node.part.0+0xc/0x684
LR [c02baa28] bus_find_device+0x48/0xac
Call Trace:
[e73e7e80] [c0268b38] pci_get_dev_by_id+0x5c/0x94
[e73e7ea0] [c0268c94] pci_get_subsys+0x38/0x48
[e73e7ed0] [f170f02c] pci_scan+0x2c/0x64 [pci_scan]
[e73e7ee0] [c00577bc] kthread+0xc4/0xd8
[e73e7f40] [c000f004] ret_from_kernel_thread+0x5c/0x64

and:

------------[ cut here ]------------
WARNING: at /home/p2020/linux-freescale/lib/klist.c:189
Modules linked in: jnx_connector leds_gpio sam_flash gpio_sam i2c_sam sam_core uio_pci_hostif pci_scan [last unloaded: sam_core]
CPU: 0 PID: 2641 Comm: pci_scan Tainted: G        W 3.14.4-juniper-00422-gf428c34 #47
task: e7ce8ea0 ti: e73e6000 task.ti: e73e6000
NIP: c04d7ad0 LR: c04d7be4 CTR: c0268ca4
REGS: e73e7d30 TRAP: 0700   Tainted: G        W (3.14.4-juniper-00422-gf428c34)
MSR: 00029000 <CE,EE,ME>  CR: 24038382  XER: 00000000
GPR00: c04d7be4 e73e7de0 e7ce8ea0 e725a264 e73e7e58 e725a264 c0268a38 eedaa2c0 
GPR08: 00000002 00000001 00000001 00021000 24038384 00000000 c00576f8 e7377750 
GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 
GPR24: 00000000 00000000 f170f000 00000000 c02ba364 e725a258 e725a258 e73e7e58 
NIP [c04d7ad0] klist_release+0x20/0xec
LR [c04d7be4] klist_dec_and_del+0x48/0x5c
Call Trace:
[e73e7e10] [c04d7be4] klist_dec_and_del+0x48/0x5c
[e73e7e20] [c04d7c3c] klist_next+0x44/0x138
[e73e7e40] [c02ba444] next_device+0x10/0x34
[e73e7e50] [c02baa30] bus_find_device+0x50/0xac
[e73e7e80] [c0268b38] pci_get_dev_by_id+0x5c/0x94
[e73e7ea0] [c0268c94] pci_get_subsys+0x38/0x48
[e73e7ed0] [f170f02c] pci_scan+0x2c/0x64 [pci_scan]
[e73e7ee0] [c00577bc] kthread+0xc4/0xd8
[e73e7f40] [c000f004] ret_from_kernel_thread+0x5c/0x64

Francesco, I'll test the patches you sent me next.

Guenter

---

/*
 * PCI scan test driver
 */

#include <linux/delay.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/sched.h>
#include <linux/kprobes.h>
#include <linux/kallsyms.h>
#include <linux/kthread.h>
#include <linux/pci.h>
#include <linux/pcieport_if.h>

static struct task_struct *pci_scan_task = NULL;

static int pci_scan(void *unused)
{
	for (;;) {
		struct pci_dev *dev = NULL;

		while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL)
			usleep_range(1000, 2000);
		schedule();
		if (kthread_should_stop())
			break;
	}
	return 0;
}

static int __init pci_scan_init(void)
{
	pci_scan_task = kthread_create(pci_scan, NULL, "pci_scan");
	if (!pci_scan_task)
		return -ENODEV;

	wake_up_process(pci_scan_task);
	return 0;
}

static void __exit pci_scan_exit(void)
{
	if (pci_scan_task)
		kthread_stop(pci_scan_task);
}

module_init(pci_scan_init);
module_exit(pci_scan_exit);

MODULE_LICENSE("GPL");

