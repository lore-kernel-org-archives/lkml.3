Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab3JQLof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 07:44:35 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58419 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751073Ab3JQLod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 07:44:33 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Lan Tianyu <tianyu.lan@intel.com>
Subject: Re: [PATCH] ACPI / power: Drop automaitc resume of power resource dependent devices
Date: Thu, 17 Oct 2013 13:56:23 +0200
Message-ID: <3517410.N1Ot4TpM2j@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <525F8A48.9020007@intel.com>
References: <4814451.BPLed2xxbP@vostro.rjw.lan> <525F8A48.9020007@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 17, 2013 02:57:12 PM Aaron Lu wrote:
> On 10/16/2013 09:25 PM, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > The mechanism causing devices depending on a given power resource
> > (that is, devices that can be in D0 only if that power resource is
> > on) to be resumed automatically when the power resource is turned
> > on (and their "inferred" power state becomes D0 as a result) is
> > inherently racy and in fact unnecessary.
> > 
> > It is racy, because if the power resources is turned on and then
> > immediately off, the device resume triggered by the first transition
> > to "on" may still happen, causing the power resource to be turned
> > on again.  That again will trigger the "resume of dependent devices"
> > mechanism, but if the devices in question are not in use, they will
> > be suspended in the meantime causing the power resource to be turned
> > off.  However, the "resume of dependent devices" will next resume
> > them again and so on.  In some cases (USB port PM in particular) that
> > leads to an endless busy loop of flipping the resource on and off
> > continuously.
> > 
> > It is needless, because whoever turns a power resource on will most
> > likely turn it off at some point and the devices that go into "D0"
> > as a result of turning it on will then go back into D3cold.
> > Moreover, turning all power resources a device needs to go into
> > D0 is not sufficient for a full transition into D0 in general.
> > Namely, _PS0 may need to be executed in addition to that in some
> > cases.  This means that the whole rationale of the "resume of
> > dependent devices" mechanism was incorrect to begin with and it's
> > best to remove it entirely.
> 
> With this patch, your previous patch could also be applied now:
> https://lkml.org/lkml/2013/6/14/173
> [PATCH 4/4] ACPI / PM: Drop two functions that are not used any more

Good catch and that code is dead anyway AFAICS, because power_dependent is only
used in device_pm.c (in those two functions) and in scan.c (where it is
initialized).

Thanks!

