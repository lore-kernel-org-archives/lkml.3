Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbaFMPfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:35:13 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:37336 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaFMPfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:35:12 -0400
MIME-Version: 1.0
In-Reply-To: <539A8EA8.9080901@zytor.com>
References: <CALCETrVNiSUHok1xCfy9CMe=kDYsPy3i_NXm0_gcO1ckb9wdeQ@mail.gmail.com>
 <539A8EA8.9080901@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 13 Jun 2014 08:34:50 -0700
Message-ID: <CALCETrVya47r1j6YUHT4_=gb6Pb5qB4sGE5sfwmxievcjdTTUw@mail.gmail.com>
Subject: Re: vdso feature requests from the Go people
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Russ Cox <rsc@golang.org>,
        Ian Taylor <iant@golang.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 10:39 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 06/12/2014 09:36 PM, Andy Lutomirski wrote:
>>
>> 1. Parsing the vDSO is a PITA.  What if we bundled the reference
>> parser inside the vdso?  Concretely, we could have AT_VDSO_FINDENTRY
>> point to a function like:
>>
>> void *vdso_find_entry(const char *name, const char *version)
>>
>> Then things like Go and maybe even musl (and klibc?) could just call
>> that function.  And we'd never have to worry about maintaining
>> compatibility with more and more weird vdso parsers.
>>
>> Implementing this could be as simple as shoving parse_vdso.c into the
>> vdso, although vdso2c could help and allow a really simple in-vdso
>> implementation.
>>
>
> I'm not really sure how much of a win that is... you have to parse
> *something*, and for the vast majority of all implementations there will
> be a dynamic linker just sitting there, and that is what it *does*.

I'm only aware of two implementations that work like that: glibc and
musl.  AFAIK neither one even tries to use the vdso when statically
linked.  IIRC, Bionic doesn't support the vdso at all, and Go has the
present issue.

And ELF parsing is a giant mess.  Currently the vdso doesn't use
DT_GNU_HASH (easy to fix) but no one can safely rely on DT_GNU_HASH
being there, and DT_GNU_HASH isn't actually easier to parse.

My point is that, for things that otherwise need to carry around a
full ELF loader, having a really easy, guaranteed-correct way to use
the vdso would be useful.

I can see how much text size it would add.  If the parser were part of
the vdso, it could probably be trimmed down a lot.  For example, there
is currently exactly one version definition, and it could be
hard-coded.  If someone were to add another version definition, they
could fix the parser at the same time.

Basically, everything except for the vdso_sym function in my parser could go.

>
>> 2. Go uses a segmented stack, and the vdso is quite unfriendly for
>> segmented stack.  If we can get compiler support, is there a
>> reasonable way that we could advertise the maximum stack usage of each
>> vdso entry point?
>
> I suspect an easier way to do that would just be to define a maximum
> stack usage for *any* vdso entry point, and then enable the gcc stack
> depth warning (perhaps even with Werror)... we can do this now.

I can imagine this causing lots of pain when gcc 4.11 comes out with
some issue that blows up the stack usage.  Or when akpm compiles on
Fedora Core 6 using some ancient toolchain that spills every local
variable three or four times and assigns every possible inline
function its own non-overlapping stack range.

My copy of gcc supports -fstack-usage, which seems like an easyish way
to obtain the information.  I'm not entirely sure whether
-fstack-usage refers to the whole call tree or just to the specific
function.

--Andy
