Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbbAUAJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:09:30 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53421 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751102AbbAUAJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:09:28 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>,
        Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        David Box <david.e.box@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: Re: [RFC Patch 05/19] ACPI: Provide union for address_space64 and ext_address_space64
Date: Wed, 21 Jan 2015 01:32:03 +0100
Message-ID: <1545690.MP6zq0KqoV@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420684386-5975-6-git-send-email-jiang.liu@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1420684386-5975-6-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 08, 2015 10:32:52 AM Jiang Liu wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> address_space64 and ext_address_space64 share substracts just at
> different offsets. To unify the parsing functions implement the two
> structs as unions of their substructs, so we can extract the shared
> data.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

This is ACPICA code, so if we change this, either we'll diverge from the
upstream (which is highly undesirable), or we'll have to change it for
the majority of OSes on the planet (all except Windows).

Lv, Bob, David, any comments here?

> ---
>  include/acpi/acrestyp.h |   49 ++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 36 insertions(+), 13 deletions(-)
> 
> diff --git a/include/acpi/acrestyp.h b/include/acpi/acrestyp.h
> index eb760ca0b2e0..307d5b2605c8 100644
> --- a/include/acpi/acrestyp.h
> +++ b/include/acpi/acrestyp.h
> @@ -326,23 +326,46 @@ struct acpi_resource_address32 {
>  	struct acpi_resource_source resource_source;
>  };
>  
> -struct acpi_resource_address64 {
> -	ACPI_RESOURCE_ADDRESS_COMMON u64 granularity;
> -	u64 minimum;
> -	u64 maximum;
> -	u64 translation_offset;
> +#define ACPI_RESOURCE_ADDRESS64_COMMON \
> +	u64 granularity;	       \
> +	u64 minimum;		       \
> +	u64 maximum;		       \
> +	u64 translation_offset;	       \
>  	u64 address_length;
> -	struct acpi_resource_source resource_source;
> +
> +struct acpi_resource_address64_common {
> +ACPI_RESOURCE_ADDRESS64_COMMON};
> +
> +struct acpi_resource_address64 {
> +	union {
> +		struct {
> +			ACPI_RESOURCE_ADDRESS_COMMON
> +			ACPI_RESOURCE_ADDRESS64_COMMON
> +			struct acpi_resource_source resource_source;
> +		};
> +		struct {
> +			struct acpi_resource_address base;
> +			struct acpi_resource_address64_common addr;
> +			struct acpi_resource_source resource_source;
> +		} common;
> +	};
>  };
>  
>  struct acpi_resource_extended_address64 {
> -	ACPI_RESOURCE_ADDRESS_COMMON u8 revision_ID;
> -	u64 granularity;
> -	u64 minimum;
> -	u64 maximum;
> -	u64 translation_offset;
> -	u64 address_length;
> -	u64 type_specific;
> +	union {
> +		struct {
> +			ACPI_RESOURCE_ADDRESS_COMMON
> +			u8 revision_ID;
> +			ACPI_RESOURCE_ADDRESS64_COMMON
> +			u64 type_specific;
> +		};
> +		struct {
> +			struct acpi_resource_address base;
> +			u8 revision_ID;
> +			struct acpi_resource_address64_common addr;
> +			u64 type_specific;
> +		} common;
> +	};
>  };
>  
>  struct acpi_resource_extended_irq {
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
