Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaLHUJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:09:29 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:55620 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaLHUJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:09:27 -0500
Message-ID: <54860571.4060803@de.ibm.com>
Date: Mon, 08 Dec 2014 21:09:21 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Hector Marco <hecmargi@upv.es>, linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, linux@arm.linux.org.uk, catalin.marinas@arm.com,
        will.deacon@arm.com, oleg@redhat.com, luto@amacapital.net,
        keescook@chromium.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack
References: <5480F756.90106@upv.es>
In-Reply-To: <5480F756.90106@upv.es>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120820-0005-0000-0000-0000026176E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.12.2014 um 01:07 schrieb Hector Marco:
> [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack
> 
>   The issue appears on PIE linked executables when all memory areas of
>   a process are randomized (randomize_va_space=2). In this case, the
>   attack "offset2lib" de-randomizes all library areas on 64 bit Linux
>   systems in less than one second.
> 
>   Further details of the PoC attack at:
>   http://cybersecurity.upv.es/attacks/offset2lib/offset2lib.html
> 
>   PIE linked applications are loaded side by side with the dynamic
>   libraries, which is exploited by the offset2lib attack. Moving away
>   the executable from the mmap_base area (libraries area) prevents the
>   attack.
> 
>   This patch loads the PIE linked executable in a different area than
>   the libraries when randomize_va_space=3.
> 
>   Patch implementation details:
> 
>    - The ELF_ET_DYN_BASE address is used as the base to load randomly
>      the PIE executable.
> 
>    - The executable image has the same entropy than
>      randomize_va_space=2.
[...]
> --- a/arch/arm/mm/mmap.c
> +++ b/arch/arm/mm/mmap.c
[...]
> --- a/arch/arm64/mm/mmap.c
> +++ b/arch/arm64/mm/mmap.c
[...]

> --- a/arch/x86/mm/mmap.c
> +++ b/arch/x86/mm/mmap.c
[...]

FWIW, please note that s390 and power (maybe others?) also have PIE support done differently, e.g.
commit d2c9dfccbc3 ("[S390] Randomize PIEs") and commit 501cb16d3cfdc ("powerpc: Randomise PIEs")

What I can tell from a quick look both architectures should be fine regarding offsetlib, as they place the executable already in a different section and randomize those differently even with randomize_va_space=2.

Would it make sense to unify the implementations again?

Christian

