Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab3DXVhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 17:37:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758191Ab3DXVhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 17:37:16 -0400
Date: Wed, 24 Apr 2013 14:37:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Andre van Herk <andre.van.herk@Prodrive.nl>,
        Micha Nelissen <micha.nelissen@Prodrive.nl>
Subject: Re: [PATCH 1/3] rapidio: make enumeration/discovery configurable
Message-Id: <20130424143714.4911405aa979bff27887765a@linux-foundation.org>
In-Reply-To: <1366813919-13766-2-git-send-email-alexandre.bounine@idt.com>
References: <1366813919-13766-1-git-send-email-alexandre.bounine@idt.com>
	<1366813919-13766-2-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013 10:31:57 -0400 Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> Rework to implement RapidIO enumeration/discovery method selection
> combined with ability to use enumeration/discovery as a kernel module.
> 
> This patch adds ability to introduce new RapidIO enumeration/discovery methods
> using kernel configuration options or loadable modules. Configuration option
> mechanism allows to select built-in or modular enumeration/discovery method from
> the list of existing methods or use external modules.
> If a modular enumeration/discovery is selected each RapidIO mport device can
> have its own method attached to it.
> 
> The currently existing enumeration/discovery code was updated to be used
> as built-in or modular method. This configuration option is named "Basic
> enumeration/discovery" method.
> 
> Several common routines have been moved from rio-scan.c to make them available
> to other enumeration methods and reduce number of exported symbols.
> 
> ...
>
> @@ -1421,3 +1295,46 @@ enum_done:
>  bail:
>  	return -EBUSY;
>  }
> +
> +struct rio_scan rio_scan_ops = {
> +	.enumerate = rio_enum_mport,
> +	.discover = rio_disc_mport,
> +};
> +
> +
> +#ifdef MODULE

Why the `ifdef MODULE'?  The module parameters are still accessible if
the driver is statically linked and we do want the driver to behave in
the same way regardless of how it was linked and loaded.

> +static bool scan;
> +module_param(scan, bool, 0);
> +MODULE_PARM_DESC(scan, "Start RapidIO network enumeration/discovery "
> +			"(default = 1)");
> +
> +/**
> + * rio_basic_attach:
> + *
> + * When this enumeration/discovery method is loaded as a module this function
> + * registers its specific enumeration and discover routines for all available
> + * RapidIO mport devices. The "scan" command line parameter controls ability of
> + * the module to start RapidIO enumeration/discovery automatically.
> + *
> + * Returns 0 for success or -EIO if unable to register itself.
> + *
> + * This enumeration/discovery method cannot be unloaded and therefore does not
> + * provide a matching cleanup_module routine.
> + */
> +
> +int __init rio_basic_attach(void)

static

> +{
> +	if (rio_register_scan(RIO_MPORT_ANY, &rio_scan_ops))
> +		return -EIO;
> +	if (scan)
> +		rio_init_mports();
> +	return 0;
> +}
> +
> +module_init(rio_basic_attach);
> +
> +MODULE_DESCRIPTION("Basic RapidIO enumeration/discovery");
> +MODULE_LICENSE("GPL");
> +
> +#endif /* MODULE */
> diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
> index d553b5d..e36628a 100644
> --- a/drivers/rapidio/rio.c
> +++ b/drivers/rapidio/rio.c
> @@ -31,6 +31,9 @@
>  
>  #include "rio.h"
>  
> +LIST_HEAD(rio_devices);

static?

> +DEFINE_SPINLOCK(rio_global_list_lock);

static?

> +
>  static LIST_HEAD(rio_mports);
>  static unsigned char next_portid;
>  static DEFINE_SPINLOCK(rio_mmap_lock);
> 
> ...
>
> +/**
> + * rio_switch_init - Sets switch operations for a particular vendor switch
> + * @rdev: RIO device
> + * @do_enum: Enumeration/Discovery mode flag
> + *
> + * Searches the RIO switch ops table for known switch types. If the vid
> + * and did match a switch table entry, then call switch initialization
> + * routine to setup switch-specific routines.
> + */
> +void rio_switch_init(struct rio_dev *rdev, int do_enum)
> +{
> +	struct rio_switch_ops *cur = __start_rio_switch_ops;
> +	struct rio_switch_ops *end = __end_rio_switch_ops;

huh, I hadn't noticed that RIO has its very own vmlinux section.  How
peculair.

> +	while (cur < end) {
> +		if ((cur->vid == rdev->vid) && (cur->did == rdev->did)) {
> +			pr_debug("RIO: calling init routine for %s\n",
> +				 rio_name(rdev));
> +			cur->init_hook(rdev, do_enum);
> +			break;
> +		}
> +		cur++;
> +	}
> +
> +	if ((cur >= end) && (rdev->pef & RIO_PEF_STD_RT)) {
> +		pr_debug("RIO: adding STD routing ops for %s\n",
> +			rio_name(rdev));
> +		rdev->rswitch->add_entry = rio_std_route_add_entry;
> +		rdev->rswitch->get_entry = rio_std_route_get_entry;
> +		rdev->rswitch->clr_table = rio_std_route_clr_table;
> +	}
> +
> +	if (!rdev->rswitch->add_entry || !rdev->rswitch->get_entry)
> +		printk(KERN_ERR "RIO: missing routing ops for %s\n",
> +		       rio_name(rdev));
> +}
> +EXPORT_SYMBOL_GPL(rio_switch_init);
> 
> ...
>
> +int rio_register_scan(int mport_id, struct rio_scan *scan_ops)
> +{
> +	struct rio_mport *port;
> +	int rc = -EBUSY;
> +
> +	list_for_each_entry(port, &rio_mports, node) {

How come the driver has no locking for rio_mports?  If a bugfix isn't
needed here then a code comment is!

> +		if (port->id == mport_id || mport_id == RIO_MPORT_ANY) {
> +			if (port->nscan && mport_id == RIO_MPORT_ANY)
> +				continue;
> +			else if (port->nscan)
> +				break;
> +
> +			port->nscan = scan_ops;
> +			rc = 0;
> +
> +			if (mport_id != RIO_MPORT_ANY)
> +				break;
> +		}
> +	}
> +
> +	return rc;
> +}
> 
> ...
>

