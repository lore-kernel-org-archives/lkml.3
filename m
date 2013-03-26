Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072Ab3CZNRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:17:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43007 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757128Ab3CZNRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:17:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI, ACPI: hold acpi_scan_lock during root bus hotplug
Date: Tue, 26 Mar 2013 14:24:41 +0100
Message-ID: <34989330.IyIZ6Qqfxh@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1362978316-23553-1-git-send-email-yinghai@kernel.org>
References: <1673357.1IdxNNvGWX@vostro.rjw.lan> <1362978316-23553-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 10, 2013 10:05:16 PM Yinghai Lu wrote:
> During merging pci tree with pm/acpi tree, Linus noticed that
> we don't have same lock using patten about acpi pci root as
> acpiphp.
> 
> Here apply same lock patten, and we need to change
> acpi_bus_hot_remove_device executing via acpi_os_hotplug_execute()
> as it also hold the lock in acpi_bus_hot_remove_device.
> 
> That will make acpi_bus_hot_remove_device calling the same as other
> callers.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Bjorn, this needs to go in before final 3.9.

Are you going to handle it, or should I take care of it?

Rafael


> ---
>  drivers/acpi/pci_root.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/pci_root.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/pci_root.c
> +++ linux-2.6/drivers/acpi/pci_root.c
> @@ -646,6 +646,7 @@ static void handle_root_bridge_insertion
>  
>  static void handle_root_bridge_removal(struct acpi_device *device)
>  {
> +	acpi_status status;
>  	struct acpi_eject_event *ej_event;
>  
>  	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
> @@ -661,7 +662,9 @@ static void handle_root_bridge_removal(s
>  	ej_event->device = device;
>  	ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
>  
> -	acpi_bus_hot_remove_device(ej_event);
> +	status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, ej_event);
> +	if (ACPI_FAILURE(status))
> +		kfree(ej_event);
>  }
>  
>  static void _handle_hotplug_event_root(struct work_struct *work)
> @@ -676,8 +679,9 @@ static void _handle_hotplug_event_root(s
>  	handle = hp_work->handle;
>  	type = hp_work->type;
>  
> -	root = acpi_pci_find_root(handle);
> +	acpi_scan_lock_acquire();
>  
> +	root = acpi_pci_find_root(handle);
>  	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
>  
>  	switch (type) {
> @@ -711,6 +715,7 @@ static void _handle_hotplug_event_root(s
>  		break;
>  	}
>  
> +	acpi_scan_lock_release();
>  	kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
>  	kfree(buffer.pointer);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
