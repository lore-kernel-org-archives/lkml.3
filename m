Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbaBTJu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:50:29 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:60321 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaBTJu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 04:50:27 -0500
Message-ID: <5305CFD7.5060600@redhat.com>
Date: Thu, 20 Feb 2014 10:50:15 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>,
        "Theodore Ts'o" <tytso@mit.edu>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, smueller@chronox.de,
        geert@linux-m68k.org, tg@mirbsd.de
Subject: Re: [PATCH,RFC] random: collect cpu randomness
References: <20140202203617.GA9499@logfs.org>
In-Reply-To: <20140202203617.GA9499@logfs.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/02/2014 21:36, Jörn Engel ha scritto:
> +#pragma GCC diagnostic push
> +#pragma GCC diagnostic ignored "-Wuninitialized"
> +	input[0] ^= cycles ^ jiffies;
> +	input[1] ^= (unsigned long)caller;
> +	input[2] ^= (unsigned long)val;
> +	input[3] ^= (unsigned long)&input;
> +#pragma GCC diagnostic pop

Your tests demonstrate that this works, and presumably you have checked 
the assembly too.  Still, this is invoking undefined behavior and the 
compiler could justifiably change those "^=" to "=".

An "asm" would be a safer way to convince the compiler that input[] is 
now initialized:

     asm volatile ("" :
         "=m" (input[0]), "=m" (input[1]),
         "=m" (input[2]), "=m" (input[3]));

and *really* XOR the values into the contents of the stack.

Of course the compiler could still have a "feature" where it 
pre-initializes the whole stack frame with some kind of canary, but that 
would be a problem even with your version of the code.

Paolo
