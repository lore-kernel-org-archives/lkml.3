Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaA1QEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:04:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36413 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbaA1QEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:04:20 -0500
Date: Tue, 28 Jan 2014 11:04:04 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Cc: Ben Guthro <benjamin.guthro@citrix.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, xen-devel@lists.xensource.com
Subject: Re: [BUG?] Interrupts enabled after
 xen_acpi_processor_resume+0x0/0x34 [xen_acpi_processor]
Message-ID: <20140128160404.GA5732@phenom.dumpdata.com>
References: <20140128150848.GA1428@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140128150848.GA1428@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 04:08:49PM +0100, Stanislaw Gruszka wrote:
> Hi,

Hey!
> 
> We have this bug report on our bugzilla:
> https://bugzilla.redhat.com/show_bug.cgi?id=1058268
> 
> In short:
> WARNING: CPU: 0 PID: 6733 at drivers/base/syscore.c:104 syscore_resume+0x9a/0xe0()
> Interrupts enabled after xen_acpi_processor_resume+0x0/0x34 [xen_acpi_processor]
> 
> Perhaps I'm wrong, but I think sysops->resume() callback should be
> atomic i.e. can not use mutexes or kmalloc(,GFP_KERNEL), what is not
> true regarding xen_acpi_processor_resume(). That callback was introduced
> by commit 3fac10145b766a2244422788f62dc35978613fd8. Fixing that will
> not be easy IMHO, but maybe you have some ideas ? :-)

If that is the case, then perhaps the patch below will fix it?

(I didn't compile tested it)

diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 7231859..7602229 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -46,7 +46,7 @@ module_param_named(off, no_hypercall, int, 0400);
  */
 static unsigned int nr_acpi_bits;
 /* Mutex to protect the acpi_ids_done - for CPU hotplug use. */
-static DEFINE_MUTEX(acpi_ids_mutex);
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
 
@@ -275,9 +275,9 @@ static int upload_pm_data(struct acpi_processor *_pr)
 {
 	int err = 0;
 
-	mutex_lock(&acpi_ids_mutex);
+	spin_lock(&acpi_ids_lock);
 	if (__test_and_set_bit(_pr->acpi_id, acpi_ids_done)) {
-		mutex_unlock(&acpi_ids_mutex);
+		spin_unlock(&acpi_ids_lock);
 		return -EBUSY;
 	}
 	if (_pr->flags.power)
@@ -286,7 +286,7 @@ static int upload_pm_data(struct acpi_processor *_pr)
 	if (_pr->performance && _pr->performance->states)
 		err |= push_pxx_to_hypervisor(_pr);
 
-	mutex_unlock(&acpi_ids_mutex);
+	spin_unlock(&acpi_ids_lock);
 	return err;
 }
 static unsigned int __init get_max_acpi_id(void)
