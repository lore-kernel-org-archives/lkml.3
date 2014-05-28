Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaE1XzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:55:19 -0400
Received: from ns.horizon.com ([71.41.210.147]:33695 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751915AbaE1XzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:55:17 -0400
Date: 28 May 2014 19:55:16 -0400
Message-ID: <20140528235516.13714.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tim.c.chen@linux.intel.com
Subject: Re: [PATCH v2] crypto: crc32c-pclmul - Shrink K_table to 32-bit words
Cc: david.m.cote@intel.com, herbert@gondor.apana.org.au,
        james.guilford@intel.com, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, sandyw@twitter.com,
        wajdi.k.feghali@intel.com
In-Reply-To: <1401318135.2970.399.camel@schen9-DESK>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Can you do a tcrypt speed measurement with and without your changes?
> Check to see if there's any slowdown.  Please make sure you pin
> the frequency of your cpu when running the test.  

Sure thing; I was already inspired to do that based on your concerns.
Do you have any particular buffer sizes or alignments you'd suggest?

Since I'm changing only the three-part core, I was going to
avoid unaligned or short buffers, stick with a single buffer so
it stays in L1 D-cache, but vary the length so we use lots of
the K_table.

It's not the RAM I was worried about, but the D-cache wasted on
on the K table.  Which doesn't affect the CRC code itself, but the
surrounding kernel code.


I'm also thinking of some ideas for handling even larger buffer sizes
without having to interrupt the 3-way main loop.  Pclmulqdq can
mutiply up to 4 32-bit values to produce a 128-bit result, which
crc32 can efficiently reduce.  So if we have three tables, of
x^(64*n) x^(4096*n), and x^(262144*n), each for n=0..63, we can
multiply them all together to handle up to a 16 MiB chunk.

The other option is to schedule the pclmulqdq in parallel with
the crc32q iterations and, after arranging a staggered start,
have a 4-part main loop, where 3 parts are performing crc32q
iterations and the fourth is using SSE to shift itself
forward (at which point it gets XORed into the data stream
that one other part is working on).

I haven't got all the details of that idea worked out in my head, but
it seems possible.  I have to study the optimization guide in detail to
see how many micro-ops the crc32q instruction from memory is (and thus
how much of the decoder it requires).

As of Nehalem, a small inner loop that fits in the decoded uop cache
has the potential to be faster than a hugely unrolled one.
