Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbaFKD6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 23:58:09 -0400
Received: from ns.horizon.com ([71.41.210.147]:31466 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751619AbaFKD6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 23:58:07 -0400
Date: 10 Jun 2014 23:58:06 -0400
Message-ID: <20140611035806.9237.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, tytso@mit.edu
Subject: Re: drivers/char/random.c: more ruminations
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        price@mit.edu
In-Reply-To: <20140611020835.GA23110@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually, it's **fine**.  That's because RNDADDENTROPY adds the
> entropy to the input pool, which is has the limit flag set.  So we
> will never pull more entropy than the pool is credited as having.
> This means that race can't happen.  It ***is*** safe.
> 
> 1)  Assume the entropy count starts at 10 bytes.
> 
> 2)  Random writer mixes in 20 bytes of entropy into the entropy pool.
> 
> 3)  Random extractor tries to extract 32 bytes of entropy.  Since the
> entropy count is still is 10, it will only get 10 bytes.  (And if we
> started with the entropy count started at zero, we wouldn't extract
> any entropy at all.)
> 
> 4) Random writer credit the entropy counter with the 20 bytes mixed in
> step #2.
> 
> See? no problems!

You can forbid underflows, but the code doesn't forbid overflows.

1. Assume the entropy count starts at 512 bytes (input pool full)
2. Random writer mixes in 20 bytes of entropy into the input pool.
2a. Input pool entropy is, however, capped at 512 bytes.
3. Random extractor extracts 32 bytes of entropy from the pool.
   Succeeds because 32 < 512.  Pool is left with 480 bytes of
   entropy.
3a. Random extractor decrements pool entropy estimate to 480 bytes.
    This is accurate.
4. Random writer credits pool with 20 bytes of entropy.
5. Input pool entropy is now 480 bytes, estimate is 500 bytes.

Problem, no?
