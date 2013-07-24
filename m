Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3GXNlj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 09:41:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43392 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab3GXNli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 09:41:38 -0400
Date: Wed, 24 Jul 2013 15:41:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix early microcode loading on AMD
Message-ID: <20130724134130.GF30777@pd.tnic>
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

Let me try to answer this as well as I can, peacemeal-wise.

On Tue, Jul 23, 2013 at 06:57:12PM +0200, Torsten Kaiser wrote:
> On Tue, Jul 23, 2013 at 5:15 PM, Borislav Petkov <bp@alien8.de> wrote:
> > On Tue, Jul 23, 2013 at 01:58:53PM +0200, Torsten Kaiser wrote:
> >> Fixup the early AMD microcode loading.
> >>
> >> * load_microcode_amd() (and the helper its using) should not have an
> >> cpu parameter.
> >
> > Hmm, I don't think so - we get the cpu handed down from microcode_core
> > and besides the early load on 32bit needs to do find_patch(cpu).
> 
> Thats why I moved that part into apply_microcode_amd(). See later on
> more, why I think that move is the right thing.
> And without that the current cpu parameter will only be used to get
> the (in the early load case not even correctly set up!) per-cpu data.
> But the only member of cpuinfo_x86 that gets uses is ->x86, the family.
> Line 159: switch(c->x86) and Line 301: if (proc_fam!)c->x86)
> 
> I really wanted to make that switch from cpu to x86family a separate
> patch, that it would be more obvious correct, but because of that
> amd_bsp_mpb hunk I can't find a good cut and thats why this patch is
> larger that I would have preferred.

Ok.

> >> The microcode loading is not depending on the CPU it is
> >
> > Mostly. There are mixed-stepping boxes which need to differentiate
> > between which cpu we're applying the patch for.
> 
> Nothing looks at ->x86_model or ->x86_mask during load.
> It will always load all patches from the current family.

Yes, that's the idea. We want to have all patches for the current family
loaded.

> If loading would really depend on the current cpu in a mixed
> system that would be horrible: Depending on which CPU gets execute
> load_microcode_amd() it there would be different patches loaded into
> RAM?

No, we load the microcode based on CPUID(1).EAX which is in the
equivalence table. Look at find_equiv_id().

But for that we need all patches belonging to the current family to be
in the cache.

> > Btw, your config boots on my F14h box with "nomodeset" on the command
> > line because it is missing radeon firmware for my gpu.
> 
> I suspect a F14h box will never see that hang. It trips over the the
> C1E erratum and amd_erratum_400[] looks like it only affects 0xfh and
> 0x10h (like my Phenom II X6).

I could fire up my F10h if needed :)

> >> executed and all the loaded patches will end up in a global list for all
> >> CPUs anyway.
> >> * Return -1 (like Intels apply_microcode) when the loading fails,
> >> also do not set the active microcode level on failure.
> >
> > Yep, this part I want. Please send it as a separate patch.
> 
> OK, will send that together with the resend for cpu_has_amd_erratum().

Ok.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
