Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab3E2Pnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:43:40 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:25951 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab3E2Pnh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:43:37 -0400
From: "Pearson, Greg" <greg.pearson@hp.com>
To: "Dall, Elizabeth J (MCLinux)" <betty.dall@hp.com>
CC: "rjw@sisk.pl" <rjw@sisk.pl>, "bhelgaas@google.com" <bhelgaas@google.com>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/3] ACPI/APEI: Force fatal AER severity when bus has
 been reset
Thread-Topic: [PATCH 2/3] ACPI/APEI: Force fatal AER severity when bus has
 been reset
Thread-Index: AQHOXIMdCBPKB68wd0Gyqc2+z2coIQ==
Date: Wed, 29 May 2013 15:42:24 +0000
Message-ID: <51A621E0.9030307@hp.com>
References: <1369766929-4386-1-git-send-email-betty.dall@hp.com>
 <1369766929-4386-3-git-send-email-betty.dall@hp.com>
In-Reply-To: <1369766929-4386-3-git-send-email-betty.dall@hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329
 Thunderbird/17.0.5
x-originating-ip: [16.210.16.251]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <036514CC7E0DBE4C88BCDE20B2302EB2@Compaq.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 12:48 PM, Betty Dall wrote:
> The CPER error record has a reset bit that indicates that the platform
> has reset the bus. The reset bit can be set for any severity error
> including recoverable.  From the AER code path's perspective,
> any error is fatal if the bus has been reset. This patch upgrades the
> severity of the AER recovery to AER_FATAL whenever the CPER error record
> indicates that the bus has been reset.
>
> Signed-off-by: Betty Dall <betty.dall@hp.com>
> ---
>
>   drivers/acpi/apei/ghes.c |   21 ++++++++++++++++++++-
>   1 files changed, 20 insertions(+), 1 deletions(-)
>
>
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index d668a8a..4a42afc 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -451,7 +451,26 @@ static void ghes_do_proc(struct ghes *ghes,
>   				int aer_severity;
>   				devfn = PCI_DEVFN(pcie_err->device_id.device,
>   						  pcie_err->device_id.function);
> -				aer_severity = cper_severity_to_aer(sev);
> +				/*
> +				 * Some Firmware First implementations
> +				 * put the device in SBR to contain
> +				 * the error. This is indicated by the
> +				 * CPER Section Decriptor Flags reset

Nit Pick, change "Decriptor" to "Descriptor".

--
Greg

> +				 * bit which means the component must
> +				 * be re-initialized or re-enabled
> +				 * prior to use. Promoting the AER
> +				 * serverity to FATAL will cause the
> +				 * AER code to link_reset and allow
> +				 * drivers to reprogram their cards.
> +				 */
> +				if (gdata->flags & CPER_SEC_RESET)
> +					aer_severity = cper_severity_to_aer(
> +							CPER_SEV_FATAL);
> +				else
> +					aer_severity =
> +						cper_severity_to_aer(sev);
> +
> +
>   				aer_recover_queue(pcie_err->device_id.segment,
>   						  pcie_err->device_id.bus,
>   						  devfn, aer_severity);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
