Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab3ALXcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 18:32:12 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39187 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab3ALXcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 18:32:10 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Tang Chen <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH v8 12/22] PCI, ACPI: debug print for installation of acpi root bridge's notifier
Date: Sun, 13 Jan 2013 00:37:57 +0100
Message-ID: <2183351.x1cn8B59bl@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357944049-29620-13-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1357944049-29620-13-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 02:40:39 PM Yinghai Lu wrote:
> From: Tang Chen <tangchen@cn.fujitsu.com>
> 
> acpi_install_notify_handler() could fail. So check the exit status
> and give a better debug info.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/acpi/pci_root.c |   12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
> index d30fb94..862abcc 100644
> --- a/drivers/acpi/pci_root.c
> +++ b/drivers/acpi/pci_root.c
> @@ -943,6 +943,7 @@ static bool acpi_is_root_bridge_object(acpi_handle handle)
>  static acpi_status __init
>  find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
>  {
> +	acpi_status status;
>  	char objname[64];
>  	struct acpi_buffer buffer = { .length = sizeof(objname),
>  				      .pointer = objname };
> @@ -955,9 +956,14 @@ find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
>  
>  	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>  
> -	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> -				handle_hotplug_event_root, NULL);
> -	printk(KERN_DEBUG "acpi root: %s notify handler installed\n", objname);
> +	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> +					handle_hotplug_event_root, NULL);
> +	if (ACPI_FAILURE(status))
> +		printk(KERN_DEBUG "acpi root: %s notify handler is not installed, exit status: %u\n",
> +				  objname, (unsigned int)status);

If we print a message on failure, I don't think we need one on success.

Besides, please use pr_debug().

> +	else
> +		printk(KERN_DEBUG "acpi root: %s notify handler is installed\n",
> +				 objname);
>  
>  	add_acpi_root_bridge(handle);

And I wonder what sens does this make to call add_acpi_root_bridge() here if we
haven't installed the notify handler for handle?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
