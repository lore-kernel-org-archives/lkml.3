Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbaE0Si5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:38:57 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33689 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaE0Siz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:38:55 -0400
MIME-Version: 1.0
In-Reply-To: <1401110850-3552-2-git-send-email-tixxdz@opendz.org>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
	<1401110850-3552-2-git-send-email-tixxdz@opendz.org>
Date: Tue, 27 May 2014 11:38:54 -0700
X-Google-Sender-Auth: x0hqMin8a-lNwLfYxe_uHC3A8ds
Message-ID: <CAGXu5jK_VkS7MPD4seQ2Bfqzi3+=ggfU3JOh6bkgu-YOxZCyhg@mail.gmail.com>
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

On Mon, May 26, 2014 at 6:27 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> Add the deny or allow flags, so we can perform proper permission checks
> and set the result accordingly. These flags are needed in case we have
> to cache the result of permission checks that are done during ->open()
> time. Later during ->read(), we can decide to allow or deny the read().
>
> The pid entries that need these flags are:
> /proc/<pid>/stat
> /proc/<pid>/wchan
> /proc/<pid>/maps  (will be handled in next patches).
>
> These files are world readable, userspace depend on that. To prevent
> ASLR leaks and to avoid breaking userspace, we follow this scheme:
>
> a) Perform permission checks during ->open()
> b) Cache the result of a) and return success
> c) Recheck the cached result during ->read()
> d) If cached == PID_ENTRY_DENY:
>    then we replace the sensitive fields with zeros, userspace won't
>    break and sensitive fields are protected.
>
> These flags are internal to /proc/<pid>/*

Since this complex area of behavior has seen a lot of changes, I think
I'd really like to see some tests in tools/testsing/selftests/
somewhere that actually codify what the expected behaviors should be.

We have a lot of corner cases, a lot of userspace behaviors to retain,
and given how fragile this area has been, I'd love to avoid seeing
regressions. It seems like we need to test file permissions, open/read
permissions, contents, etc, under many different cases (priv, unpriv,
passing between priv/unpriv and unpriv/priv, ptrace checks, etc).

If we could do a "make run_tests" in a selftests subdirectory, it'd be
much easier to a) validate these fixes, and b) avoid regressions.

-Kees

-- 
Kees Cook
Chrome OS Security
