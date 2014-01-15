Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaAOJqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:46:25 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:40531 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaAOJqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:46:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAFECyb9jbVHjM7--tRgbjfS9_MaAAvOhR3qXEKPKS6eW23V9Kg@mail.gmail.com>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
	<1389371417-379-7-git-send-email-roy.franz@linaro.org>
	<CAKv+Gu9OfieNhvj07tQv+ucQomZhDVDxwdV3Z9Tm+HaHE8HG-Q@mail.gmail.com>
	<CAFECyb9jx4NA0v_qNgrto4qG3KV3fBOpGh839Mnvbjody4xwYA@mail.gmail.com>
	<CAFECyb9jbVHjM7--tRgbjfS9_MaAAvOhR3qXEKPKS6eW23V9Kg@mail.gmail.com>
Date: Wed, 15 Jan 2014 10:46:18 +0100
Message-ID: <CAKv+Gu8yW3z3fAeZcA92s_URDcxMFhOqeWuxSiWxbdVGdHH+yA@mail.gmail.com>
Subject: Re: [PATCH V6 6/8] Add EFI stub for ARM
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Patch Tracking <patches@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Dave Martin <dave.martin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 January 2014 03:16, Roy Franz <roy.franz@linaro.org> wrote:
> On Tue, Jan 14, 2014 at 5:47 PM, Roy Franz <roy.franz@linaro.org> wrote:
>> On Tue, Jan 14, 2014 at 1:05 AM, Ard Biesheuvel
>> <ard.biesheuvel@linaro.org> wrote:
>>> On 10 January 2014 17:30, Roy Franz <roy.franz@linaro.org> wrote:
>>>> This patch adds EFI stub support for the ARM Linux kernel.  The EFI stub
>>>> operates similarly to the x86 stub: it is a shim between the EFI firmware
>>>> and the normal zImage entry point, and sets up the environment that the
>>>> zImage is expecting.  This includes loading the initrd (optionaly) and
>>>> device tree from the system partition based on the kernel command line.
>>>> The stub updates the device tree as necessary, adding entries for EFI
>>>> runtime services. The PE/COFF "MZ" header at offset 0 results in the
>>>> first instruction being an add that corrupts r5, which is not used by
>>>> the zImage interface.
>>>>
>>>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>>>> Acked-by: Grant Likely <grant.likely@linaro.org>
>>>> ---
>>>
>>> [...]
>>>
>>>> diff --git a/arch/arm/boot/compressed/efi-header.S b/arch/arm/boot/compressed/efi-header.S
>>>> new file mode 100644
>>>> index 0000000..dbb7101
>>>> --- /dev/null
>>>> +++ b/arch/arm/boot/compressed/efi-header.S
>>>> @@ -0,0 +1,117 @@
>>>> +@ Copyright (C) 2013 Linaro Ltd;  <roy.franz@linaro.org>
>>>> +@
>>>> +@ This file contains the PE/COFF header that is part of the
>>>> +@ EFI stub.
>>>> +@
>>>> +
>>>> +       .org    0x3c
>>>> +       @
>>>> +       @ The PE header can be anywhere in the file, but for
>>>> +       @ simplicity we keep it together with the MSDOS header
>>>> +       @ The offset to the PE/COFF header needs to be at offset
>>>> +       @ 0x3C in the MSDOS header.
>>>> +       @ The only 2 fields of the MSDOS header that are used are this
>>>> +       @ PE/COFF offset, and the "MZ" bytes at offset 0x0.
>>>> +       @
>>>> +       .long   pe_header                       @ Offset to the PE header.
>>>> +
>>>> +      .align 3

Btw you also have a whitespace error here.

>>>> +pe_header:
>>>> +       .ascii  "PE"
>>>> +       .short  0
>>>> +
>>>> +coff_header:
>>>> +       .short  0x01c2                          @ ARM or Thumb
>>>
>>> Could you explain why you are using 0x1c2 (Thumb) here and not 0x1c0 (ARM) ?
>>>
>>> Cheers,
>>> Ard.
>>
>> Nope.  It should be 0x1c0.
>>
>> Roy
>
> OK, now I resolved the nagging feeling that I had already fixed
> this...   Right now, the EDK2 UEFI implementation
> requires the machine type for ARM to be "0x1c2".  I don't think that
> this is correct, but correcting this in EDK2 slipped through
> the cracks, but is now back on my todo list.
>
> I think that for now we should leave this as 0x1c2 so that the
> unpatched EDK2 builds will boot it, and some time after EDK2 is
> updated
> this can be changed.  I'll work on a patch for EDK2 and get the
> discussion going on that list to resolve this in EDK2.
>

OK. I have updated sbsigntool (Linaro's version) so it supports
either, but I agree that using the ARM constant is the correct way.

-- 
Ard.
