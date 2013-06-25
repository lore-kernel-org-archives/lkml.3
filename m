Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab3FYXnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:43:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55618 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab3FYXnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:43:04 -0400
Message-ID: <51CA2B03.4080106@wwwdotorg.org>
Date: Tue, 25 Jun 2013 17:42:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Leif Lindholm <leif.lindholm@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org, hpa@linux.intel.com, tglx@linutronix.de,
        matt.fleming@intel.com
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org> <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
In-Reply-To: <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 12:11 PM, Leif Lindholm wrote:
> This patch provides documentation of the [U]EFI runtime services and
> configuration features.


> diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt

> +The implementation depends on receiving pointers to the UEFI memory map
> +and System Table in a Flattened Device Tree - so is only available with
> +CONFIG_OF.
> +
> +It (early) parses the FDT for the following parameters:

Part of this document (the raw requirements for DT content, rather than
the discussion of OS implementation/behaviour in parsing/interpreting
the properties) should be part of a file in
Documentation/devicetree/bindings/ (arm/uefi.txt?).

What node are these properties expected to be contained within?

Shouldn't that node be required to contain a compatible value, which
would define the schema for the other properties?

> +- 'efi-system-table':
> +  Physical address of the system table. (required)
> +- 'efi-runtime-mmap':
> +  Physical address of an EFI memory map, containing at least
> +  the regions to be preserved. (required)
> +- 'efi-runtime-mmap-size':
> +  Size in bytes of the provided memory map. (required)
> +- 'efi-mmap-desc-size':
> +  Size of each descriptor in the memory map. (override default)
> +- 'efi-mmap-desc-ver':
> +  Memory descriptor format version. (override default)
> +
> +Since UEFI firmware on ARM systems are required to use a 1:1 memory map
> +even on LPAE-capable systems, the above fields are 32-bit regardless.

What about ARMv8? Is the intention to have a separate definition for the
UEFI bindings on ARMv8, so that compatibility isn't an issue? What if a
future version of UEFI allows LPAE usage?

It may be better to explicitly state that the size of those properties
is either #address-cells from the parent node (presumably the top-level
of the DT), and/or introduce some property to explicitly state the size
of the properties. Those mechanisms would allow forward-compatibility to
LPAE usage or ARMv8 without requiring the text of the binding definition
to change.

Also, it seems legal to state the physical addresses using 64-bits even
if the actual values themselves are restricted to 32-bit range by the
UEFI spec. Illegal values would presumably cause SW that interprets them
to fail error-checks, and be rejected.

> +After the kernel has mapped the required regions into its address space,
> +a SetVirtualAddressMap() call is made into UEFI in order to update
> +relocations. This call must be performed with all the code in a 1:1

Presumably "all the code" also includes "all .data and .bss", or
whatever the UEFI-equivalent may be? I'm not familiar with UEFI at all;
does the "EFI memory map" mentioned above describe all the memory
regions that must be mapped to use UEFI?

> +mapping. This implementation achieves this by temporarily disabling the
> +MMU for the duration of this call. This can only be done safely:
> +- before secondary CPUs are brought online.
> +- after early_initcalls have completed, sinze it uses setup_mm_for_reboot().

