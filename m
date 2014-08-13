Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbaHMVfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 17:35:20 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:59797 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaHMVfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 17:35:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Stultz <john.stultz@linaro.org>
Cc: ksummit-discuss@lists.linuxfoundation.org,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Joseph S. Myers" <joseph@codesourcery.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: (Resend) 2038 Kernel Summit Discussion Fodder
Date: Wed, 13 Aug 2014 23:35:11 +0200
Message-ID: <1832675.rG7xa0ukNo@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-23-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53EAAC95.7080301@linaro.org>
References: <53EAAC95.7080301@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:LCHL2bMzx4kL7MTjFRCpMgfktWFcwWDlAvWPJ3jtVlm
 nbKH4Ou0FZZD3K0okgVoAvA7pCZL4VsQFjdFb31mv0fXos0/S+
 3SmbBCinbgSlIVeBV4e/ZHs8R/Nlxvl08VkARS0hKyGTG+o/oA
 Giz2u7mZv8M3ohpJOVT5boaM06qQdNSMj21o9TrrIevQsUWRCo
 B98XYV0i/ujbWjyp6K7kkRP9o2wrC6+Dh5IqA7lO5XyutBbjmG
 tEpblkSYovA6N4oWQkj5WF0AHkvLXROKDKnmiyswPrr2Cz7/2U
 loF12SAwVWI4ObKX3Ixbc+bWI8Jyn0VD/SVW+7nPnN6xIIt7xR
 F99h1FOYqv4rLLf8Zmas=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 August 2014 17:08:53 John Stultz wrote:

> Next week at Kernel Summit, I'm hoping to have a discussion on 2038 during
> one of the unconference slots, so I wanted to send out some background
> information about the various proposed approaches (as well as send this out
> for wider input, since apparently there won't be much libc representation
> at KS).

Thanks a lot for doing the writeup. I've been on vacation the past two weeks,
so I couldn't really contribute much during that time, but a lot of what
you write here is what we discussed earlier in private.

> 1) In-kernel correctness: Making sure the kernel itself handles the 2038
> rollover correctly. As noted in LWN (https://lwn.net/Articles/607741/) this
> work has begun and portions have been merged. Personally, I don’t really
> see this as that interesting of a discussion topic, and with the exception
> of dealing with external representations of time like on-disk filesystem
> formats, etc, it is for the most part a matter of just going through,
> finding and fixing things (with a few extra complications around ioctls).
> Mostly this will revolve around adding explicitly sized 64bit time_t types
> (and 32bit types for compatibility), and migrating in-kernel users over to
> the explicitly sized implementations, allowing us to validate conversion by
> eventually removing the in-kernel time_t type, of course finding non-time_t
> custom storage uses will be a long tail of work.

Some more thoughts on how I think this can proceed:

I think the most important tool here is compile-time validation, by ensuring
no use of time_t or a derived structure (timespec, timeval, itimerspec, ...)
can be compiled if you are building a kernel that you want to survive y2038.

Any drivers or file systems that we don't expect to need at that time
(e.g. ext2/3 rather than ext4) can keep using the unsafe interfaces
but will be disabled in Kconfig or removed from the code using #ifdef
in case we are building a 64-bit-time-only kernel.

> From discussions so far, it seems the preferred change to the userspace
> interface is what I’ll call the “Large File” method, as it follows the
> approach used for large file support:
> 
> Create new 64bit time_t/timespec/timeval/etc variants for syscalls, while
> preserving existing interfaces. This has some complexity around IOCTLs, but
> that can mostly be handled by creating new ioctl numbers while preserving
> the old ones. Since we’re only modifying time types, we’ll also need to add
> compat versions for many of these syscalls for 64bit native systems.

Josh Triplett already brought up the point of introducing completely new
interfaces for some cases and having libc emulate the old calls. A variation
of this would be to not add any 64-bit version of syscalls that are already
outdated. For example, we don't really need a 64-bit gettimeofday system
call, because we can easily implement it through clock_gettime.

I'd rather not introduce a 64-bit version of struct timeval if all syscalls
using it already have a replacement using timespec.

> The downsides here are many. The distros will probably hate this idea, as
> it requires rebuilding the world, and maintaining another legacy
> architecture support. I’m also not completely sure how robust multi-arch
> packaging is in the face of having to handle 3-4 architectures on one
> system. On the kernel side, it also adds more complexity, where we have to
> add even more complex compat support for 64bit systems to handle all the
> various 32bit applications possible.
>
> That said the practical reality isn't much further from the the “Libc
> Version Bump” approach, since legacy support will need legacy versions of
> all dependent libraries there a well. Similarly the additional storage
> required to support legacy applications is a positive motivator to get
> folks to move away from unsafe legacy applications. I also personally like
> the clarity the new virtual architecture brings, and that it would allow a
> kernel option to disable 2038-unsafe legacy support.

As mentioned above, I think the last point is not unique to this approach,
we can and should have that option in any case.

Between the "large file" approach and the "libc version bump" approach,
there doesn't have to be such a strict distinction. As you write, they
are the same from a kernel perspective, and I would expect most libc
implementations other than glibc (i.e. uclibc, bionic, newlib, musl, ...)
to only support the second approach for practical reasons.

In case of glibc, the preferred approach seems to be the "large file"
method, which means that any function passing a time value will have
at least two versions. However, you should be able to build a glibc
binary that only supports the most recent version of these interfaces,
effectively dropping support for the old ABI.

At a distro level, anybody can make the decision when to stop supporting
the old ABI independently: Gentoo can do this as an option as soon
as it works, while Debian can make a 10-year plan for a seamless
migration and Fedora can decide to dodge the problem by never even
enabling 64-bit time and just dropping support for 32-bit architectures
at some point before 2038, following what RHEL7 already did.

Most importantly, the embedded distros that most care about really long
term support (openembedded, buildroot, openwrt, ptxdist, ...) can just
drop 32-bit time_t entirely by switching the default to 64-bit time_t in
a new source release, independent of whether glibc gives them the
option for backwards compatibility or not.

	Arnd
