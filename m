Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3GXRtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:49:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54622 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab3GXRto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:49:44 -0400
Date: Wed, 24 Jul 2013 19:49:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix early microcode loading on AMD
Message-ID: <20130724174936.GJ30777@pd.tnic>
References: <20130723135853.579c3cd5@googlemail.com>
 <20130723151552.GF8497@pd.tnic>
 <CAPVoSvR30mjRq8Kcp34akb6R1oTi4Y+z7CCO_8FWK5cGd-W61A@mail.gmail.com>
 <20130724134130.GF30777@pd.tnic>
 <CAPVoSvSPB_UKO-g6032LCd3CBTbTJmrOtJcFfnU7O_e5nG8cng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPVoSvSPB_UKO-g6032LCd3CBTbTJmrOtJcFfnU7O_e5nG8cng@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 04:20:58PM +0200, Torsten Kaiser wrote:
> First moving that hunk, then switching from cpu to x86family did work.
> See patch 4/5 and 5/5. :-)

I will get to those eventually.

> > No, we load the microcode based on CPUID(1).EAX which is in the
> > equivalence table. Look at find_equiv_id().
> >
> > But for that we need all patches belonging to the current family to be
> > in the cache.
> 
> I think you confused *load* and *apply*.

No I didn't - I meant what I said, I simply pointed at the wrong
function. find_cpu_family_by_equiv_cpu() at the beginning of
verify_and_add_patch() does look at the family when *loading*.

> That function (or better its helper find_patch()) need the full
> stepping/masking. I did not change that function, because in that case
> 'cpu' makes sense as a parameter, because the microcode needs to be
> applied for each CPU. (You could argue that that parameter is also
> stupid: If you ever pass something else as raw_smp_processor_id()
> then it will BUG(). But removing that parameter would need to change
> the whole microcode_core.c and also microcode_intel.c. And there
> that parameter might make sense, so it's better to keep 'cpu' for
> apply_microcode_amd())

No reason to deal with it if it is only a hypothetical issue.

> But wrt. you concern about mixed stepping systems: There early
> microcode loading is definitly broken for 32bit. The current mainline
> code will save the patch for the BSP in amd_bsp_mpb and then apply
> that to all CPUs irregardless of its stepping. With my change in 4/5
> to move the amd_bsp_mpb setup to apply time it will now wrongly patch
> all CPUs with the microcode that was loaded last.
>
> But u8 amd_bsp_mpb[NR_CPUS][MPB_MAX_SIZE] doesn't look like a good
> idea. Maybe the best way here is to fail apply_microcode_amd()
> if amd_bsp_mpb already contains an incompatible patch and in
> load_ucode_amd_ap() only apply it when the cpu_sig matches. Or u8
> amd_bsp_mpb[4][MPB_MAX_SIZE] which would support up to 4 different
> steppings per system.

Yes, I think 4 should be more than enough.

And I think this should be prepared in save_microcode_in_initrd_amd()
like this: look at all APs - if they have mixed steppings, save the
following mapping:

	CPUID(1).EAX -> patch blob.

Then, at load_ucode_amd_ap() during resume from suspend, we get do
CPUID(1) on the current AP, get the patch blob and apply it.

Something like that...

> No patch yet, because I do not understand why that is not a problem
> on 64bit. load_ucode_amd_bsp() is shared between 32 and 64 so if that
> code works then I can't really find a need for amd_bsp_mpb at all.

On 64-bit we create the pcache with the first call to
load_microcode_amd() on the first AP. For all the subsequent APs, we do
find_patch(cpu) so no need to cache a BSP patch.

> So my current plan is to look into who calls load_ucode_amd_bsp()
> and load_ucode_amd_ap() and in what sequence (..hopefully in the
> same sequence on 32 and 64bit...) and if I can find a rational why
> amd_bsp_mpb can be killed, I will send you a patch.

See above.

> Otherwise I will try to create something that will fail
> apply_microcode_amd() in a safe way, if CONFIG_MICROCODE_AMD_EARLY
> gets uses on a mixed system.

Remember: we either *must* apply a microcode patch on *all* cores or not
at all. But with the suggestion above I think that should be not that
hard.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
