Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148AbaDMEUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 00:20:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59730 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbaDMEUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 00:20:32 -0400
Message-ID: <534A107B.2050203@zytor.com>
Date: Sat, 12 Apr 2014 21:20:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, Brian Gerst <brgerst@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com> <53483487.6030103@zytor.com> <53485BB8.1000106@mit.edu> <53485D95.9030301@zytor.com> <5348643F.1020405@mit.edu>
In-Reply-To: <5348643F.1020405@mit.edu>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 02:53 PM, Andy Lutomirski wrote:
> 
> If you want a fully correct solution, you can use a fancier allocation
> policy that can fit quite a few cpus per 4G :)
> 

The more I think about this, I think this might actually be a reasonable
option, *IF* someone is willing to deal with actually implementing it.

The difference versus my "a" alternative is rather than mapping the
existing kernel stack into an alternate part of the address space would
be that we would have a series of ministacks that is only large enough
that we can handle the IRET data *and* big enough to handle any
exceptions that IRET may throw, until we can switch back to the real
kernel stack.  Tests would have to be added to the appropriate exception
paths, as early as possible.  We would then *copy* the IRET data to the
ministack before returning.  Each ministack would be mapped 65536 times.

If we can get away with 64 bytes per CPU, then we can get away with 4
GiB of address space per 1024 CPUs, so if MAX_CPUS is 16384 we would
need 64 GiB of address space... which is not unreasonable on 64 bits.
The total memory consumption would be about 81 bytes per CPU for the
ministacks plus page tables (just over 16K per 1K CPUs.)  Again, fairly
reasonable, but a *lot* of complexity.

	-hpa

