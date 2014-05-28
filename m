Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaE1Q76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:59:58 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:37919 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaE1Q7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:59:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140528114248.GA2893@dztty>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
	<1401110850-3552-2-git-send-email-tixxdz@opendz.org>
	<CAGXu5jK_VkS7MPD4seQ2Bfqzi3+=ggfU3JOh6bkgu-YOxZCyhg@mail.gmail.com>
	<20140528114248.GA2893@dztty>
Date: Wed, 28 May 2014 09:59:54 -0700
X-Google-Sender-Auth: rLsG4Z2kxxOJuTU6f34kbQHJwqo
Message-ID: <CAGXu5jLtinFUuXr2UN0k3BvM5ge4_DfhfKVb8v2SLTbnsMPnOQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] procfs: use flags to deny or allow access to /proc/<pid>/$entry
From: Kees Cook <keescook@chromium.org>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 4:42 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> On Tue, May 27, 2014 at 11:38:54AM -0700, Kees Cook wrote:
>> On Mon, May 26, 2014 at 6:27 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
>> > Add the deny or allow flags, so we can perform proper permission checks
>> > and set the result accordingly. These flags are needed in case we have
>> > to cache the result of permission checks that are done during ->open()
>> > time. Later during ->read(), we can decide to allow or deny the read().
>> >
>> > The pid entries that need these flags are:
>> > /proc/<pid>/stat
>> > /proc/<pid>/wchan
>> > /proc/<pid>/maps  (will be handled in next patches).
>> >
>> > These files are world readable, userspace depend on that. To prevent
>> > ASLR leaks and to avoid breaking userspace, we follow this scheme:
>> >
>> > a) Perform permission checks during ->open()
>> > b) Cache the result of a) and return success
>> > c) Recheck the cached result during ->read()
>> > d) If cached == PID_ENTRY_DENY:
>> >    then we replace the sensitive fields with zeros, userspace won't
>> >    break and sensitive fields are protected.
>> >
>> > These flags are internal to /proc/<pid>/*
>>
>> Since this complex area of behavior has seen a lot of changes, I think
>> I'd really like to see some tests in tools/testsing/selftests/
>> somewhere that actually codify what the expected behaviors should be.
> Ok, sounds good!
>
>> We have a lot of corner cases, a lot of userspace behaviors to retain,
>> and given how fragile this area has been, I'd love to avoid seeing
>> regressions. It seems like we need to test file permissions, open/read
>> permissions, contents, etc, under many different cases (priv, unpriv,
>> passing between priv/unpriv and unpriv/priv, ptrace checks, etc).
> Yes, nice.
>
>> If we could do a "make run_tests" in a selftests subdirectory, it'd be
>> much easier to a) validate these fixes, and b) avoid regressions.
> Ok!
>
> Since I'm working on this on my free time and when time permits, please
> give me some days! I'll try to handle the cases I've discussed here.
>
> Now Kees, some of these files are still world readable and affected:
> smaps, maps ... I know, it's a matter of suid binary on your distro, and
> every one can exploit it. So what to do: make the tests public or write
> the tests and fix these entries then at last make the tests public ?

I expect these tests to be public -- there is nothing secret about how
things are currently vulnerable. I think the priv vs unpriv tests can
be emulated (without root setuid) using a prctl(PR_SET_DUMPABLE, 0)
call which should give you similar protections.

> Where should I send the tests ?

They should be part of the patch series, and live in the
tools/testing/selftests/ tree of the kernel. There are plenty of
examples in there. If you have the tests as the first set of patches,
then you can show which tests start passing with each additional fix.
I would break the tests up into "what is expected to work now" that
all pass, and then add all the cases that are currently a problem that
will all fail. Then as more of the fixes land from your series, more
of those tests will pass until everything is passing.

-Kees

-- 
Kees Cook
Chrome OS Security
