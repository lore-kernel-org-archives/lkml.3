Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbaCFPnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:43:42 -0500
Received: from moutng.kundenserver.de ([212.227.126.131]:51742 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbaCFPnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:43:40 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v5 3/3] arm64: Add architecture support for PCI
Date: Tue, 4 Mar 2014 23:28:51 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-pci" <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>
References: <1393948216-11599-1-git-send-email-Liviu.Dudau@arm.com> <1393948216-11599-4-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1393948216-11599-4-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201403042328.51361.arnd@arndb.de>
X-Provags-ID: V02:K0:sF7g/UX4jt1DztSJSxVk2JuQztgPvnVSKJBrCjhOguz
 LnqsQrYaZk1avpZdhxdKfPnHLhUZ8SzOykveFwyGJGpwe5SXeN
 0ah/ta76VH4tGOr51cDY00Nk7E9xx5mqx2ubbq7G+xYhnrzo2J
 OZjU4ZTdWP7gzl5CRfrv7ZMffv8Dt7U7to4Rl4ZdM4Q8c6iI2s
 qMV29FUEQ0W558TFee9D15q083V3q8ct3GDqvEfJa8RXOcBJ7y
 kIv4u77lSgmbY88cjNinl+kxLr01G3n7c7C7V1Kd3G3zI7OhKQ
 7198KWLgqrOtQWq9AX9NjZJOUT5Zubz01BJe73QaB/jpCJgZ3K
 rOpNt/r/VZzwgPEsh4e8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2014, Liviu Dudau wrote:

> +extern int isa_dma_bridge_buggy;

As commented before, I still think we can hardcode this to off

> +unsigned long pci_address_to_pio(phys_addr_t address)
> +{
> +	struct ioresource *res;
> +
> +	list_for_each_entry(res, &io_list, list) {
> +		if (address >= res->start &&
> +			address < res->start + res->size) {
> +			return res->start - address;
> +		}
> +	}
> +
> +	return (unsigned long)-1;
> +}
> +EXPORT_SYMBOL_GPL(pci_address_to_pio);

This has two problems:

- You return the address in bus space not the logical Linux
  port number as powerpc and microblaze do.
- You imply that the window starts at bus address zero, which
  might not be the case.

> +EXPORT_SYMBOL(pcibios_fixup_bus);

no need for this export.

> +/*
> + * We don't have to worry about legacy ISA devices, so nothing to do here
> + */
> +resource_size_t pcibios_align_resource(void *data, const struct resource *res,
> +				resource_size_t size, resource_size_t align)
> +{
> +	return ALIGN(res->start, align);
> +}
> +EXPORT_SYMBOL(pcibios_align_resource);

or this one. Also, the ALIGN() is already done by the PCI core.

	Arnd
