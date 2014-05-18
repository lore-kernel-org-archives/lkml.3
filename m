Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaERQMI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 12:12:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48723 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbaERQMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 12:12:06 -0400
Message-ID: <5378DB83.1000406@zytor.com>
Date: Sun, 18 May 2014 09:10:43 -0700
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
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <4706636.rTYoqSXXOR@wuerfel> <Pine.LNX.4.64.1405151949160.911@digraph.polyomino.org.uk> <9236147.lyD24Zv5SZ@wuerfel> <53769B27.2090407@zytor.com> <Pine.LNX.4.64.1405162336150.24114@digraph.polyomino.org.uk> <5376AE23.10905@zytor.com> <Pine.LNX.4.64.1405181325520.4608@digraph.polyomino.org.uk>
In-Reply-To: <Pine.LNX.4.64.1405181325520.4608@digraph.polyomino.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2014 06:46 AM, Joseph S. Myers wrote:
> 
> It's advising against breaking compatibility with existing applications 
> (in that case, C90 applications that assume sizes can be cast to unsigned 
> long for printing, etc.) unless necessary.
> 

Yes, the values in question will not be a problem for that in this case,
so it doesn't apply.

> Rich Felker suggests 
> <https://sourceware.org/bugzilla/show_bug.cgi?id=16438> there are similar 
> security risks from various types in the x32 ABI being wider than size_t.  
> That seems entirely plausible, if unconfirmed; I don't think there's been 
> much effort to look for such issues where applications expect types to be 
> no wider than size_t when there's no use to them being wider than size_t.  
> Most of those choices are valid but may be risky to existing software much 
> as IL32LLP64 can be risky to existing software.

Everything can be risky if done poorly, unfortunately.

> The userspace ABI for struct timespec with 64-bit time_t and 32-bit long 
> should use long tv_nsec in any future ports, with appropriate conversion 
> code in glibc if the kernel interface is different (for ports that started 
> out with 32-bit time_t, conversion code will be needed anyway to convert 
> to the 32-bit structure if the new syscalls are unavailable at runtime and 
> so the old syscalls need to be used, but if the kernel's structure with 
> 64-bit time_t is different from that in userspace then both old and new 
> kernels need conversion code).  Given Rich Felker's bug reports, it seems 
> reasonable to suppose that musl will wish to do this as well as glibc.

This potentially requires the kernel to maintain three separate ABIs if
there is a legacy 32-bit ABI, which is quite frankly idiotic.  You seem
to be thinking of POSIX as something handed down by gods, which it
isn't... quite frankly they did something stupid here and should fix
their own mess.

As far as glibc is concerned, this would require glibc to intercept each
ioctl, which is completely infeasible... struct timespec/timeval is
embedded far too deep everywhere.

	-hpa

