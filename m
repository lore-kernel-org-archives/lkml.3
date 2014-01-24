Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaAXQ3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:29:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:27199 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbaAXQ3U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:29:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,713,1384329600"; 
   d="scan'208";a="464208434"
From: "Moore, Robert" <robert.moore@intel.com>
To: Hanjun Guo <hanjun.guo@linaro.org>, "Zheng, Lv" <lv.zheng@intel.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: RE: [PATCH 1/2] ACPI / ACPICA: refactor acpi_evaluate_object() to
 reduce nesting if
Thread-Topic: [PATCH 1/2] ACPI / ACPICA: refactor acpi_evaluate_object() to
 reduce nesting if
Thread-Index: AQHPGSBAj1rtlmnthkC27noEzMvSIJqUEJfg
Date: Fri, 24 Jan 2014 16:29:19 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E37C7D13E4@ORSMSX103.amr.corp.intel.com>
References: <1390580407-14525-1-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1390580407-14525-1-git-send-email-hanjun.guo@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please file a bugzilla on this at:

https://bugs.acpica.org/

thanks.
Bob


> -----Original Message-----
> From: Hanjun Guo [mailto:hanjun.guo@linaro.org]
> Sent: Friday, January 24, 2014 8:20 AM
> To: Zheng, Lv; Moore, Robert
> Cc: Rafael J. Wysocki; linux-acpi@vger.kernel.org; devel@acpica.org;
> patches@linaro.org; linux-kernel@vger.kernel.org; linaro-
> acpi@lists.linaro.org; Hanjun Guo
> Subject: [PATCH 1/2] ACPI / ACPICA: refactor acpi_evaluate_object() to
> reduce nesting if
> 
> acpi_evaluate_object() has nesting if judgement to make code a little bit
> complicated, refactor it to make things simple.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  drivers/acpi/acpica/nsxfeval.c |  104 +++++++++++++++++++----------------
> -----
>  1 file changed, 50 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/nsxfeval.c
> b/drivers/acpi/acpica/nsxfeval.c index 1f0c28b..a1b0b88 100644
> --- a/drivers/acpi/acpica/nsxfeval.c
> +++ b/drivers/acpi/acpica/nsxfeval.c
> @@ -370,68 +370,64 @@ acpi_evaluate_object(acpi_handle handle,
>  	 * If we are expecting a return value, and all went well above,
>  	 * copy the return value to an external object.
>  	 */
> -	if (return_buffer) {
> -		if (!info->return_object) {
> -			return_buffer->length = 0;
> -		} else {
> -			if (ACPI_GET_DESCRIPTOR_TYPE(info->return_object) ==
> -			    ACPI_DESC_TYPE_NAMED) {
> -				/*
> -				 * If we received a NS Node as a return object,
> this means that
> -				 * the object we are evaluating has nothing
> interesting to
> -				 * return (such as a mutex, etc.)  We return an
> error because
> -				 * these types are essentially unsupported by this
> interface.
> -				 * We don't check up front because this makes it
> easier to add
> -				 * support for various types at a later date if
> necessary.
> -				 */
> -				status = AE_TYPE;
> -				info->return_object = NULL;	/* No need to delete
> a NS Node */
> -				return_buffer->length = 0;
> -			}
> +	if (!return_buffer)
> +		goto out;
> 
> -			if (ACPI_SUCCESS(status)) {
> +	if (!info->return_object) {
> +		return_buffer->length = 0;
> +		goto out;
> +	}
> 
> -				/* Dereference Index and ref_of references */
> +	if (ACPI_GET_DESCRIPTOR_TYPE(info->return_object) ==
> +		ACPI_DESC_TYPE_NAMED) {
> +		/*
> +		 * If we received a NS Node as a return object, this means
> that
> +		 * the object we are evaluating has nothing interesting to
> +		 * return (such as a mutex, etc.)  We return an error because
> +		 * these types are essentially unsupported by this interface.
> +		 * We don't check up front because this makes it easier to add
> +		 * support for various types at a later date if necessary.
> +		 */
> +		status = AE_TYPE;
> +		info->return_object = NULL;	/* No need to delete a NS Node
> */
> +		return_buffer->length = 0;
> +	}
> 
> -				acpi_ns_resolve_references(info);
> +	if (ACPI_FAILURE(status))
> +		goto out;
> 
> -				/* Get the size of the returned object */
> +	/* Dereference Index and ref_of references */
> 
> -				status =
> -				    acpi_ut_get_object_size(info->return_object,
> -							    &buffer_space_needed);
> -				if (ACPI_SUCCESS(status)) {
> -
> -					/* Validate/Allocate/Clear caller buffer */
> -
> -					status =
> -					    acpi_ut_initialize_buffer
> -					    (return_buffer,
> -					     buffer_space_needed);
> -					if (ACPI_FAILURE(status)) {
> -						/*
> -						 * Caller's buffer is too small or a
> new one can't
> -						 * be allocated
> -						 */
> -						ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> -								  "Needed buffer size %X,
> %s\n",
> -								  (u32)
> -								  buffer_space_needed,
> -								  acpi_format_exception
> -								  (status)));
> -					} else {
> -						/* We have enough space for the
> object, build it */
> -
> -						status =
> -						    acpi_ut_copy_iobject_to_eobject
> -						    (info->return_object,
> -						     return_buffer);
> -					}
> -				}
> -			}
> +	acpi_ns_resolve_references(info);
> +
> +	/* Get the size of the returned object */
> +
> +	status = acpi_ut_get_object_size(info->return_object,
> +						&buffer_space_needed);
> +	if (ACPI_SUCCESS(status)) {
> +
> +		/* Validate/Allocate/Clear caller buffer */
> +
> +		status = acpi_ut_initialize_buffer(return_buffer,
> +							buffer_space_needed);
> +		if (ACPI_FAILURE(status)) {
> +			/*
> +			 * Caller's buffer is too small or a new one can't
> +			 * be allocated
> +			 */
> +			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
> +					"Needed buffer size %X, %s\n",
> +					(u32)buffer_space_needed,
> +					 acpi_format_exception(status)));
> +		} else {
> +			/* We have enough space for the object, build it */
> +
> +			status = acpi_ut_copy_iobject_to_eobject(
> +					info->return_object, return_buffer);
>  		}
>  	}
> 
> +out:
>  	if (info->return_object) {
>  		/*
>  		 * Delete the internal return object. NOTE: Interpreter must
> be
> --
> 1.7.9.5

