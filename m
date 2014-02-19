Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbaBSPiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:38:52 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64171 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754360AbaBSPis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:38:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        Robert Moore <robert.moore@intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@acpica.org
Subject: Re: [RFC Patch v1 2/6] ACPI: rename acpi_evaluate_hotplug_ost to acpi_evaluate_ost for reuse
Date: Wed, 19 Feb 2014 16:53:39 +0100
Message-ID: <18853631.7tB2OTjZFf@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5304453F.1050104@linux.intel.com>
References: <1392613271-10912-1-git-send-email-jiang.liu@linux.intel.com> <6382282.2gCVKeUJUt@vostro.rjw.lan> <5304453F.1050104@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 19, 2014 01:46:39 PM Jiang Liu wrote:
> Hi Rafael,
> 	We have following code to deal with existing users.
> +#ifdef ACPI_HOTPLUG_OST
> +#define	acpi_evaluate_hotplug_ost	acpi_evaluate_ost

Well, I'd very much prefer the users to be updated.

> +#else
> +static inline acpi_status
>  acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
> -			u32 status_code, struct acpi_buffer *status_buf);
> +			u32 status_code, struct acpi_buffer *status_buf)
> +{ return AE_OK; }
> +#endif
> 
> Thanks!
> 
> On 2014/2/18 9:06, Rafael J. Wysocki wrote:
> > On Monday, February 17, 2014 01:02:49 PM Jiang Liu wrote:
> >> Rename acpi_evaluate_hotplug_ost() to acpi_evaluate_ost() for later resue.
> >>
> >> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> >> ---
> >>  drivers/acpi/utils.c    |   14 ++++----------
> >>  include/acpi/acpi_bus.h |   10 +++++++++-
> >>  2 files changed, 13 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
> >> index 85e3b61..19d0169 100644
> >> --- a/drivers/acpi/utils.c
> >> +++ b/drivers/acpi/utils.c
> >> @@ -433,17 +433,15 @@ EXPORT_SYMBOL(acpi_get_physical_device_location);
> >>   * When the platform does not support _OST, this function has no effect.
> >>   */
> >>  acpi_status
> >> -acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
> >> -		u32 status_code, struct acpi_buffer *status_buf)
> > 
> > There are users of this, what about updating them?
> > 
> >> +acpi_evaluate_ost(acpi_handle handle, u32 source_event, u32 status_code,
> >> +		  struct acpi_buffer *status_buf)
> >>  {
> >> -#ifdef ACPI_HOTPLUG_OST
> >>  	union acpi_object params[3] = {
> >>  		{.type = ACPI_TYPE_INTEGER,},
> >>  		{.type = ACPI_TYPE_INTEGER,},
> >>  		{.type = ACPI_TYPE_BUFFER,}
> >>  	};
> >>  	struct acpi_object_list arg_list = {3, params};
> >> -	acpi_status status;
> >>  
> >>  	params[0].integer.value = source_event;
> >>  	params[1].integer.value = status_code;
> >> @@ -455,13 +453,9 @@ acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
> >>  		params[2].buffer.length = 0;
> >>  	}
> >>  
> >> -	status = acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
> >> -	return status;
> >> -#else
> >> -	return AE_OK;
> >> -#endif
> >> +	return acpi_evaluate_object(handle, "_OST", &arg_list, NULL);
> >>  }
> >> -EXPORT_SYMBOL(acpi_evaluate_hotplug_ost);
> >> +EXPORT_SYMBOL(acpi_evaluate_ost);
> >>  
> >>  /**
> >>   * acpi_handle_printk: Print message with ACPI prefix and object path
> >> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> >> index 8256eb4..adef502 100644
> >> --- a/include/acpi/acpi_bus.h
> >> +++ b/include/acpi/acpi_bus.h
> >> @@ -49,8 +49,16 @@ acpi_evaluate_reference(acpi_handle handle,
> >>  			struct acpi_object_list *arguments,
> >>  			struct acpi_handle_list *list);
> >>  acpi_status
> >> +acpi_evaluate_ost(acpi_handle handle, u32 source_event, u32 status_code,
> >> +		  struct acpi_buffer *status_buf);
> >> +#ifdef ACPI_HOTPLUG_OST
> >> +#define	acpi_evaluate_hotplug_ost	acpi_evaluate_ost
> >> +#else
> >> +static inline acpi_status
> >>  acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
> >> -			u32 status_code, struct acpi_buffer *status_buf);
> >> +			u32 status_code, struct acpi_buffer *status_buf)
> >> +{ return AE_OK; }
> >> +#endif
> >>  
> >>  acpi_status
> >>  acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld_info **pld);
> >>
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
