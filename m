Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbaFHUsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 16:48:15 -0400
Received: from ns.horizon.com ([71.41.210.147]:53872 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753744AbaFHUsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 16:48:03 -0400
Date: 8 Jun 2014 16:48:00 -0400
Message-ID: <20140608204800.7610.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: davem@davemloft.net, dborkman@redhat.com, hannes@stressinduktion.org,
        linux@horizon.com, shemminger@osdl.org, tytso@mit.edu
Subject: Re: [PATCH 5/7] lib/random32.c: Make prandom_u32_max efficient for powers of 2
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1402248852.14095.126480525.5C81F8C6@webmail.messagingengine.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for your comments!

> Have you checked assembler output if this helps anything at all? Constant
> propagation in the compiler should be able to figure that out all by
> itself. The only places I use __builtin_constant_p today are where I
> also make use of inline assembler.

Yes, I did.  (I'll expand the commit comment for v2; my bad.)

It seems that GCC isn't smart enough to reduce this to a single shift.
With the multiply and reduce, the code looks like:
        call    prandom_u32
        xorl    %edx, %edx
        shldl   $4, %eax, %edx
        movl    %edx, %eax

Instead of the hoped-for
        call    prandom_u32
	shrl	$28, %eax

Converting to a single mask is something the compiler can't do,
because it doesn't understand that using the lsbits instead of the
msbits is okay.

With the mask, it turns into the spectacularly simple:
        call    prandom_u32
        andl    $15, %eax

An interesting question is which is preferred in general.

The AND allows non-constant powers of 2 without requiring CLZ.  But I
don't recall seeing that actually happen anywhere.  And the shift allows
a smaller encoding (8-bit rather than 32-bit immediate constant) when
the power of 2 is known at compile time and is larger than 128 (for
example, PAGE_SIZE).

Me, I thought it was in the noise and not worth stressing about,
but I also understand the hackers's urge for maximum tweaking.


The other thing that I couldn't think of a clean wrapper for is the
"probability 1 in N" case that happens in several bits of code.
For example, in drivers/mtd/ubi/debug.h, I made the following change:

 static inline int ubi_dbg_is_bitflip(const struct ubi_device *ubi)
 {
-	if (ubi->dbg.emulate_bitflips)
-		return !(prandom_u32() % 200);
-	return 0;
+	return ubi->dbg.emulate_bitflips && prandom_u32() < -1u/200;
 }

GCC doesn't know how to optimize "prandom_u32_max(200) == 0", which
is basically the same.  It spits out:

        call    prandom_u32
        movl    %eax, %edx
        movl    $200, %eax
        mull    %edx
        testl   %edx, %edx

I couldn't think of a good enough function name for this, so I just left
it as inline code.  (Using "-1u/200" rather than the technically correct
"(u32)(((u64)1 << 32)/200)" is okay as long as 200 isn't a power of 2, and
even if it were, the error wouldn't matter since it's approximate anyway.)

> Btw, IIRC there is a function is_power_of_2 somewhere. ;)

In <linux/log2.h>; thanks for the pointer.
