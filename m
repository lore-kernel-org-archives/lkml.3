Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaFOR6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 13:58:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41043 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbaFOR6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 13:58:11 -0400
Message-ID: <539DDE9C.3010903@zytor.com>
Date: Sun, 15 Jun 2014 10:57:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Rich Felker <dalias@libc.org>, Mikael Pettersson <mikpelinux@gmail.com>,
        Russ Cox <rsc@golang.org>, Linux API <linux-api@vger.kernel.org>,
        Ian Taylor <iant@golang.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Subject: Re: [RFC 0/2] __vdso_findsym
References: <cover.1402769596.git.luto@amacapital.net> <21405.44257.742122.786960@gargle.gargle.HOWL> <20140615143500.GP179@brightrain.aerifal.cx> <539DD26B.3060709@zytor.com> <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
In-Reply-To: <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2014 10:40 AM, Andy Lutomirski wrote:
> 
> To be clear, I have no desire whatsoever to give the vdso an actual
> ELF parser or anything else that userspace should be providing itself.
> I think that a special-purpose vdso parser in the vdso makes some
> sense, though, since userspace might otherwise provide one for the
> sole purpose of parsing the vdso.
> 
> And there's plenty of reasons that having the vdso be an ELF image is
> useful.  For one thing, gdb can take advantage of it.  For another,
> CRIU is parsing it for a rather different reason, and something like
> __vdso_findsym won't fill that need.
> 
> Also, given the general lack of a comprehensible specification of what
> the GNU flavor of the ELF format actually is [1], there's something to
> be said for reducing the proliferation of ELF parsers.  glibc and
> binutils are quite unlikely to become incompatible with each other,
> but I sincerely doubt that anyone from binutils land is likely to
> review (and maintain!) my ELF parser, Go's, or a hypothetical future
> ELF parser from any of the other glibc-less things.  If those things
> use one that's in the kernel, then it's easy for the kernel to
> guarantee that each vdso image can successfully parse itself.
> 
> [1] The only comprehensible description of the GNU hash extension that
> I could find is on Oracle's blog (!)
> 

Yes, but that is why we provide the standard SysV hash.  The GNU hash is
not too bad, but you're absolutely right the documentation stinks.

Providing a simple symbol lookup is an opportunistic thing, and might be
useful that way, and only because (as you say) the version in the vdso
would only need to be guaranteed to parse a single data structure --
that same vdso.

On the other hand, it better work, correctly, in every version of the
kernel, so I believe it will need to be done such that it is either
correct by construction or gets self-tested during the build process so
it errors out on failure.  One simple way to do correct by construction
would be to do the "vdso entry point by index" -- a new kind of system
call numbers, in effect, as much as it has shades of Windows DLL with
their "ordinal numbers".

	-hpa

