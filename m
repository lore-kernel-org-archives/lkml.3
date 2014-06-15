Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaFORk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 13:40:26 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:48758 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaFORkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 13:40:24 -0400
MIME-Version: 1.0
In-Reply-To: <539DD26B.3060709@zytor.com>
References: <cover.1402769596.git.luto@amacapital.net> <21405.44257.742122.786960@gargle.gargle.HOWL>
 <20140615143500.GP179@brightrain.aerifal.cx> <539DD26B.3060709@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 15 Jun 2014 10:40:03 -0700
Message-ID: <CALCETrXTpkto2gJBiFC4CR5D=Lqf2YfP5BBH02f8hFW+TUGqeA@mail.gmail.com>
Subject: Re: [RFC 0/2] __vdso_findsym
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rich Felker <dalias@libc.org>, Mikael Pettersson <mikpelinux@gmail.com>,
        Russ Cox <rsc@golang.org>, Linux API <linux-api@vger.kernel.org>,
        Ian Taylor <iant@golang.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2014 at 10:05 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/15/2014 07:35 AM, Rich Felker wrote:
>>
>> Arguably, it was a mistake for the kernel to expose a virtual ELF to
>> begin with, and it should just have exposed a "lookup function by
>> name" operation to begin with. Yes this can be done in userspace, but
>> I see it more as a matter of "fixing a broken API design".
>>
>
> What the fsck are you smoking?  There is immense value in providing a
> stable and very well-defined data structure, which also happens to be
> what dynamic linkers already want to consume.  Providing a helper for
> crippled libc applications has potential value.  Shaving a few hundred
> bytes off static applications is a very weak argument, simply because it
> is such a small fraction of the enormous cost of a static application,
> and static applications are problematic in a number of other ways,
> especially the lack of ability to fix bugs.
>
> Treating the kernel as an ersatz dynamic library for "static"
> applications is kind of silly -- after all, why not provide an entire
> libc in the vdso?  I have actually seen people advocate for doing that.

To be clear, I have no desire whatsoever to give the vdso an actual
ELF parser or anything else that userspace should be providing itself.
I think that a special-purpose vdso parser in the vdso makes some
sense, though, since userspace might otherwise provide one for the
sole purpose of parsing the vdso.

And there's plenty of reasons that having the vdso be an ELF image is
useful.  For one thing, gdb can take advantage of it.  For another,
CRIU is parsing it for a rather different reason, and something like
__vdso_findsym won't fill that need.

Also, given the general lack of a comprehensible specification of what
the GNU flavor of the ELF format actually is [1], there's something to
be said for reducing the proliferation of ELF parsers.  glibc and
binutils are quite unlikely to become incompatible with each other,
but I sincerely doubt that anyone from binutils land is likely to
review (and maintain!) my ELF parser, Go's, or a hypothetical future
ELF parser from any of the other glibc-less things.  If those things
use one that's in the kernel, then it's easy for the kernel to
guarantee that each vdso image can successfully parse itself.

[1] The only comprehensible description of the GNU hash extension that
I could find is on Oracle's blog (!)

--Andy
