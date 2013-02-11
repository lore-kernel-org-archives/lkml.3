Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab3BKFiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 00:38:51 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:57789 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3BKFit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 00:38:49 -0500
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Feb 2013 00:38:49 EST
Date: Mon, 11 Feb 2013 07:31:00 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Subject: [BUG] irq_dispose_mapping after irq request failure
Message-ID: <20130211053100.GB18462@sapphire.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi lkml,

The drivers/edac/mpc85xx_edac.c driver contains the following (abbreviated)
code snippet it its .probe:

		res = devm_request_irq(&op->dev, pdata->irq,
				       mpc85xx_pci_isr, IRQF_DISABLED,
				       "[EDAC] PCI err", pci);
		if (res < 0) {
			irq_dispose_mapping(pdata->irq);
			goto err2;
		}

Now, since the requested irq is already in use, and IRQF_SHARED is not set,
devm_request_irq errors() out, which is OK. Less OK is the
irq_dispose_mapping() call, which gives me this:

EDAC PCI1: Giving out device to module 'MPC85xx_edac' controller 'mpc85xx_pci_err': DEV 'ffe0a000.pcie' (INTERRUPT)
genirq: Flags mismatch irq 16. 00000020 ([EDAC] PCI err) vs. 00000020 ([EDAC] PCI err)
mpc85xx_pci_err_probe: Unable to requiest irq 16 for MPC85xx PCI err
remove_proc_entry: removing non-empty directory 'irq/16', leaking at least '[EDAC] PCI err'
------------[ cut here ]------------
WARNING: at fs/proc/generic.c:842
NIP: c00cd00c LR: c00cd00c CTR: c000c5e4
REGS: cf039b80 TRAP: 0700   Not tainted  (3.8.0-rc7-00002-g37ddebf)
MSR: 00029000 <CE,EE,ME>  CR: 42042422  XER: 00000000
TASK = cf034000[1] 'swapper' THREAD: cf038000
GPR00: c00cd00c cf039c30 cf034000 0000005b 0000005c 0000005c c04b7dde 435d2050 
GPR08: 43492065 c04a9a44 00000000 cf039bf0 22042424 00000000 c00025d0 00000000 
GPR16: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 c042fe78 
GPR24: 00000000 00000000 c04c3f90 cf05294c 00100100 00200200 cf039c78 cf052900 
NIP [c00cd00c] remove_proc_entry+0x190/0x1bc
LR [c00cd00c] remove_proc_entry+0x190/0x1bc
Call Trace:
[cf039c30] [c00cd00c] remove_proc_entry+0x190/0x1bc (unreliable)
[cf039c70] [c0058c64] unregister_irq_proc+0x6c/0x74
[cf039c90] [c0054530] free_desc+0x34/0x68
[cf039cb0] [c00545f0] irq_free_descs+0x44/0x88
[cf039cd0] [c00585c8] irq_dispose_mapping+0x68/0x70
[cf039ce0] [c0222650] mpc85xx_pci_err_probe+0x2a8/0x308
[cf039d20] [c0014f8c] fsl_pci_probe+0x74/0x80
[cf039d30] [c01a9c48] platform_drv_probe+0x20/0x30
[cf039d40] [c01a88c4] driver_probe_device+0xcc/0x1f4
[cf039d60] [c01a7288] bus_for_each_drv+0x60/0x9c
[cf039d90] [c01a85ac] device_attach+0x78/0x90
[cf039db0] [c01a7430] bus_probe_device+0x34/0x9c
[cf039dd0] [c01a55c4] device_add+0x410/0x580
[cf039e10] [c022eef4] of_device_add+0x40/0x50
[cf039e20] [c022f550] of_platform_device_create_pdata+0x6c/0x8c
[cf039e40] [c022f658] of_platform_bus_create+0xe8/0x178
[cf039e90] [c022f7a0] of_platform_bus_probe+0xac/0xdc
[cf039eb0] [c0415488] mpc85xx_common_publish_devices+0x20/0x30
[cf039ec0] [c0415578] __machine_initcall_p1020_rdb_mpc85xx_common_publish_devices+0x2c/0x3c
[cf039ed0] [c040e83c] do_one_initcall+0xdc/0x1b4
[cf039f00] [c040ea24] kernel_init_freeable+0x110/0x1a8
[cf039f30] [c00025e8] kernel_init+0x18/0xf8
[cf039f40] [c000b868] ret_from_kernel_thread+0x64/0x6c
Instruction dump:
2f870000 41be0030 80bf002c 3c80c033 3c60c03e 38846be0 38840260 38a50055 
38df0055 38e70055 38631770 48260331 <0fe00000> 7fe3fb78 4bfffb41 48000018 
---[ end trace 9af370ce0e147530 ]---

So, is irq_dispose_mapping() the right thing to do when irq request fails?

A simple grep shows that irq_dispose_mapping() calls are mostly limited to
powerpc code. Is there a reason for that?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
