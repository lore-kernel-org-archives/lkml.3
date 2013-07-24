Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab3GXN4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:56:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42478 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3GXN4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:56:17 -0400
Date: Wed, 24 Jul 2013 15:56:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix early microcode loading on AMD
Message-ID: <20130724135610.GG30777@pd.tnic>
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
> >> * Save the amd_bsp_mpb on apply, not on load. Otherwise someone could
> >> later load an older microcode file that would overwrite amd_bsp_mpb,
> >> but would not be applied to the CPUs
> >
> > See the patch id check in apply_ucode_in_initrd()?
> >
> >         if (eq_id == mc->hdr.processor_rev_id && rev < mc->hdr.patch_id)
> 
> I meant with "load" load_microcode_amd() not the loading of the
> microcode into the CPU.
> 
> 1.: load microcode rev X into CPU (early or normal is not important)
> 2.: get older microcode file that only contains rev Y with Y<X
> 3.: trigger load_microcode_amd() with a corrupt file: This will call
> cleanup() and empty pcache.

Ok, that's actually a good catch. So I wonder: why in hell would we
flush the pcache if some of the blobs we're loading are corrupted. So
what?! Jacob, what were you thinking - I'd be very interested to know
what the idea behind this was.

So, just to refresh everybody: the idea of the pcache is to keep all
patches for the current family in memory so that we can support all
sorts of hotplug and cpu mixed stepping diddling.

> 4.: trigger load_microcode_amd() with the older file:
>  * this will now load rev Y into pcache
>  * rev Y will be returned by find_patch and copied into amd_bsp_mpb
>  * any try to apply rev Y will be skipped in apply_microcode_amd()
> 
> So now the CPU still correctly has rev X, but amd_bsp_mpb will contain
> the wrong rev Y.

Right, so this shouldn't happen - what should happen is, pcache would
hold both X and Y and find_patch would automatically give you the right
one.

And this is guaranteed since we keep the patches in a sorted linked list
by ->patch_id which is guaranteed to be increasing.

So actually load_microcode_amd() shouldn't be doing cleanup() but simply
return ret upwards.

> That copying already in load_microcode also is suspicious if someone
> would only load the microcode but not apply it. But I did not find
> a codepath in arch/x86/kernel/microcode_core.c to load it without a
> followup apply.

Yeah, we always load and apply.

So now back to the original problem - load_microcode_amd() shouldn't
clear the pcache and, in that case, a subsequent find_patch() would
always give the right patch.

Ok?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
