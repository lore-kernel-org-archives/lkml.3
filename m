Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764Ab3CHHCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:02:18 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:50642 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697Ab3CHHCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:02:16 -0500
MIME-Version: 1.0
In-Reply-To: <20130308055729.GG14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
	<1362718720-27048-6-git-send-email-yinghai@kernel.org>
	<20130308055729.GG14556@mtj.dyndns.org>
Date: Thu, 7 Mar 2013 23:02:15 -0800
X-Google-Sender-Auth: l-whO9YAmrxOp4MkGxiNf1-fVP8
Message-ID: <CAE9FiQVeXTbLYQM=t1ZM6t7q51vvv65bicuVutbeSGZv1fT6zA@mail.gmail.com>
Subject: Re: [PATCH 05/14] x86, ACPI: Find acpi tables in initrd early at head_32.S/head64.c
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 9:57 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Mar 07, 2013 at 08:58:31PM -0800, Yinghai Lu wrote:
>> diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
>> index 73afd11..ca08f0e 100644
>> --- a/arch/x86/kernel/head_32.S
>> +++ b/arch/x86/kernel/head_32.S
>> @@ -149,6 +149,10 @@ ENTRY(startup_32)
>>       call load_ucode_bsp
>>  #endif
>>
>> +#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
>> +     call x86_acpi_override_find
>> +#endif
>
> The function is always defined.  We can probalby lose ifdef here?

just mimic microcode updating again.

>
> Also, does it really have to be called from head_32.S?  No way this
> can be done after entering C code?  It would be great if you can
> explain overall design choices in the head message (and important
> patches).

have to be with head_32.S and it is with 32bit flat mode, so could access
4G blow without setting page table.

Will try add to more in the change log.

>
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index 668e658..d43545a 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -424,6 +424,32 @@ static void __init reserve_initrd(void)
>>  }
>>  #endif /* CONFIG_BLK_DEV_INITRD */
>>
>> +#ifdef CONFIG_ACPI_INITRD_TABLE_OVERRIDE
>> +void __init x86_acpi_override_find(void)
>> +{
>> +     unsigned long ramdisk_image, ramdisk_size;
>> +     unsigned char *p = NULL;
>> +
>> +#ifdef CONFIG_X86_32
>> +     struct boot_params *boot_params_p;
>> +
>> +     boot_params_p = (struct boot_params *)__pa_symbol(&boot_params);
>> +     ramdisk_image = boot_params_p->hdr.ramdisk_image;
>> +     ramdisk_size  = boot_params_p->hdr.ramdisk_size;
>> +     p = (unsigned char *)ramdisk_image;
>> +     acpi_initrd_override_find(p, ramdisk_size, true);
>> +#else
>> +     ramdisk_image = get_ramdisk_image();
>> +     ramdisk_size  = get_ramdisk_size();
>> +     if (ramdisk_image)
>> +             p = __va(ramdisk_image);
>> +     acpi_initrd_override_find(p, ramdisk_size, false);
>> +#endif
>> +}
>> +#else
>> +void __init x86_acpi_override_find(void) { }
>
> And add a comment here why we're not doing static inline for the dummy
> function?

...
