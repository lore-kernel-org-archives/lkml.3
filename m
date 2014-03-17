Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037AbaCQMJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:09:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:1990 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932767AbaCQMJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:09:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,669,1389772800"; 
   d="scan'208";a="501497250"
Message-ID: <5326E5E8.4070804@intel.com>
Date: Mon, 17 Mar 2014 13:09:12 +0100
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lv Zheng <lv.zheng@intel.com>
CC: Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] ACPI: Default disable auto-serialization.
References: <14866.1394813101@turing-police.cc.vt.edu> <cover.1395028738.git.lv.zheng@intel.com> <fdc47fb7d89d984a164531b316e8b56f73ed05c9.1395028738.git.lv.zheng@intel.com>
In-Reply-To: <fdc47fb7d89d984a164531b316e8b56f73ed05c9.1395028738.git.lv.zheng@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/17/2014 5:14 AM, Lv Zheng wrote:
> This feature enabled by the following commit is still under development.
>
>    Commit: cd52379678785b02d7a357988cfba214fdaf92f4
>    Subject: ACPICA: Add global option to disable method auto-serialization.
>    This change adds an option to disable the auto-serialization of
>    methods that create named objects.
>
> This patch disables it by default temporarily according to the bug reports.

Well, it doesn't restore the 3.14 behavior of acpi_auto_serialize, as 
far as I can say, so we can't apply it.

I still can drop the commits related to auto-serialization from my 
acpica branch.  Which commits are they?

> References: http://www.spinics.net/lists/linux-acpi/msg49496.html
> Reported-by: Valdis Kletnieks <validis.kletnieks@vt.edu>
> Reported-by: Sabrina Dubroka <sd@queasysnail.net>
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> ---
>   Documentation/kernel-parameters.txt |    8 ++++----
>   drivers/acpi/acpica/acglobal.h      |    2 +-
>   drivers/acpi/osl.c                  |   12 ++++++------
>   3 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 91f0be8..a159537 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -229,13 +229,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>   			use by PCI
>   			Format: <irq>,<irq>...
>   
> -	acpi_no_auto_serialize	[HW,ACPI]
> -			Disable auto-serialization of AML methods
> +	acpi_auto_serialize	[HW,ACPI]
> +			Enable auto-serialization of AML methods
>   			AML control methods that contain the opcodes to create
>   			named objects will be marked as "Serialized" by the
>   			auto-serialization feature.
> -			This feature is enabled by default.
> -			This option allows to turn off the feature.
> +			This feature is disabled by default.
> +			This option allows to turn on the feature.
>   
>   	acpi_no_auto_ssdt	[HW,ACPI] Disable automatic loading of SSDT
>   
> diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
> index 49bbc71..ea0f838 100644
> --- a/drivers/acpi/acpica/acglobal.h
> +++ b/drivers/acpi/acpica/acglobal.h
> @@ -99,7 +99,7 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_enable_interpreter_slack, FALSE);
>    * that create named objects are marked Serialized in order to prevent
>    * possible run-time problems if they are entered by more than one thread.
>    */
> -ACPI_INIT_GLOBAL(u8, acpi_gbl_auto_serialize_methods, TRUE);
> +ACPI_INIT_GLOBAL(u8, acpi_gbl_auto_serialize_methods, FALSE);
>   
>   /*
>    * Create the predefined _OSI method in the namespace? Default is TRUE
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index d40d6dc..928f0c2 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -1538,20 +1538,20 @@ static int __init osi_setup(char *str)
>   __setup("acpi_osi=", osi_setup);
>   
>   /*
> - * Disable the auto-serialization of named objects creation methods.
> + * Enable the auto-serialization of named objects creation methods.
>    *
> - * This feature is enabled by default.  It marks the AML control methods
> + * This feature is disabled by default.  It marks the AML control methods
>    * that contain the opcodes to create named objects as "Serialized".
>    */
> -static int __init acpi_no_auto_serialize_setup(char *str)
> +static int __init acpi_auto_serialize_setup(char *str)
>   {
> -	acpi_gbl_auto_serialize_methods = FALSE;
> -	pr_info("ACPI: auto-serialization disabled\n");
> +	acpi_gbl_auto_serialize_methods = TRUE;
> +	pr_info("ACPI: auto-serialization enabled\n");
>   
>   	return 1;
>   }
>   
> -__setup("acpi_no_auto_serialize", acpi_no_auto_serialize_setup);
> +__setup("acpi_auto_serialize", acpi_auto_serialize_setup);
>   
>   /* Check of resource interference between native drivers and ACPI
>    * OperationRegions (SystemIO and System Memory only).

