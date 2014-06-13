Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaFMQDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:03:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49731 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbaFMQDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:03:16 -0400
Message-ID: <539B20B6.2070705@zytor.com>
Date: Fri, 13 Jun 2014 09:03:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Russ Cox <rsc@golang.org>,
        Ian Taylor <iant@golang.org>
Subject: Re: vdso feature requests from the Go people
References: <CALCETrVNiSUHok1xCfy9CMe=kDYsPy3i_NXm0_gcO1ckb9wdeQ@mail.gmail.com> <539A8EA8.9080901@zytor.com> <CALCETrVya47r1j6YUHT4_=gb6Pb5qB4sGE5sfwmxievcjdTTUw@mail.gmail.com>
In-Reply-To: <CALCETrVya47r1j6YUHT4_=gb6Pb5qB4sGE5sfwmxievcjdTTUw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2014 08:34 AM, Andy Lutomirski wrote:
> 
> I'm only aware of two implementations that work like that: glibc and
> musl.  AFAIK neither one even tries to use the vdso when statically
> linked.  IIRC, Bionic doesn't support the vdso at all, and Go has the
> present issue.
> 

I would expect uClibc to behave similarly.  Bionic does, indeed, not
support the vdso, but that is not for the lack of a linker but is really
a shortcoming in Bionic.

> And ELF parsing is a giant mess.  Currently the vdso doesn't use
> DT_GNU_HASH (easy to fix) but no one can safely rely on DT_GNU_HASH
> being there, and DT_GNU_HASH isn't actually easier to parse.

Right... and the vdso is small enough that the performance doesn't
matter.  However, we probably *ought* to publish DT_GNU_HASH data.

>>> 2. Go uses a segmented stack, and the vdso is quite unfriendly for
>>> segmented stack.  If we can get compiler support, is there a
>>> reasonable way that we could advertise the maximum stack usage of each
>>> vdso entry point?
>>
>> I suspect an easier way to do that would just be to define a maximum
>> stack usage for *any* vdso entry point, and then enable the gcc stack
>> depth warning (perhaps even with Werror)... we can do this now.
> 
> I can imagine this causing lots of pain when gcc 4.11 comes out with
> some issue that blows up the stack usage.  Or when akpm compiles on
> Fedora Core 6 using some ancient toolchain that spills every local
> variable three or four times and assigns every possible inline
> function its own non-overlapping stack range.
> 
> My copy of gcc supports -fstack-usage, which seems like an easyish way
> to obtain the information.  I'm not entirely sure whether
> -fstack-usage refers to the whole call tree or just to the specific
> function.

There are issues either way.  However, most vdso code doesn't use much
stack at all, and it seems reasonable to put a (conservative) cap on it
as a matter of policy.

	-hpa


