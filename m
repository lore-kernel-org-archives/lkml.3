Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3GXOO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:14:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45929 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab3GXOOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:14:22 -0400
Date: Wed, 24 Jul 2013 16:14:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix early microcode loading on AMD
Message-ID: <20130724141414.GH30777@pd.tnic>
References: <20130723135853.579c3cd5@googlemail.com>
 <20130723151552.GF8497@pd.tnic>
 <CAPVoSvR30mjRq8Kcp34akb6R1oTi4Y+z7CCO_8FWK5cGd-W61A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPVoSvR30mjRq8Kcp34akb6R1oTi4Y+z7CCO_8FWK5cGd-W61A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 06:57:12PM +0200, Torsten Kaiser wrote:
> >> * Save the amd_bsp_mpb on every update. Otherwise someone could offline
> >> the BSP, update the microcode and this would be lost on resume
> >
> > Huh, is amd_bsp_mpb going to disappear all of a sudden?
> >
> > And that doesn't matter because when we online the BSP later, it goes
> > through the CPU hotplug notifier mc_cpu_callback. Or am I missing
> > something?
> 
> Yeah, me correctly describing what I was meaning. ;-)
> 
> 1.: boot system, BIOS give microcode rev. X
> 2.: offline the BSP
> 3.: update microcode to rev. Y with Y > X

Right, with cleanup() removed, when you do that step, you go through
load_microcode_amd() which adds the patch to the pcache with
__load_microcode_amd() and a subsequent find_patch will give you Y which
you memcpy to amd_bsp_mpb.

> Because the BSP is not online rev. Y will not be copied into amd_bsp_mpb
> 4.: supend
> 5.: resume, BIOS gives rev. X again
> 6.: amd_bsp_mpb is empty -> rev. Y will not be reapplied.
> 
> >> * apply_ucode_in_initrd() now also needs to save amd_bsp_mbp, because
> >> load_microcode_amd() its no longer doing this and its not using
> >> apply_microcode_amd().
> >> * extract common checks and initialisations from load_ucode_ap() and
> >> load_microcode_amd() to load_microcode_amd_early(). The change from
> >> cpu to x86family in load_microcode_amd() allows to drop the code messing
> >> with cpu_data(cpu), with is wrong anyway because at that point the
> >> per-cpu cpu_info is not yet setup. And these values would later be
> >> overwritten by smp_store_boot_cpu_info() / smp_store_cpu_info().
> >
> > Right, so I was thinking about this. And the code is pretty nasty: we do a
> > load_ucode_amd_ap() but we do add the ucode for the BSP:
> >
> >         if (load_microcode_amd(0, ucode, ucode_size) != UCODE_OK)
> 
> No, that code will not be reached for the BSP, because it is behind:

That's correct - load_ucode_amd_ap() is not supposed to load ucode on
the BSP.

> if (cpu && !ucode_loaded) {
> The BSP has cpu == 0. Thats why I adding the following in my patch:
> +       /* BSP via load_ucode_amd_bsp() */
> +       if (!cpu)
> +               return;
> 
> I don't understand if that is really correct, but that was the
> original behavior, and I didn't feel competent enough to decree that
> calling load_microcode_amd() for the BSP would be save.
> (The code there is strange: There is a load_ucode_amd_bsp() but
> load_ucode_amd_ap() will also be called for the BSP.

Yes, this is strange and this is the confusing issue.

Here's how it should work: we want the BSP to load the microcode, put it
in the pcache and also write it into amd_bsp_mpb. The 32-bit version of
load_ucode_amd_ap() takes it and applies it because we run with paging
off at the time.

> And it seems the call to load_ucode_ap() for the BSP will come from a
> very different place (via trap_init()) that the other CPUs.
> And I did not even try to understand what X86_32 is doing...)

Yep. That question needs sorting too.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
