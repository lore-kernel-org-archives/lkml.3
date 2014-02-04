Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaBDQkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:40:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50630 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbaBDQk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:40:29 -0500
Date: Tue, 4 Feb 2014 17:40:22 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [RFC][PATCH] ia64: Fix atomic ops vs memory barriers
Message-ID: <20140204164022.GZ5002@laptop.programming.kicks-ass.net>
References: <20140204122212.GO8874@twins.programming.kicks-ass.net>
 <CA+55aFz6LGt35C2ex6qCM8cQDowmr9HR-+hR9bMXJPE707+k-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz6LGt35C2ex6qCM8cQDowmr9HR-+hR9bMXJPE707+k-A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 08:29:36AM -0800, Linus Torvalds wrote:
> On Tue, Feb 4, 2014 at 4:22 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > The below patch assumes the SDM is right (TM), and fixes the atomic_t,
> > cmpxchg() and xchg() implementations by inserting a mf before the
> > cmpxchg.acq (or xchg).
> 
> You picked the wrong thing to be right. The SDM is wrong.

Figured, just my luck :-)

> Last time this came up, Tony explained it thus:
> 
> >> Worse still - early processor implementations actually just ignored
> >> the acquire/release and did a full fence all the time.  Unfortunately
> >> this meant a lot of badly written code that used .acq when they really
> >> wanted .rel became legacy out in the wild - so when we made a cpu
> >> that strictly did the .acq or .rel ... all that code started breaking - so
> >> we had to back-pedal and keep the "legacy" behavior of a full fence :-(

That would make a lovely comment near ia64_cmpxchg().

> and since ia64 is basically on life support as an architecture, we can
> pretty much agree that the SDM is dead, and the only thing that
> matters is implementation.
> 
> The above quote was strictly in the context of just cmpxchg, though,
> so it's possible that the "fetchadd" instruction acts differently. I
> would personally expect it to have the same issues, but let's see what
> Tony says.. Tony?

I would suspect it to be a full fence too, let me do the reverse patch.

---
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -65,11 +65,8 @@ __set_bit (int nr, volatile void *addr)
 	*((__u32 *) addr + (nr >> 5)) |= (1 << (nr & 31));
 }
 
-/*
- * clear_bit() has "acquire" semantics.
- */
-#define smp_mb__before_clear_bit()	smp_mb()
-#define smp_mb__after_clear_bit()	do { /* skip */; } while (0)
+#define smp_mb__before_clear_bit()	barrier();
+#define smp_mb__after_clear_bit()	barrier();
 
 /**
  * clear_bit - Clears a bit in memory
--- a/arch/ia64/include/uapi/asm/cmpxchg.h
+++ b/arch/ia64/include/uapi/asm/cmpxchg.h
@@ -118,6 +118,15 @@ extern long ia64_cmpxchg_called_with_bad
 #define cmpxchg_rel(ptr, o, n)	\
 	ia64_cmpxchg(rel, (ptr), (o), (n), sizeof(*(ptr)))
 
+/*
+ * Worse still - early processor implementations actually just ignored
+ * the acquire/release and did a full fence all the time.  Unfortunately
+ * this meant a lot of badly written code that used .acq when they really
+ * wanted .rel became legacy out in the wild - so when we made a cpu
+ * that strictly did the .acq or .rel ... all that code started breaking - so
+ * we had to back-pedal and keep the "legacy" behavior of a full fence :-(
+ */
+
 /* for compatibility with other platforms: */
 #define cmpxchg(ptr, o, n)	cmpxchg_acq((ptr), (o), (n))
 #define cmpxchg64(ptr, o, n)	cmpxchg_acq((ptr), (o), (n))
