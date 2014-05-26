Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaEZRVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:21:11 -0400
Received: from numidia.opendz.org ([98.142.220.152]:35142 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaEZRVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:21:09 -0400
Date: Mon, 26 May 2014 18:21:01 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Andy Lutomirski <luto@amacapital.net>
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
Subject: Re: [PATCH 1/9] procfs: use flags to deny or allow access to
 /proc/<pid>/$entry
Message-ID: <20140526172101.GA6380@dztty>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
 <1401110850-3552-2-git-send-email-tixxdz@opendz.org>
 <CALCETrUte7WRMi23+rp+XbgAoOcw=TPZe02YEuZRZyVroj+mfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUte7WRMi23+rp+XbgAoOcw=TPZe02YEuZRZyVroj+mfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 09:57:16AM -0700, Andy Lutomirski wrote:
> On Mon, May 26, 2014 at 6:27 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> > Add the deny or allow flags, so we can perform proper permission checks
> > and set the result accordingly. These flags are needed in case we have
> > to cache the result of permission checks that are done during ->open()
> > time. Later during ->read(), we can decide to allow or deny the read().
> >
> > The pid entries that need these flags are:
> > /proc/<pid>/stat
> > /proc/<pid>/wchan
> > /proc/<pid>/maps  (will be handled in next patches).
> >
> > These files are world readable, userspace depend on that. To prevent
> > ASLR leaks and to avoid breaking userspace, we follow this scheme:
> >
> > a) Perform permission checks during ->open()
> > b) Cache the result of a) and return success
> > c) Recheck the cached result during ->read()
> 
> Why is (c) needed?
In order to not break these entries, some of them are world readable.

So we perform the re-check that *single* cached integer, in order to
allow access for the non-sensitive, and block or pad with zeros the
sensitive.


> >
> >  /*
> > + * Flags used to deny or allow current to access /proc/<pid>/$entry
> > + * after proper permission checks.
> > + */
> > +enum {
> > +       PID_ENTRY_DENY  = 0,    /* Deny access */
> > +       PID_ENTRY_ALLOW = 1,    /* Allow access */
> > +};
> 
> I think this would be less alarming if this were:
> 
> #define PID_ENTRY_DENY ((void *)1UL)
> #define PID_ENTRY_ALLOW ((void *)2UL)
Hmm,

I would like to keep it enum, enum is type-safe and I want to follow the
semantics of /proc/pid/stat and others:

check the patches and you will see that by making the variable 1 or 0 it
follows what's currently done, and IMHO 0 or 1 is more intuitive in this
case!

> Also, I don't like DENY and ALLOW.  It's not denying and allowing.
> How about PID_ENTRY_OPENER_MAY_PTRACE and
> PID_ENTRY_OPENER_MAY_NOT_PTRACE?
Hm, Ok I'll perhaps change this! will see what other thinks!

Thank you!

> --Andy

-- 
Djalal Harouni
http://opendz.org
