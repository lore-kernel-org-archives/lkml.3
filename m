Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449Ab3ISIsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:48:19 -0400
Received: from verein.lst.de ([213.95.11.211]:42590 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab3ISIsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:48:17 -0400
Date: Thu, 19 Sep 2013 10:47:11 +0200 (CEST)
From: Torsten Duwe <duwe@lst.de>
Reply-To: Torsten Duwe <duwe@lst.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Torsten Duwe <duwe@lst.de>, tytso@mit.edu, ingo.tuchscherer@de.ibm.com,
        linux-kernel@vger.kernel.org, Hans-Georg Markgraf <MGRF@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [Resend PATCH 2/2] s390: provide hardware randomness from zcrypt
 card to /dev/random
In-Reply-To: <52322621.3040908@zytor.com>
Message-ID: <alpine.LNX.2.00.1309191030180.3014@linux.site>
References: <alpine.LNX.2.00.1309121139000.3818@linux.site> <52322621.3040908@zytor.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: LST e.V.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 12 Sep 2013, H. Peter Anvin wrote:

> From what I can gather from the patch this is too heavyweight (need
> locks and so on) to use as arch_get_random*().  There has been a lot of

Alas, I can see there's only x86 that currently has this implemented?

> discussion about the pros and cons of allowing the kernel to bypass
> rngd, but I would think that any such plumbing -- once it gets past the
> fully synchronous low latency properties of arch_get_random*() -- really
> should be implemented as an option in the existing hwrng device
> infrastructure.

As I wrote in the intro, the problem to solve is slow startup when ASLR is 
in effect; in that case: until rngd or haveged is finally running.

> In other words, start by implementing a hwrng device.  That will work
> right now with rngd running.  Then we can consider if we want to allow

That's already there, thanks to the IBM guys :)

> bypass of rngd for certain hwrng devices -- which may include zcrypt,
> virtio_rng and so on.

I'm currently thinking about some kind of buffer in zcrypt, where 
arch_get_random can get a long or int quickly, as "designed" after x86.
Device init or low water would trigger a work item to refill the buffer.
It might tun out though, that every device on every architecture that does
not quite match the x86 approach implements its own buffer.

What do you think?

Besides that, as you wrote, a generic mechanism to mix hwrngs into the 
input pool would be nice, triggered by user space policy. As far as I can 
see, some mixing of arch_get_random is done, but no entropy credited?

	Torsten

