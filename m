Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3ALXVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 18:21:50 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39168 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754431Ab3ALXVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 18:21:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH v8 10/22] ACPI: Introduce a new acpi handle to determine HID match.
Date: Sun, 13 Jan 2013 00:27:35 +0100
Message-ID: <2495590.pVLu9nhCCO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357944049-29620-11-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1357944049-29620-11-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 02:40:37 PM Yinghai Lu wrote:
> From: Tang Chen <tangchen@cn.fujitsu.com>
> 
> We need to find out if one handle is for root bridge, and install notify
> handler for it to handle pci root bus hot add.
> At that time, root bridge acpi device is not created yet.
> 
> So acpi_match_device_ids() will not work.
> 
> This patch add a function to check if new acpi handle's HID matches a list
> of IDs.  The new api use acpi_device_info instead acpi_device.
> 
> -v2: updated changelog, also check length for string info...
>      change checking sequence by moving string comaring close to for loop.
> 					- Yinghai
> -v3: change to _GPL according to Rafael

Please fold this into [11/22].  Otherwise one has to look at these two patches
at the same time to understand how the code is supposed to work, which is less
than useful.

Thanks,
Rafael


> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> ---
>  drivers/acpi/scan.c     |   33 +++++++++++++++++++++++++++++++++
>  include/acpi/acpi_bus.h |    2 ++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index db7664e..8883539 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -470,6 +470,39 @@ int acpi_match_device_ids(struct acpi_device *device,
>  }
>  EXPORT_SYMBOL(acpi_match_device_ids);
>  
> +int acpi_match_object_info_ids(struct acpi_device_info *info,
> +			       const struct acpi_device_id *ids)
> +{
> +	const struct acpi_device_id *id;
> +	char *str;
> +	u32 len;
> +	int i;
> +
> +	len = info->hardware_id.length;
> +	if (len) {
> +		str = info->hardware_id.string;
> +		if (str)
> +			for (id = ids; id->id[0]; id++)
> +				if (!strcmp((char *)id->id, str))
> +					return 0;
> +	}
> +
> +	for (i = 0; i < info->compatible_id_list.count; i++) {
> +		len = info->compatible_id_list.ids[i].length;
> +		if (!len)
> +			continue;
> +		str = info->compatible_id_list.ids[i].string;
> +		if (!str)
> +			continue;
> +		for (id = ids; id->id[0]; id++)
> +			if (!strcmp((char *)id->id, str))
> +				return 0;
> +	}
> +
> +	return -ENOENT;
> +}
> +EXPORT_SYMBOL_GPL(acpi_match_object_info_ids);
> +
>  static void acpi_free_ids(struct acpi_device *device)
>  {
>  	struct acpi_hardware_id *id, *tmp;
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index a9e1421..2246ba9 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -355,6 +355,8 @@ int acpi_bus_trim(struct acpi_device *start, int rmdevice);
>  acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
>  int acpi_match_device_ids(struct acpi_device *device,
>  			  const struct acpi_device_id *ids);
> +int acpi_match_object_info_ids(struct acpi_device_info *info,
> +			       const struct acpi_device_id *ids);
>  int acpi_create_dir(struct acpi_device *);
>  void acpi_remove_dir(struct acpi_device *);
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
