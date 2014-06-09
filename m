Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbaFIKad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 06:30:33 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:53590 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932201AbaFIKa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 06:30:28 -0400
Message-Id: <1402309827.7242.126672901.053EFD6E@webmail.messagingengine.com>
X-Sasl-Enc: GXDC2DATxSd8Ef8wS8Q7kXge/D/GOcbNjz2Ffh/Yxrse 1402309827
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: George Spelvin <linux@horizon.com>, davem@davemloft.net,
        dborkman@redhat.com, shemminger@osdl.org, tytso@mit.edu
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-037d6a32
In-Reply-To: <20140608204800.7610.qmail@ns.horizon.com>
References: <20140608204800.7610.qmail@ns.horizon.com>
Subject: Re: [PATCH 5/7] lib/random32.c: Make prandom_u32_max efficient for
 powers of 2
Date: Mon, 09 Jun 2014 03:30:27 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your detailed explanation!

On Sun, Jun 8, 2014, at 13:48, George Spelvin wrote:
> Thank you for your comments!
> 
> > Have you checked assembler output if this helps anything at all? Constant
> > propagation in the compiler should be able to figure that out all by
> > itself. The only places I use __builtin_constant_p today are where I
> > also make use of inline assembler.
> 
> Yes, I did.  (I'll expand the commit comment for v2; my bad.)
> 
> It seems that GCC isn't smart enough to reduce this to a single shift.
> With the multiply and reduce, the code looks like:
>         call    prandom_u32
>         xorl    %edx, %edx
>         shldl   $4, %eax, %edx
>         movl    %edx, %eax
> 
> Instead of the hoped-for
>         call    prandom_u32
> 	shrl	$28, %eax

On x86_64 I get the above result. Seems like gcc doesn't see the downcast to u32 far enough ahead and stays in DI mode on i386, thus the shldl. It shouldn't matter that much... ;)

> Converting to a single mask is something the compiler can't do,
> because it doesn't understand that using the lsbits instead of the
> msbits is okay.

Yep, sure.

> With the mask, it turns into the spectacularly simple:
>         call    prandom_u32
>         andl    $15, %eax
> 
> An interesting question is which is preferred in general.
> 
> The AND allows non-constant powers of 2 without requiring CLZ.  But I
> don't recall seeing that actually happen anywhere.  And the shift allows
> a smaller encoding (8-bit rather than 32-bit immediate constant) when
> the power of 2 is known at compile time and is larger than 128 (for
> example, PAGE_SIZE).

I actually don't know if folding logic in gcc is so enhanced to see that coming. ;)
Would be interesting tough, maybe I'll try that later.

> Me, I thought it was in the noise and not worth stressing about,
> but I also understand the hackers's urge for maximum tweaking.

Totally ok. ;)

I don't have any problems with the patch, although such a detailed changelog would be nice + some approx. numbers of how many times we run into the new optimization.

Bye,
Hannes
