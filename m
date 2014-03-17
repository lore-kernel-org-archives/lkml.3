Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075AbaCQMdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:33:37 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:56125 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933061AbaCQMdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:33:35 -0400
Message-ID: <1395059613.1999.7.camel@x41>
Subject: Re: v3.14-rc1+: new error: "nsc-ircc, Wrong chip version ff"
From: Paul Bolle <pebolle@tiscali.nl>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 17 Mar 2014 13:33:33 +0100
In-Reply-To: <3120107.Slm5jUkmCN@vostro.rjw.lan>
References: <1395006095.2002.8.camel@x41>
	 <3120107.Slm5jUkmCN@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Mar 2014 12:33:33.0582 (UTC) FILETIME=[1C531AE0:01CF41DD]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki schreef op ma 17-03-2014 om 01:02 [+0100]:
> On Sunday, March 16, 2014 10:41:35 PM Paul Bolle wrote:
> > 2) What should I do to make that error go away?
> 
> This is not an error, but a message whose log level is too high.  It basically
> means "I found something, but I don't like it, so I'm not going to handle it."

I see. It's actually quite old and is mentioned rather often on the web.
I must have seen if before, when I actually used IrDA, but that's a few
years ago now.

> The messages come from nsc_ircc_setup(), which is called from nsc_ircc_open(),
> which in turn is called by nsc_ircc_init(), which is a module intialization
> function of the nsc-ircc module.
> 
> I *guess* what happens is that the PNP layer creates a PNP device object
> for something it didn't create an object for previously, so I wonder if the
> patch below makes those messages go away?

No, they're still there (with this patch applied on top of v3.14-rc7).

> ---
>  drivers/acpi/internal.h    |    1 -
>  drivers/pnp/pnpacpi/core.c |    5 ++++-
>  include/acpi/acpi_bus.h    |    1 +
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> Index: linux-pm/drivers/pnp/pnpacpi/core.c
> ===================================================================
> --- linux-pm.orig/drivers/pnp/pnpacpi/core.c
> +++ linux-pm/drivers/pnp/pnpacpi/core.c
> @@ -258,7 +258,10 @@ static int __init pnpacpi_add_device(str
>  	if (!pnpid)
>  		return 0;
>  
> -	if (is_exclusive_device(device) || !device->status.present)
> +	if (acpi_bus_get_status(device))
> +		return 0;
> +
> +	if (is_exclusive_device(device) || !acpi_device_is_present(device))
>  		return 0;
>  
>  	dev = pnp_alloc_dev(&pnpacpi_protocol, num, pnpid);
> Index: linux-pm/drivers/acpi/internal.h
> ===================================================================
> --- linux-pm.orig/drivers/acpi/internal.h
> +++ linux-pm/drivers/acpi/internal.h
> @@ -97,7 +97,6 @@ void acpi_device_add_finalize(struct acp
>  void acpi_free_pnp_ids(struct acpi_device_pnp *pnp);
>  int acpi_bind_one(struct device *dev, struct acpi_device *adev);
>  int acpi_unbind_one(struct device *dev);
> -bool acpi_device_is_present(struct acpi_device *adev);
>  bool acpi_device_is_battery(struct acpi_device *adev);
>  
>  /* --------------------------------------------------------------------------

This hunk required a trivial context change in v3.14-rc7.

> Index: linux-pm/include/acpi/acpi_bus.h
> ===================================================================
> --- linux-pm.orig/include/acpi/acpi_bus.h
> +++ linux-pm/include/acpi/acpi_bus.h
> @@ -422,6 +422,7 @@ void acpi_bus_put_acpi_device(struct acp
>  acpi_status acpi_bus_get_status_handle(acpi_handle handle,
>  				       unsigned long long *sta);
>  int acpi_bus_get_status(struct acpi_device *device);
> +bool acpi_device_is_present(struct acpi_device *adev);
>  
>  int acpi_bus_set_power(acpi_handle handle, int state);
>  const char *acpi_power_state_string(int state);

Thanks,


Paul Bolle

