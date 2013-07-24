Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3GXOTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:19:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34261 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab3GXOTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:19:35 -0400
Date: Wed, 24 Jul 2013 16:19:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix early microcode loading on AMD
Message-ID: <20130724141927.GI30777@pd.tnic>
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
> > The other problem I see is not updating c->microcode since it is going
> > to be overwritten by smp_store_cpu_info, which is unfortunate.
> >
> > And I don't see where Intel are updating that cpuinfo_x86.microcode
> > field on early load too.
> >
> > So, AFAICT, c->microcode would remain unset when we only do early
> > microcode load. But that is something we should fix as a later patch.
> 
> I don't see a problem with that staying unset.
> apply_microcode_amd() directly reads the rev from
> MSR_AMD64_PATCH_LEVEL so it does not depend on that being correct.
> And smp_store_(boot)_cpu_info will also read the current rev directly
> from the CPU to fill ->microcode.

We need to store the actual microcode revision to c->microcode for
/proc/cpuinfo and MCE.

> 
> > So I think you should switch load_ucode_amd_ap to __apply_microcode_amd:
> >
> >         p = find_patch()
> >
> >         __apply_microcode_amd(p->mc_data);
> >
> > which should take care of the issue you're seeing, IMHO.
> 
> The issue I'm seeing is that collect_cpu_info_amd_early() fills c->x86
> but not c->x86_vendor.
> Which breaks cpu_has_amd_erratum() and then Erratum 400 breaks the boot.
> 
> I did not really want to switch from apply_microcode_amd() to
> __apply_microcode_amd() because then I would lose the check if the new
> microcode is really an upgrade.

Well, if the BSP has already loaded the pcache, there's no need for
the AP to parse and load the same microcode blobs file for the initrd,
right?

> >> * load_ucode_ap(): Quick exit for !cpu, because without load_microcode_amd()
> >> getting called apply_microcode_amd() can't do anything. Exit, if no microcode
> >> could be loaded.
> >
> > This could probably be a WARN_ON(!cpu) to catch errors...
> 
> No, load_ucode_ap() will be called for cpu == 0.

This needs fixing IMO...

Btw, thanks for looking at this and asking critical questions!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
