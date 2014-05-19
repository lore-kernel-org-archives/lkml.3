Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaESWlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:41:14 -0400
Received: from longford.logfs.org ([213.229.74.203]:43348 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaESWlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:41:12 -0400
Date: Mon, 19 May 2014 18:39:43 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: mix all saved registers into entropy pool
Message-ID: <20140519223943.GC14563@logfs.org>
References: <20140519211719.GA14563@logfs.org>
 <20140519212320.GB14563@logfs.org>
 <537A8319.5010100@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537A8319.5010100@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 15:18:01 -0700, H. Peter Anvin wrote:
> 
> I think this is likely to be particularly valuable during boot.  I can
> see it becoming substantially less valuable after that point, but during
> boot is when the most critical.
> 
> What I do see as an issue is that the value is probably impossible to
> quantify, and so I feel more than a bit queasy about giving it
> /dev/random credit.  However, making sure the pool is well stirred
> during boot is really way more important.

I would feel fairly confident giving this .25 bits of entropy per
event.  With 40% unique hashes and assuming at most 1 bit of entropy
for a unique hash, that is a fairly conservative underestimate.

But as you can see from the patch, I feel less confident doing any
kind of entropy-guessing in general and have skipped that step.  By
the .25 bits metric, my patch should feed 128 bits of entropy into
both the non-blocking pool and the input pool within the first 5s or
so of boot time.  In reality it is likely more.

The other problem to solve is VM clones sharing the same state for the
various pools.  Assuming HZ=100 no external interrupts and .25 bits, we
would gather 128 bits in just above 5s.  That is not great, but okish.

What worries me is that much of those 5s may be spent inside the idle
loop and have rather predictable register content and we may run
tickless.  I have no great solution for that case.

We could change the ratelimiting to, say, 4 interrupts per jiffie.
But that would still not help much in the worst case scenario above,
so the benefits don't seem convincing.

Jörn

--
When you admit that some people are too important to prosecute, it's
just a few short steps to the obvious corollary – that everybody else
is unimportant enough to jail.
-- Matt Taibbi
