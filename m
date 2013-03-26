Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934256Ab3CZNbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:31:24 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43102 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933808Ab3CZNbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:31:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bob Moore <robert.moore@intel.com>, Len Brown <len.brown@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mattia Dongili <malattia@linux.it>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Adam Belay <abelay@mit.edu>, Bjorn Helgaas <bhelgaas@google.com>,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] ACPI: Set length even for TYPE_END_TAG acpi resource
Date: Tue, 26 Mar 2013 14:38:48 +0100
Message-ID: <3286748.nH2qgHsh48@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1364066197-11670-1-git-send-email-yinghai@kernel.org>
References: <1364066197-11670-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, March 23, 2013 12:16:37 PM Yinghai Lu wrote:
> Found with pm/linux-next, network device in QEMU/KVM guest does not
> work anymore.
> 
> Bisected to commit c13085e5
>     ACPICA: Resource Mgr: Prevent infinite loops in resource walks
> 
> That commit will check acpi_resource length strictly.
> it cause acpi_set_current_resources return failure and irq for pci device
> is not set properly.
> 
> Set length for all those TYPE_END_TAG acpi_resources.
> 
> Bisected-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Mattia Dongili <malattia@linux.it>
> Cc: Matthew Garrett <matthew.garrett@nebula.com>
> Cc: Adam Belay <abelay@mit.edu>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: platform-driver-x86@vger.kernel.org

Applied.

Thanks,
Rafael


> ---
>  drivers/acpi/pci_link.c            |    1 +
>  drivers/platform/x86/sony-laptop.c |    3 ++-
>  drivers/pnp/pnpacpi/rsparser.c     |    1 +
>  3 files changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/acpi/pci_link.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/pci_link.c
> +++ linux-2.6/drivers/acpi/pci_link.c
> @@ -354,6 +354,7 @@ static int acpi_pci_link_set(struct acpi
>  
>  	}
>  	resource->end.type = ACPI_RESOURCE_TYPE_END_TAG;
> +	resource->end.length = sizeof(struct acpi_resource);
>  
>  	/* Attempt to set the resource */
>  	status = acpi_set_current_resources(link->device->handle, &buffer);
> Index: linux-2.6/drivers/platform/x86/sony-laptop.c
> ===================================================================
> --- linux-2.6.orig/drivers/platform/x86/sony-laptop.c
> +++ linux-2.6/drivers/platform/x86/sony-laptop.c
> @@ -4121,7 +4121,7 @@ static int sony_pic_enable(struct acpi_d
>  		resource->res3.data.irq.sharable = ACPI_SHARED;
>  
>  		resource->res4.type = ACPI_RESOURCE_TYPE_END_TAG;
> -
> +		resource->res4.length = sizeof(struct acpi_resource);
>  	}
>  	/* setup Type 2/3 resources */
>  	else {
> @@ -4140,6 +4140,7 @@ static int sony_pic_enable(struct acpi_d
>  		resource->res2.data.irq.sharable = ACPI_SHARED;
>  
>  		resource->res3.type = ACPI_RESOURCE_TYPE_END_TAG;
> +		resource->res3.length = sizeof(struct acpi_resource);
>  	}
>  
>  	/* Attempt to set the resource */
> Index: linux-2.6/drivers/pnp/pnpacpi/rsparser.c
> ===================================================================
> --- linux-2.6.orig/drivers/pnp/pnpacpi/rsparser.c
> +++ linux-2.6/drivers/pnp/pnpacpi/rsparser.c
> @@ -634,6 +634,7 @@ int pnpacpi_build_resource_template(stru
>  	}
>  	/* resource will pointer the end resource now */
>  	resource->type = ACPI_RESOURCE_TYPE_END_TAG;
> +	resource->length = sizeof(struct acpi_resource);
>  
>  	return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
