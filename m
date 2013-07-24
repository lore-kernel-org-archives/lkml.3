Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3GXOos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:44:48 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:33542 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab3GXOoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:44:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130724135610.GG30777@pd.tnic>
References: <20130723135853.579c3cd5@googlemail.com>
	<20130723151552.GF8497@pd.tnic>
	<CAPVoSvR30mjRq8Kcp34akb6R1oTi4Y+z7CCO_8FWK5cGd-W61A@mail.gmail.com>
	<20130724135610.GG30777@pd.tnic>
Date: Wed, 24 Jul 2013 16:44:45 +0200
Message-ID: <CAPVoSvShyTo7ukAu42tJAn29Tt0HtDxGBNDXtvffiioOz5AXmA@mail.gmail.com>
Subject: Re: [PATCH]Fix early microcode loading on AMD
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 3:56 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Jul 23, 2013 at 06:57:12PM +0200, Torsten Kaiser wrote:
>> >> * Save the amd_bsp_mpb on apply, not on load. Otherwise someone could
>> >> later load an older microcode file that would overwrite amd_bsp_mpb,
>> >> but would not be applied to the CPUs
>> >
>> > See the patch id check in apply_ucode_in_initrd()?
>> >
>> >         if (eq_id == mc->hdr.processor_rev_id && rev < mc->hdr.patch_id)
>>
>> I meant with "load" load_microcode_amd() not the loading of the
>> microcode into the CPU.
>>
>> 1.: load microcode rev X into CPU (early or normal is not important)
>> 2.: get older microcode file that only contains rev Y with Y<X
>> 3.: trigger load_microcode_amd() with a corrupt file: This will call
>> cleanup() and empty pcache.
>
> Ok, that's actually a good catch. So I wonder: why in hell would we
> flush the pcache if some of the blobs we're loading are corrupted. So
> what?! Jacob, what were you thinking - I'd be very interested to know
> what the idea behind this was.
>
> So, just to refresh everybody: the idea of the pcache is to keep all
> patches for the current family in memory so that we can support all
> sorts of hotplug and cpu mixed stepping diddling.

Then it would probably be the best to kill free_cache() completely.
Which would mean cleanup() should also go.
Which will make unloading microcode_amd.ko impossible.
But that is probably a good idea anyway: If you unload the module
there is no way to keep pcache.

But I still have another way to kill you: free_equiv_cpu_table()
Without that table find_patch() can't work and will not return the
correct information.

And that can be triggered by:
* start of load_microcode_amd(): If you reach that function (Only
UCODE_MAGIC needs to be in the file) that table is dead.
* __load_microcode_amd(): If the file only contains the table but no
patches ("invalid type field in container file section header\n")

>> 4.: trigger load_microcode_amd() with the older file:
>>  * this will now load rev Y into pcache
>>  * rev Y will be returned by find_patch and copied into amd_bsp_mpb
>>  * any try to apply rev Y will be skipped in apply_microcode_amd()
>>
>> So now the CPU still correctly has rev X, but amd_bsp_mpb will contain
>> the wrong rev Y.
>
> Right, so this shouldn't happen - what should happen is, pcache would
> hold both X and Y and find_patch would automatically give you the right
> one.
>
> And this is guaranteed since we keep the patches in a sorted linked list
> by ->patch_id which is guaranteed to be increasing.
>
> So actually load_microcode_amd() shouldn't be doing cleanup() but simply
> return ret upwards.

But it already called free_equiv_cpu_table() and so pcache is inaccessible.

And I don't think just preserving equiv_cpu_table for restoring in the
error case will be the right solution: If the new firmware file
contains a new table with fewer entries (or different entries!) some
of the patches in pcache might become inaccessible.

>> That copying already in load_microcode also is suspicious if someone
>> would only load the microcode but not apply it. But I did not find
>> a codepath in arch/x86/kernel/microcode_core.c to load it without a
>> followup apply.
>
> Yeah, we always load and apply.
>
> So now back to the original problem - load_microcode_amd() shouldn't
> clear the pcache and, in that case, a subsequent find_patch() would
> always give the right patch.

Not if equiv_cpu_table got mangled.
So should install_equiv_cpu_table() be turned into
add_to_equiv_cpu_table() or should pcache save all cpu_sig with each
patch, so that find_patch() no longer needs equiv_cpu_table?
I suspect saving that in struct ucode_patch might be better, to
prevent changes in equiv_id <-> cpu_sig mapping to make a patch
inaccessible.

Torsten
