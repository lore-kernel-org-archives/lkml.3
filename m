Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaFEMlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:41:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51294 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751015AbaFEMlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:41:07 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: lenb@kernel.org, Randy Wright <rwright@hp.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Fix bug when acpi reset register is implemented in system memory
Date: Thu, 05 Jun 2014 14:58:22 +0200
Message-ID: <7970700.XBb1Ob3tCb@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1401897359-28873-1-git-send-email-david.e.box@linux.intel.com>
References: <1401897359-28873-1-git-send-email-david.e.box@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 04, 2014 08:55:59 AM David E. Box wrote:
> From: Randy Wright <rwright@hp.com>
> 
> Use acpi_os_map_generic_address to pre-map the reset register if it is memory
> mapped, thereby preventing https://bugzilla.kernel.org/show_bug.cgi?id=77131
> 
> Signed-off-by: Randy Wright <rwright@hp.com>
> Signed-off-by: David E. Box <david.e.box@linux.intel.com>

Applied with minor changes, thanks!.

Please check the bleeding-edge branch of the linux-pm.git tree.

Rafael


> ---
>  drivers/acpi/osl.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 6776c59..5325844 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -1798,6 +1798,19 @@ acpi_status __init acpi_os_initialize(void)
>  	acpi_os_map_generic_address(&acpi_gbl_FADT.xpm1b_event_block);
>  	acpi_os_map_generic_address(&acpi_gbl_FADT.xgpe0_block);
>  	acpi_os_map_generic_address(&acpi_gbl_FADT.xgpe1_block);
> +	if (acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER) {
> +		/*
> +		 * Use acpi_os_map_generic_address to pre-map the reset
> +		 * register if it's in system memory, thereby preventing
> +		 * https://bugzilla.kernel.org/show_bug.cgi?id=77131
> +		 */
> +		int rv;
> +		struct acpi_generic_address *reset_reg
> +			= &acpi_gbl_FADT.reset_register;
> +		rv = acpi_os_map_generic_address(reset_reg);
> +		pr_info(PREFIX
> +			"%s: map reset_reg status %d\n", __func__, rv);
> +	}
>  
>  	return AE_OK;
>  }
> @@ -1826,6 +1839,8 @@ acpi_status acpi_os_terminate(void)
>  	acpi_os_unmap_generic_address(&acpi_gbl_FADT.xgpe0_block);
>  	acpi_os_unmap_generic_address(&acpi_gbl_FADT.xpm1b_event_block);
>  	acpi_os_unmap_generic_address(&acpi_gbl_FADT.xpm1a_event_block);
> +	if (acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER)
> +		acpi_os_unmap_generic_address(&acpi_gbl_FADT.reset_register);
>  
>  	destroy_workqueue(kacpid_wq);
>  	destroy_workqueue(kacpi_notify_wq);
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
