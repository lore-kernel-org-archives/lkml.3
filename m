Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3L0Aq0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 19:46:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47982 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab3L0AqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 19:46:22 -0500
Message-ID: <52BCCDC4.1090409@zytor.com>
Date: Thu, 26 Dec 2013 16:45:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] speeding up the stat() family of system calls...
References: <CA+55aFxZ2u+M72u3HSD7TVY2+WRRi27pYC=_4Wawr5y1m8DfnQ@mail.gmail.com>	<20131224204625.GB20471@gmail.com> <CA+55aFzPBdbfKovMT8Edr4SmE2_=+OKJFac9XW2awegogTkVTA@mail.gmail.com>
In-Reply-To: <CA+55aFzPBdbfKovMT8Edr4SmE2_=+OKJFac9XW2awegogTkVTA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2013 11:00 AM, Linus Torvalds wrote:
> 
> Interestingly, looking at the cp_new_stat() profiles, the games we
> play to get efficient range checking seem to actually hurt us. Maybe
> it's the "sbb" that is just expensive, or maybe it's turning a (very
> predictable) conditional branch into a data dependency chain instead.
> Or maybe it's just random noise in my profiles that happened to make
> those sbb's look bad.
> 

I'm not at all surprised... there is a pretty serious data dependency
chain here and in the end we end up manifesting a value in a register
that has to be tested even though it is available in the flags.  Inline
assembly also means the compiler can't optimize it at all.

I have to wonder if we actually have to test the upper limit, though: we
can always guarantee a guard zone between user space and kernel space,
and thus guarantee either a #PF or #GP if someone tries to overflow user
space.  Testing just the lower limit would be much cheaper, especially
on 64 bits where we can simply test the sign bit.

What do you think?

	-hpa

