Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab3GXSGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:06:16 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48203 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab3GXSGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:06:15 -0400
Date: Wed, 24 Jul 2013 20:06:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix early microcode loading on AMD
Message-ID: <20130724180607.GK30777@pd.tnic>
References: <20130723135853.579c3cd5@googlemail.com>
 <20130723151552.GF8497@pd.tnic>
 <CAPVoSvR30mjRq8Kcp34akb6R1oTi4Y+z7CCO_8FWK5cGd-W61A@mail.gmail.com>
 <20130724135610.GG30777@pd.tnic>
 <CAPVoSvShyTo7ukAu42tJAn29Tt0HtDxGBNDXtvffiioOz5AXmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPVoSvShyTo7ukAu42tJAn29Tt0HtDxGBNDXtvffiioOz5AXmA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 04:44:45PM +0200, Torsten Kaiser wrote:
> Then it would probably be the best to kill free_cache() completely.
> Which would mean cleanup() should also go.
> Which will make unloading microcode_amd.ko impossible.
> But that is probably a good idea anyway: If you unload the module
> there is no way to keep pcache.
> 
> But I still have another way to kill you: free_equiv_cpu_table()
> Without that table find_patch() can't work and will not return the
> correct information.
> 
> And that can be triggered by:
> * start of load_microcode_amd(): If you reach that function (Only
> UCODE_MAGIC needs to be in the file) that table is dead.
> * __load_microcode_amd(): If the file only contains the table but no
> patches ("invalid type field in container file section header\n")

If you have root, there are a gazillion ways to kill the system. Those
are just a couple more, and a bit complicated even :)

> But it already called free_equiv_cpu_table() and so pcache is inaccessible.

That's the old table. __load_microcode_amd() installs the current one.

Ok, I remember now, the situation is a bit different: the container file
has all patches. If we load a new container file, it contains newer
replacements + old ones which remained unchanged:

http://marc.info/?l=linux-kernel&m=137427483928693

So actually, when we encounter an error when loading a new blob,
we have to *keep* the old pcache and equiv_table. Which means
load_microcode_amd() shouldn't free the table *before* doing
__load_microcode_amd() but *after* verifying it succeeded.

> And I don't think just preserving equiv_cpu_table for restoring in
> the error case will be the right solution: If the new firmware file
> contains a new table with fewer entries (or different entries!) some
> of the patches in pcache might become inaccessible.

Yes, see above.

> >> That copying already in load_microcode also is suspicious if someone
> >> would only load the microcode but not apply it. But I did not find
> >> a codepath in arch/x86/kernel/microcode_core.c to load it without a
> >> followup apply.
> >
> > Yeah, we always load and apply.
> >
> > So now back to the original problem - load_microcode_amd() shouldn't
> > clear the pcache and, in that case, a subsequent find_patch() would
> > always give the right patch.
> 
> Not if equiv_cpu_table got mangled.
> So should install_equiv_cpu_table() be turned into
> add_to_equiv_cpu_table() or should pcache save all cpu_sig with each
> patch, so that find_patch() no longer needs equiv_cpu_table?
> I suspect saving that in struct ucode_patch might be better, to
> prevent changes in equiv_id <-> cpu_sig mapping to make a patch
> inaccessible.

Yeah. I remembered :) See above.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
