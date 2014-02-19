Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaBSRii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:38:38 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20096 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaBSRig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:38:36 -0500
Date: Wed, 19 Feb 2014 12:38:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [Patch v2 3/5] xen, acpi_pad: use acpi_evaluate_ost() to replace
 open-coded version
Message-ID: <20140219173822.GF11365@phenom.dumpdata.com>
References: <1392789739-32317-1-git-send-email-jiang.liu@linux.intel.com>
 <1392789739-32317-3-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392789739-32317-3-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 02:02:17PM +0800, Jiang Liu wrote:
> Use public function acpi_evaluate_ost() to replace open-coded
> version of evaluating ACPI _OST method.
> 

Looks OK to me.

> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/xen/xen-acpi-pad.c |   26 +++++++-------------------
>  1 file changed, 7 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/xen/xen-acpi-pad.c b/drivers/xen/xen-acpi-pad.c
> index 40c4bc0..f83b754 100644
> --- a/drivers/xen/xen-acpi-pad.c
> +++ b/drivers/xen/xen-acpi-pad.c
> @@ -77,27 +77,14 @@ static int acpi_pad_pur(acpi_handle handle)
>  	return num;
>  }
>  
> -/* Notify firmware how many CPUs are idle */
> -static void acpi_pad_ost(acpi_handle handle, int stat,
> -	uint32_t idle_nums)
> -{
> -	union acpi_object params[3] = {
> -		{.type = ACPI_TYPE_INTEGER,},
> -		{.type = ACPI_TYPE_INTEGER,},
> -		{.type = ACPI_TYPE_BUFFER,},
> -	};
> -	struct acpi_object_list arg_list = {3, params};
> -
> -	params[0].integer.value = ACPI_PROCESSOR_AGGREGATOR_NOTIFY;
> -	params[1].integer.value =  stat;
> -	params[2].buffer.length = 4;
> -	params[2].buffer.pointer = (void *)&idle_nums;
> -	acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
> -}
> -
>  static void acpi_pad_handle_notify(acpi_handle handle)
>  {
>  	int idle_nums;
> +	struct acpi_buffer param = {
> +		.length = 4,
> +		.pointer = (void *)&idle_nums,
> +	};
> +
>  
>  	mutex_lock(&xen_cpu_lock);
>  	idle_nums = acpi_pad_pur(handle);
> @@ -109,7 +96,8 @@ static void acpi_pad_handle_notify(acpi_handle handle)
>  	idle_nums = xen_acpi_pad_idle_cpus(idle_nums)
>  		    ?: xen_acpi_pad_idle_cpus_num();
>  	if (idle_nums >= 0)
> -		acpi_pad_ost(handle, 0, idle_nums);
> +		acpi_evaluate_ost(handle, ACPI_PROCESSOR_AGGREGATOR_NOTIFY,
> +				  0, &param);
>  	mutex_unlock(&xen_cpu_lock);
>  }
>  
> -- 
> 1.7.10.4
> 
