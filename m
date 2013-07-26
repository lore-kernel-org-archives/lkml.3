Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab3GZIJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 04:09:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:33622 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab3GZIJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 04:09:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,749,1367996400"; 
   d="scan'208";a="337215477"
From: "Zheng, Lv" <lv.zheng@intel.com>
To: "Zheng, Lv" <lv.zheng@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        "Zhao, Yakui" <yakui.zhao@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>
Subject: RE: [PATCH 06/13] ACPI/IPMI: Add reference counting for ACPI
 operation region handlers
Thread-Topic: [PATCH 06/13] ACPI/IPMI: Add reference counting for ACPI
 operation region handlers
Thread-Index: AQHOh3wWhtcRfGeNDUSAzJ7WvM5MAZl1VZ+AgADGrgCAAHSgoA==
Date: Fri, 26 Jul 2013 08:09:13 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E8802435DF5@SHSMSX101.ccr.corp.intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com>
 <cover.1374566394.git.lv.zheng@intel.com>
 <d9d5acba01eb80580e7696c50db4263ded86a86c.1374566394.git.lv.zheng@intel.com>
 <1597566.Nfc7r37F3q@vostro.rjw.lan>
 <1AE640813FDE7649BE1B193DEA596E8802435AB5@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E8802435AB5@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6Q8A2kc009737

