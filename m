Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3GXPBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 11:01:41 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:55792 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab3GXPBk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 11:01:40 -0400
MIME-Version: 1.0
In-Reply-To: <20130724141927.GI30777@pd.tnic>
References: <20130723135853.579c3cd5@googlemail.com>
	<20130723151552.GF8497@pd.tnic>
	<CAPVoSvR30mjRq8Kcp34akb6R1oTi4Y+z7CCO_8FWK5cGd-W61A@mail.gmail.com>
	<20130724141927.GI30777@pd.tnic>
Date: Wed, 24 Jul 2013 17:01:39 +0200
Message-ID: <CAPVoSvRfo7jePJ-NK444s9XwZK96xpf5w=vwQ9xRMp8oH-rVig@mail.gmail.com>
Subject: Re: [PATCH]Fix early microcode loading on AMD
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 4:19 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Jul 23, 2013 at 06:57:12PM +0200, Torsten Kaiser wrote:
>> > The other problem I see is not updating c->microcode since it is going
>> > to be overwritten by smp_store_cpu_info, which is unfortunate.
>> >
>> > And I don't see where Intel are updating that cpuinfo_x86.microcode
>> > field on early load too.
>> >
>> > So, AFAICT, c->microcode would remain unset when we only do early
>> > microcode load. But that is something we should fix as a later patch.
>>
>> I don't see a problem with that staying unset.
>> apply_microcode_amd() directly reads the rev from
>> MSR_AMD64_PATCH_LEVEL so it does not depend on that being correct.
>> And smp_store_(boot)_cpu_info will also read the current rev directly
>> from the CPU to fill ->microcode.
>
> We need to store the actual microcode revision to c->microcode for
> /proc/cpuinfo and MCE.

init_amd() will fill that field. (You could alway compile with
CONFIG_MICROCODE_AMD=n and that field would still need filling)
And as that will get called before smp_store_(boo)_cpu_info()
everything should be fine.

>> > So I think you should switch load_ucode_amd_ap to __apply_microcode_amd:
>> >
>> >         p = find_patch()
>> >
>> >         __apply_microcode_amd(p->mc_data);
>> >
>> > which should take care of the issue you're seeing, IMHO.
>>
>> The issue I'm seeing is that collect_cpu_info_amd_early() fills c->x86
>> but not c->x86_vendor.
>> Which breaks cpu_has_amd_erratum() and then Erratum 400 breaks the boot.
>>
>> I did not really want to switch from apply_microcode_amd() to
>> __apply_microcode_amd() because then I would lose the check if the new
>> microcode is really an upgrade.
>
> Well, if the BSP has already loaded the pcache, there's no need for
> the AP to parse and load the same microcode blobs file for the initrd,
> right?

loading != applying.

load_ucode_amd_ap() should probably called apply_ucode_amd_ap()
because that is primarily for applying the microcode.
That it also loads it (but really only once thanks to ucode_loaded) is
only because nobody else has run yet.

That whole place is hairy: Because on 32bit that seems to run much
earlier the 64 and 32 cases are very different.
64bit can and will use pcache/apply_microcode_amd() for the non BSP
CPUs, but on 32 bit everything directly applys the patches from initrd
memory into the CPUs be directly calling __apply_microcode_amd(). And
so bypassing pcache.

See comment above the 32bit version of load_ucode_amd_ap():
/*
 * On 32-bit, since AP's early load occurs before paging is turned on, we
 * cannot traverse cpu_equiv_table and pcache in kernel heap memory. So during
 * cold boot, AP will apply_ucode_in_initrd() just like the BSP. During
 * save_microcode_in_initrd_amd() BSP's patch is copied to amd_bsp_mpb, which
 * is used upon resume from suspend.
 */

As written in the other email: I'm currently trying to see if I can
kill amd_bsp_mpb...

>> >> * load_ucode_ap(): Quick exit for !cpu, because without load_microcode_amd()
>> >> getting called apply_microcode_amd() can't do anything. Exit, if no microcode
>> >> could be loaded.
>> >
>> > This could probably be a WARN_ON(!cpu) to catch errors...
>>
>> No, load_ucode_ap() will be called for cpu == 0.
>
> This needs fixing IMO...

Can't answer that. I have only seen that it is called for cpu == 0 and
that there is no special case für CPU#0 in all the places that call
load_ucode_ap()...

> Btw, thanks for looking at this and asking critical questions!
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
