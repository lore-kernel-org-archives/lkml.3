Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965765Ab3E2LGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 07:06:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57336 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965542Ab3E2LGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 07:06:49 -0400
Date: Wed, 29 May 2013 13:06:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] x86/microcode: early microcode patch loading
 support on AMD
Message-ID: <20130529110643.GB16556@pd.tnic>
References: <1369323618-5820-1-git-send-email-jacob.shin@amd.com>
 <1369323618-5820-4-git-send-email-jacob.shin@amd.com>
 <20130528224529.GC29233@pd.tnic>
 <20130528234307.GA20622@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130528234307.GA20622@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 06:43:07PM -0500, Jacob Shin wrote:
> > Anyway, this whole Kconfig microcode section could use a simplification
> > but this is not the subject of this patchset - I'll try to address it
> > after this, as stated in another mail.
> 
> Yes, I'll simplify the Kconfig as you suggested in your ealier email.

You don't necessarily have to - as I explained in the other mail,
distros end up enabling both anyway so we probably don't need the vendor
split. Instead, simply having microcode loading and early microcode
loading functionality seems like enough to me.

But this is another conversation so you don't have to address it now.

> > At least I can't seem to trigger any build failures when I comment them
> > out.
> 
> Hm.. I couldn't build without it at some point, I'll take them out but they
> might be indrectly included anyways.

Yes, let's leave them out. I'll run randconfig builds when your patches
are ready and we'll see.

...

> > Why do we even need this? Hotplug should take care of reappying
> > microcode on all cores.
> 
> It is needed because otherwise BSP does not reapply microcode on resume, see
> microcode_core.c BSP resume code path.

Ah, we don't hotplug the BSP, sure - I was looking at the the
mc_cpu_notifier...

...

> > Right, come to think of it, we don't use this uci->mc thing anywhere
> > except in mc_bp_resume. But even there, we call ->apply_microcode()
> > which on AMD searches the patch in the patch cache so no need for this
> > assignment at all.
> 
> Right, but at least we need a non-zero value, I can stick "1" in there I guess.
> Whatever you prefer.

That's for the BSP, right? Yeah, ok, then please just leave it like it
is but add a nice comment why we're doing it.

...


> > This comment needs a bit of scrubbing, spell- and readability check.
> > 
> > And it says we cannot traverse the pcache and yet we traverse it with
> > find_patch().
> > 
> > ???
> 
> What I meant was that we can traverse it now, but on 32 bits, later when we
> go into suspend and resume, we since we load before paging is turned on, we
> cannot traverse through equiv_cpu_table and pcache.

Ok, I get it now.

...

> BSP cannot vmalloc() for both 32 and 64 bits, so we cannot "install"
> equiv_cpu_table, also cannot create pcache yet.

But we can use the one in the initrd, extract the information and save
it locally like you do with the bsp_mpb. Then, when later another
microcode blob gets loaded, we simply not use the initial one.

I don't know whether that is a more favourable approach, though - I'm
just conjecturing here.

> On 32 bits, APs cannot vmalloc(), so we take the same code path as the BSPs
> loading from initrd memory, and not installing equiv_cpu_table and not creating
> pcache.

... which sounds to me like this functionality needs to be extracted in
a function callable by BSP and AP path.

> Okay I'll just rewrite the the whole thing tomorrow,
>
> I'll separate out the early stuff by itself into microcode_amd_early.c
>
> And try and word the comments clearer.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
