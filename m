Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaBRAwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:52:46 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65114 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751547AbaBRAwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:52:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        Tony Luck <tony.luck@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch v1 3/6] acpi_pad: use acpi_evaluate_pad() to replace open-coded version
Date: Tue, 18 Feb 2014 02:07:33 +0100
Message-ID: <2178847.Vaot4mm02Q@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392613373-11003-3-git-send-email-jiang.liu@linux.intel.com>
References: <1392613271-10912-1-git-send-email-jiang.liu@linux.intel.com> <1392613373-11003-1-git-send-email-jiang.liu@linux.intel.com> <1392613373-11003-3-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 17, 2014 01:02:50 PM Jiang Liu wrote:
> Use public function acpi_evaluate_pad() to replace open-coded

I suppose you mean acpi_evaluate_ost()?  And in the other patches
in this series too?

> version of evaluating ACPI _OST method.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/acpi/acpi_pad.c |   24 +++++-------------------
>  1 file changed, 5 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
> index 1e3ce76..86b4e11 100644
> --- a/drivers/acpi/acpi_pad.c
> +++ b/drivers/acpi/acpi_pad.c
> @@ -408,28 +408,14 @@ static int acpi_pad_pur(acpi_handle handle)
>  	return num;
>  }
>  
> -/* Notify firmware how many CPUs are idle */
> -static void acpi_pad_ost(acpi_handle handle, int stat,
> -	uint32_t idle_cpus)
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
> -	params[2].buffer.pointer = (void *)&idle_cpus;
> -	acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
> -}
> -
>  static void acpi_pad_handle_notify(acpi_handle handle)
>  {
>  	int num_cpus;
>  	uint32_t idle_cpus;
> +	struct acpi_buffer param = {
> +		.length = 4,
> +		.pointer = (void *)&idle_cpus,
> +	};
>  
>  	mutex_lock(&isolated_cpus_lock);
>  	num_cpus = acpi_pad_pur(handle);
> @@ -439,7 +425,7 @@ static void acpi_pad_handle_notify(acpi_handle handle)
>  	}
>  	acpi_pad_idle_cpus(num_cpus);
>  	idle_cpus = acpi_pad_idle_cpus_num();
> -	acpi_pad_ost(handle, 0, idle_cpus);
> +	acpi_evaluate_ost(handle, ACPI_PROCESSOR_AGGREGATOR_NOTIFY, 0, &param);
>  	mutex_unlock(&isolated_cpus_lock);
>  }
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
