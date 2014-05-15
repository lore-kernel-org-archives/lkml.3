Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaEOAPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 20:15:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34600 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbaEOAPn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 20:15:43 -0400
Message-ID: <537406FA.2040906@zytor.com>
Date: Wed, 14 May 2014 17:14:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
References: <1399971456-3941-1-git-send-email-lftan@altera.com>	<6202090.0OtAjefIFT@wuerfel>	<CAMuHMdVxc3XRanpboWPumvQKbg-qdRBHQvYXwjTKX4CrxXPeAw@mail.gmail.com>	<8399002.IIyBoyEHox@wuerfel> <CANcMJZAOi9ctWkpEgynj6wxCrvW4oS5ZHj3Chv04D=VQDogEvw@mail.gmail.com>
In-Reply-To: <CANcMJZAOi9ctWkpEgynj6wxCrvW4oS5ZHj3Chv04D=VQDogEvw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2014 02:33 PM, John Stultz wrote:
> 
> We can do some tricks for internal optimizations here if these are
> critical.  I'd be more concerned about userland divisions where moving
> to a 64bit time_t would cause performance issues that we cannot help
> optimize.
> 

Honestly, the cost of not addressing the Y2038 problem in plenty of time
is going to be way, way, way, way more expensive than some additional
arithmetic.

As far as converting to calendar notation (e.g. the Gregorian calendar),
only the first division needs to be done with full time_t width.
Furthermore, since the divisor is known a priori, the compiler *should*
be able to do it as an inverse multiply.[1]

The remaining divisions are bounded, and a smart compiler should even
know that.

> I'm not sure I'm totally following this... Are you suggesting we keep
> 32bit time internally w/ some different offset but then pass to
> userland a 64bit time_t?  Or are you suggesting we change the abi to
> move the epoch?

I think this makes sense as a way of emergency rescue of legacy ABIs --
similar to the windowing solution used to Y2K-rescue legacy systems.
Nonlegacy ABIs should just be designed correctly from the start.

> I think I'm with hpa in his recent mail in that the internal
> representation is an optimization detail, and the bigger question is146
> do we use a  64bit time_t for future systems (possibly w/ a major ABI
> break - with compat interface for existing 32bit applications), or do
> we try to rev interfaces function by function to provide 2038 safe
> versions which applications will have to be modified to use?
> 
> Me, I'm a fan of moving time_t to 64bits, since it makes "porting"
> applications to a 2038 safe ABI easier.

I obviously couldn't agree more.

	-hpa


[1] Not entirely true: the highest possible divisor necessary when doing
Gregorian calendar calculations is 12_622_780_800 (0x2_f060_5980), the
number of seconds in each Gregorian 400-year cycle.  Similarly, dividing
with 86400 first to separate time and date requires the date part of the
result to remain 64 bits until the next division.  Thus, depending on
exactly how the calculations are partitioned it may be necessary to do
two 64-bit wide divisions; this can, however, be avoided with some care.

