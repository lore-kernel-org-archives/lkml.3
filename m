Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933732Ab3GWQ5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:57:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52768 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933677Ab3GWQ5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:57:13 -0400
MIME-Version: 1.0
In-Reply-To: <20130723151552.GF8497@pd.tnic>
References: <20130723135853.579c3cd5@googlemail.com>
	<20130723151552.GF8497@pd.tnic>
Date: Tue, 23 Jul 2013 18:57:12 +0200
Message-ID: <CAPVoSvR30mjRq8Kcp34akb6R1oTi4Y+z7CCO_8FWK5cGd-W61A@mail.gmail.com>
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

On Tue, Jul 23, 2013 at 5:15 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Jul 23, 2013 at 01:58:53PM +0200, Torsten Kaiser wrote:
>> Fixup the early AMD microcode loading.
>>
>> * load_microcode_amd() (and the helper its using) should not have an
>> cpu parameter.
>
> Hmm, I don't think so - we get the cpu handed down from microcode_core
> and besides the early load on 32bit needs to do find_patch(cpu).

Thats why I moved that part into apply_microcode_amd(). See later on
more, why I think that move is the right thing.
And without that the current cpu parameter will only be used to get
the (in the early load case not even correctly set up!) per-cpu data.
But the only member of cpuinfo_x86 that gets uses is ->x86, the family.
Line 159: switch(c->x86) and Line 301: if (proc_fam!)c->x86)

I really wanted to make that switch from cpu to x86family a separate
patch, that it would be more obvious correct, but because of that
amd_bsp_mpb hunk I can't find a good cut and thats why this patch is
larger that I would have preferred.

>> The microcode loading is not depending on the CPU it is
>
> Mostly. There are mixed-stepping boxes which need to differentiate
> between which cpu we're applying the patch for.

Nothing looks at ->x86_model or ->x86_mask during load.
It will always load all patches from the current family.
If loading would really depend on the current cpu in a mixed system
that would be horrible: Depending on which CPU gets execute
load_microcode_amd() it there would be different patches loaded into
RAM?

> Btw, your config boots on my F14h box with "nomodeset" on the command
> line because it is missing radeon firmware for my gpu.

I suspect a F14h box will never see that hang. It trips over the the
C1E erratum and amd_erratum_400[] looks like it only affects 0xfh and
0x10h (like my Phenom II X6).

>> executed and all the loaded patches will end up in a global list for all
>> CPUs anyway.
>> * Return -1 (like Intels apply_microcode) when the loading fails,
>> also do not set the active microcode level on failure.
>
> Yep, this part I want. Please send it as a separate patch.

OK, will send that together with the resend for cpu_has_amd_erratum().

>> * Save the amd_bsp_mpb on apply, not on load. Otherwise someone could
>> later load an older microcode file that would overwrite amd_bsp_mpb,
>> but would not be applied to the CPUs
>
> See the patch id check in apply_ucode_in_initrd()?
>
>         if (eq_id == mc->hdr.processor_rev_id && rev < mc->hdr.patch_id)

I meant with "load" load_microcode_amd() not the loading of the
microcode into the CPU.

1.: load microcode rev X into CPU (early or normal is not important)
2.: get older microcode file that only contains rev Y with Y<X
3.: trigger load_microcode_amd() with a corrupt file: This will call
cleanup() and empty pcache.
4.: trigger load_microcode_amd() with the older file:
 * this will now load rev Y into pcache
 * rev Y will be returned by find_patch and copied into amd_bsp_mpb
 * any try to apply rev Y will be skipped in apply_microcode_amd()

So now the CPU still correctly has rev X, but amd_bsp_mpb will contain
the wrong rev Y.

That copying already in load_microcode also is suspicious if someone
would only load the microcode but not apply it. But I did not find a
codepath in arch/x86/kernel/microcode_core.c to load it without a
followup apply.

>> * Save the amd_bsp_mpb on every update. Otherwise someone could offline
>> the BSP, update the microcode and this would be lost on resume
>
> Huh, is amd_bsp_mpb going to disappear all of a sudden?
>
> And that doesn't matter because when we online the BSP later, it goes
> through the CPU hotplug notifier mc_cpu_callback. Or am I missing
> something?

Yeah, me correctly describing what I was meaning. ;-)

1.: boot system, BIOS give microcode rev. X
2.: offline the BSP
3.: update microcode to rev. Y with Y > X
Because the BSP is not online rev. Y will not be copied into amd_bsp_mpb
4.: supend
5.: resume, BIOS gives rev. X again
6.: amd_bsp_mpb is empty -> rev. Y will not be reapplied.

