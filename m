Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaKCK4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:56:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37266 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbaKCKzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:55:14 -0500
Date: Mon, 3 Nov 2014 11:55:08 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Pala <gotar@polanet.pl>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] amd64_edac: Build module on x86-32
Message-ID: <20141103105508.GB27384@pd.tnic>
References: <20141102102212.GA7034@polanet.pl>
 <20141102103300.GB5229@pd.tnic>
 <20141102121139.GA7000@polanet.pl>
 <20141102123538.GE5229@pd.tnic>
 <20141102140839.GA27342@polanet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141102140839.GA27342@polanet.pl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 02, 2014 at 03:08:39PM +0100, Tomasz Pala wrote:
> Can't say - such error (noticed) happened to me only once, how many silent bit
> rots I've missed is hard to say, as I haven't got data checksums before.
> The previous modules were well tested in this motherboard, so I can't
> blame them nor any other component - it's a 'cosmic ray' situation.

So we still don't know. I wouldn't throw away the old DIMMs if it is a
single failure only.

> OK, with EDAC_DECODE_MCE I would know if I should blame RAM or not. But
> if UCE rate is 1/year I can't randomly remove modules and wait if the
> problem is gone. Any single UCE should result in action that narrows
> down the possibile causes. Other than 'replace entire RAM' obviously.

I think with UCE you mean uncorrectable error?

If so, those normally announce themselves by a bunch of correctable
errors prior. Which roughly means, a DIMM usually announces that it is
going to get bad soon.

So yes, enabling EDAC_DECODE_MCE should be a good first step as it will
tell you when errors occur.

Btw, I forgot to ask, why are you even running 32-bit? Do you have some
old K8 CPU which is not 64-bit capable?

As a matter of fact, can you apply your patch, enable CONFIG_EDAC_DEBUG
and catch dmesg and send it to me, privately is fine too.

> 1. Yes, I'm going to test, but no, I'm not capable of fixing it, sorry.
> 1a. There were other reporters you said, maybe some of them are capable.

Well, I haven't seen anything besides this one patch, similar to yours.
And they've claimed that it works. But the devil is in the detail as
always so what I'm afraid of is we enable this and then months later,
once it trickles down to more users, bug reports start coming in. Bug
reports which no one would have time to address and maybe fix.

I guess we can add this hunk to your patch, albeit a bit controversial:

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 1a1d7c43a20f..17638d7cf5c2 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -3035,6 +3035,11 @@ static int __init amd64_edac_init(void)
 		goto err_no_instances;
 
 	setup_pci_device();
+
+#ifdef CONFIG_X86_32
+	amd64_err("%s on 32-bit is unsupported. USE AT YOUR OWN RISK!\n", EDAC_MOD_STR);
+#endif
+
 	return 0;
 
 err_no_instances:

> 2. Were there any op-mode specific issues in this code till now? Does
>    this differ from not having e.g. F10h hardware? If that happens, I
>    might grant remote access to such machine, but that's unfortunatelly all.


> 3. Didn't know that lack of resources to support discrepancies that might
>    occur (but not occuring right now) is valid reason for disabling module
>    entirely. After all, there are many parts that are not maintained
>    actively at all and nobody removes them preemptively. Back then it
>    could be (X86_64 || EXPERIMENTAL), couldn't now it be just a note in
>    the description?

EXPERIMENTAL is gone from the kernel.

And as I explained already, I just don't have the bandwidth and am not
really persuaded supporting 32-bit is worth the effort to do it. It is a
conscious decision. That's why I say, if people want it, they can send
me fixes but cannot expect me to fix stuff.

> 4. To be honest I think that more people are abandoning x86-32 than
>    enabling ECC on them, so I wouldn't worry about people starting to use this
>    and report 32-bit related errors. If you got reports on this once per a few
>    months that's the order of magnitude we are talking about.

Probably. And yes, people should abandon 32-bit if they haven't done so! :-D

> So, if 32-bit related error are real threat, not just an excuse, ENOTIME
> for handling them is fair enough - people determined to have this
> running like me will find their way. But please don't say it's not
> _worth_ it, Kconfig descriptions are not a place to make such judgements
> (as it's YOUR time vs MY data). I'd go for something more objective,
> like "this driver might be run on 32-bit kernel, however no complains
> would be accepted due to lack of resources to handle 32-bit specific
> bugs").

Fair enough. How about the warning above? It will issue upon successful
loading on 32-bit.

But I'd still like to know what is the reason you're not moving to 64-bit.

> Oh, and one more thing about the proposed description - I've noticed before:
> 
> [PATCH 01/16] amd64_edac: Remove F11h support
> Fri, 26 Nov 2010 20:04:08 +0100
> 
> F11h doesn't support DRAM ECC so whack it away.
> 
> and I see F10h, F15h and F16h families only mentioned in amd64_edac.c.

I don't understand what you mean here...

The driver supports everything from K8 on which can do ECC. Family 11h
doesn't support ECC so no need for an EDAC driver. I hope this answers
your question.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
