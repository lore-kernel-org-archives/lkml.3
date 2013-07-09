Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab3GIJcC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:32:02 -0400
Received: from mga02.intel.com ([134.134.136.20]:54239 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab3GIJcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:32:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1027,1363158000"; 
   d="scan'208";a="367028656"
Date: Tue, 9 Jul 2013 12:37:26 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: [RFC][PATCH 6/8] ACPI / hotplug / PCI: Drop
 acpiphp_handle_to_bridge()
Message-ID: <20130709093726.GK4898@intel.com>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
 <3804403.VVlzfJfUyu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3804403.VVlzfJfUyu@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 02:20:31AM +0200, Rafael J. Wysocki wrote:
> @@ -953,37 +937,49 @@ static void acpiphp_sanitize_bus(struct
>   * ACPI event handlers
>   */
>  
> -static acpi_status
> -check_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
> +static acpi_status check_sub_bridges(acpi_handle handle, u32 lvl, void *data,
> +				     void **rv)
>  {
> -	struct acpiphp_bridge *bridge;
> -	char objname[64];
> -	struct acpi_buffer buffer = { .length = sizeof(objname),
> -				      .pointer = objname };
> +	struct acpiphp_context *context = acpiphp_get_context(handle);
> +
> +	if (!context)
> +		return AE_OK;
>  
> -	bridge = acpiphp_handle_to_bridge(handle);
> -	if (bridge) {
> +	if (context->bridge) {
> +		struct acpiphp_bridge *bridge = context->bridge;
> +		char objname[64];
> +		struct acpi_buffer buffer = { .length = sizeof(objname),
> +					      .pointer = objname };
> +
> +		get_bridge(bridge);
>  		acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
> -		dbg("%s: re-enumerating slots under %s\n",
> -			__func__, objname);
> +		dbg("%s: re-enumerating slots under %s\n", __func__, objname);

Although not related to this patch directly, how about using
acpi_handle_debug() or similar here?

>  		acpiphp_check_bridge(bridge);
>  		put_bridge(bridge);
>  	}
> +	acpiphp_put_context(context);
>  	return AE_OK ;
>  }
