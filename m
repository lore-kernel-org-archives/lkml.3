Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761744Ab3BON0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:26:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:29522 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab3BON0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 08:26:36 -0500
Date: Fri, 15 Feb 2013 08:26:24 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liu Jinsong <jinsong.liu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: build failure after merge of the xen-two tree
Message-ID: <20130215132624.GB11777@phenom.dumpdata.com>
References: <20130215154551.d11e9d376d30d32b9673e6cc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130215154551.d11e9d376d30d32b9673e6cc@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2013 at 03:45:51PM +1100, Stephen Rothwell wrote:
> Hi Konrad,
> 
> After merging the xen-two tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

Good morning!
> 
> drivers/xen/xen-acpi-memhotplug.c: In function 'acpi_memory_get_device':
> drivers/xen/xen-acpi-memhotplug.c:191:2: error: implicit declaration of function 'acpi_bus_add' [-Werror=implicit-function-declaration]
> drivers/xen/xen-acpi-memhotplug.c: At top level:
> drivers/xen/xen-acpi-memhotplug.c:417:3: warning: initialization from incompatible pointer type [enabled by default]
> drivers/xen/xen-acpi-memhotplug.c:417:3: warning: (near initialization for 'xen_acpi_memory_device_driver.ops.remove') [enabled by default]
> 
> Caused by commit 259f201cb7ea ("xen/acpi: ACPI memory hotplug").
> 
> drivers/xen/xen-acpi-cpuhotplug.c: In function 'acpi_processor_device_add':
> drivers/xen/xen-acpi-cpuhotplug.c:254:2: error: implicit declaration of function 'acpi_bus_add' [-Werror=implicit-function-declaration]
> drivers/xen/xen-acpi-cpuhotplug.c: At top level:
> drivers/xen/xen-acpi-cpuhotplug.c:425:3: warning: initialization from incompatible pointer type [enabled by default]
> drivers/xen/xen-acpi-cpuhotplug.c:425:3: warning: (near initialization for 'xen_acpi_processor_driver.ops.remove') [enabled by default]
> 
> Caused by commit 181232c249f0 ("xen/acpi: ACPI cpu hotplug").

Grrrreat! Jinsong, can you please fix that ? A patch on top of the #linux-next
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

> 
> These commits interacted with commits 636458de36f1 ("ACPI: Remove the
> arguments of acpi_bus_add() that are not used"), 0cd6ac52b333 ("ACPI:
> Make acpi_bus_scan() and acpi_bus_add() take only one argument") and
> b8bd759acd05 ("ACPI / scan: Drop acpi_bus_add() and use acpi_bus_scan()
> instead") from the pm tree.
> 
> I have added this merge fix patch and can carry it as necessary (I did
> *not* fix the warnings above):

<nods>
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 15 Feb 2013 15:37:27 +1100
> Subject: [PATCH] xen/acpi: fix up for apci_bus_add api change

Thank you. I keep on forgetting - but would it be OK for me to take this
patch in my tree? Or should I not since this is a new functionality that
Rafael is going to introduce in v3.9?

And if so, perhaps I should tack it on in my tree, once Rafael does a git
pull to Linus? Or just point Linus to this git commit?

BTW, I really appreciate the work you are doing to keep sync of different
trees and bubbling this up before the merge window opens.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/xen/xen-acpi-cpuhotplug.c | 2 +-
>  drivers/xen/xen-acpi-memhotplug.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/xen-acpi-cpuhotplug.c b/drivers/xen/xen-acpi-cpuhotplug.c
> index 9eefbb0..0db4722 100644
> --- a/drivers/xen/xen-acpi-cpuhotplug.c
> +++ b/drivers/xen/xen-acpi-cpuhotplug.c
> @@ -251,7 +251,7 @@ int acpi_processor_device_add(acpi_handle handle, struct acpi_device **device)
>  	if (acpi_bus_get_device(phandle, &pdev))
>  		return -ENODEV;
>  
> -	if (acpi_bus_add(device, pdev, handle, ACPI_BUS_TYPE_PROCESSOR))
> +	if (acpi_bus_scan(handle))
>  		return -ENODEV;
>  
>  	return 0;
> diff --git a/drivers/xen/xen-acpi-memhotplug.c b/drivers/xen/xen-acpi-memhotplug.c
> index 678680c..164287b 100644
> --- a/drivers/xen/xen-acpi-memhotplug.c
> +++ b/drivers/xen/xen-acpi-memhotplug.c
> @@ -188,7 +188,7 @@ acpi_memory_get_device(acpi_handle handle,
>  	 * Now add the notified device.  This creates the acpi_device
>  	 * and invokes .add function
>  	 */
> -	result = acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE);
> +	result = acpi_bus_scan(handle);
>  	if (result) {
>  		pr_warn(PREFIX "Cannot add acpi bus\n");
>  		return -EINVAL;
> -- 
> 1.8.1
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


