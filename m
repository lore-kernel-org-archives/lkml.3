Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572AbaEZQ5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:57:39 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:52404 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaEZQ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:57:37 -0400
MIME-Version: 1.0
In-Reply-To: <1401110850-3552-2-git-send-email-tixxdz@opendz.org>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org> <1401110850-3552-2-git-send-email-tixxdz@opendz.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 26 May 2014 09:57:16 -0700
Message-ID: <CALCETrUte7WRMi23+rp+XbgAoOcw=TPZe02YEuZRZyVroj+mfQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] procfs: use flags to deny or allow access to /proc/<pid>/$entry
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
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

Why is (c) needed?

>
>  /*
> + * Flags used to deny or allow current to access /proc/<pid>/$entry
> + * after proper permission checks.
> + */
> +enum {
> +       PID_ENTRY_DENY  = 0,    /* Deny access */
> +       PID_ENTRY_ALLOW = 1,    /* Allow access */
> +};

I think this would be less alarming if this were:

#define PID_ENTRY_DENY ((void *)1UL)
#define PID_ENTRY_ALLOW ((void *)2UL)

Also, I don't like DENY and ALLOW.  It's not denying and allowing.
How about PID_ENTRY_OPENER_MAY_PTRACE and
PID_ENTRY_OPENER_MAY_NOT_PTRACE?

--Andy
