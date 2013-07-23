Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab3GWPQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:16:00 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55368 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab3GWPP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:15:59 -0400
Date: Tue, 23 Jul 2013 17:15:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH]Fix early microcode loading on AMD
Message-ID: <20130723151552.GF8497@pd.tnic>
References: <20130723135853.579c3cd5@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130723135853.579c3cd5@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 01:58:53PM +0200, Torsten Kaiser wrote:
> Fixup the early AMD microcode loading.
> 
> * load_microcode_amd() (and the helper its using) should not have an
> cpu parameter.

Hmm, I don't think so - we get the cpu handed down from microcode_core
and besides the early load on 32bit needs to do find_patch(cpu).

> The microcode loading is not depending on the CPU it is

Mostly. There are mixed-stepping boxes which need to differentiate
between which cpu we're applying the patch for.

Btw, your config boots on my F14h box with "nomodeset" on the command
line because it is missing radeon firmware for my gpu.

> executed and all the loaded patches will end up in a global list for all
> CPUs anyway.
> * Return -1 (like Intels apply_microcode) when the loading fails,
> also do not set the active microcode level on failure.

Yep, this part I want. Please send it as a separate patch.

> * Save the amd_bsp_mpb on apply, not on load. Otherwise someone could
> later load an older microcode file that would overwrite amd_bsp_mpb,
> but would not be applied to the CPUs

See the patch id check in apply_ucode_in_initrd()?

	if (eq_id == mc->hdr.processor_rev_id && rev < mc->hdr.patch_id)


> * Save the amd_bsp_mpb on every update. Otherwise someone could offline
> the BSP, update the microcode and this would be lost on resume

Huh, is amd_bsp_mpb going to disappear all of a sudden?

And that doesn't matter because when we online the BSP later, it goes
through the CPU hotplug notifier mc_cpu_callback. Or am I missing
something?

> * apply_ucode_in_initrd() now also needs to save amd_bsp_mbp, because
> load_microcode_amd() its no longer doing this and its not using 
> apply_microcode_amd().
> * extract common checks and initialisations from load_ucode_ap() and
> load_microcode_amd() to load_microcode_amd_early(). The change from
> cpu to x86family in load_microcode_amd() allows to drop the code messing
> with cpu_data(cpu), with is wrong anyway because at that point the
> per-cpu cpu_info is not yet setup. And these values would later be
> overwritten by smp_store_boot_cpu_info() / smp_store_cpu_info().

Right, so I was thinking about this. And the code is pretty nasty: we do a
load_ucode_amd_ap() but we do add the ucode for the BSP:

	if (load_microcode_amd(0, ucode, ucode_size) != UCODE_OK)

so the actual problem is apply_microcode_amd() using as an arg cpu != 0.
And we can take care of that by using, say __apply_microcode_amd() and
hand it the BSP's patch.

The other problem I see is not updating c->microcode since it is going
to be overwritten by smp_store_cpu_info, which is unfortunate.

And I don't see where Intel are updating that cpuinfo_x86.microcode
field on early load too.

So, AFAICT, c->microcode would remain unset when we only do early
microcode load. But that is something we should fix as a later patch.

So I think you should switch load_ucode_amd_ap to __apply_microcode_amd:

	p = find_patch()

	__apply_microcode_amd(p->mc_data);

which should take care of the issue you're seeing, IMHO.

> * fold collect_cpu_info_amd_early() into load_ucode_amd_ap(), because its
> only used at one place.

Yes, that should be done especially since we are not going to touch
cpuinfo_x86 fields anymore.

> * load_ucode_ap(): Quick exit for !cpu, because without load_microcode_amd()
> getting called apply_microcode_amd() can't do anything. Exit, if no microcode
> could be loaded.

This could probably be a WARN_ON(!cpu) to catch errors...

And so on.

So I see a couple of issues in this patch and they should be separated
into single patches - one patch taking care of one issue and explaining
what the problem is in the commit message (I know you can do that good
:)).

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
