Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbaEQAdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 20:33:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33087 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756201AbaEQAd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 20:33:29 -0400
Message-ID: <5376AE23.10905@zytor.com>
Date: Fri, 16 May 2014 17:32:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Joseph S. Myers" <joseph@codesourcery.com>
CC: Arnd Bergmann <arnd@arndb.de>, Chung-Lin Tang <cltang@codesourcery.com>,
        John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ley Foon Tan <lftan@altera.com>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LeyFoon Tan <lftan.linux@gmail.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <4706636.rTYoqSXXOR@wuerfel> <Pine.LNX.4.64.1405151949160.911@digraph.polyomino.org.uk> <9236147.lyD24Zv5SZ@wuerfel> <53769B27.2090407@zytor.com> <Pine.LNX.4.64.1405162336150.24114@digraph.polyomino.org.uk>
In-Reply-To: <Pine.LNX.4.64.1405162336150.24114@digraph.polyomino.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 04:47 PM, Joseph S. Myers wrote:
>>
>> struct timespec is specified in POSIX as having type "long" for tv_nsec.
>>  This, as Linus pointed out, is totally braindamaged.
> 
> long is a perfectly reasonable type for this purpose - it's guaranteed to 
> have enough precision.  ISO C11 follows POSIX in the definition of struct 
> timespec.
> 

That is not the issue.  The issue is that by fixing the type, the POSIX
committee foolishly fixed the ABI unnecessarily.  There is nothing wrong
with storing this value in a long, of course, but:

a) there is no reason it needs to be as wide as long, on an LP64 ABI an
   int would serve just fine;
b) ABI compatibilility issue, especially since on virtually all ABIs a
   96-bit struct timespec would end up padded to 128 bits anyway;
c) gratuitously different from struct timeval.

>> x32 does not follow POSIX (Linus pretty much dictated that), and instead
>> does the __kernel_suseconds_t to match the native kernel type.  The
>> proposal at some point was to try to push a snseconds_t into POSIX.
> 
> If the x32 kernel won't be fixed to treat the high part as padding then 
> glibc will need fixing to copy all struct timespec values passed to the 
> kernel and clear the padding when copying (really, fixing that bug would 
> need such copying anyway unless --enable-kernel is used to allow a fixed 
> kernel to be assumed).  In any case, we should not put any more ports into 
> glibc with that x32 bug; "long" and an explicit padding field is the way 
> to go (and copying / zeroing if the kernel doesn't treat that padding 
> field as padding).
> 
> Adding snseconds_t to POSIX seems pointless when there is no need for this 
> field to store values that can't fit in "long".  Even if it were added, 
> good practice would say that implementations should keep using "long" 
> whenever possible for compatibility with existing applications (just like 
> the ISO C recommendation "The types used for size_t and ptrdiff_t should 
> not have an integer conversion rank greater than that of signed long int 
> unless the implementation supports objects large enough to make this 
> necessary.").

That is a very different thing, though.

> If you were designing from scratch, no doubt a typedef such as snseconds_t 
> would be there, but with real-world APIs that have accumulated over time, 
> deviating from "long" now is a bad idea.

Given that you already have a long long member of the same structure, it
seems unlikely that adding another long long to this is a problem.

Anyway, this was discussed back in 2011:

https://lkml.org/lkml/2011/8/31/244

	-hpa


