Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaFJSyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:54:13 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:58284 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaFJSyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:54:10 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAKbGBLi1hRxe03EB70HOYRTuVhHkAyTnhfv8HFXEwatP6Qn8tA@mail.gmail.com>
References: <alpine.LNX.2.00.1406101517300.9378@pobox.suse.cz> <CA+55aFyY7_=3xt-0KE=-fmb+kLurxkBmh8TZWgDZMi_RVpKBpg@mail.gmail.com> <CAKbGBLi1hRxe03EB70HOYRTuVhHkAyTnhfv8HFXEwatP6Qn8tA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] tell gcc optimizer to never introduce new data races
From: Richard Biener <richard.guenther@gmail.com>
Date: Tue, 10 Jun 2014 20:54:09 +0200
To: Steven Noonan <steven@uplinklabs.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Jiri Kosina <jkosina@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Jambor <mjambor@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Message-ID: <fb599019-daba-4d09-8524-fa692bd1f3a4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On June 10, 2014 8:04:13 PM CEST, Steven Noonan <steven@uplinklabs.net> wrote:
>On Tue, Jun 10, 2014 at 10:46 AM, Linus Torvalds
><torvalds@linux-foundation.org> wrote:
>> On Tue, Jun 10, 2014 at 6:23 AM, Jiri Kosina <jkosina@suse.cz> wrote:
>>> We have been chasing a memory corruption bug, which turned out to be
>>> caused by very old gcc (4.3.4), which happily turned conditional
>load into
>>> a non-conditional one, and that broke correctness (the condition was
>met
>>> only if lock was held) and corrupted memory.
>>
>> Just out of interest, can you point to the particular kernel code
>that
>> caused this? I think that's more interesting than the example program
>> you show - which I'm sure is really nice for gcc developers as an
>> example, but from a kernel standpoint I think it's more important to
>> show the particular problems this caused for the kernel?
>>
>
>Jiri, is there a workaround for compilers that don't support '--param
>allow-store-data-races=0'? For example:

The optimization that purposely performs the undesired transform is loop store motion which is part of the tree loop invariant motion optimization. You can disable that with -fno-tree-loop-im.

That the bug didn't appear with newer compilers was due to lucky decisions to not inline a particular function.

Richard.

>$ gcc-4.5 -O2 -o cond_store cond_store.c && ./cond_store
>Segmentation fault (core dumped)
>
>$ gcc-4.5 -O2 --param allow-store-data-races=0 -o cond_store
>cond_store.c && ./cond_store
>cc1: error: invalid parameter ‘allow-store-data-races’
>
>$ gcc-4.5 -v
>Using built-in specs.
>COLLECT_GCC=gcc-4.5
>COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-unknown-linux-gnu/4.5.4/lto-wrapper
>Target: x86_64-unknown-linux-gnu
>Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
>--infodir=/usr/share/info --libdir=/usr/lib --libexecdir=/usr/lib
>--program-suffix=-4.5 --enable-shared
>--enable-languages=c,c++,fortran,objc,obj-c++ --enable-__cxa_atexit
>--disable-libstdcxx-pch --disable-multilib --disable-libgomp
>--disable-libmudflap --disable-libssp --enable-clocale=gnu
>--with-tune=generic --with-cloog --with-ppl --with-system-zlib
>Thread model: posix
>gcc version 4.5.4 (GCC)