>> * apply_ucode_in_initrd() now also needs to save amd_bsp_mbp, because
>> load_microcode_amd() its no longer doing this and its not using
>> apply_microcode_amd().
>> * extract common checks and initialisations from load_ucode_ap() and
>> load_microcode_amd() to load_microcode_amd_early(). The change from
>> cpu to x86family in load_microcode_amd() allows to drop the code messing
>> with cpu_data(cpu), with is wrong anyway because at that point the
>> per-cpu cpu_info is not yet setup. And these values would later be
>> overwritten by smp_store_boot_cpu_info() / smp_store_cpu_info().
>
> Right, so I was thinking about this. And the code is pretty nasty: we do a
> load_ucode_amd_ap() but we do add the ucode for the BSP:
>
>         if (load_microcode_amd(0, ucode, ucode_size) != UCODE_OK)

No, that code will not be reached for the BSP, because it is behind:
if (cpu && !ucode_loaded) {
The BSP has cpu == 0. Thats why I adding the following in my patch:
+       /* BSP via load_ucode_amd_bsp() */
+       if (!cpu)
+               return;

I don't understand if that is really correct, but that was the
original behavior, and I didn't feel competent enough to decree that
calling load_microcode_amd() for the BSP would be save.
(The code there is strange: There is a load_ucode_amd_bsp() but
load_ucode_amd_ap() will also be called for the BSP.
And it seems the call to load_ucode_ap() for the BSP will come from a
very different place (via trap_init()) that the other CPUs.
And I did not even try to understand what X86_32 is doing...)

> so the actual problem is apply_microcode_amd() using as an arg cpu != 0.
> And we can take care of that by using, say __apply_microcode_amd() and
> hand it the BSP's patch.

That one I don't understand.
cpu!=0 is nessasary to patch all the other CPUs.

> The other problem I see is not updating c->microcode since it is going
> to be overwritten by smp_store_cpu_info, which is unfortunate.
>
> And I don't see where Intel are updating that cpuinfo_x86.microcode
> field on early load too.
>
> So, AFAICT, c->microcode would remain unset when we only do early
> microcode load. But that is something we should fix as a later patch.

I don't see a problem with that staying unset.
apply_microcode_amd() directly reads the rev from
MSR_AMD64_PATCH_LEVEL so it does not depend on that being correct.
And smp_store_(boot)_cpu_info will also read the current rev directly
from the CPU to fill ->microcode.

> So I think you should switch load_ucode_amd_ap to __apply_microcode_amd:
>
>         p = find_patch()
>
>         __apply_microcode_amd(p->mc_data);
>
> which should take care of the issue you're seeing, IMHO.

The issue I'm seeing is that collect_cpu_info_amd_early() fills c->x86
but not c->x86_vendor.
Which breaks cpu_has_amd_erratum() and then Erratum 400 breaks the boot.

I did not really want to switch from apply_microcode_amd() to
__apply_microcode_amd() because then I would lose the check if the new
microcode is really an upgrade.

I would like to get rid of the messing with uci->cpu_sig, but that is
needed in find_patch() so can't be removed even when using
__appy_microcode_amd().

>> * fold collect_cpu_info_amd_early() into load_ucode_amd_ap(), because its
>> only used at one place.
>
> Yes, that should be done especially since we are not going to touch
> cpuinfo_x86 fields anymore.
>
>> * load_ucode_ap(): Quick exit for !cpu, because without load_microcode_amd()
>> getting called apply_microcode_amd() can't do anything. Exit, if no microcode
>> could be loaded.
>
> This could probably be a WARN_ON(!cpu) to catch errors...

No, load_ucode_ap() will be called for cpu == 0.
init/main.c: start_kernel() calls trap_init()
trap_init() calls cpu_init()
cpu_init() calls load_ucode_ap()
load_ucode_ap() then calls load_ucode_amd_ap()

I think that silent exit at that place is correct.
If load_microcode_amd() could do anything there needs to be correct
microcode data at initrd_start + ucode_offset.
But if there is valid microcode then load_ucode_amd_bsp() should also
have found it an applied it to the BSP already.
So skipping applay_microcode_amd() for cpu==0 is OK.

> And so on.
>
> So I see a couple of issues in this patch and they should be separated
> into single patches - one patch taking care of one issue and explaining
> what the problem is in the commit message (I know you can do that good
> :)).

I know, I know.
I really wanted "just" a small patch that only killed the accesses to cpu_data.
Which seemed like it only needed the API change from cpu to x86family
in microcode_amd.c.
But then the amd_bsp_mbp made this much more complicated.

OK, I will try to splitt this, at least seperating the correct error
exit for when __apply_microcode_amd() fails will get an separat patch.

Maybe I will get the rest split up as well. :-)

Torsten

> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
