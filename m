Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3H3KiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:38:23 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51839 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412Ab3H3KiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:38:21 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVnfVcYdc7XHyM9oA5GF-HG35JghWNabE4pgvBvTh1E0g@mail.gmail.com>
References: <CA+55aFyMeK+bAvkqi_HpShqm7Des6uriVP_xp+BJqD0ASCVL0g@mail.gmail.com>
	<1377751465.4028.20.camel@pasglop>
	<20130829070012.GC27322@gmail.com>
	<CA+55aFwzY_1tD5vmaDgwAGLXNSGw4XS8vEp9vOpN6NPm5+Mxow@mail.gmail.com>
	<CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
	<20130830094857.GA14502@gmail.com>
	<CA+icZUX5F8NtZkc1WsFZC8ggs0K7O=dk2iyhwCDi7FQz+7cHeQ@mail.gmail.com>
	<CA+icZUVKkVuOCf1h-g8-XZ=Kjt6aLF7Yh9Mt90hbNa7q0jsvQA@mail.gmail.com>
	<CA+icZUVnfVcYdc7XHyM9oA5GF-HG35JghWNabE4pgvBvTh1E0g@mail.gmail.com>
Date: Fri, 30 Aug 2013 12:38:18 +0200
Message-ID: <CA+icZUVU1u2hMOHT9bVdx=8O5rt9ahBqL=PLZkNpnqo6EXT7Dg@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 12:29 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Aug 30, 2013 at 11:58 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Fri, Aug 30, 2013 at 11:56 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> On Fri, Aug 30, 2013 at 11:48 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>>>
>>>> * Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>>
>>>>> On Fri, Aug 30, 2013 at 9:55 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>>>> > On Fri, Aug 30, 2013 at 5:54 AM, Linus Torvalds
>>>>> > <torvalds@linux-foundation.org> wrote:
>>>>> >> On Thu, Aug 29, 2013 at 8:12 PM, Waiman Long <waiman.long@hp.com> wrote:
>>>>> >>> On 08/29/2013 07:42 PM, Linus Torvalds wrote:
>>>>> >>>>
>>>>> >>>> Waiman? Mind looking at this and testing? Linus
>>>>> >>>
>>>>> >>> Sure, I will try out the patch tomorrow morning and see how it works out for
>>>>> >>> my test case.
>>>>> >>
>>>>> >> Ok, thanks, please use this slightly updated patch attached here.
>>>>> >>
>>>>> >> It improves on the previous version in actually handling the
>>>>> >> "unlazy_walk()" case with native lockref handling, which means that
>>>>> >> one other not entirely odd case (symlink traversal) avoids the d_lock
>>>>> >> contention.
>>>>> >>
>>>>> >> It also refactored the __d_rcu_to_refcount() to be more readable, and
>>>>> >> adds a big comment about what the heck is going on. The old code was
>>>>> >> clever, but I suspect not very many people could possibly understand
>>>>> >> what it actually did. Plus it used nested spinlocks because it wanted
>>>>> >> to avoid checking the sequence count twice. Which is stupid, since
>>>>> >> nesting locks is how you get really bad contention, and the sequence
>>>>> >> count check is really cheap anyway. Plus the nesting *really* didn't
>>>>> >> work with the whole lockref model.
>>>>> >>
>>>>> >> With this, my stupid thread-lookup thing doesn't show any spinlock
>>>>> >> contention even for the "look up symlink" case.
>>>>> >>
>>>>> >> It also avoids the unnecessary aligned u64 for when we don't actually
>>>>> >> use cmpxchg at all.
>>>>> >>
>>>>> >> It's still one single patch, since I was working on lots of small
>>>>> >> cleanups. I think it's pretty close to done now (assuming your testing
>>>>> >> shows it performs fine - the powerpc numbers are promising, though),
>>>>> >> so I'll split it up into proper chunks rather than random commit
>>>>> >> points. But I'm done for today at least.
>>>>> >>
>>>>> >> NOTE NOTE NOTE! My test coverage really has been pretty pitiful. You
>>>>> >> may hit cases I didn't test. I think it should be *stable*, but maybe
>>>>> >> there's some other d_lock case that your tuned waiting hid, and that
>>>>> >> my "fastpath only for unlocked case" version ends up having problems
>>>>> >> with.
>>>>> >>
>>>>> >
>>>>> > Following this thread with half an eye... Was that "unsigned" stuff
>>>>> > fixed (someone pointed to it).
>>>>> > How do you call that test-patch (subject)?
>>>>> > I would like to test it on my SNB ultrabook with your test-case script.
>>>>> >
>>>>>
>>>>> Here on Ubuntu/precise v12.04.3 AMD64 I get these numbers for total loops:
>>>>>
>>>>> lockref:  w/o patch | w/ patch
>>>>> ======================
>>>>> Run #1: 2.688.094 | 2.643.004
>>>>> Run #2: 2.678.884 | 2.652.787
>>>>> Run #3: 2.686.450 | 2.650.142
>>>>> Run #4: 2.688.435 | 2.648.409
>>>>> Run #5: 2.693.770 | 2.651.514
>>>>>
>>>>> Average: 2687126,6 VS. 2649171,2 ( ???37955,4 )
>>>>
>>>> For precise stddev numbers you can run it like this:
>>>>
>>>>    perf stat --null --repeat 5 ./test
>>>>
>>>> and it will measure time only and print the stddev in percentage:
>>>>
>>>>  Performance counter stats for './test' (5 runs):
>>>>
>>>>        1.001008928 seconds time elapsed                                          ( +-  0.00% )
>>>>
>>>
>>> Hi Ingo,
>>>
>>> that sounds really good :-).
>>>
>>> AFAICS 'make deb-pkg' does not have support to build linux-tools
>>> Debian package where perf is included.
>>> Can I run an older version of perf or should I / have to try with the
>>> one shipped in Linux v3.11-rc7+ sources?
>>> How can I build perf standalone, out of my sources?
>>>
>>
>> Hmm, I installed linux-tools-common (3.2.0-53.81).
>>
>> $ perf stat --null --repeat 5 ./t_lockref_from-linus
>> perf_3.11.0-rc7 not found
>> You may need to install linux-tools-3.11.0-rc7
>>
>
> [ Sorry for being off-topic ]
>
> Hey Ingo,
>
> can you help, please?
>
> I installed so far all missing -dev packages...
>
> $ sudo apt-get install libelf-dev libdw-dev libunwind7-dev libslang2-dev
>
> ...and then want a perf-only build...
>
> [ See tools/Makefile ]
>
> $ LANG=C LC_ALL=C make -C tools/ perf_install 2>&1 | tee ../perf_install-log.txt
>
> This ends up like this:
> ...
> make[2]: Entering directory
> `/home/wearefam/src/linux-kernel/linux/tools/lib/traceevent'
> make[2]: Leaving directory
> `/home/wearefam/src/linux-kernel/linux/tools/lib/traceevent'
>     LINK perf
> gcc: error: /home/wearefam/src/linux-kernel/linux/tools/lib/lk/liblk.a:
> No such file or directory
> make[1]: *** [perf] Error 1
> make[1]: Leaving directory `/home/wearefam/src/linux-kernel/linux/tools/perf'
> make: *** [perf_install] Error 2
>
> $ LANG=C LC_ALL=C ll tools/lib/lk/
> total 20
> drwxr-xr-x 2 wearefam wearefam 4096 Aug 30 12:11 ./
> drwxr-xr-x 4 wearefam wearefam 4096 Jul 11 19:42 ../
> -rw-r--r-- 1 wearefam wearefam 1430 Aug 30 09:56 Makefile
> -rw-r--r-- 1 wearefam wearefam 2144 Jul 11 19:42 debugfs.c
> -rw-r--r-- 1 wearefam wearefam  619 Jul 11 19:42 debugfs.h
>
> Why is liblk not built?
>
> - Sedat -
>
> P.S.: To clean perf build, run...
>
> $ LANG=C LC_ALL=C make -C tools/ perf_clean

Sorry for flooding...

The tools/perf only build seems to be BROKEN in v3.11-rc7.

WORKAROUND:

$ sudo apt-get install libelf-dev libdw-dev libunwind7-dev
libslang2-dev libnuma-dev

$ LANG=C LC_ALL=C make -C tools/ liblk

$ LANG=C LC_ALL=C make -C tools/ perf_install

This works here.

- Sedat -
