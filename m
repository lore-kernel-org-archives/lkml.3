Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693AbaKMRj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:39:26 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:45155 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933663AbaKMRjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:39:22 -0500
MIME-Version: 1.0
In-Reply-To: <20141113112633.GE13350@arm.com>
References: <1415863793-6219-1-git-send-email-chanho.min@lge.com> <20141113112633.GE13350@arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 13 Nov 2014 17:39:00 +0000
Message-ID: <CAFEAcA_dSxRgkvuJW6aHdSv88NkXXHBMAzjyJMTRbW3mXAV3Sg@mail.gmail.com>
Subject: Re: [PATCH] ARM: cacheflush: disallow pending signals during cacheflush
To: Will Deacon <will.deacon@arm.com>
Cc: Chanho Min <chanho.min@lge.com>, Russell King <linux@arm.linux.org.uk>,
        Jon Medhurst <tixy@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Gunho Lee <gunho.lee@lge.com>, HyoJun Im <hyojun.im@lge.com>,
        Jongsung Kim <neidhard.kim@lge.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        mtk.manpages@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 November 2014 11:26, Will Deacon <will.deacon@arm.com> wrote:
> Whilst I don't think this is the correct solution, I agree that there's
> a potential issue here. We could change the restart return value to
> -ERESTARTNOINTR instead, but I can imagine something like a periodic
> SIGALRM which could prevent a large cacheflush from ever completing.
> Do we actually care about making forward progress in such a scenario?
>
> It is interesting to note that this change has been in mainline since
> May last year without any reported issues. That could be down to a number
> of reasons:
>
>   (1) People are using old kernels on ARM
>
>   (2) Code doesn't check the return value from the cacheflush system call,
>       because it historically always returned 0

...and the documentation comment in the source code didn't say
anything about the syscall having a return value; it only
described the input parameters. I would actually be surprised
if any userspace caller of this syscall checked its return value
(the libgcc cacheflush function used by gcc's clear_cache builtin
doesn't, to pick one popularly used example).

>   (3) People are getting lucky with timing, as this is likely difficult
>       to hit

    (4) The resulting misbehaviour ("my JIT crashes occasionally and
        non-reproducibly at some point possibly some while after the
        cacheflush call") will be extremely hard to track back
        to this kernel change

> This leaves me with the following questions:
>
>   - Has this change been shown to break anything in practice?
>   - Can we change the internal return value to -ERESTARTNOINTR?
>   - What do we do about kernels that *do* return -EINTR? (>=3.12?)

My suggestion would be "treat this as a bugfix, put it into
stable kernels in the usual way (and assume distros will pick
it up if appropriate)".

>   - Can we get a manpage put together to describe this mess?

That would be nice :-)

-- PMM
