Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240Ab3GCVbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 17:31:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57672 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab3GCVbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 17:31:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 6/8] PCI: acpiphp: workaround for Thunderbolt on Acer Aspire S5
Date: Wed, 03 Jul 2013 23:40:42 +0200
Message-ID: <1444243.g9GbxN3NM0@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1372860295-8306-7-git-send-email-mika.westerberg@linux.intel.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com> <1372860295-8306-7-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 03, 2013 05:04:53 PM Mika Westerberg wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> 
> Correct ACPI PCI hotplug imeplementation should have _RMV method in a
> PCI slot (device under pci bridge). In Acer Aspire S5 case we have it
> deeper in hierarchy:
> 
> Device (RP05)
> {
>    // ...
>    Device (HRUP)
>    {
>        // ...
>        Device (HRDN)
>        {
>            // ...
>            Device (EPUP)
>            {
>                // ...
>                Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
>                {
>                    Return (One)
>                }
>            }
>        }
>    }
> }
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/pci/hotplug/acpi_pcihp.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
> index 2a47e82..d92ebfb 100644
> --- a/drivers/pci/hotplug/acpi_pcihp.c
> +++ b/drivers/pci/hotplug/acpi_pcihp.c
> @@ -422,6 +422,19 @@ static int pcihp_is_ejectable(acpi_handle handle)
>  	status = acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
>  	if (ACPI_SUCCESS(status) && removable)
>  		return 1;
> +
> +	/*
> +	 * Workaround for Thunderbolt implementation on Acer Aspire S5.
> +	 *
> +	 * Correct ACPI PCI hotplug imeplementation has _RMV method in a PCI
> +	 * slot (device under pci bridge). In Acer Aspire S5 case we have it
> +	 * deeper in hierarchy.
> +	 */
> +	status = acpi_evaluate_integer(handle, "HRDN.EPUP._RMV", NULL,
> +			&removable);

Well, calling stuff like this directly from a general function is kind of ugly.

Can we use something like a quirk instead?  A DMI check or something?

> +	if (ACPI_SUCCESS(status) && removable)
> +		return 1;
> +
>  	return 0;
>  }

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
