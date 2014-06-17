Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbaFQQF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:05:58 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:51346 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933601AbaFQQFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:05:54 -0400
MIME-Version: 1.0
In-Reply-To: <1402982995-13747-4-git-send-email-jiang.liu@linux.intel.com>
References: <1402982995-13747-1-git-send-email-jiang.liu@linux.intel.com> <1402982995-13747-4-git-send-email-jiang.liu@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 17 Jun 2014 10:05:33 -0600
Message-ID: <CAErSpo4y9HQB-OcX8XwpXHW=xCvDQOJZgokG5iMqg705XZnevg@mail.gmail.com>
Subject: Re: [RFC Patch V2 03/16] ACPI, x86/PCI: Move resource_to_addr() to
 acpi generic
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Len Brown <lenb@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 11:29 PM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
> From: Yinghai Lu <yinghai@kernel.org>
>
> Rui Wang reported ioapic hot-add does not work on his machine
> that _CRS have MEMORY_FIXED.
> He also proposed to expose resource_to_addr() and use it for ioapic.
>
> We should move it to acpi generic, as ioapi.c current is in

s/ioapi.c/ioapic.c/

> drivers/pci/.
>
> Or should move it to acpica?
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index 0bdacc5e26a3..e91deebf0930 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -424,6 +424,52 @@ void acpi_dev_free_resource_list(struct list_head *list)
>  }
>  EXPORT_SYMBOL_GPL(acpi_dev_free_resource_list);
>
> +acpi_status acpi_mem_addr_resource_to_address64(struct acpi_resource *resource,
> +                       struct acpi_resource_address64 *addr)
> +{
> +       acpi_status status;
> +       struct acpi_resource_memory24 *memory24;
> +       struct acpi_resource_memory32 *memory32;
> +       struct acpi_resource_fixed_memory32 *fixed_memory32;
> +
> +       memset(addr, 0, sizeof(*addr));
> +       switch (resource->type) {
> +       case ACPI_RESOURCE_TYPE_MEMORY24:
> +               memory24 = &resource->data.memory24;
> +               addr->resource_type = ACPI_MEMORY_RANGE;
> +               addr->minimum = memory24->minimum;
> +               addr->address_length = memory24->address_length;
> +               addr->maximum = addr->minimum + addr->address_length - 1;
> +               return AE_OK;
> +       case ACPI_RESOURCE_TYPE_MEMORY32:
> +               memory32 = &resource->data.memory32;
> +               addr->resource_type = ACPI_MEMORY_RANGE;
> +               addr->minimum = memory32->minimum;
> +               addr->address_length = memory32->address_length;
> +               addr->maximum = addr->minimum + addr->address_length - 1;
> +               return AE_OK;
> +       case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
> +               fixed_memory32 = &resource->data.fixed_memory32;
> +               addr->resource_type = ACPI_MEMORY_RANGE;
> +               addr->minimum = fixed_memory32->address;
> +               addr->address_length = fixed_memory32->address_length;
> +               addr->maximum = addr->minimum + addr->address_length - 1;
> +               return AE_OK;
> +       case ACPI_RESOURCE_TYPE_ADDRESS16:
> +       case ACPI_RESOURCE_TYPE_ADDRESS32:
> +       case ACPI_RESOURCE_TYPE_ADDRESS64:
> +               status = acpi_resource_to_address64(resource, addr);
> +               if (ACPI_SUCCESS(status) &&
> +                   (addr->resource_type == ACPI_MEMORY_RANGE ||
> +                   addr->resource_type == ACPI_IO_RANGE) &&
> +                   addr->address_length > 0) {
> +                       return AE_OK;
> +               }
> +               break;
> +       }
> +       return AE_ERROR;
> +}

There's already very similar-looking code in acpi/resource.c, e.g.,
acpi_dev_resource_address_space() and acpi_dev_resource_memory().  Can
you use that existing code instead of adding new code that's mostly a
duplication?

Bjorn
