Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3K0MXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 07:23:19 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36421 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab3K0MXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 07:23:17 -0500
MIME-Version: 1.0
In-Reply-To: <20131127121231.968E6C404EC@trevor.secretlab.ca>
References: <1385034003-32160-1-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu9VbSLDOYnuGkuajSHmp2PMKE-hLS4X0Gu-KO=uhU9skg@mail.gmail.com> <20131127121231.968E6C404EC@trevor.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 27 Nov 2013 12:22:55 +0000
X-Google-Sender-Auth: Cz0lYd25V1g-dRFSDyZbYZkWypo
Message-ID: <CACxGe6upu2yAeVRRjvLnnLctNYnUSaxR0gCp9WmtWHbco9hRUA@mail.gmail.com>
Subject: Re: [PATCH] firmware/dmi_scan: generalize for use by other archs
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, Al Stone <al.stone@linaro.org>,
        Yi Li <yi.li@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 12:12 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Mon, 25 Nov 2013 13:07:23 +0100, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> Hello all,
>>
>> Resending this patch to a slightly wider audience.
>>
>> The point of this patch is reworking the dmi_scan code slightly so it
>> can be reused on ARM and arm64.
>> There are no functional changes for x86 or IA-64, just one open
>> question, i.e., whether the non-EFI fallback probe should be performed
>> on IA-64 in the first place.
>>
>> If I could get acks for this patch please (if there are no
>> objections), I will propose it to be merged through the ARM and/or
>> arm64 trees as part of the complete series to enable SMBIOS.
>>
>> On 21 November 2013 12:40, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> > This patch makes a couple of changes to the SMBIOS/DMI scanning
>> > code so it can be used on other archs (such as ARM and arm64):
>> > (a) wrap the calls to ioremap()/iounmap(), this allows the use of a
>> >     flavor of ioremap() more suitable for random unaligned access;
>> > (b) allow the non-EFI fallback probe into hardcoded physical address
>> >     0xF0000 to be disabled.
>> >
>> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> Looks good.
>
> Reviewed-by: Grant Likely <grant.likely@linaro.org>

Actually, I have one thought here...\

>> >         } else {
>> > -               p = dmi_ioremap(0xF0000, 0x10000);
>> > +#ifdef DMI_SCAN_MACHINE_NON_EFI_FALLBACK
>> > +               p = dmi_early_remap(0xF0000, 0x10000);
>> >                 if (p == NULL)
>> >                         goto error;
>> >

This is just ugly. #ifdef blocks inside of code is strongly
discouraged. Instead, you can change the } else { line to:
        } else if IS_ENABLED(CONFIG_DMI_NON_EFI_FALLBACK) {

and then add an empty stanza to drivers/firmware/Kconfig:

config DMI_NON_EFI_FALLBACK
        bool

And finally, make x86 and ia64 select it in arch/{ia64,x86}/Kconfig:

config DMI
        bool
        select DMI_NON_EFI_FALLBACK
        default y

Which eliminates the DMI_SCAN_MACHINE_NON_EFI_FALLBACK #define from
the header files.

>> > @@ -510,12 +511,13 @@ void __init dmi_scan_machine(void)
>> >                         memcpy_fromio(buf + 16, q, 16);
>> >                         if (!dmi_present(buf)) {
>> >                                 dmi_available = 1;
>> > -                               dmi_iounmap(p, 0x10000);
>> > +                               dmi_early_unmap(p, 0x10000);
>> >                                 goto out;
>> >                         }
>> >                         memcpy(buf, buf + 16, 16);
>> >                 }
>> > -               dmi_iounmap(p, 0x10000);
>> > +               dmi_early_unmap(p, 0x10000);
>> > +#endif
>> >         }
>> >   error:
>> >         pr_info("DMI not present or invalid.\n");
>> > @@ -787,13 +789,13 @@ int dmi_walk(void (*decode)(const struct dmi_header *, void *),
>> >         if (!dmi_available)
>> >                 return -1;
>> >
>> > -       buf = ioremap(dmi_base, dmi_len);
>> > +       buf = dmi_remap(dmi_base, dmi_len);
>> >         if (buf == NULL)
>> >                 return -1;
>> >
>> >         dmi_table(buf, dmi_len, dmi_num, decode, private_data);
>> >
>> > -       iounmap(buf);
>> > +       dmi_unmap(buf);
>> >         return 0;
>> >  }
>> >  EXPORT_SYMBOL_GPL(dmi_walk);
>> > --
>> > 1.8.3.2
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
