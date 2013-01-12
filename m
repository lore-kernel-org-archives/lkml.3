Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab3ALXiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 18:38:08 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39207 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab3ALXiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 18:38:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v8 16/22] PCI, acpiphp: Don't bailout even no slots found yet.
Date: Sun, 13 Jan 2013 00:43:53 +0100
Message-ID: <1767472.DguSxT8x55@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1357944049-29620-17-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org> <1357944049-29620-17-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 11, 2013 02:40:43 PM Yinghai Lu wrote:
> Could have root bus hot addde later and there may be slots that need acpiphp.

s/addde/added/

The changes look reasonable to me, but I'm not very familiar with the code in
question.

Thanks,
Rafael


> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/hotplug/acpiphp.h      |    1 -
>  drivers/pci/hotplug/acpiphp_core.c |   23 ++---------------------
>  drivers/pci/hotplug/acpiphp_glue.c |   22 ----------------------
>  3 files changed, 2 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
> index a1afb5b..b3ead7a 100644
> --- a/drivers/pci/hotplug/acpiphp.h
> +++ b/drivers/pci/hotplug/acpiphp.h
> @@ -193,7 +193,6 @@ extern void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *slot);
>  /* acpiphp_glue.c */
>  extern int acpiphp_glue_init (void);
>  extern void acpiphp_glue_exit (void);
> -extern int acpiphp_get_num_slots (void);
>  typedef int (*acpiphp_callback)(struct acpiphp_slot *slot, void *data);
>  
>  extern int acpiphp_enable_slot (struct acpiphp_slot *slot);
> diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
> index 96316b7..c2fd309 100644
> --- a/drivers/pci/hotplug/acpiphp_core.c
> +++ b/drivers/pci/hotplug/acpiphp_core.c
> @@ -50,7 +50,6 @@
>  bool acpiphp_debug;
>  
>  /* local variables */
> -static int num_slots;
>  static struct acpiphp_attention_info *attention_info;
>  
>  #define DRIVER_VERSION	"0.5"
> @@ -272,25 +271,6 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
>  	return 0;
>  }
>  
> -static int __init init_acpi(void)
> -{
> -	int retval;
> -
> -	/* initialize internal data structure etc. */
> -	retval = acpiphp_glue_init();
> -
> -	/* read initial number of slots */
> -	if (!retval) {
> -		num_slots = acpiphp_get_num_slots();
> -		if (num_slots == 0) {
> -			acpiphp_glue_exit();
> -			retval = -ENODEV;
> -		}
> -	}
> -
> -	return retval;
> -}
> -
>  /**
>   * release_slot - free up the memory used by a slot
>   * @hotplug_slot: slot to free
> @@ -379,7 +359,8 @@ static int __init acpiphp_init(void)
>  		return 0;
>  
>  	/* read all the ACPI info from the system */
> -	return init_acpi();
> +	/* initialize internal data structure etc. */
> +	return acpiphp_glue_init();
>  }
>  
>  
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index 02c41ab..30467ec 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -1446,28 +1446,6 @@ void  acpiphp_glue_exit(void)
>  	acpi_pci_unregister_driver(&acpi_pci_hp_driver);
>  }
>  
> -
> -/**
> - * acpiphp_get_num_slots - count number of slots in a system
> - */
> -int __init acpiphp_get_num_slots(void)
> -{
> -	struct acpiphp_bridge *bridge;
> -	int num_slots = 0;
> -
> -	list_for_each_entry(bridge, &bridge_list, list) {
> -		dbg("Bus %04x:%02x has %d slot%s\n",
> -				pci_domain_nr(bridge->pci_bus),
> -				bridge->pci_bus->number, bridge->nr_slots,
> -				bridge->nr_slots == 1 ? "" : "s");
> -		num_slots += bridge->nr_slots;
> -	}
> -
> -	dbg("Total %d slots\n", num_slots);
> -	return num_slots;
> -}
> -
> -
>  /**
>   * acpiphp_enable_slot - power on slot
>   * @slot: ACPI PHP slot
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
