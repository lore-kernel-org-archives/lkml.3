Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3G2O2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:28:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:38693 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab3G2O2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:28:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,770,1367996400"; 
   d="scan'208";a="378332603"
Message-ID: <51F67C1E.9030609@intel.com>
Date: Mon, 29 Jul 2013 22:28:46 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 3/3] ACPI / PM: Use ACPI_STATE_D3_COLD instead of ACPI_STATE_D3
 everywhere
References: <10433383.dueoNg39qi@vostro.rjw.lan> <2158879.Vvb1Htqafe@vostro.rjw.lan>
In-Reply-To: <2158879.Vvb1Htqafe@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2013 09:14 PM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> There are several places in the tree where ACPI_STATE_D3 is used
> instead of ACPI_STATE_D3_COLD which should be used instead for
> clarity.  Modify them all to use ACPI_STATE_D3_COLD as appropriate.
> 
> [The definition of ACPI_STATE_D3 itself cannot go away at this point
>  as it is part of ACPICA.]
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Aaron Lu <aaron.lu@intel.com>

Thanks,
Aaron

> ---
>  drivers/acpi/fan.c         |    4 ++--
>  drivers/acpi/power.c       |    2 +-
>  drivers/acpi/scan.c        |    4 ++--
>  drivers/ata/libata-acpi.c  |    4 ++--
>  drivers/ide/ide-acpi.c     |    5 +++--
>  drivers/pnp/pnpacpi/core.c |    6 +++---
>  include/acpi/acpi_bus.h    |    3 ++-
>  7 files changed, 15 insertions(+), 13 deletions(-)
> 
> Index: linux-pm/drivers/acpi/fan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/fan.c
> +++ linux-pm/drivers/acpi/fan.c
> @@ -93,7 +93,7 @@ static int fan_get_cur_state(struct ther
>  	if (result)
>  		return result;
>  
> -	*state = (acpi_state == ACPI_STATE_D3 ? 0 :
> +	*state = (acpi_state == ACPI_STATE_D3_COLD ? 0 :
>  		 (acpi_state == ACPI_STATE_D0 ? 1 : -1));
>  	return 0;
>  }
> @@ -108,7 +108,7 @@ fan_set_cur_state(struct thermal_cooling
>  		return -EINVAL;
>  
>  	result = acpi_bus_set_power(device->handle,
> -				state ? ACPI_STATE_D0 : ACPI_STATE_D3);
> +				state ? ACPI_STATE_D0 : ACPI_STATE_D3_COLD);
>  
>  	return result;
>  }
> Index: linux-pm/drivers/acpi/power.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/power.c
> +++ linux-pm/drivers/acpi/power.c
> @@ -784,7 +784,7 @@ int acpi_power_get_inferred_state(struct
>  		}
>  	}
>  
> -	*state = ACPI_STATE_D3;
> +	*state = ACPI_STATE_D3_COLD;
>  	return 0;
>  }
>  
> Index: linux-pm/drivers/acpi/scan.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/scan.c
> +++ linux-pm/drivers/acpi/scan.c
> @@ -1409,8 +1409,8 @@ static void acpi_bus_get_power_flags(str
>  	/* Set defaults for D0 and D3 states (always valid) */
>  	device->power.states[ACPI_STATE_D0].flags.valid = 1;
>  	device->power.states[ACPI_STATE_D0].power = 100;
> -	device->power.states[ACPI_STATE_D3].flags.valid = 1;
> -	device->power.states[ACPI_STATE_D3].power = 0;
> +	device->power.states[ACPI_STATE_D3_COLD].flags.valid = 1;
> +	device->power.states[ACPI_STATE_D3_COLD].power = 0;
>  
>  	/* Set D3cold's explicit_set flag if _PS3 exists. */
>  	if (device->power.states[ACPI_STATE_D3_HOT].flags.explicit_set)
> Index: linux-pm/drivers/ata/libata-acpi.c
> ===================================================================
> --- linux-pm.orig/drivers/ata/libata-acpi.c
> +++ linux-pm/drivers/ata/libata-acpi.c
> @@ -947,11 +947,11 @@ static void pata_acpi_set_state(struct a
>  			continue;
>  
>  		acpi_bus_set_power(dev_handle, state.event & PM_EVENT_RESUME ?
> -						ACPI_STATE_D0 : ACPI_STATE_D3);
> +					ACPI_STATE_D0 : ACPI_STATE_D3_COLD);
>  	}
>  
>  	if (!(state.event & PM_EVENT_RESUME))
> -		acpi_bus_set_power(port_handle, ACPI_STATE_D3);
> +		acpi_bus_set_power(port_handle, ACPI_STATE_D3_COLD);
>  }
>  
>  /**
> Index: linux-pm/drivers/ide/ide-acpi.c
> ===================================================================
> --- linux-pm.orig/drivers/ide/ide-acpi.c
> +++ linux-pm/drivers/ide/ide-acpi.c
> @@ -520,11 +520,12 @@ void ide_acpi_set_state(ide_hwif_t *hwif
>  	ide_port_for_each_present_dev(i, drive, hwif) {
>  		if (drive->acpidata->obj_handle)
>  			acpi_bus_set_power(drive->acpidata->obj_handle,
> -					   on ? ACPI_STATE_D0 : ACPI_STATE_D3);
> +				on ? ACPI_STATE_D0 : ACPI_STATE_D3_COLD);
>  	}
>  
>  	if (!on)
> -		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D3);
> +		acpi_bus_set_power(hwif->acpidata->obj_handle,
> +				   ACPI_STATE_D3_COLD);
>  }
>  
>  /**
> Index: linux-pm/drivers/pnp/pnpacpi/core.c
> ===================================================================
> --- linux-pm.orig/drivers/pnp/pnpacpi/core.c
> +++ linux-pm/drivers/pnp/pnpacpi/core.c
> @@ -131,7 +131,7 @@ static int pnpacpi_disable_resources(str
>  	/* acpi_unregister_gsi(pnp_irq(dev, 0)); */
>  	ret = 0;
>  	if (acpi_bus_power_manageable(handle))
> -		acpi_bus_set_power(handle, ACPI_STATE_D3);
> +		acpi_bus_set_power(handle, ACPI_STATE_D3_COLD);
>  		/* continue even if acpi_bus_set_power() fails */
>  	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_DIS", NULL, NULL)))
>  		ret = -ENODEV;
> @@ -174,10 +174,10 @@ static int pnpacpi_suspend(struct pnp_de
>  
>  	if (acpi_bus_power_manageable(handle)) {
>  		int power_state = acpi_pm_device_sleep_state(&dev->dev, NULL,
> -							     ACPI_STATE_D3);
> +							ACPI_STATE_D3_COLD);
>  		if (power_state < 0)
>  			power_state = (state.event == PM_EVENT_ON) ?
> -					ACPI_STATE_D0 : ACPI_STATE_D3;
> +					ACPI_STATE_D0 : ACPI_STATE_D3_COLD;
>  
>  		/*
>  		 * acpi_bus_set_power() often fails (keyboard port can't be
> Index: linux-pm/include/acpi/acpi_bus.h
> ===================================================================
> --- linux-pm.orig/include/acpi/acpi_bus.h
> +++ linux-pm/include/acpi/acpi_bus.h
> @@ -477,7 +477,8 @@ static inline int acpi_pm_device_sleep_s
>  	if (p)
>  		*p = ACPI_STATE_D0;
>  
> -	return (m >= ACPI_STATE_D0 && m <= ACPI_STATE_D3) ? m : ACPI_STATE_D0;
> +	return (m >= ACPI_STATE_D0 && m <= ACPI_STATE_D3_COLD) ?
> +		m : ACPI_STATE_D0;
>  }
>  static inline void acpi_dev_pm_add_dependent(acpi_handle handle,
>  					     struct device *depdev) {}
> 

