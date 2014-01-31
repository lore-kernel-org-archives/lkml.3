Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbaAaQCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 11:02:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40086 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932385AbaAaQBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 11:01:55 -0500
Date: Fri, 31 Jan 2014 11:01:40 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: David Rientjes <rientjes@google.com>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, Ben Guthro <benjamin.guthro@citrix.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        xen-devel@lists.xensource.com
Subject: Re: [BUG?] Interrupts enabled after
 xen_acpi_processor_resume+0x0/0x34 [xen_acpi_processor]
Message-ID: <20140131160140.GC23648@phenom.dumpdata.com>
References: <20140128150848.GA1428@redhat.com>
 <20140128160404.GA5732@phenom.dumpdata.com>
 <alpine.DEB.2.02.1401282120180.20167@chino.kir.corp.google.com>
 <20140129082521.GA1362@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129082521.GA1362@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 09:25:22AM +0100, Stanislaw Gruszka wrote:
> (Cc: correct Rafael email)
> 
> On Tue, Jan 28, 2014 at 09:24:57PM -0800, David Rientjes wrote:
> > On Tue, 28 Jan 2014, Konrad Rzeszutek Wilk wrote:
> > 
> > > diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
> > > index 7231859..7602229 100644
> > > --- a/drivers/xen/xen-acpi-processor.c
> > > +++ b/drivers/xen/xen-acpi-processor.c
> > > @@ -46,7 +46,7 @@ module_param_named(off, no_hypercall, int, 0400);
> > >   */
> > >  static unsigned int nr_acpi_bits;
> > >  /* Mutex to protect the acpi_ids_done - for CPU hotplug use. */
> > > -static DEFINE_MUTEX(acpi_ids_mutex);
> > > +static DEFINE_SPINLOCK(acpi_ids_lock);
> > >  /* Which ACPI ID we have processed from 'struct acpi_processor'. */
> > >  static unsigned long *acpi_ids_done;
> > >  /* Which ACPI ID exist in the SSDT/DSDT processor definitions. */
> > > @@ -68,7 +68,7 @@ static int push_cxx_to_hypervisor(struct acpi_processor *_pr)
> > >  	int ret = 0;
> > >  
> > >  	dst_cx_states = kcalloc(_pr->power.count,
> > > -				sizeof(struct xen_processor_cx), GFP_KERNEL);
> > > +				sizeof(struct xen_processor_cx), GFP_ATOMIC);
> > >  	if (!dst_cx_states)
> > >  		return -ENOMEM;
> > >  
> > > @@ -149,7 +149,7 @@ xen_copy_pss_data(struct acpi_processor *_pr,
> > >  		     sizeof(struct acpi_processor_px));
> > >  
> > >  	dst_states = kcalloc(_pr->performance->state_count,
> > > -			     sizeof(struct xen_processor_px), GFP_KERNEL);
> > > +			     sizeof(struct xen_processor_px), GFP_ATOMIC);
> > >  	if (!dst_states)
> > >  		return ERR_PTR(-ENOMEM);
> > >  
> > > @@ -275,9 +275,9 @@ static int upload_pm_data(struct acpi_processor *_pr)
> > >  {
> > >  	int err = 0;
> > >  
> > > -	mutex_lock(&acpi_ids_mutex);
> > > +	spin_lock(&acpi_ids_lock);
> > >  	if (__test_and_set_bit(_pr->acpi_id, acpi_ids_done)) {
> > > -		mutex_unlock(&acpi_ids_mutex);
> > > +		spin_unlock(&acpi_ids_lock);
> > >  		return -EBUSY;
> > >  	}
> > >  	if (_pr->flags.power)
> > > @@ -286,7 +286,7 @@ static int upload_pm_data(struct acpi_processor *_pr)
> > >  	if (_pr->performance && _pr->performance->states)
> > >  		err |= push_pxx_to_hypervisor(_pr);
> > >  
> > > -	mutex_unlock(&acpi_ids_mutex);
> > > +	spin_unlock(&acpi_ids_lock);
> > >  	return err;
> > >  }
> > >  static unsigned int __init get_max_acpi_id(void)
> > 
> > Looks incomplete, what about the kzalloc() in 
> > xen_upload_processor_pm_data() and kcalloc()s in check_acpi_ids()?
> 
> Indeed and additionally from check_acpi_ids() we call
> acpi_walk_namespace(), which also take mutexes. Hence unfortunately
> making xen_upload_processor_pm_data() atomic is not easy, but possibly
> can be done by saving some data in memory after initialization.
> 
> Or perhaps this problem can be solved differently, by not using 
> yscore_ops->resume(), but some other resume callback from core, which
> allow to sleep. Than can require registering dummy device or sysfs
> class, but maybe there are simpler solutions.

Perhaps by using 'subsys_system_register' and stick it there?

Again, untested and uncompiled:


diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
index 7231859..a2524f6 100644
--- a/drivers/xen/xen-acpi-processor.c
+++ b/drivers/xen/xen-acpi-processor.c
@@ -27,7 +27,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/syscore_ops.h>
 #include <linux/acpi.h>
 #include <acpi/processor.h>
 #include <xen/xen.h>
@@ -495,13 +494,15 @@ static int xen_upload_processor_pm_data(void)
 	return rc;
 }
 
-static void xen_acpi_processor_resume(void)
+static int xen_acpi_processor_resume(struct device *dev)
 {
 	bitmap_zero(acpi_ids_done, nr_acpi_bits);
-	xen_upload_processor_pm_data();
+	return xen_upload_processor_pm_data();
 }
 
-static struct syscore_ops xap_syscore_ops = {
+static struct bus_type xap_bus = {
+	.name	= "xen-acpi-processor",
+	.dev_name = "xen-acpi-processor",
 	.resume	= xen_acpi_processor_resume,
 };
 
@@ -555,7 +556,7 @@ static int __init xen_acpi_processor_init(void)
 	if (rc)
 		goto err_unregister;
 
-	register_syscore_ops(&xap_syscore_ops);
+	subsys_system_register(&xap_bus);
 
 	return 0;
 err_unregister:
@@ -574,7 +575,7 @@ static void __exit xen_acpi_processor_exit(void)
 {
 	int i;
 
-	unregister_syscore_ops(&xap_syscore_ops);
+	bus_unregister(&xap_bus);
 	kfree(acpi_ids_done);
 	kfree(acpi_id_present);
 	kfree(acpi_id_cst_present);
> 
> Thanks
> Stanislaw 
>  
