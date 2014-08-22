Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaHVWg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 18:36:59 -0400
Received: from ns.horizon.com ([71.41.210.147]:44366 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752107AbaHVWg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 18:36:58 -0400
Date: 22 Aug 2014 18:36:56 -0400
Message-ID: <20140822223656.27100.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: akpm@linux-foundation.org, zhaoxiu.zeng@gmail.com
Subject: Re: [PATCH 1/1] GCD: add binary GCD algorithm
Cc: dhowells@redhat.com, jwboyer@redhat.com, linux-kernel@vger.kernel.org,
        linux@horizon.com, mingo@kernel.org, peterz@infradead.org,
        takahiro.akashi@linaro.org
In-Reply-To: <20140822143117.29474ac2ac8092e27d26660a@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Otherwise I don't think we can justify the additional maintenance
> cost/risk, sorry.

This is am extremely self-contained and easy to test piece of code.
Look at the history; the total edits to the function since the
beginning of git in 2005 are:
- A theoretical bug fix to handle zero arguments better
- A global header file cleanup that hit lib/gcd.c
- Relocation to lib/ from sound/core/pcm_timer.c

And... nothing else.

This is the sort of leaf function that, once it works, gets left alone
forever.

Your point about "it's not a bottleneck, so why optimize it?" is valid,
but the maintenance issue is something of a red herring.

The maintenance hassle I *do* worry about the Kconfig magic to decide
whether to enable it.  But that's something I'd defer to the ARM
maintainers on.

> And if we *do* decide to proceed with this patch, we should include a
> patch which enables it on as many architectures as possible, so it gets
> runtime tested.

It's pretty harmless even on machines which *do* have fast division,
so we could just enable it everywhere.

GMP, whose benchmarking I'm inclined to trust, uses binary GCD for all
small (3-word or less) values.

https://gmplib.org/manual/Binary-GCD.html

The expected nymber of iterations to perform the Euclidean algorithm
for two random numbers 1 <= x,y <= n is 1.216 log2(n) + 0.06.
Binary GCD is quite similar.  Its main advantage is the large gain
in the first step when the inputs are of very different size.

Binary GCD's perfoemance problems come from unpredictable branches.
Euclid's algorithm has less of those.
