Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077AbaE3UDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:03:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47336 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbaE3UDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:03:30 -0400
Message-ID: <5388E3EF.6030700@zytor.com>
Date: Fri, 30 May 2014 13:02:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Josh Boyer <jwboyer@fedoraproject.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] x86,vdso: Fix cross-compilation from big-endian
 architectures
References: <CALCETrXef77JLoEp5hCXSdMAk7usWsL-sUG6NrcgLgrz3krfag@mail.gmail.com> <cover.1401464755.git.luto@amacapital.net> <2cf258df123cb24bad63c274c8563c050547d99d.1401464755.git.luto@amacapital.net>
In-Reply-To: <2cf258df123cb24bad63c274c8563c050547d99d.1401464755.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 08:48 AM, Andy Lutomirski wrote:
> This adds a macro GET(x) to convert x from big-endian to
> little-endian.  Hopefully I put it everywhere it needs to go and got
> all the cases needed for everyone's linux/elf.h.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/vdso/vdso2c.c | 15 ++++++++++++
>  arch/x86/vdso/vdso2c.h | 63 ++++++++++++++++++++++++++++----------------------
>  2 files changed, 50 insertions(+), 28 deletions(-)

A couple of observations:

1. We shouldn't use double-underscore in host C code.

2. It would be nice if we can take these sort of things (host-build
   helper macros) and move them to some common file in the Linux kernel
   eventually, so it would be a good thing to make the naming a little
   less general.

3. Even though it isn't necessary, making it work on 8-bit values so
   one doesn't have to worry about the type would seem like a good
   thing.

I came up with the following, it seems like a reasonable simplification:

> #define _LE(x, bits, ifnot)						\
> 	__builtin_choose_expr(						\
> 		(sizeof(x) == bits/8),					\
> 		(__typeof__(x))le##bits##toh(x), ifnot)
> 
> extern void bad_le(uint64_t);
> #define _LAST_LE(x)							\
> 	__builtin_choose_expr(sizeof(x) == 1, (x), bad_le(x))
> 
> #define LE(x)								\
> 	_LE(x, 64, _LE(x, 32, _LE(x, 16, _LAST_LE(x))))

What do you think?

	-hpa

