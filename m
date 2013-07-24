Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab3GXOVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:21:03 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45646 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab3GXOU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:20:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130724134130.GF30777@pd.tnic>
References: <20130723135853.579c3cd5@googlemail.com>
	<20130723151552.GF8497@pd.tnic>
	<CAPVoSvR30mjRq8Kcp34akb6R1oTi4Y+z7CCO_8FWK5cGd-W61A@mail.gmail.com>
	<20130724134130.GF30777@pd.tnic>
Date: Wed, 24 Jul 2013 16:20:58 +0200
Message-ID: <CAPVoSvSPB_UKO-g6032LCd3CBTbTJmrOtJcFfnU7O_e5nG8cng@mail.gmail.com>
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

On Wed, Jul 24, 2013 at 3:41 PM, Borislav Petkov <bp@alien8.de> wrote:
> Let me try to answer this as well as I can, peacemeal-wise.
>
> On Tue, Jul 23, 2013 at 06:57:12PM +0200, Torsten Kaiser wrote:
>> On Tue, Jul 23, 2013 at 5:15 PM, Borislav Petkov <bp@alien8.de> wrote:
>> > On Tue, Jul 23, 2013 at 01:58:53PM +0200, Torsten Kaiser wrote:
>> >> Fixup the early AMD microcode loading.
>> >>
>> >> * load_microcode_amd() (and the helper its using) should not have an
>> >> cpu parameter.
>> >
>> > Hmm, I don't think so - we get the cpu handed down from microcode_core
>> > and besides the early load on 32bit needs to do find_patch(cpu).
>>
>> Thats why I moved that part into apply_microcode_amd(). See later on
>> more, why I think that move is the right thing.
>> And without that the current cpu parameter will only be used to get
>> the (in the early load case not even correctly set up!) per-cpu data.
>> But the only member of cpuinfo_x86 that gets uses is ->x86, the family.
>> Line 159: switch(c->x86) and Line 301: if (proc_fam!)c->x86)
>>
>> I really wanted to make that switch from cpu to x86family a separate
>> patch, that it would be more obvious correct, but because of that
>> amd_bsp_mpb hunk I can't find a good cut and thats why this patch is
>> larger that I would have preferred.
>
> Ok.

First moving that hunk, then switching from cpu to x86family did work.
See patch 4/5 and 5/5. :-)

>> >> The microcode loading is not depending on the CPU it is
>> >
>> > Mostly. There are mixed-stepping boxes which need to differentiate
>> > between which cpu we're applying the patch for.
>>
>> Nothing looks at ->x86_model or ->x86_mask during load.
>> It will always load all patches from the current family.
>
> Yes, that's the idea. We want to have all patches for the current family
> loaded.

And thats why switching from cpu to x86family is OK: during *load* we
only care for the family.

>> If loading would really depend on the current cpu in a mixed
>> system that would be horrible: Depending on which CPU gets execute
>> load_microcode_amd() it there would be different patches loaded into
>> RAM?
>
> No, we load the microcode based on CPUID(1).EAX which is in the
> equivalence table. Look at find_equiv_id().
>
> But for that we need all patches belonging to the current family to be
> in the cache.

I think you confused *load* and *apply*.
load_microcode_amd() *loads* the microcode from a firmwarefile into
the pcache list.
This wants all patches for the family and thats why my switch here is OK.
apply_microcode_amd() *applies* the microcode to the CPU / "loads" it
into the CPU. That function (or better its helper find_patch()) need
the full stepping/masking. I did not change that function, because in
that case 'cpu' makes sense as a parameter, because the microcode
needs to be applied for each CPU. (You could argue that that parameter
is also stupid: If you ever pass something else as
raw_smp_processor_id() then it will BUG(). But removing that parameter
would need to change the whole microcode_core.c and also
microcode_intel.c. And there that parameter might make sense, so it's
better to keep 'cpu' for apply_microcode_amd())

But wrt. you concern about mixed stepping systems: There early
microcode loading is definitly broken for 32bit.
The current mainline code will save the patch for the BSP in
amd_bsp_mpb and then apply that to all CPUs irregardless of its
stepping. With my change in 4/5 to move the amd_bsp_mpb setup to apply
time it will now wrongly patch all CPUs with the microcode that was
loaded last.
But u8 amd_bsp_mpb[NR_CPUS][MPB_MAX_SIZE] doesn't look like a good idea.
Maybe the best way here is to fail apply_microcode_amd() if
amd_bsp_mpb already contains an incompatible patch and in
load_ucode_amd_ap() only apply it when the cpu_sig matches.
Or u8 amd_bsp_mpb[4][MPB_MAX_SIZE] which would support up to 4
different steppings per system.

No patch yet, because I do not understand why that is not a problem on
64bit. load_ucode_amd_bsp() is shared between 32 and 64 so if that
code works then I can't really find a need for amd_bsp_mpb at all.

So my current plan is to look into who calls load_ucode_amd_bsp() and
load_ucode_amd_ap() and in what sequence (..hopefully in the same
sequence on 32 and 64bit...) and if I can find a rational why
amd_bsp_mpb can be killed, I will send you a patch.
Otherwise I will try to create something that will fail
apply_microcode_amd() in a safe way, if CONFIG_MICROCODE_AMD_EARLY
gets uses on a mixed system.

>> > Btw, your config boots on my F14h box with "nomodeset" on the command
>> > line because it is missing radeon firmware for my gpu.
>>
>> I suspect a F14h box will never see that hang. It trips over the the
>> C1E erratum and amd_erratum_400[] looks like it only affects 0xfh and
>> 0x10h (like my Phenom II X6).
>
> I could fire up my F10h if needed :)
>
>> >> executed and all the loaded patches will end up in a global list for all
>> >> CPUs anyway.
>> >> * Return -1 (like Intels apply_microcode) when the loading fails,
>> >> also do not set the active microcode level on failure.
>> >
>> > Yep, this part I want. Please send it as a separate patch.
>>
>> OK, will send that together with the resend for cpu_has_amd_erratum().
>
> Ok.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
