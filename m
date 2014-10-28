Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaJ1RbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:31:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37957 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbaJ1RbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:31:13 -0400
Date: Tue, 28 Oct 2014 18:31:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 2/8] x86, microcode, intel: don't update each HT core
 twice
Message-ID: <20141028173109.GB10873@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-3-git-send-email-hmh@hmh.eng.br>
 <20141020133252.GC3524@pd.tnic>
 <20141020182427.GB19306@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141020182427.GB19306@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 04:24:27PM -0200, Henrique de Moraes Holschuh wrote:
> Over time, grepping for that information on reports and logs all over the
> net has helped me a great deal.

Helped you how, for what? I still am searching for a justification to
bother the user with the fact that her microcode just got upgraded. I
mean, she can simply do:

$ grep microcode /proc/cpuinfo | head -1
microcode       : 0x6000822

if needed.

Now, the error cases where the upgrade fails for some unexpected reason
is what we want to know.

> I really miss the full microcode ID information in /proc/cpuinfo, in fact.

Full ID, you mean all fields of struct cpu_signature on Intel?

If so,

   ->sig - CPUID_EAX(1) which is in /proc/cpuinfo

   ->pf - processor flags in MSR_0x17[52:50] - I guess you can read that
   out with rdmsr 0x17. Why do we need to know that one except maybe to
   verify why a patch doesn't get accepted by the loader?

   -> rev - that's in MSR_IA32_UCODE_REV

I'm not really sure we absolutely need those except for debugging. Thus
the pr_debug() suggestion from my side.

> MSR 79H writes are on a class of their own as far as "expensive" goes... On
> a modern i3/i5/i7, it will take approximately one million cycles to complete
> (the larger the microcode update, the longer it takes).
> 
> I don't think people usually associate MSR write with "takes one million
> cycles to complete"...

So? You don't do microcode updates all the time - it is done once during
boot and when cores come back online.

> This is old code, I guess it predates wrmsrl()...
> 
> Should I replace the old split version with wrmsrl() in this patch, or as a
> separate patch?

Yes please. And then add to the commit message something of the sorts
"While at it, ..."

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
