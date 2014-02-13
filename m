Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaBMNoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 08:44:09 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:48417 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaBMNoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:44:06 -0500
MIME-Version: 1.0
In-Reply-To: <20140213115552.GU20378@tucnak.redhat.com>
References: <1392274867-15236-1-git-send-email-steven@uplinklabs.net>
	<tip-a9f180345f5378ac87d80ed0bea55ba421d83859@git.kernel.org>
	<20140213115552.GU20378@tucnak.redhat.com>
Date: Thu, 13 Feb 2014 05:44:02 -0800
Message-ID: <CAKbGBLiZfkFus26K3W14GahA0bi9As+qFoKPiU7JKBAfDKORuA@mail.gmail.com>
Subject: Re: [tip:x86/urgent] compiler/gcc4: Make quirk for asm_volatile_goto(
 ) unconditional
From: Steven Noonan <steven@uplinklabs.net>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, peterz@infradead.org,
        stable@vger.kernel.org, rostedt@goodmis.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Richard Henderson <rth@twiddle.net>, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's the current Arch Linux GCC package:

$ gcc -v
Using built-in specs.
COLLECT_GCC=/usr/bin/gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-unknown-linux-gnu/4.8.2/lto-wrapper
Target: x86_64-unknown-linux-gnu
Configured with: /build/gcc/src/gcc-4.8-20140206/configure
--prefix=/usr --libdir=/usr/lib --libexecdir=/usr/lib
--mandir=/usr/share/man --infodir=/usr/share/info
--with-bugurl=https://bugs.archlinux.org/
 --enable-languages=c,c++,ada,fortran,go,lto,objc,obj-c++
--enable-shared --enable-threads=posix --with-system-zlib
--enable-__cxa_atexit --disable-libunwind-exceptions
--enable-clocale=gnu --disable-libstdcxx-pch --disable-libssp
--enable-gnu-unique-object --enable-linker-build-id
--enable-cloog-backend=isl --disable-cloog-version-check --enable-lto
--enable-plugin --enable-install-libiberty
--with-linker-hash-style=gnu --disable-multilib --disable-werror
--enable-checking=release
Thread model: posix
gcc version 4.8.2 20140206 (prerelease) (GCC)

https://projects.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD?h=packages/gcc&id=53e7ca8e616ebf6530f5dc43e86381dff92f136c

(Resending this message because gmail keeps defaulting to HTML email
and vger.kernel.org keeps rejecting those... Thanks Google.)

On Thu, Feb 13, 2014 at 3:55 AM, Jakub Jelinek <jakub@redhat.com> wrote:
> On Thu, Feb 13, 2014 at 03:37:08AM -0800, tip-bot for Steven Noonan wrote:
>> Commit-ID:  a9f180345f5378ac87d80ed0bea55ba421d83859
>> Gitweb:     http://git.kernel.org/tip/a9f180345f5378ac87d80ed0bea55ba421d83859
>> Author:     Steven Noonan <steven@uplinklabs.net>
>> AuthorDate: Wed, 12 Feb 2014 23:01:07 -0800
>> Committer:  Ingo Molnar <mingo@kernel.org>
>> CommitDate: Thu, 13 Feb 2014 12:34:05 +0100
>>
>> compiler/gcc4: Make quirk for asm_volatile_goto() unconditional
>>
>> I started noticing problems with KVM guest destruction on Linux
>> 3.12+, where guest memory wasn't being cleaned up. I bisected it
>> down to the commit introducing the new 'asm goto'-based atomics,
>> and found this quirk was later applied to those.
>>
>> Unfortunately, even with GCC 4.8.2 (which ostensibly fixed the
>> known 'asm goto' bug) I am still getting some kind of
>> miscompilation. If I enable the asm_volatile_goto quirk for my
>> compiler, KVM guests are destroyed correctly and the memory is
>> cleaned up.
>
> BTW, which exact 4.8.2 were you using?
> The last known asm goto bug has been fixed on October, 10th, 2013:
> http://gcc.gnu.org/PR58670
> so before the October, 16th, 2013 4.8.2 release.  But already since
> May 31th, 2013 the tip of the 4.8 GCC branch has been announcing itself
> as 4.8.2 prerelease.  While some distribution versions of GCC announce
> themselves as the new version only starting from the release date,
> i.e. snapshots in between 4.8.1 release and 4.8.2 release announce
> themselves as 4.8.1, in other distributions or upstream it announces itself
> as 4.8.2.  So, if you are using the latter and a snapshot in between May
> 31th, 2013 and October, 10th, 2013, then you could see gcc patchlevel 2,
> yet have a gcc with that bug unfixed.
> So, if the kernel doesn't use a runtime test/configure test to check for
> this issue, but instead just relies on the patchlevel version, the only
> safe way would be to look for GCC >= 4.9 or GCC 4.8 with patchlevel > 2
> rather than > 1.
>
>         Jakub
