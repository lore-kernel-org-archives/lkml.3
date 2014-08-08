Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbaHHMyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 08:54:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43209 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142AbaHHMyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 08:54:37 -0400
Date: Fri, 8 Aug 2014 14:54:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: forbid some incorrect metadata
Message-ID: <20140808125430.GC2776@pd.tnic>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-8-git-send-email-hmh@hmh.eng.br>
 <20140728153157.GC5350@pd.tnic>
 <20140728193734.GC9752@khazad-dum.debian.net>
 <20140729104520.GF11179@pd.tnic>
 <20140729202543.GB15382@khazad-dum.debian.net>
 <20140804110942.GC4808@pd.tnic>
 <20140804201836.GA24823@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140804201836.GA24823@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 05:18:36PM -0300, Henrique de Moraes Holschuh wrote:
> > Because I think it would be better if we simply load the microcode blob
> > we get from Intel unchanged. Like we do on AMD.
> 
> And like we currently do on Intel.  We agree on this, I don't want the
> kernel microcode driver to split anything.

Ok.

So if we don't split, we can savely check ->total_size % 1024.

If someone tries to load a microcode blob which has been split and so
on, then we should refuse loading. We want to accept microcode from the
vendor and nothing else glued together.

> I would hope so as well, but I am a bit more sceptical than you on this.

Well, if you spot a discrepancy where they diverge from the SDM, you
make sure you scream loudly.

> "CPUID returns a value in a model specific register in addition to its usual
> register return values. The semantics of CPUID cause it to deposit an update
> ID value in the 64-bit model-specific register at address 08BH
> (IA32_BIOS_SIGN_ID).  If no update is present in the processor, the value in
> the MSR remains unmodified.  The BIOS must pre-load a zero into the MSR
> before executing CPUID. If a read of the MSR at 8BH still returns zero after
> executing CPUID, this indicates that no update is present."
> 
> Reading a revision of zero really is supposed to mean "no update is present
> in the processor", and that's because it must be pre-loaded with a zero
> before cpuid is called.
> 
> IMHO, this mean that one should be really paranoid over any Intel microcode
> update that claims to have a revision of zero.  Intel wouldn't release such
> a microcode update except in error, and we can safely assume we want nothing
> to do with any such update attempts.

Ok, then please change the patch to reflect that - it is not "silicon
microcode" anymore but revision 0 is special and means no update was
done. Which is a proper way for the CPU to signal microcode update
status.

> Yeah, well, if you have CONFIG_X86_MSR enabled, all bets are off.  Thanks
> for reminding me about that one.

Yes, the only thing you need is the ability to execute *MSR insns in ring0.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
