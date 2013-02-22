Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3BVIys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 03:54:48 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:42771 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3BVIym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 03:54:42 -0500
Date: Fri, 22 Feb 2013 09:54:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] nohz: Make tick_nohz_irq_exit() irq safe
Message-ID: <20130222085438.GA29144@gmail.com>
References: <1361373336-11337-1-git-send-email-fweisbec@gmail.com>
 <alpine.LFD.2.02.1302202155320.22263@ionos>
 <CA+55aFwTFOsRTX3pHeZ+664rAms-Liwco3scEPJum6=C3BCoEQ@mail.gmail.com>
 <alpine.LFD.2.02.1302211920440.22263@ionos>
 <CA+55aFwj0bVS0H1YBMq9EHbkYrU7-so8S6onCKs2M1Q+g4AmNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwj0bVS0H1YBMq9EHbkYrU7-so8S6onCKs2M1Q+g4AmNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Feb 21, 2013 at 10:21 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > This was a draft patch. I made it a WARN_ON_ONCE() already.
> 
> Ok, good.
> 
> I really wish we could just get rid of BUG_ON(). It was a bad 
> idea, and it makes it easy for people to do the wrong thing. 
> Sadly, we have tons of them.

So my old plan was to use a little bit of psychology.

Firstly, we could just turn BUG_ON() into a WARN() variant that 
emits:

  BUG: ...

while a WARN()ings emit:

  WARNING: ...

and then we could introduce a new primitive:

  CRASH_ON();

which would be used in the (few) places that really, really 
cannot continue sanely and need to crash the box.

This naming alone would inhibit its use through two channels:

 - Putting the word 'CRASH' into your code feels risky, 
   dissonant and wrong (perfect code does not crash) and thus 
   needs conscious frontal lobe effort to justify it - while 
   BUG_ON() really feels more like a harmless assert to most 
   kernel developers, which is in our muscle memory through 
   years training.

 - CRASH_ON() takes one character more typing than WARN_ON(), 
   and we know good kernel developers are fundamentally lazy.

[ This is an arguably lazy plan that does not involve changing 
  the 10,000+ BUG_ON() call sites and does not involve the
  re-training of thousands of mis-trained kernel developers who 
  introduced over 900 new BUG_ON()s in the v3.7->v3.8 cycle 
  alone (!). ]

So while I don't think we can win the war against BUG_ON(), I 
think we can fight the lazy general's war: turn the enemy over 
to our side and declare victory?

Thanks,

	Ingo
