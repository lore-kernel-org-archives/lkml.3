Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaI2Rzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 13:55:33 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20061 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbaI2Rzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 13:55:31 -0400
Date: Mon, 29 Sep 2014 13:55:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: sgruszka@redhat.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com
Subject: Re: [PATCH] Revert "xen/acpi-processor: fix enabling interrupts on
 syscore_resume"
Message-ID: <20140929175517.GA5000@laptop.dumpdata.com>
References: <1412002276-30873-1-git-send-email-konrad.wilk@oracle.com>
 <5429730E.1050506@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5429730E.1050506@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 03:56:14PM +0100, David Vrabel wrote:
> On 29/09/14 15:51, Konrad Rzeszutek Wilk wrote:
> > This reverts commit cd979883b9ede90643e019f33cb317933eb867b4.
> > 
> > As it actually never gets called on the initial domain when
> > resuming. That is after we suspend and go in resume, the
> > do_suspend (from manage.c) is never called (it is if it
> > was running as a guest)- so the 'resume' functionality of the driver
> > was never called.
> > 
> > Which means that this whole patch was pointless (well, it did
> > remove the WARNING splat).
> > 
> > This patch reverts the patch and allows the C and P states to
> > be uploaded to the hypervisor on ACPI S3 resume of the
> > initial domain. It sadly brings back the WARNING splat which
> > will have to be dealt with at some point.
> 
> Incorrectly enabling interrupts in contexts where this is not permitted
> is not just harmless "WARNING splat".
> 
> This has been broken since 3.15-rc1 without anyone else noticing so I
> think we can afford to take a bit more time and fix the original bug
> properly.

This patch should be a good start to discussing the fix.

>From 3544815f7c44508e2c9a0c55caf4a32cc8283685 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 29 Sep 2014 13:48:57 -0400
Subject: [PATCH] xen-acpi-processor: Use spinlock and GFP_ATOMIC to deal with
 resume

hitting the IRQs being enabled during resume.

WARNING: CPU: 0 PID: 6733 at drivers/base/syscore.c:104 syscore_resume+0x9a/0xe0()
Interrupts enabled after xen_acpi_processor_resume+0x0/0x34 [xen_acpi_processor]

Call Trace:
 [<ffffffff81667a8b>] dump_stack+0x45/0x56
 [<ffffffff8106921d>] warn_slowpath_common+0x7d/0xa0
 [<ffffffff8106928c>] warn_slowpath_fmt+0x4c/0x50
 [<ffffffffa0261bb0>] ? xen_upload_processor_pm_data+0x300/0x300 [xen_acpi_processor]
 [<ffffffff814055fa>] syscore_resume+0x9a/0xe0
 [<ffffffff810aef42>] suspend_devices_and_enter+0x402/0x470
 [<ffffffff810af128>] pm_suspend+0x178/0x260

Converting the mutex to a spinlock and all of the GPF_KERNEL
to GFP_ATOMIC take care of that.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-acpi-processor.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 2d727ab..8c76767 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -45,8 +45,8 @@ module_param_named(off, no_hypercall, int, 0400);
  * which is dynamically computed based on the MADT or x2APIC table.
  */
 static unsigned int nr_acpi_bits;
-/* Mutex to protect the acpi_ids_done - for CPU hotplug use. */
-static DEFINE_MUTEX(acpi_ids_mutex);
+/* Spinlock to protect the acpi_ids_done - for CPU hotplug use. */
+static DEFINE_SPINLOCK(acpi_ids_lock);
 /* Which ACPI ID we have processed from 'struct acpi_processor'. */
 static unsigned long *acpi_ids_done;
 /* Which ACPI ID exist in the SSDT/DSDT processor definitions. */
@@ -68,7 +68,7 @@ static int push_cxx_to_hypervisor(struct acpi_processor *_pr)
 	int ret = 0;
 
 	dst_cx_states = kcalloc(_pr->power.count,
-				sizeof(struct xen_processor_cx), GFP_KERNEL);
+				sizeof(struct xen_processor_cx), GFP_ATOMIC);
 	if (!dst_cx_states)
 		return -ENOMEM;
 
