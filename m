Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761240Ab3BMXYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 18:24:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45947 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab3BMXYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 18:24:44 -0500
Message-ID: <511C207E.9030008@zytor.com>
Date: Wed, 13 Feb 2013 15:23:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [RFC PATCH 1/4] x86, cpu: Expand cpufeature facility to include
 cpu bugs
References: <1360581521-4712-1-git-send-email-bp@alien8.de> <1360581521-4712-2-git-send-email-bp@alien8.de>
In-Reply-To: <1360581521-4712-2-git-send-email-bp@alien8.de>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 03:18 AM, Borislav Petkov wrote:
>  
> +#define __BUG_CHECK_BIT(bit)					\
> +({								\
> +	WARN_ON(bit >> 5 < NCAPINTS);				\
> +	bit;							\
> +})
> +

Do we need this?  Either way, if we do, I would suggest doing something
like:

	if (__builtin_constant_p(bit))
		bad_bug_number();

... and flag bad_bug_number as a compile time error, since the vast
majority of the time the bit number will be constant.

However, I don't think it is necessary.  In order for this to ever
trigger someone must have known they were testing for a bug, and yet not
used the X86_BUG_ macros, which seems very unlikely.

>  #define X86_BUG_F00F		(NCAPINTS*32+ 0) /* Intel F00F bug */
>  #define X86_BUG_FDIV		(NCAPINTS*32+ 1) /* FPU FDIV bug */
> +#define X86_BUG_COMA		(NCAPINTS*32+ 2) /* Cyrix 6x86 coma */

Just to make it a bit cleaner once we have more than one word of bug
tests, I would suggest macroizing this:

#define X86_BUG(x) (NCAPINTS*32 + (x))

... and then just ...

#define X86_BUG_F00F	X86_BUG(0)
#define X86_BUG_FDIV	X86_BUG(1)

... and so on.

The only reason we *don't* do that with the features is that they tend
to come chunkwise in the form of CPUID words.

	-hpa

