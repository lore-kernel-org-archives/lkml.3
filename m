Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaANT3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:29:22 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:48924 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaANT3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:29:18 -0500
MIME-Version: 1.0
In-Reply-To: <1389371417-379-7-git-send-email-roy.franz@linaro.org>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
	<1389371417-379-7-git-send-email-roy.franz@linaro.org>
Date: Tue, 14 Jan 2014 13:29:17 -0600
Message-ID: <CAL_JsqLDVBfYomiNpFRacku4pJ3TrFy4rKJKedGp+LPGQt4m0w@mail.gmail.com>
Subject: Re: [PATCH V6 6/8] Add EFI stub for ARM
From: Rob Herring <robherring2@gmail.com>
To: Roy Franz <roy.franz@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        matt.fleming@intel.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linaro Patches <patches@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Dave P Martin <dave.martin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 10:30 AM, Roy Franz <roy.franz@linaro.org> wrote:
> This patch adds EFI stub support for the ARM Linux kernel.  The EFI stub
> operates similarly to the x86 stub: it is a shim between the EFI firmware
> and the normal zImage entry point, and sets up the environment that the
> zImage is expecting.  This includes loading the initrd (optionaly) and
> device tree from the system partition based on the kernel command line.
> The stub updates the device tree as necessary, adding entries for EFI
> runtime services. The PE/COFF "MZ" header at offset 0 results in the
> first instruction being an add that corrupts r5, which is not used by
> the zImage interface.
>
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> Acked-by: Grant Likely <grant.likely@linaro.org>
> ---

[snip]

> +       /* Look up the base of DRAM from the device tree. */
> +       fdt = (void *)fdt_addr;
> +       node = fdt_subnode_offset(fdt, 0, "memory");
> +       region = fdt_getprop(fdt, node, "reg", NULL);
> +       if (region) {
> +               dram_base = fdt64_to_cpu(region->base);

This will not work if the address is 32-bit size.

> +       } else {
> +               /* There is no way to get amount or addresses of physical
> +                * memory installed using EFI calls.  If the device tree
> +                * we read from disk doesn't have this, there is no way
> +                * for us to construct this informaion.
> +                */
> +               pr_efi_err(sys_table, "No 'memory' node in device tree.\n");
> +               goto fail_free_fdt;

The current pc can't be used to determine the DRAM base like AUTO_ZRELADDR?

Rob
