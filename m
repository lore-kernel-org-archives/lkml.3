Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbbA0Qom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:44:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbbA0Qoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:44:38 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v2 3/5] drivers: hv: Teardown synthetic interrupt controllers on module unload
Date: Tue, 27 Jan 2015 17:44:17 +0100
Message-Id: <1422377059-7858-4-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1422377059-7858-1-git-send-email-vkuznets@redhat.com>
References: <1422377059-7858-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SynIC has to be switched off when we unload the module, otherwise registered
memory pages can get corrupted after (as Hyper-V host still writes there) and
we see the following crashes for random processes:

[   89.116774] BUG: Bad page map in process sh  pte:4989c716 pmd:36f81067
[   89.159454] addr:0000000000437000 vm_flags:00000875 anon_vma:          (null) mapping:ffff88007bba55a0 index:37
[   89.226146] vma->vm_ops->fault: filemap_fault+0x0/0x410
[   89.257776] vma->vm_file->f_op->mmap: generic_file_mmap+0x0/0x60
[   89.297570] CPU: 0 PID: 215 Comm: sh Tainted: G    B          3.19.0-rc5_bug923184+ #488
[   89.353738] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090006  05/23/2012
[   89.409138]  0000000000000000 000000004e083d7b ffff880036e9fa18 ffffffff81a68d31
[   89.468724]  0000000000000000 0000000000437000 ffff880036e9fa68 ffffffff811a1e3a
[   89.519233]  000000004989c716 0000000000000037 ffffea0001edc340 0000000000437000
[   89.575751] Call Trace:
[   89.591060]  [<ffffffff81a68d31>] dump_stack+0x45/0x57
[   89.625164]  [<ffffffff811a1e3a>] print_bad_pte+0x1aa/0x250
[   89.667234]  [<ffffffff811a2c95>] vm_normal_page+0x55/0xa0
[   89.703818]  [<ffffffff811a3105>] unmap_page_range+0x425/0x8a0
[   89.737982]  [<ffffffff811a3601>] unmap_single_vma+0x81/0xf0
[   89.780385]  [<ffffffff81184320>] ? lru_deactivate_fn+0x190/0x190
[   89.820130]  [<ffffffff811a4131>] unmap_vmas+0x51/0xa0
[   89.860168]  [<ffffffff811ad12c>] exit_mmap+0xac/0x1a0
[   89.890588]  [<ffffffff810763c3>] mmput+0x63/0x100
[   89.919205]  [<ffffffff811eba48>] flush_old_exec+0x3f8/0x8b0
[   89.962135]  [<ffffffff8123b5bb>] load_elf_binary+0x32b/0x1260
[   89.998581]  [<ffffffff811a14f2>] ? get_user_pages+0x52/0x60

hv_synic_cleanup() function exists but noone calls it now. Do the following:
- call hv_synic_cleanup() on each cpu from vmbus_exit();
- write global disable bit through MSR;
- use hv_synic_free_cpu() to avoid memory leask and code duplication.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/hv.c        | 9 +++++++--
 drivers/hv/vmbus_drv.c | 4 ++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index 50e51a5..39531dc 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -477,6 +477,7 @@ void hv_synic_cleanup(void *arg)
 	union hv_synic_sint shared_sint;
 	union hv_synic_simp simp;
 	union hv_synic_siefp siefp;
+	union hv_synic_scontrol sctrl;
 	int cpu = smp_processor_id();
 
 	if (!hv_context.synic_initialized)
@@ -502,6 +503,10 @@ void hv_synic_cleanup(void *arg)
 
 	wrmsrl(HV_X64_MSR_SIEFP, siefp.as_uint64);
 
-	free_page((unsigned long)hv_context.synic_message_page[cpu]);
-	free_page((unsigned long)hv_context.synic_event_page[cpu]);
+	/* Disable the global synic bit */
+	rdmsrl(HV_X64_MSR_SCONTROL, sctrl.as_uint64);
+	sctrl.enable = 0;
+	wrmsrl(HV_X64_MSR_SCONTROL, sctrl.as_uint64);
+
+	hv_synic_free_cpu(cpu);
 }
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index d5cd2fb..f7e2c9e 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -996,11 +996,15 @@ cleanup:
 
 static void __exit vmbus_exit(void)
 {
+	int cpu;
+
 	vmbus_connection.conn_state = DISCONNECTED;
 	hv_remove_vmbus_irq();
 	vmbus_free_channels();
 	bus_unregister(&hv_bus);
 	hv_cleanup();
+	for_each_online_cpu(cpu)
+		smp_call_function_single(cpu, hv_synic_cleanup, NULL, 1);
 	acpi_bus_unregister_driver(&vmbus_acpi_driver);
 	vmbus_disconnect();
 }
-- 
1.9.3

