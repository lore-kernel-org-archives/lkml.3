Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaKEWHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:07:40 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55514 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751310AbaKEWHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:07:38 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 3/4] PNP: Allow device to override ACPI device sleep
Date: Wed, 05 Nov 2014 23:28:24 +0100
Message-ID: <4057911.0dclCWmemA@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415212854-16944-4-git-send-email-peter@hurleysoftware.com>
References: <1415212854-16944-1-git-send-email-peter@hurleysoftware.com> <1415212854-16944-4-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 05, 2014 01:40:53 PM Peter Hurley wrote:
> If the serial console is an ACPI PNP device, the PNP bus attempts to
> power-down the device, even though the no_console_suspend command line
> parameter is specified (eg., debugging suspend/resume).
> 
> Add PNP_SUSPEND capability which is on by default, but when cleared,
> prevents pnpacpi_suspend() (which is the ACPI PNP protocol ->suspend()
> method).
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>

While I'm not disagreeing with this entirely, I have a concern.

There are two types of suspend in Linux these days, runtime suspend and
system suspend.  What this is about is "device suspend during system
suspend" only, so the flag name is somewhat confusing.

Also the flag is only going to be used for consoles, so why don't you
introduce a PNP_CONSOLE flag and then define pnp_can_suspend() as

static inline pnp_can_suspend(struct pnp_dev *pnp_dev)
{
	return pnp_dev->protocol->suspend &&
		 (!(pnp_dev->capabilities & PNP_CONSOLE) || console_suspend_enabled);
}

> ---
>  drivers/pnp/driver.c       | 2 +-
>  drivers/pnp/pnpacpi/core.c | 2 +-
>  include/linux/pnp.h        | 3 +++
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
> index f748cc8..4e57d33 100644
> --- a/drivers/pnp/driver.c
> +++ b/drivers/pnp/driver.c
> @@ -182,7 +182,7 @@ static int __pnp_bus_suspend(struct device *dev, pm_message_t state)
>  			return error;
>  	}
>  
> -	if (pnp_dev->protocol->suspend)
> +	if (pnp_can_suspend(pnp_dev))
>  		pnp_dev->protocol->suspend(pnp_dev, state);
>  	return 0;
>  }
> diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
> index d2b780a..115bb73 100644
> --- a/drivers/pnp/pnpacpi/core.c
> +++ b/drivers/pnp/pnpacpi/core.c
> @@ -253,7 +253,7 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
>  	dev->active = device->status.enabled;
>  	if (acpi_has_method(device->handle, "_SRS"))
>  		dev->capabilities |= PNP_CONFIGURABLE;
> -	dev->capabilities |= PNP_READ;
> +	dev->capabilities |= PNP_READ | PNP_SUSPEND;
>  	if (device->flags.dynamic_status && (dev->capabilities & PNP_CONFIGURABLE))
>  		dev->capabilities |= PNP_WRITE;
>  	if (device->flags.removable)
> diff --git a/include/linux/pnp.h b/include/linux/pnp.h
> index 195aafc..5a5cbc2 100644
> --- a/include/linux/pnp.h
> +++ b/include/linux/pnp.h
> @@ -309,6 +309,7 @@ struct pnp_fixup {
>  #define PNP_DISABLE		0x0004
>  #define PNP_CONFIGURABLE	0x0008
>  #define PNP_REMOVABLE		0x0010
> +#define PNP_SUSPEND		0x0020
>  
>  #define pnp_can_read(dev)	(((dev)->protocol->get) && \
>  				 ((dev)->capabilities & PNP_READ))
> @@ -318,6 +319,8 @@ struct pnp_fixup {
>  				 ((dev)->capabilities & PNP_DISABLE))
>  #define pnp_can_configure(dev)	((!(dev)->active) && \
>  				 ((dev)->capabilities & PNP_CONFIGURABLE))
> +#define pnp_can_suspend(dev)	(((dev)->protocol->suspend) && \
> +				 ((dev)->capabilities & PNP_SUSPEND))
>  
>  #ifdef CONFIG_ISAPNP
>  extern struct pnp_protocol isapnp_protocol;
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