> From: linux-acpi-owner@vger.kernel.org
> [mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Zheng, Lv
> Sent: Friday, July 26, 2013 8:48 AM
> 
> 
> 
> > From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
> > Sent: Friday, July 26, 2013 4:27 AM
> >
> > On Tuesday, July 23, 2013 04:09:43 PM Lv Zheng wrote:
> > > This patch adds reference couting for ACPI operation region handlers
> > > to fix races caused by the ACPICA address space callback invocations.
> > >
> > > ACPICA address space callback invocation is not suitable for Linux
> > > CONFIG_MODULE=y execution environment.  This patch tries to protect
> > > the address space callbacks by invoking them under a module safe
> > environment.
> > > The IPMI address space handler is also upgraded in this patch.
> > > The acpi_unregister_region() is designed to meet the following
> > > requirements:
> > > 1. It acts as a barrier for operation region callbacks - no callback will
> > >    happen after acpi_unregister_region().
> > > 2. acpi_unregister_region() is safe to be called in moudle->exit()
> > >    functions.
> > > Using reference counting rather than module referencing allows such
> > > benefits to be achieved even when acpi_unregister_region() is called
> > > in the environments other than module->exit().
> > > The header file of include/acpi/acpi_bus.h should contain the
> > > declarations that have references to some ACPICA defined types.
> > >
> > > Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> > > Reviewed-by: Huang Ying <ying.huang@intel.com>
> > > ---
> > >  drivers/acpi/acpi_ipmi.c |   16 ++--
> > >  drivers/acpi/osl.c       |  224
> > ++++++++++++++++++++++++++++++++++++++++++++++
> > >  include/acpi/acpi_bus.h  |    5 ++
> > >  3 files changed, 235 insertions(+), 10 deletions(-)
> > >
> > > diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
> > > index
> > > 5f8f495..2a09156 100644
> > > --- a/drivers/acpi/acpi_ipmi.c
> > > +++ b/drivers/acpi/acpi_ipmi.c
> > > @@ -539,20 +539,18 @@ out_ref:
> > >  static int __init acpi_ipmi_init(void)  {
> > >  	int result = 0;
> > > -	acpi_status status;
> > >
> > >  	if (acpi_disabled)
> > >  		return result;
> > >
> > >  	mutex_init(&driver_data.ipmi_lock);
> > >
> > > -	status = acpi_install_address_space_handler(ACPI_ROOT_OBJECT,
> > > -						    ACPI_ADR_SPACE_IPMI,
> > > -						    &acpi_ipmi_space_handler,
> > > -						    NULL, NULL);
> > > -	if (ACPI_FAILURE(status)) {
> > > +	result = acpi_register_region(ACPI_ADR_SPACE_IPMI,
> > > +				      &acpi_ipmi_space_handler,
> > > +				      NULL, NULL);
> > > +	if (result) {
> > >  		pr_warn("Can't register IPMI opregion space handle\n");
> > > -		return -EINVAL;
> > > +		return result;
> > >  	}
> > >
> > >  	result = ipmi_smi_watcher_register(&driver_data.bmc_events);
> > > @@ -596,9 +594,7 @@ static void __exit acpi_ipmi_exit(void)
> > >  	}
> > >  	mutex_unlock(&driver_data.ipmi_lock);
> > >
> > > -	acpi_remove_address_space_handler(ACPI_ROOT_OBJECT,
> > > -					  ACPI_ADR_SPACE_IPMI,
> > > -					  &acpi_ipmi_space_handler);
> > > +	acpi_unregister_region(ACPI_ADR_SPACE_IPMI);
> > >  }
> > >
> > >  module_init(acpi_ipmi_init);
> > > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c index
> > > 6ab2c35..8398e51 100644
> > > --- a/drivers/acpi/osl.c
> > > +++ b/drivers/acpi/osl.c
> > > @@ -86,6 +86,42 @@ static struct workqueue_struct *kacpid_wq;
> > > static struct workqueue_struct *kacpi_notify_wq;  static struct
> > > workqueue_struct *kacpi_hotplug_wq;
> > >
> > > +struct acpi_region {
> > > +	unsigned long flags;
> > > +#define ACPI_REGION_DEFAULT		0x01
> > > +#define ACPI_REGION_INSTALLED		0x02
> > > +#define ACPI_REGION_REGISTERED		0x04
> > > +#define ACPI_REGION_UNREGISTERING	0x08
> > > +#define ACPI_REGION_INSTALLING		0x10
> >
> > What about (1UL << 1), (1UL << 2) etc.?
> >
> > Also please remove the #defines out of the struct definition.
> 
> OK.
> 
> >
> > > +	/*
> > > +	 * NOTE: Upgrading All Region Handlers
> > > +	 * This flag is only used during the period where not all of the
> > > +	 * region handers are upgraded to the new interfaces.
> > > +	 */
> > > +#define ACPI_REGION_MANAGED		0x80
> > > +	acpi_adr_space_handler handler;
> > > +	acpi_adr_space_setup setup;
> > > +	void *context;
> > > +	/* Invoking references */
> > > +	atomic_t refcnt;
> >
> > Actually, why don't you use krefs?
> 
> If you take a look at other piece of my codes, you'll find there are two reasons:
> 
> 1. I'm using while (atomic_read() > 1) to implement the objects' flushing and
> there is no kref API to do so.
>   I just think it is not suitable for me to introduce such an API into kref.h and
> start another argument around kref designs in this bug fix patch. :-)
>   I'll start a discussion about kref design using another thread.
> 2. I'm using ipmi_dev|msg_release() as a pair of ipmi_dev|msg_alloc(), it's kind
> of atomic_t coding style.
>   If atomic_t is changed to struct kref, I will need to implement two API,
> __ipmi_dev_release() to take a struct kref as parameter and call
> ipmi_dev_release inside it.
>   By not using kref, I needn't write codes to implement such API.
> 
> >
> > > +};
> > > +
> > > +static struct acpi_region
> acpi_regions[ACPI_NUM_PREDEFINED_REGIONS]
> > = {
> > > +	[ACPI_ADR_SPACE_SYSTEM_MEMORY] = {
> > > +		.flags = ACPI_REGION_DEFAULT,
> > > +	},
> > > +	[ACPI_ADR_SPACE_SYSTEM_IO] = {
> > > +		.flags = ACPI_REGION_DEFAULT,
> > > +	},
> > > +	[ACPI_ADR_SPACE_PCI_CONFIG] = {
> > > +		.flags = ACPI_REGION_DEFAULT,
> > > +	},
> > > +	[ACPI_ADR_SPACE_IPMI] = {
> > > +		.flags = ACPI_REGION_MANAGED,
> > > +	},
> > > +};
> > > +static DEFINE_MUTEX(acpi_mutex_region);
> > > +
> > >  /*
> > >   * This list of permanent mappings is for memory that may be
> > > accessed
> > from
> > >   * interrupt context, where we can't do the ioremap().
> > > @@ -1799,3 +1835,191 @@ void alloc_acpi_hp_work(acpi_handle handle,
> > u32 type, void *context,
> > >  		kfree(hp_work);
> > >  }
> > >  EXPORT_SYMBOL_GPL(alloc_acpi_hp_work);
> > > +
> > > +static bool acpi_region_managed(struct acpi_region *rgn) {
> > > +	/*
> > > +	 * NOTE: Default and Managed
> > > +	 * We only need to avoid region management on the regions
> managed
> > > +	 * by ACPICA (ACPI_REGION_DEFAULT).  Currently, we need
> additional
> > > +	 * check as many operation region handlers are not upgraded, so
> > > +	 * only those known to be safe are managed
> (ACPI_REGION_MANAGED).
> > > +	 */
> > > +	return !(rgn->flags & ACPI_REGION_DEFAULT) &&
> > > +	       (rgn->flags & ACPI_REGION_MANAGED); }
> > > +
> > > +static bool acpi_region_callable(struct acpi_region *rgn) {
> > > +	return (rgn->flags & ACPI_REGION_REGISTERED) &&
> > > +	       !(rgn->flags & ACPI_REGION_UNREGISTERING); }
> > > +
> > > +static acpi_status
> > > +acpi_region_default_handler(u32 function,
> > > +			    acpi_physical_address address,
> > > +			    u32 bit_width, u64 *value,
> > > +			    void *handler_context, void *region_context) {
> > > +	acpi_adr_space_handler handler;
> > > +	struct acpi_region *rgn = (struct acpi_region *)handler_context;
> > > +	void *context;
> > > +	acpi_status status = AE_NOT_EXIST;
> > > +
> > > +	mutex_lock(&acpi_mutex_region);
> > > +	if (!acpi_region_callable(rgn) || !rgn->handler) {
> > > +		mutex_unlock(&acpi_mutex_region);
> > > +		return status;
> > > +	}
> > > +
> > > +	atomic_inc(&rgn->refcnt);
> > > +	handler = rgn->handler;
> > > +	context = rgn->context;
> > > +	mutex_unlock(&acpi_mutex_region);
> > > +
> > > +	status = handler(function, address, bit_width, value, context,
> > > +			 region_context);
> >
> > Why don't we call the handler under the mutex?

I think my reply is against this question, let me remove it up.

> It's a kind of programming style related concern.
> IMO, using locks around callback function is a buggy programming style that
> could lead to dead locks.
> Let me explain this using an example.
> 
> Object A exports a register/unregister API for other objects.
> Object B calls A's register/unregister API to register/unregister B's callback.

Sorry I have to use object rather than module here as there might be several objects inside a module that have the same situation need to be handled.

> It's likely that object B will hold lock_of_B around unregister/register when
> object B is destroyed/created, the lock_of_B is likely also used inside the
> callback.
> So when object A holds the lock_of_A around the callback invocation, it leads to
> dead lock since:
> 1. the locking order for the register/unregister side will be: lock(lock_of_B),
> lock(lock_of_A) 2. the locking order for the callback side will be: lock(lock_of_A),
> lock(lock_of_B) They are in the reversed order!

I think this example is not quite correct.
There is another aspect in unregister implementation which is the intent of this patch:
No callback running/imitated after "unregister", we can call this a "flush" requirement.
Inside of the callback, lock_of_B should not be held if "flush" is required.

> 
> IMO, Linux may need to introduce __callback, __api as decelerators for the
> functions, and use sparse to enforce this rule, sparse knows if a callback is
> invoked under some locks.
> 
> In the case of ACPICA space_handlers, as you may know, when an ACPI
> operation region handler is invoked, there will be no lock held inside ACPICA
> (interpreter lock must be freed before executing operation region handlers).
> So the likelihood of the dead lock is pretty much high here!

I need to mention another requirement of the operation region handler.
It is required that multiple operation region handlers are executed at the same time, or the IO operations invoked by the BIOS ASL codes will be serialized.
IMO, IO operations invoked by the BIOS ASL need to be parallelized.
Thus mutex is not useful to implement a protection here.

So the mutex is unlocked before executing the handler, IMO, reference counting is useful here to meet this requirement.

> >
> > What exactly prevents context from becoming NULL before the call above?

I think my answers did not answer this question directly.

Sorry that I'm not clear what you want to ask here.  Let me just try to be practical.

The code is here:
>
> > > +	mutex_lock(&acpi_mutex_region);
> > > +	if (!acpi_region_callable(rgn) || !rgn->handler) {

> > > +	handler = rgn->handler;
> > > +	context = rgn->context;
> > > +	mutex_unlock(&acpi_mutex_region);

The handler is ensured not to be NULL within the mutex lock.

Thanks for commenting.

Best regards
-Lv

> >
> > > +	atomic_dec(&rgn->refcnt);
> > > +
> > > +	return status;
> > > +}
> > > +
> > > +static acpi_status
> > > +acpi_region_default_setup(acpi_handle handle, u32 function,
> > > +			  void *handler_context, void **region_context) {
> > > +	acpi_adr_space_setup setup;
> > > +	struct acpi_region *rgn = (struct acpi_region *)handler_context;
> > > +	void *context;
> > > +	acpi_status status = AE_OK;
> > > +
> > > +	mutex_lock(&acpi_mutex_region);
> > > +	if (!acpi_region_callable(rgn) || !rgn->setup) {
> > > +		mutex_unlock(&acpi_mutex_region);
> > > +		return status;
> > > +	}
> > > +
> > > +	atomic_inc(&rgn->refcnt);
> > > +	setup = rgn->setup;
> > > +	context = rgn->context;
> > > +	mutex_unlock(&acpi_mutex_region);
> > > +
> > > +	status = setup(handle, function, context, region_context);
> >
> > Can setup drop rgn->refcnt ?
> 
> The reason is same as the handler, as a setup is also a callback.
> 
> >
> > > +	atomic_dec(&rgn->refcnt);
> > > +
> > > +	return status;
> > > +}
> > > +
> > > +static int __acpi_install_region(struct acpi_region *rgn,
> > > +				 acpi_adr_space_type space_id)
> > > +{
> > > +	int res = 0;
> > > +	acpi_status status;
> > > +	int installing = 0;
> > > +
> > > +	mutex_lock(&acpi_mutex_region);
> > > +	if (rgn->flags & ACPI_REGION_INSTALLED)
> > > +		goto out_lock;
> > > +	if (rgn->flags & ACPI_REGION_INSTALLING) {
> > > +		res = -EBUSY;
> > > +		goto out_lock;
> > > +	}
> > > +
> > > +	installing = 1;
> > > +	rgn->flags |= ACPI_REGION_INSTALLING;
> > > +	status = acpi_install_address_space_handler(ACPI_ROOT_OBJECT,
> > space_id,
> > > +						    acpi_region_default_handler,
> > > +						    acpi_region_default_setup,
> > > +						    rgn);
> > > +	rgn->flags &= ~ACPI_REGION_INSTALLING;
> > > +	if (ACPI_FAILURE(status))
> > > +		res = -EINVAL;
> > > +	else
> > > +		rgn->flags |= ACPI_REGION_INSTALLED;
> > > +
> > > +out_lock:
> > > +	mutex_unlock(&acpi_mutex_region);
> > > +	if (installing) {
> > > +		if (res)
> > > +			pr_err("Failed to install region %d\n", space_id);
> > > +		else
> > > +			pr_info("Region %d installed\n", space_id);
> > > +	}
> > > +	return res;
> > > +}
> > > +
> > > +int acpi_register_region(acpi_adr_space_type space_id,
> > > +			 acpi_adr_space_handler handler,
> > > +			 acpi_adr_space_setup setup, void *context) {
> > > +	int res;
> > > +	struct acpi_region *rgn;
> > > +
> > > +	if (space_id >= ACPI_NUM_PREDEFINED_REGIONS)
> > > +		return -EINVAL;
> > > +
> > > +	rgn = &acpi_regions[space_id];
> > > +	if (!acpi_region_managed(rgn))
> > > +		return -EINVAL;
> > > +
> > > +	res = __acpi_install_region(rgn, space_id);
> > > +	if (res)
> > > +		return res;
> > > +
> > > +	mutex_lock(&acpi_mutex_region);
> > > +	if (rgn->flags & ACPI_REGION_REGISTERED) {
> > > +		mutex_unlock(&acpi_mutex_region);
> > > +		return -EBUSY;
> > > +	}
> > > +
> > > +	rgn->handler = handler;
> > > +	rgn->setup = setup;
> > > +	rgn->context = context;
> > > +	rgn->flags |= ACPI_REGION_REGISTERED;
> > > +	atomic_set(&rgn->refcnt, 1);
> > > +	mutex_unlock(&acpi_mutex_region);
> > > +
> > > +	pr_info("Region %d registered\n", space_id);
> > > +
> > > +	return 0;
> > > +}
> > > +EXPORT_SYMBOL_GPL(acpi_register_region);
> > > +
> > > +void acpi_unregister_region(acpi_adr_space_type space_id) {
> > > +	struct acpi_region *rgn;
> > > +
> > > +	if (space_id >= ACPI_NUM_PREDEFINED_REGIONS)
> > > +		return;
> > > +
> > > +	rgn = &acpi_regions[space_id];
> > > +	if (!acpi_region_managed(rgn))
> > > +		return;
> > > +
> > > +	mutex_lock(&acpi_mutex_region);
> > > +	if (!(rgn->flags & ACPI_REGION_REGISTERED)) {
> > > +		mutex_unlock(&acpi_mutex_region);
> > > +		return;
> > > +	}
> > > +	if (rgn->flags & ACPI_REGION_UNREGISTERING) {
> > > +		mutex_unlock(&acpi_mutex_region);
> > > +		return;
> >
> > What about
> >
> > 	if ((rgn->flags & ACPI_REGION_UNREGISTERING)
> > 	    || !(rgn->flags & ACPI_REGION_REGISTERED)) {
> > 		mutex_unlock(&acpi_mutex_region);
> > 		return;
> > 	}
> >
> 
> OK.
> 
> > > +	}
> > > +
> > > +	rgn->flags |= ACPI_REGION_UNREGISTERING;
> > > +	rgn->handler = NULL;
> > > +	rgn->setup = NULL;
> > > +	rgn->context = NULL;
> > > +	mutex_unlock(&acpi_mutex_region);
> > > +
> > > +	while (atomic_read(&rgn->refcnt) > 1)
> > > +		schedule_timeout_uninterruptible(usecs_to_jiffies(5));
> >
> > Wouldn't it be better to use a wait queue here?
> 
> Yes, I'll try.
> 
> >
> > > +	atomic_dec(&rgn->refcnt);
> > > +
> > > +	mutex_lock(&acpi_mutex_region);
> > > +	rgn->flags &= ~(ACPI_REGION_REGISTERED |
> > ACPI_REGION_UNREGISTERING);
> > > +	mutex_unlock(&acpi_mutex_region);
> > > +
> > > +	pr_info("Region %d unregistered\n", space_id); }
> > > +EXPORT_SYMBOL_GPL(acpi_unregister_region);
> > > diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h index
> > > a2c2fbb..15fad0d 100644
> > > --- a/include/acpi/acpi_bus.h
> > > +++ b/include/acpi/acpi_bus.h
> > > @@ -542,4 +542,9 @@ static inline int unregister_acpi_bus_type(void
> > > *bus) { return 0; }
> > >
> > >  #endif				/* CONFIG_ACPI */
> > >
> > > +int acpi_register_region(acpi_adr_space_type space_id,
> > > +			 acpi_adr_space_handler handler,
> > > +			 acpi_adr_space_setup setup, void *context); void
> > > +acpi_unregister_region(acpi_adr_space_type space_id);
> > > +
> > >  #endif /*__ACPI_BUS_H__*/
> >
> > Thanks,
> > Rafael
> 
> Thanks
> -Lv
> 
> >
> >
> > --
> > I speak only for myself.
> > Rafael J. Wysocki, Intel Open Source Technology Center.
> N     r  y   b X  Ç§v ^ )Şº{.n +    { i b {ay Ê‡Ú™ ,j   f   h   z  w
> j:+v   w j m         zZ+     İ¢j"  ! i
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
