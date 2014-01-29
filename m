Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbaA2FZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 00:25:00 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54131 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaA2FY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 00:24:59 -0500
Date: Tue, 28 Jan 2014 21:24:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Stanislaw Gruszka <sgruszka@redhat.com>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, Ben Guthro <benjamin.guthro@citrix.com>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        xen-devel@lists.xensource.com
Subject: Re: [BUG?] Interrupts enabled after xen_acpi_processor_resume+0x0/0x34
 [xen_acpi_processor]
In-Reply-To: <20140128160404.GA5732@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1401282120180.20167@chino.kir.corp.google.com>
References: <20140128150848.GA1428@redhat.com> <20140128160404.GA5732@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Konrad Rzeszutek Wilk wrote:

> diff --git a/drivers/xen/xen-acpi-processor.c b/drivers/xen/xen-acpi-processor.c
> index 7231859..7602229 100644
> --- a/drivers/xen/xen-acpi-processor.c
> +++ b/drivers/xen/xen-acpi-processor.c
> @@ -46,7 +46,7 @@ module_param_named(off, no_hypercall, int, 0400);
>   */
>  static unsigned int nr_acpi_bits;
>  /* Mutex to protect the acpi_ids_done - for CPU hotplug use. */
> -static DEFINE_MUTEX(acpi_ids_mutex);
> +static DEFINE_SPINLOCK(acpi_ids_lock);
>  /* Which ACPI ID we have processed from 'struct acpi_processor'. */
>  static unsigned long *acpi_ids_done;
>  /* Which ACPI ID exist in the SSDT/DSDT processor definitions. */
> @@ -68,7 +68,7 @@ static int push_cxx_to_hypervisor(struct acpi_processor *_pr)
>  	int ret = 0;
>  
>  	dst_cx_states = kcalloc(_pr->power.count,
> -				sizeof(struct xen_processor_cx), GFP_KERNEL);
> +				sizeof(struct xen_processor_cx), GFP_ATOMIC);
>  	if (!dst_cx_states)
>  		return -ENOMEM;
>  
> @@ -149,7 +149,7 @@ xen_copy_pss_data(struct acpi_processor *_pr,
>  		     sizeof(struct acpi_processor_px));
>  
>  	dst_states = kcalloc(_pr->performance->state_count,
> -			     sizeof(struct xen_processor_px), GFP_KERNEL);
> +			     sizeof(struct xen_processor_px), GFP_ATOMIC);
>  	if (!dst_states)
>  		return ERR_PTR(-ENOMEM);
>  
> @@ -275,9 +275,9 @@ static int upload_pm_data(struct acpi_processor *_pr)
>  {
>  	int err = 0;
>  
> -	mutex_lock(&acpi_ids_mutex);
> +	spin_lock(&acpi_ids_lock);
>  	if (__test_and_set_bit(_pr->acpi_id, acpi_ids_done)) {
> -		mutex_unlock(&acpi_ids_mutex);
> +		spin_unlock(&acpi_ids_lock);
>  		return -EBUSY;
>  	}
>  	if (_pr->flags.power)
> @@ -286,7 +286,7 @@ static int upload_pm_data(struct acpi_processor *_pr)
>  	if (_pr->performance && _pr->performance->states)
>  		err |= push_pxx_to_hypervisor(_pr);
>  
> -	mutex_unlock(&acpi_ids_mutex);
> +	spin_unlock(&acpi_ids_lock);
>  	return err;
>  }
>  static unsigned int __init get_max_acpi_id(void)

Looks incomplete, what about the kzalloc() in 
xen_upload_processor_pm_data() and kcalloc()s in check_acpi_ids()?
