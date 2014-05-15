Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaEODce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 23:32:34 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:56032 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaEODcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 23:32:32 -0400
Date: Wed, 14 May 2014 23:32:29 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>,
        Chung-Lin Tang <cltang@codesourcery.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
In-Reply-To: <537406FA.2040906@zytor.com>
Message-ID: <alpine.LFD.2.11.1405142319140.17310@knanqh.ubzr>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <6202090.0OtAjefIFT@wuerfel> <CAMuHMdVxc3XRanpboWPumvQKbg-qdRBHQvYXwjTKX4CrxXPeAw@mail.gmail.com> <8399002.IIyBoyEHox@wuerfel> <CANcMJZAOi9ctWkpEgynj6wxCrvW4oS5ZHj3Chv04D=VQDogEvw@mail.gmail.com>
 <537406FA.2040906@zytor.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014, H. Peter Anvin wrote:

> On 05/14/2014 02:33 PM, John Stultz wrote:
> > 
> > We can do some tricks for internal optimizations here if these are
> > critical.  I'd be more concerned about userland divisions where moving
> > to a 64bit time_t would cause performance issues that we cannot help
> > optimize.
> > 
> 
> Honestly, the cost of not addressing the Y2038 problem in plenty of time
> is going to be way, way, way, way more expensive than some additional
> arithmetic.
> 
> As far as converting to calendar notation (e.g. the Gregorian calendar),
> only the first division needs to be done with full time_t width.
> Furthermore, since the divisor is known a priori, the compiler *should*
> be able to do it as an inverse multiply.[1]

The compiler is apparently not that smart.  It does it already for 32 by 
32 bit divisions, but not for 64 by 32 divisions. Fortunately, with 
gcc-4 at least, constant propagation on long longs works well enough to 
do it by hand.  That's how I implemented do_div() for ARM years ago.  
See arch/arm/include/asm/div64.h from line 65.  The same could be 
implemented for x86 and others.


Nicolas
