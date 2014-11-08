Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaKHV6G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 16:58:06 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52839 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752465AbaKHV6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 16:58:03 -0500
X-Sasl-enc: 2fBgP8ApORvXdiodoGpmTh9yK9ghlajEzSpxvBBiS1BO 1415483881
Date: Sat, 8 Nov 2014 19:57:49 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 7/8] x86, microcode, intel: guard against misaligned
 microcode data
Message-ID: <20141108215749.GC32023@khazad-dum.debian.net>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-8-git-send-email-hmh@hmh.eng.br>
 <20141107195905.GE5180@pd.tnic>
 <20141107225425.GC18128@khazad-dum.debian.net>
 <20141107234806.GG5180@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141107234806.GG5180@pd.tnic>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Nov 2014, Borislav Petkov wrote:
> On Fri, Nov 07, 2014 at 08:54:25PM -0200, Henrique de Moraes Holschuh wrote:
> > Well, it might well be lost in the noise given how slow a microcode update
> > is.
> > 
> > What I mean is that the early microcode driver "won't waste cpu time moving
> > data that is already aligned".
> 
> Yes, don't say "faster" but explain that we can save us the shuffling
> of microcode data back and forth in the early loader if the microcode
> update is 16-byte aligned in the initrd.

Will change.

> > That WARN_ONCE() should only trigger if a bug shows its ugly face.  If it is
> > triggering in any other case, this patch is broken.
> > 
> > mc_intel->bits in the late driver really shouldn't depend at all on any
> > alignment from initramfs or whatever: that path is supposed to run on
> > microcode that came from the firmware loader, or the deprecated microcode
> 
> Right, the early path is apply_microcode_early() - I misread that part,
> sorry.
> 
> > device, or which was memcpy'd from the initramfs to a kmalloc()'d area by
> > save_microcode() in the early driver.  All of these will always be 16-byte
> > aligned AFAIK.
> 
> Why will it always be 16-byte aligned? And if it is going to be always
> 16-byte aligned, why do we need the WARN_ONCE() at all?

...

> > So, the early driver gets alignment code as it will usually have to deal
> > with unaligned microcode data, and the late driver (which should never see
> > unaligned microcode data) gets a WARN_ONCE to alert us if something broke in
> > the kernel code.
> > 
> > Should I change the WARN_ONCE message to:
> > 
> > WARN_ONCE(... "kernel bug: microcode data incorrectly aligned") ?
> 
> No, you should either give a possible scenario where an unaligned
> pointer can really happen or, alternatively, if you can prove that the
> condition will never happen, drop the WARN_ONCE completely.

If I know of a non-kernel-bug scenario where it could happen, I'd have added
code that fixes the alignment like I did in the early driver...

AFAIK, that WARN_ON is only going to trigger if kmalloc changes and starts
returning less strictly aligned data, or if something is corrupting memory.

I will remove the WARN_ONCE, and place a comment in its place:

/*
 * the memory area holding the microcode update data must be 16-byte
 * aligned.  This is supposed to be guaranteed by kmalloc().
 */

> Oh, and even if the WARN_ONCE triggers, what can we do about it? If we
> can't do anything about it, then we have a problem. If we can, then we
> better do it and change the WARN_ONCE to an if-check which, if positive,
> executes code that fixes the situation.

All we could do is abort the update.  The real reason behind the
misalignment would have to be tracked in order to know what should be done
about it.

> IOW, what I'm trying to say is, can we make the kmalloc'ed memory
> 16-byte aligned and if so, then copy the microcode data there and be
> happy. And I think we can... :-)

Sure, we can.  But AFAIK kmalloc() is supposed to already give us a 16-byte
aligned data area.

> > Neither do I.  But this has zero footprint on the resulting kernel, and
> > might save someone 10 years from now from trying to debug initramfs data
> > corruption.
> 
> ... and someone might waste a lot of time 10 years from now trying
> to fathom why the hell that thing was added, only to realize that
> someone was being unreasonably overzealous. No, we don't add code for
> hypothetical cases which are absolutely improbable.

I will drop it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
