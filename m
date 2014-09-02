Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbaIBVdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:33:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63756 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755153AbaIBVdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:33:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bob Moore <robert.moore@intel.com>
Subject: Re: [PATCH] ACPICA: ACPI 5.1: Add support for runtime validation of _DSD package.
Date: Tue, 02 Sep 2014 23:52:27 +0200
Message-ID: <1928853.GNCaIt2FMa@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <856f29de2607cab36bb3936fae26daa275e0b129.1409275857.git.lv.zheng@intel.com>
References: <856f29de2607cab36bb3936fae26daa275e0b129.1409275857.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 29, 2014 09:32:42 AM Lv Zheng wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Adds ACPICA kernel runtime support to validate contents/format
> of the _DSD package, similar to the iASL support. Ported by
> Mika Westerberg.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Bob Moore <robert.moore@intel.com>
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>

Queued up for 3.17-rc4, thanks!

> ---
>  drivers/acpi/acpica/nsprepkg.c |   39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/drivers/acpi/acpica/nsprepkg.c b/drivers/acpi/acpica/nsprepkg.c
> index 68f7258..1b13b92 100644
> --- a/drivers/acpi/acpica/nsprepkg.c
> +++ b/drivers/acpi/acpica/nsprepkg.c
> @@ -316,6 +316,45 @@ acpi_ns_check_package(struct acpi_evaluate_info *info,
>  		    acpi_ns_check_package_list(info, package, elements, count);
>  		break;
>  
> +	case ACPI_PTYPE2_UUID_PAIR:
> +
> +		/* The package must contain pairs of (UUID + type) */
> +
> +		if (count & 1) {
> +			expected_count = count + 1;
> +			goto package_too_small;
> +		}
> +
> +		while (count > 0) {
> +			status = acpi_ns_check_object_type(info, elements,
> +							   package->ret_info.
> +							   object_type1, 0);
> +			if (ACPI_FAILURE(status)) {
> +				return (status);
> +			}
> +
> +			/* Validate length of the UUID buffer */
> +
> +			if ((*elements)->buffer.length != 16) {
> +				ACPI_WARN_PREDEFINED((AE_INFO,
> +						      info->full_pathname,
> +						      info->node_flags,
> +						      "Invalid length for UUID Buffer"));
> +				return (AE_AML_OPERAND_VALUE);
> +			}
> +
> +			status = acpi_ns_check_object_type(info, elements + 1,
> +							   package->ret_info.
> +							   object_type2, 0);
> +			if (ACPI_FAILURE(status)) {
> +				return (status);
> +			}
> +
> +			elements += 2;
> +			count -= 2;
> +		}
> +		break;
> +
>  	default:
>  
>  		/* Should not get here if predefined info table is correct */
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