@@ -149,7 +149,7 @@ xen_copy_pss_data(struct acpi_processor *_pr,
 		     sizeof(struct acpi_processor_px));
 
 	dst_states = kcalloc(_pr->performance->state_count,
-			     sizeof(struct xen_processor_px), GFP_KERNEL);
+			     sizeof(struct xen_processor_px), GFP_ATOMIC);
 	if (!dst_states)
 		return ERR_PTR(-ENOMEM);
 
@@ -273,11 +273,12 @@ err_free:
 }
 static int upload_pm_data(struct acpi_processor *_pr)
 {
+	unsigned long flags;
 	int err = 0;
 
-	mutex_lock(&acpi_ids_mutex);
+	spin_lock_irqsave(&acpi_ids_lock, flags);
 	if (__test_and_set_bit(_pr->acpi_id, acpi_ids_done)) {
-		mutex_unlock(&acpi_ids_mutex);
+		spin_unlock_irqrestore(&acpi_ids_lock, flags);
 		return -EBUSY;
 	}
 	if (_pr->flags.power)
@@ -286,7 +287,7 @@ static int upload_pm_data(struct acpi_processor *_pr)
 	if (_pr->performance && _pr->performance->states)
 		err |= push_pxx_to_hypervisor(_pr);
 
-	mutex_unlock(&acpi_ids_mutex);
+	spin_lock_irqsave(&acpi_ids_lock, flags);
 	return err;
 }
 static unsigned int __init get_max_acpi_id(void)
@@ -395,11 +396,11 @@ static int check_acpi_ids(struct acpi_processor *pr_backup)
 	/* All online CPUs have been processed at this stage. Now verify
 	 * whether in fact "online CPUs" == physical CPUs.
 	 */
-	acpi_id_present = kcalloc(BITS_TO_LONGS(nr_acpi_bits), sizeof(unsigned long), GFP_KERNEL);
+	acpi_id_present = kcalloc(BITS_TO_LONGS(nr_acpi_bits), sizeof(unsigned long), GFP_ATOMIC);
 	if (!acpi_id_present)
 		return -ENOMEM;
 
-	acpi_id_cst_present = kcalloc(BITS_TO_LONGS(nr_acpi_bits), sizeof(unsigned long), GFP_KERNEL);
+	acpi_id_cst_present = kcalloc(BITS_TO_LONGS(nr_acpi_bits), sizeof(unsigned long), GFP_ATOMIC);
 	if (!acpi_id_cst_present) {
 		kfree(acpi_id_present);
 		return -ENOMEM;
@@ -482,7 +483,7 @@ static int xen_upload_processor_pm_data(void)
 			continue;
 
 		if (!pr_backup) {
-			pr_backup = kzalloc(sizeof(struct acpi_processor), GFP_KERNEL);
+			pr_backup = kzalloc(sizeof(struct acpi_processor), GFP_ATOMIC);
 			if (pr_backup)
 				memcpy(pr_backup, _pr, sizeof(struct acpi_processor));
 		}
@@ -514,7 +515,7 @@ static int __init xen_acpi_processor_init(void)
 		return rc;
 
 	nr_acpi_bits = get_max_acpi_id() + 1;
-	acpi_ids_done = kcalloc(BITS_TO_LONGS(nr_acpi_bits), sizeof(unsigned long), GFP_KERNEL);
+	acpi_ids_done = kcalloc(BITS_TO_LONGS(nr_acpi_bits), sizeof(unsigned long), GFP_ATOMIC);
 	if (!acpi_ids_done)
 		return -ENOMEM;
 
@@ -527,7 +528,7 @@ static int __init xen_acpi_processor_init(void)
 	for_each_possible_cpu(i) {
 		if (!zalloc_cpumask_var_node(
 			&per_cpu_ptr(acpi_perf_data, i)->shared_cpu_map,
-			GFP_KERNEL, cpu_to_node(i))) {
+			GFP_ATOMIC, cpu_to_node(i))) {
 			rc = -ENOMEM;
 			goto err_out;
 		}
-- 
1.9.3

> 
> David
