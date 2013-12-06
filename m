Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab3LFA6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:58:50 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:55248 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab3LFA6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:58:48 -0500
MIME-Version: 1.0
In-Reply-To: <20131205192456.1B602C40785@trevor.secretlab.ca>
References: <1385595115-21488-1-git-send-email-roy.franz@linaro.org>
	<1385595115-21488-3-git-send-email-roy.franz@linaro.org>
	<20131205192456.1B602C40785@trevor.secretlab.ca>
Date: Thu, 5 Dec 2013 16:58:47 -0800
Message-ID: <CAFECyb8xoue5R9tH+Vjvpk-uyxjvxXX5=n0Son_+3vu28y8C8A@mail.gmail.com>
Subject: Re: [PATCH V5 2/6] Add shared update_fdt() function for ARM/ARM64
From: Roy Franz <roy.franz@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Dave Martin <dave.martin@arm.com>, Mark Salter <msalter@redhat.com>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 11:24 AM, Grant Likely <grant.likely@linaro.org> wrote:
> On Wed, 27 Nov 2013 15:31:51 -0800, Roy Franz <roy.franz@linaro.org> wrote:
>> Both ARM and ARM64 stubs will update the device tree
>> that they pass to the kernel.  In both cases they
>> primarily need to add the same UEFI related information,
>> so the function can be shared.
>> Create a new FDT related file for this to avoid use
>> of architecture #ifdefs in efi-stub-helper.c
>> Change EFI allocation type for memory map to
>> EFI_RUNTIME_SERVICES_DATA, since we are passing
>> this buffer to the kernel, or immediately freeing it.
>>
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>
> Hi Roy,
>
> Comments below...
>
>> +static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>> +                            void *fdt, int new_fdt_size, char *cmdline_ptr,
>> +                            u64 initrd_addr, u64 initrd_size,
>> +                            efi_memory_desc_t *memory_map,
>> +                            unsigned long map_size, unsigned long desc_size,
>> +                            u32 desc_ver)
>> +{
>> +     int node;
>> +     int status;
>> +     u32 fdt_val32;
>> +     u64 fdt_val64;
>> +     /* Copy definition of linux_banner here.  Since this code is
>> +      * built as part of the decompressor for ARM v7, pulling
>> +      * in version.c where linux_banner is defined for the
>> +      * kernel brings other kernel dependencies with it.
>> +      */
>> +     const char linux_banner[] =
>> +         "Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
>> +         LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";
>
> This is inherently fragile because the string is now defined in two
> places. This issue shouldn't hold off merging the patch, but a follow up
> patch should be crafted to make it possible to pull in version.c without
> the other dependencies....
>
> Then again, the version.c strings have a very big "DON'T TOUCH" warning
> on them so I'm probably worrying about nothing.  :-)

I wasn't really happy about copying the definition here, but as this
will be verified by UEFI
code in the kernel if this every is changed it should not be much of a
problem in practice.
I can take a look at what changes would be required for using
version.c here.  I haven't worked
out what would need to be done, but was hesitant to make changes there
to support a one-off use
of the kernel version string outside of the kernel (ie in the
decompressor/stub), and was trying to keep
this patchset limited to changing arm/EFI code.

>
>> +
>> +     status = fdt_open_into(orig_fdt, fdt, new_fdt_size);
>> +     if (status != 0)
>> +             goto fdt_set_fail;
>> +
>> +     node = fdt_subnode_offset(fdt, 0, "chosen");
>> +     if (node < 0) {
>> +             node = fdt_add_subnode(fdt, 0, "chosen");
>> +             if (node < 0) {
>> +                     status = node; /* node is error code when negative */
>> +                     goto fdt_set_fail;
>> +             }
>> +     }
>> +
>> +     if ((cmdline_ptr != NULL) && (strlen(cmdline_ptr) > 0)) {
>> +             status = fdt_setprop(fdt, node, "bootargs", cmdline_ptr,
>> +                                  strlen(cmdline_ptr) + 1);
>> +             if (status)
>> +                     goto fdt_set_fail;
>> +     }
>> +
>> +     /* Set intird address/end in device tree, if present */
>
> sp. initrd
>
> None of the above comments are blockers though.
>
> Acked-by: Grant Likely <grant.likely@linaro.org>
>

Thanks,
Roy
