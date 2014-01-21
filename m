Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaAUVVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:21:08 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:10085 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbaAUVVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:21:05 -0500
Message-ID: <1390338897.1792.467.camel@misato.fc.hp.com>
Subject: Re: [Patch v1 1/3] ACPI: add callback prepare() into
 acpi_hotplug_handler
From: Toshi Kani <toshi.kani@hp.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@acpica.org
Date: Tue, 21 Jan 2014 14:14:57 -0700
In-Reply-To: <1390013297-23462-1-git-send-email-jiang.liu@linux.intel.com>
References: <1390013297-23462-1-git-send-email-jiang.liu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-18 at 10:48 +0800, Jiang Liu wrote:
> Add callback prepare() into acpi_hotplug_handler, which will get called
> at the very beginning of ACPI hotplug event handler. The ACPI core will
> ignore the event if prepare() returns NOTIFY_STOP.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/acpi/scan.c     |    4 ++++
>  include/acpi/acpi_bus.h |    1 +
>  2 files changed, 5 insertions(+)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index fd39459..6b0f419 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -392,6 +392,10 @@ static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
>  	struct acpi_device *adev;
>  	acpi_status status;
>  
> +	if (handler->prepare &&
> +	    handler->prepare(handle, type, data) == NOTIFY_STOP)
> +		return;

The OS is responsible for calling _OST when it is implemented.  So you
cannot just return here.  See acpi_hotplug_unsupported(handle, type)
next line.  Also, please describe why prepare() needs to be added.

Thanks,
-Toshi



> +
>  	if (!handler->hotplug.enabled)
>  		return acpi_hotplug_unsupported(handle, type);
>  
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index ddabed1..09a73bd 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -113,6 +113,7 @@ static inline struct acpi_hotplug_profile *to_acpi_hotplug_profile(
>  struct acpi_scan_handler {
>  	const struct acpi_device_id *ids;
>  	struct list_head list_node;
> +	int (*prepare)(acpi_handle handle, u32 type, void *context);
>  	int (*attach)(struct acpi_device *dev, const struct acpi_device_id *id);
>  	void (*detach)(struct acpi_device *dev);
>  	struct acpi_hotplug_profile hotplug;


