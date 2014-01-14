Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaANTf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:35:29 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:36248 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaANTf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:35:26 -0500
MIME-Version: 1.0
In-Reply-To: <CAL_JsqLDVBfYomiNpFRacku4pJ3TrFy4rKJKedGp+LPGQt4m0w@mail.gmail.com>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
	<1389371417-379-7-git-send-email-roy.franz@linaro.org>
	<CAL_JsqLDVBfYomiNpFRacku4pJ3TrFy4rKJKedGp+LPGQt4m0w@mail.gmail.com>
Date: Tue, 14 Jan 2014 11:35:25 -0800
Message-ID: <CAFECyb83kmpj20nX3fw5HXw_hFyzj45aFga6nhG04qdKc-6jJw@mail.gmail.com>
Subject: Re: [PATCH V6 6/8] Add EFI stub for ARM
From: Roy Franz <roy.franz@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linaro Patches <patches@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Dave P Martin <dave.martin@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 11:29 AM, Rob Herring <robherring2@gmail.com> wrote:
> On Fri, Jan 10, 2014 at 10:30 AM, Roy Franz <roy.franz@linaro.org> wrote:
>> This patch adds EFI stub support for the ARM Linux kernel.  The EFI stub
>> operates similarly to the x86 stub: it is a shim between the EFI firmware
>> and the normal zImage entry point, and sets up the environment that the
>> zImage is expecting.  This includes loading the initrd (optionaly) and
>> device tree from the system partition based on the kernel command line.
>> The stub updates the device tree as necessary, adding entries for EFI
>> runtime services. The PE/COFF "MZ" header at offset 0 results in the
>> first instruction being an add that corrupts r5, which is not used by
>> the zImage interface.
>>
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>> Acked-by: Grant Likely <grant.likely@linaro.org>
>> ---
>
> [snip]
>
>> +       /* Look up the base of DRAM from the device tree. */
>> +       fdt = (void *)fdt_addr;
>> +       node = fdt_subnode_offset(fdt, 0, "memory");
>> +       region = fdt_getprop(fdt, node, "reg", NULL);
>> +       if (region) {
>> +               dram_base = fdt64_to_cpu(region->base);
>
> This will not work if the address is 32-bit size.
>
>> +       } else {
>> +               /* There is no way to get amount or addresses of physical
>> +                * memory installed using EFI calls.  If the device tree
>> +                * we read from disk doesn't have this, there is no way
>> +                * for us to construct this informaion.
>> +                */
>> +               pr_efi_err(sys_table, "No 'memory' node in device tree.\n");
>> +               goto fail_free_fdt;
>
> The current pc can't be used to determine the DRAM base like AUTO_ZRELADDR?
>
> Rob

Hi Rob,

   UEFI may load the stub based kernel anywhere, so we don't get any
useful information from where we were loaded.
I am currently working on getting the base address from the EFI memory
map, so all of the above code will go away, the only FDT
operations that the stub will perform is to add the EFI related fields.

Roy