> And the following ATA patch at the same time:
> 
> From: Aaron Lu <aaron.lu@intel.com>
> Subject: [PATCH] ata: acpi: remove power dependent device handling
> 
> Previously, we want the SCSI device corrsponding to ATA device gets
> runtime resumed when the power resource for that ATA device is turned
> on by some other device, so we added the SCSI device to the dependent
> device list of the ATA device's ACPI node. Since now we decided this
> behavior is troublesome and hard to avoid race, this behavior has been
> dropped. This patch cleans up the corresponding code in ATA ACPI layer.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>  drivers/ata/libata-acpi.c | 14 --------------
>  drivers/ata/libata-scsi.c |  3 ---
>  drivers/ata/libata.h      |  4 ----
>  3 files changed, 21 deletions(-)
> 
> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
> index 4ba8b04..ab714d2 100644
> --- a/drivers/ata/libata-acpi.c
> +++ b/drivers/ata/libata-acpi.c
> @@ -1035,17 +1035,3 @@ void ata_acpi_on_disable(struct ata_device *dev)
>  {
>  	ata_acpi_clear_gtf(dev);
>  }
> -
> -void ata_scsi_acpi_bind(struct ata_device *dev)
> -{
> -	acpi_handle handle = ata_dev_acpi_handle(dev);
> -	if (handle)
> -		acpi_dev_pm_add_dependent(handle, &dev->sdev->sdev_gendev);
> -}
> -
> -void ata_scsi_acpi_unbind(struct ata_device *dev)
> -{
> -	acpi_handle handle = ata_dev_acpi_handle(dev);
> -	if (handle)
> -		acpi_dev_pm_remove_dependent(handle, &dev->sdev->sdev_gendev);
> -}
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 97a0cef..db6dfcf 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3679,7 +3679,6 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>  			if (!IS_ERR(sdev)) {
>  				dev->sdev = sdev;
>  				scsi_device_put(sdev);
> -				ata_scsi_acpi_bind(dev);
>  			} else {
>  				dev->sdev = NULL;
>  			}
> @@ -3767,8 +3766,6 @@ static void ata_scsi_remove_dev(struct ata_device *dev)
>  	struct scsi_device *sdev;
>  	unsigned long flags;
>  
> -	ata_scsi_acpi_unbind(dev);
> -
>  	/* Alas, we need to grab scan_mutex to ensure SCSI device
>  	 * state doesn't change underneath us and thus
>  	 * scsi_device_get() always succeeds.  The mutex locking can
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index eeeb778..45b5ab3 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -121,8 +121,6 @@ extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
>  extern void ata_acpi_bind_port(struct ata_port *ap);
>  extern void ata_acpi_bind_dev(struct ata_device *dev);
>  extern acpi_handle ata_dev_acpi_handle(struct ata_device *dev);
> -extern void ata_scsi_acpi_bind(struct ata_device *dev);
> -extern void ata_scsi_acpi_unbind(struct ata_device *dev);
>  #else
>  static inline void ata_acpi_dissociate(struct ata_host *host) { }
>  static inline int ata_acpi_on_suspend(struct ata_port *ap) { return 0; }
> @@ -133,8 +131,6 @@ static inline void ata_acpi_set_state(struct ata_port *ap,
>  				      pm_message_t state) { }
>  static inline void ata_acpi_bind_port(struct ata_port *ap) {}
>  static inline void ata_acpi_bind_dev(struct ata_device *dev) {}
> -static inline void ata_scsi_acpi_bind(struct ata_device *dev) {}
> -static inline void ata_scsi_acpi_unbind(struct ata_device *dev) {}
>  #endif
>  
>  /* libata-scsi.c */
> > 
> > Reported-by: Lan Tianyu <tianyu.lan@intel.com>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/acpi/power.c |  100 ---------------------------------------------------
> >  1 file changed, 1 insertion(+), 99 deletions(-)
> > 
> > Index: linux-pm/drivers/acpi/power.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/power.c
> > +++ linux-pm/drivers/acpi/power.c
> > @@ -59,16 +59,9 @@ ACPI_MODULE_NAME("power");
> >  #define ACPI_POWER_RESOURCE_STATE_ON	0x01
> >  #define ACPI_POWER_RESOURCE_STATE_UNKNOWN 0xFF
> >  
> > -struct acpi_power_dependent_device {
> > -	struct list_head node;
> > -	struct acpi_device *adev;
> > -	struct work_struct work;
> > -};
> > -
> >  struct acpi_power_resource {
> >  	struct acpi_device device;
> >  	struct list_head list_node;
> > -	struct list_head dependent;
> >  	char *name;
> >  	u32 system_level;
> >  	u32 order;
> > @@ -233,32 +226,6 @@ static int acpi_power_get_list_state(str
> >  	return 0;
> >  }
> >  
> > -static void acpi_power_resume_dependent(struct work_struct *work)
> > -{
> > -	struct acpi_power_dependent_device *dep;
> > -	struct acpi_device_physical_node *pn;
> > -	struct acpi_device *adev;
> > -	int state;
> > -
> > -	dep = container_of(work, struct acpi_power_dependent_device, work);
> > -	adev = dep->adev;
> > -	if (acpi_power_get_inferred_state(adev, &state))
> > -		return;
> > -
> > -	if (state > ACPI_STATE_D0)
> > -		return;
> > -
> > -	mutex_lock(&adev->physical_node_lock);
> > -
> > -	list_for_each_entry(pn, &adev->physical_node_list, node)
> > -		pm_request_resume(pn->dev);
> > -
> > -	list_for_each_entry(pn, &adev->power_dependent, node)
> > -		pm_request_resume(pn->dev);
> > -
> > -	mutex_unlock(&adev->physical_node_lock);
> > -}
> > -
> >  static int __acpi_power_on(struct acpi_power_resource *resource)
> >  {
> >  	acpi_status status = AE_OK;
> > @@ -283,14 +250,8 @@ static int acpi_power_on_unlocked(struct
> >  				  resource->name));
> >  	} else {
> >  		result = __acpi_power_on(resource);
> > -		if (result) {
> > +		if (result)
> >  			resource->ref_count--;
> > -		} else {
> > -			struct acpi_power_dependent_device *dep;
> > -
> > -			list_for_each_entry(dep, &resource->dependent, node)
> > -				schedule_work(&dep->work);
> > -		}
> >  	}
> >  	return result;
> >  }
> > @@ -390,52 +351,6 @@ static int acpi_power_on_list(struct lis
> >  	return result;
> >  }
> >  
> > -static void acpi_power_add_dependent(struct acpi_power_resource *resource,
> > -				     struct acpi_device *adev)
> > -{
> > -	struct acpi_power_dependent_device *dep;
> > -
> > -	mutex_lock(&resource->resource_lock);
> > -
> > -	list_for_each_entry(dep, &resource->dependent, node)
> > -		if (dep->adev == adev)
> > -			goto out;
> > -
> > -	dep = kzalloc(sizeof(*dep), GFP_KERNEL);
> > -	if (!dep)
> > -		goto out;
> > -
> > -	dep->adev = adev;
> > -	INIT_WORK(&dep->work, acpi_power_resume_dependent);
> > -	list_add_tail(&dep->node, &resource->dependent);
> > -
> > - out:
> > -	mutex_unlock(&resource->resource_lock);
> > -}
> > -
> > -static void acpi_power_remove_dependent(struct acpi_power_resource *resource,
> > -					struct acpi_device *adev)
> > -{
> > -	struct acpi_power_dependent_device *dep;
> > -	struct work_struct *work = NULL;
> > -
> > -	mutex_lock(&resource->resource_lock);
> > -
> > -	list_for_each_entry(dep, &resource->dependent, node)
> > -		if (dep->adev == adev) {
> > -			list_del(&dep->node);
> > -			work = &dep->work;
> > -			break;
> > -		}
> > -
> > -	mutex_unlock(&resource->resource_lock);
> > -
> > -	if (work) {
> > -		cancel_work_sync(work);
> > -		kfree(dep);
> > -	}
> > -}
> > -
> >  static struct attribute *attrs[] = {
> >  	NULL,
> >  };
> > @@ -524,8 +439,6 @@ static void acpi_power_expose_hide(struc
> >  
> >  void acpi_power_add_remove_device(struct acpi_device *adev, bool add)
> >  {
> > -	struct acpi_device_power_state *ps;
> > -	struct acpi_power_resource_entry *entry;
> >  	int state;
> >  
> >  	if (adev->wakeup.flags.valid)
> > @@ -535,16 +448,6 @@ void acpi_power_add_remove_device(struct
> >  	if (!adev->power.flags.power_resources)
> >  		return;
> >  
> > -	ps = &adev->power.states[ACPI_STATE_D0];
> > -	list_for_each_entry(entry, &ps->resources, node) {
> > -		struct acpi_power_resource *resource = entry->resource;
> > -
> > -		if (add)
> > -			acpi_power_add_dependent(resource, adev);
> > -		else
> > -			acpi_power_remove_dependent(resource, adev);
> > -	}
> > -
> >  	for (state = ACPI_STATE_D0; state <= ACPI_STATE_D3_HOT; state++)
> >  		acpi_power_expose_hide(adev,
> >  				       &adev->power.states[state].resources,
> > @@ -882,7 +785,6 @@ int acpi_add_power_resource(acpi_handle
> >  	acpi_init_device_object(device, handle, ACPI_BUS_TYPE_POWER,
> >  				ACPI_STA_DEFAULT);
> >  	mutex_init(&resource->resource_lock);
> > -	INIT_LIST_HEAD(&resource->dependent);
> >  	INIT_LIST_HEAD(&resource->list_node);
> >  	resource->name = device->pnp.bus_id;
> >  	strcpy(acpi_device_name(device), ACPI_POWER_DEVICE_NAME);
> > 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
