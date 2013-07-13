Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab3GMWk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 18:40:27 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:37071 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab3GMWk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 18:40:26 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1307131317350.11918@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1307131317350.11918@ionos.tec.linutronix.de>
Date: Sat, 13 Jul 2013 15:40:24 -0700
X-Google-Sender-Auth: XV70zLF5d-BtHkOwFzM3sjrUAj4
Message-ID: <CA+55aFwJAV7DnMAyMm+Hdp3uYrgn+BRcBS4cLGf+KGQCdhKwbg@mail.gmail.com>
Subject: Re: [GIT pull] x86 updates for 3.11
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 4:21 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
>    * Guarantee IDT page alignment

What the F*CK, guys?

This piece-of-shit commit is marked for stable, but you clearly never
even test-compiled it, did you?

Because on x86-64 (the which is the only place where the patch
matters), I don't see how you could have avoided this honking huge
warning otherwise:

  arch/x86/kernel/traps.c:74:1: warning: braces around scalar
initializer [enabled by default]
   gate_desc idt_table[NR_VECTORS] __page_aligned_data = { { { { 0, 0 } } }, };
   ^
  arch/x86/kernel/traps.c:74:1: warning: (near initialization for
‘idt_table[0].offset_low’) [enabled by default]
  arch/x86/kernel/traps.c:74:1: warning: braces around scalar
initializer [enabled by default]
  arch/x86/kernel/traps.c:74:1: warning: (near initialization for
‘idt_table[0].offset_low’) [enabled by default]
  arch/x86/kernel/traps.c:74:1: warning: excess elements in scalar
initializer [enabled by default]
  arch/x86/kernel/traps.c:74:1: warning: (near initialization for
‘idt_table[0].offset_low’) [enabled by default]

and I don't think this is compiler-specific, because that code is
crap. The declaration for gate_desc is very very different for 32-bit
and 64-bit x86 for whatever braindamaged reasons.

Seriously, WTF? I made the mistake of doing multiple merges
back-to-back with the intention of not doing a full allmodconfig build
in between them, and now I have to undo them all because this pull
request was full of unbelievable shit.

And why the hell was this marked for stable even *IF* it hadn't been
complete and utter tripe? It even has a comment in the commit message
about how this probably doesn't matter. So it's doubly crap: it's
*wrong*, and it didn't actually fix anything to begin with.

There aren't enough swear-words in the English language, so now I'll
have to call you perkeleen vittupää just to express my disgust and
frustration with this crap.

            Linus
