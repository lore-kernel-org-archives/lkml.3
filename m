Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab3ATWcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 17:32:11 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47779 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab3ATWcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 17:32:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v9 06/11] PCI, ACPI, acpiphp: Rename alloc_acpiphp_hp_work() to alloc_acpi_hp_work
Date: Sun, 20 Jan 2013 23:38:08 +0100
Message-ID: <2123353.z1dtQmXUNo@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358495602-22867-7-git-send-email-yinghai@kernel.org>
References: <1358495602-22867-1-git-send-email-yinghai@kernel.org> <1358495602-22867-7-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 17, 2013 11:53:17 PM Yinghai Lu wrote:
> Will need to use it for pci root bridge hotplug support, rename
> *acpiphp* to *acpi* and move to osc.c.
> Also make kacpi_hotplug_wq static after that.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> ---
>  drivers/acpi/osl.c                 |   24 +++++++++++++++++++--
>  drivers/pci/hotplug/acpiphp_glue.c |   42 ++++++------------------------------
>  include/acpi/acpiosxf.h            |    9 +++++++-
>  3 files changed, 36 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 3ff2678..afcce46 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -84,8 +84,7 @@ static acpi_osd_handler acpi_irq_handler;
>  static void *acpi_irq_context;
>  static struct workqueue_struct *kacpid_wq;
>  static struct workqueue_struct *kacpi_notify_wq;
> -struct workqueue_struct *kacpi_hotplug_wq;
> -EXPORT_SYMBOL(kacpi_hotplug_wq);
> +static struct workqueue_struct *kacpi_hotplug_wq;
>  
>  /*
>   * This list of permanent mappings is for memory that may be accessed from
> @@ -1778,3 +1777,24 @@ void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
>  {
>  	__acpi_os_prepare_sleep = func;
>  }
> +
> +void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
> +			void (*func)(struct work_struct *work))
> +{
> +	struct acpi_hp_work *hp_work;
> +	int ret;
> +
> +	hp_work = kmalloc(sizeof(*hp_work), GFP_KERNEL);
> +	if (!hp_work)
> +		return;
> +
> +	hp_work->handle = handle;
> +	hp_work->type = type;
> +	hp_work->context = context;
> +
> +	INIT_WORK(&hp_work->work, func);
> +	ret = queue_work(kacpi_hotplug_wq, &hp_work->work);
> +	if (!ret)
> +		kfree(hp_work);
> +}
> +EXPORT_SYMBOL(alloc_acpi_hp_work);

That should be EXPORT_SYMBOL_GPL().

> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 79db296..55e03b6 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -1203,34 +1203,6 @@ check_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
>  	return AE_OK ;
>  }
>  
> -struct acpiphp_hp_work {
> -	struct work_struct work;
> -	acpi_handle handle;
> -	u32 type;
> -	void *context;
> -};
> -
> -static void alloc_acpiphp_hp_work(acpi_handle handle, u32 type,
> -				  void *context,
> -				  void (*func)(struct work_struct *work))
> -{
> -	struct acpiphp_hp_work *hp_work;
> -	int ret;
> -
> -	hp_work = kmalloc(sizeof(*hp_work), GFP_KERNEL);
> -	if (!hp_work)
> -		return;
> -
> -	hp_work->handle = handle;
> -	hp_work->type = type;
> -	hp_work->context = context;
> -
> -	INIT_WORK(&hp_work->work, func);
> -	ret = queue_work(kacpi_hotplug_wq, &hp_work->work);
> -	if (!ret)
> -		kfree(hp_work);
> -}
> -
>  static void _handle_hotplug_event_bridge(struct work_struct *work)
>  {
>  	struct acpiphp_bridge *bridge;
> @@ -1239,11 +1211,11 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
>  				      .pointer = objname };
>  	struct acpi_device *device;
>  	int num_sub_bridges = 0;
> -	struct acpiphp_hp_work *hp_work;
> +	struct acpi_hp_work *hp_work;
>  	acpi_handle handle;
>  	u32 type;
>  
> -	hp_work = container_of(work, struct acpiphp_hp_work, work);
> +	hp_work = container_of(work, struct acpi_hp_work, work);
>  	handle = hp_work->handle;
>  	type = hp_work->type;
>  
> @@ -1346,8 +1318,7 @@ static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
>  	 * For now just re-add this work to the kacpi_hotplug_wq so we
>  	 * don't deadlock on hotplug actions.
>  	 */
> -	alloc_acpiphp_hp_work(handle, type, context,
> -			      _handle_hotplug_event_bridge);
> +	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_bridge);
>  }
>  
>  static void _handle_hotplug_event_func(struct work_struct *work)
> @@ -1356,12 +1327,12 @@ static void _handle_hotplug_event_func(struct work_struct *work)
>  	char objname[64];
>  	struct acpi_buffer buffer = { .length = sizeof(objname),
>  				      .pointer = objname };
> -	struct acpiphp_hp_work *hp_work;
> +	struct acpi_hp_work *hp_work;
>  	acpi_handle handle;
>  	u32 type;
>  	void *context;
>  
> -	hp_work = container_of(work, struct acpiphp_hp_work, work);
> +	hp_work = container_of(work, struct acpi_hp_work, work);
>  	handle = hp_work->handle;
>  	type = hp_work->type;
>  	context = hp_work->context;
> @@ -1422,8 +1393,7 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
>  	 * For now just re-add this work to the kacpi_hotplug_wq so we
>  	 * don't deadlock on hotplug actions.
>  	 */
> -	alloc_acpiphp_hp_work(handle, type, context,
> -			      _handle_hotplug_event_func);
> +	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_func);
>  }
>  
>  static acpi_status
> diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
> index 4315274..adab63c 100644
> --- a/include/acpi/acpiosxf.h
> +++ b/include/acpi/acpiosxf.h
> @@ -193,7 +193,14 @@ void acpi_os_fixed_event_count(u32 fixed_event_number);
>  /*
>   * Threads and Scheduling
>   */
> -extern struct workqueue_struct *kacpi_hotplug_wq;

include/acpi/acpiosxf.h is related to ACPICA, so while removing kacpi_hotplug_wq
from it should be OK, please put the rest into acpi_bus.h, preferably next to the
definition of acpi_eject_event.

> +struct acpi_hp_work {
> +	struct work_struct work;
> +	acpi_handle handle;
> +	u32 type;
> +	void *context;
> +};
> +void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
> +			void (*func)(struct work_struct *work));
>  
>  acpi_thread_id acpi_os_get_thread_id(void);

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
