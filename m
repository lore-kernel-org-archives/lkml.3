Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbbAUA1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:27:55 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56881 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752053AbbAUA1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:27:54 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [RFC Patch 14/19] ACPI: Translate resource into master side address for bridge window resources
Date: Wed, 21 Jan 2015 01:50:30 +0100
Message-ID: <2697984.BuF6Nq9EvE@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420684386-5975-15-git-send-email-jiang.liu@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1420684386-5975-15-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 08, 2015 10:33:01 AM Jiang Liu wrote:
> Add translation_offset into the result address for bridge window
> resources to form the master side address.
> 
> Currently acpi_dev_resource_{ext_}address_space() are only used for
> devices instead of bridges, so it won't break current users. Later
> it will be used to support PCI host bridge drivers.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/acpi/resource.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index d3aa56674bd4..16d334a1ee25 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -203,6 +203,20 @@ static bool acpi_decode_space(struct resource *res, resource_size_t *offset,
>  	res->start = addr->minimum;
>  	res->end = addr->maximum;
>  
> +	/*
> +	 * For bridges that translate addresses across the bridge,
> +	 * translation_offset is the offset that must be added to the
> +	 * address on the secondary side to obtain the address on the
> +	 * primary side. Non-bridge devices must list 0 for all Address
> +	 * Translation offset bits.
> +	 */
> +	if (base->producer_consumer == ACPI_PRODUCER) {

OK, so the assumption is that this check is never true in the current code, right?

> +		res->start += addr->translation_offset;
> +		res->end += addr->translation_offset;
> +	} else if (addr->translation_offset) {

And won't this break anything even if so?

> +		return false;
> +	}
> +
>  	switch(base->resource_type) {
>  	case ACPI_MEMORY_RANGE:
>  		acpi_dev_memresource_flags(res, len, wp);
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
