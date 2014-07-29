Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbaG2RWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:22:04 -0400
Received: from legacy.ddn.com ([64.47.133.206]:41919 "EHLO legacy.ddn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbaG2RWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:22:03 -0400
Date: Tue, 29 Jul 2014 11:21:58 -0600
From: Greg Edwards <gedwards@ddn.com>
To: Joerg Roedel <joro@8bytes.org>
CC: David Woodhouse <dwmw2@infradead.org>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] iommu/vt-d: race setting IRQ CPU affinity while
 freeing IRQ
Message-ID: <20140729172158.GA23529@psuche.datadirectnet.com>
References: <20140722142719.GA28143@psuche.datadirectnet.com>
 <20140723144024.GA14017@8bytes.org>
 <20140723144917.GA26986@psuche.datadirectnet.com>
 <20140723151040.GB14017@8bytes.org>
 <20140723161326.GB32422@psuche.datadirectnet.com>
 <20140729104531.GB9809@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140729104531.GB9809@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.32.22.128]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 12:45:31PM +0200, Joerg Roedel wrote:
> On Wed, Jul 23, 2014 at 10:13:26AM -0600, Greg Edwards wrote:
>> A user process setting the CPU affinity of an IRQ for a KVM
>> direct-assigned device via /proc/irq/<IRQ#>/smp_affinity can race with
>> the IRQ being released by QEMU, resulting in a NULL iommu pointer
>> dereference in get_irte().
>
> Maybe I wasn't clear enough, what I am missing is a panic message with a
> backtrace from the NULL pointer deref you are seeing in the commit
> message.

Sure, sorry I didn't send that along previously.  We originally saw this on a
3.9 kernel, then recently on a 3.14 stable kernel.  I hadn't reproduced it on
current tip yet.  Here it is for Linus' tree as of this morning:

[ 6638.327851] BUG: unable to handle kernel NULL pointer dereference at 0000000000000090
[ 6638.335955] IP: [<ffffffff8190a652>] intel_ioapic_set_affinity+0x82/0x1b0
[ 6638.343012] PGD 99172e067 PUD 1026979067 PMD 0 
[ 6638.347858] Oops: 0000 [#1] SMP 
[ 6638.351386] Modules linked in:
[ 6638.354718] CPU: 1 PID: 3354 Comm: affin Not tainted 3.16.0-rc7-00007-g31dab71 #1
[ 6638.362480] Hardware name: Supermicro SYS-F617R2-RT+/X9DRFR, BIOS 3.0a 01/29/2014
[ 6638.370259] task: ffff881025b0e720 ti: ffff88099173c000 task.ti: ffff88099173c000
[ 6638.378063] RIP: 0010:[<ffffffff8190a652>]  [<ffffffff8190a652>] intel_ioapic_set_affinity+0x82/0x1b0
[ 6638.387649] RSP: 0018:ffff88099173fdb0  EFLAGS: 00010046
[ 6638.393314] RAX: 0000000000000082 RBX: ffff880a36294600 RCX: 0000000000000082
[ 6638.400824] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8266af00
[ 6638.408341] RBP: ffff88099173fdf8 R08: 0000000000000000 R09: ffff88103ec00490
[ 6638.415867] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88099173fe90
[ 6638.423402] R13: 000000000000005f R14: ffff880faa38fe80 R15: ffff880faa38fe80
[ 6638.430942] FS:  00007f7161f05740(0000) GS:ffff88107fc40000(0000) knlGS:0000000000000000
[ 6638.439456] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6638.445640] CR2: 0000000000000090 CR3: 000000099140d000 CR4: 00000000001427e0
[ 6638.453227] Stack:
[ 6638.455699]  ffffffff81c44740 ffff88099173fdc8 ffffffff00000000 00000000c991fd3b
[ 6638.463660]  ffff880a36294600 ffff88099173fe90 ffff88099173fe90 0000000000000000
[ 6638.471623]  0000000000000286 ffff88099173fe08 ffffffff8190aac5 ffff88099173fe28
[ 6638.479605] Call Trace:
[ 6638.482562]  [<ffffffff8190aac5>] set_remapped_irq_affinity+0x25/0x40
[ 6638.489534]  [<ffffffff811322dc>] irq_do_set_affinity+0x1c/0x50
[ 6638.495985]  [<ffffffff81132458>] irq_set_affinity_locked+0x98/0xd0
[ 6638.502781]  [<ffffffff811324d6>] __irq_set_affinity+0x46/0x70
[ 6638.509142]  [<ffffffff811362dc>] write_irq_affinity.isra.6+0xdc/0x100
[ 6638.516198]  [<ffffffff8113631c>] irq_affinity_list_proc_write+0x1c/0x20
[ 6638.523440]  [<ffffffff8129f30d>] proc_reg_write+0x3d/0x80
[ 6638.529474]  [<ffffffff812384a7>] vfs_write+0xb7/0x1f0
[ 6638.535165]  [<ffffffff81243619>] ? putname+0x29/0x40
[ 6638.540771]  [<ffffffff812390c5>] SyS_write+0x55/0xd0
[ 6638.546386]  [<ffffffff81adc729>] system_call_fastpath+0x16/0x1b
[ 6638.552970] Code: ff 48 85 d2 74 68 4c 8b 7a 30 4d 85 ff 74 5f 48 c7 c7 00 af 66 82 e8 9e 1b 1d 00 49 8b 57 20 41 0f b7 77 28 48 c7 c7 00 af 66 82 <48> 8b 8a 90 00 00 00 41 0f b7 57 2a 01 f2 48 89 c6 48 63 d2 48 
[ 6638.574199] RIP  [<ffffffff8190a652>] intel_ioapic_set_affinity+0x82/0x1b0
[ 6638.581735]  RSP <ffff88099173fdb0>
[ 6638.585872] CR2: 0000000000000090

> Also I am still wondering why it is possible to set affinity from
> userspace while the irq is about to be freed. Shouldn't the proc files
> are already unregistered when the irq is freed?

The QEMU thread is doing a KVM_DEASSIGN_DEV_IRQ ioctl.  It looks like the call
chain is:

  kvm_vm_ioctl_assigned_device
    kvm_vm_ioctl_deassign_dev_irq
      kvm_deassign_irq
        deassign_host_irq
          pci_disable_msix
            free_msi_irqs
              arch_teardown_msi_irqs
                default_teardown_msi_irqs
                  arch_teardown_msi_irq
                    native_teardown_msi_irq
                      irq_free_hwirq
                        irq_free_hwirqs

irq_free_hwirqs() does:

460         for (i = from, j = cnt; j > 0; i++, j--) {
461                 irq_set_status_flags(i, _IRQ_NOREQUEST | _IRQ_NOPROBE);
462                 arch_teardown_hwirq(i);   <----------- QEMU is down this path to free_irte()
463         }
464         irq_free_descs(from, cnt);   <------------ proc files unregistered down this path


I guess the question is if it would be safe to change that ordering?  I don't know.

Greg
