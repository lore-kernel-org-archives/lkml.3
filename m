Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbbAEW4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:56:54 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49435 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbbAEW4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:56:52 -0500
MIME-Version: 1.0
In-Reply-To: <54A8791B.6020001@nod.at>
References: <20150102194616.GA27538@amd>
	<54A7103E.6020500@nod.at>
	<20150102222936.GA29018@amd>
	<alpine.LRH.2.00.1501022331060.30884@twin.jikos.cz>
	<20150102224646.GB29018@amd>
	<alpine.LNX.2.00.1501022348070.16297@pobox.suse.cz>
	<20150102225420.GC29018@amd>
	<54A72306.2050908@nod.at>
	<20150102230837.GA4482@amd>
	<54A7BA45.1050005@nod.at>
	<20150103223644.GB27979@amd>
	<CALCETrWBHJ52YjowqJ7S90bXvkw_B1VxbkSDKpyjwC1WYvGE3w@mail.gmail.com>
	<54A8791B.6020001@nod.at>
Date: Mon, 5 Jan 2015 14:56:51 -0800
X-Google-Sender-Auth: riSjoE2daYWEgehGK0IageiKkd4
Message-ID: <CAGXu5j+SFV-nird_YpqiSNV2MUZnmkTJy44u=_vqmEiQjjK3fg@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Deter exploit bruteforcing
From: Kees Cook <keescook@chromium.org>
To: Richard Weinberger <richard@nod.at>
Cc: Andy Lutomirski <luto@amacapital.net>, Pavel Machek <pavel@ucw.cz>,
        Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        DaeSeok Youn <daeseok.youn@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, vdavydov@parallels.com,
        Rik van Riel <riel@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Brad Spengler <spender@grsecurity.net>,
        PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 3, 2015 at 3:19 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 04.01.2015 um 00:06 schrieb Andy Lutomirski:
>> As an attempt to help end this particular line of debate: putting the
>> sleep in glibc won't work.  The point isn't to make the crashed
>> process crash more slowly; it's to limit the rate at which *new*
>> siblings can be forked and crashed as a canary or ASLR brute-force
>> probe.  IOW, adding a sleep call to glibc slows down the wrong thing.
>> Also, trying to get libc to take action on a plain old segfault is a
>> giant mess, because it involves mucking with signal handling, which
>> glibc really has no business doing by default.
>
> Thanks for pointing this out!

Yeah, this doesn't belong in glibc. The support for fork-speed-control
must be in the kernel. Improving glibc is an entirely separate idea.

For glibc, it would be nice to create a "halp, I'm being attacked"
syscall that like abort(), but used in cases of memory corruption,
etc. This would provide a much cleaner way for programs to communicate
to the kernel that something malicious is happening. Neither SIGABRT
nor SIGSYS are quite right for this, but SIGSYS (as used by seccomp)
is likely closer.

>> Also, this patch is missing a bit, I think.  We really want to control
>> the total rate of crashes.  This patch imposes a delay per crash, but
>> AFAICS it would still be possible for an attacker to coerce a forking
>> server to fork, say, 10k children, then probe all of them, then wait
>> 30 seconds and repeat.

I general, while I would expect this to be limited by the default
RLIMIT_NOFILE of 1024, it's still a valid observation, though the
scope is smaller. Regardless, it would still be a defensive benefit to
slow down forks.

Brad, PaXTeam: have you considered limiting open connections from the
same IP address or anything like that for defending against this kind
"wide prefork" attack?

> Sounds reasonable. This is exactly why I've extracted that feature from
> grsecurity and posted it here on LKML.
> Now we have the chance to make the feature better and can identify weak points.

The grsecurity version also handles set[ug]id binaries more aggressively.
https://en.wikibooks.org/wiki/Grsecurity/Appendix/Grsecurity_and_PaX_Configuration_Options#Deter_exploit_bruteforcing

Speaking to "default or not", it needs to be off by default in the
kernel configs. It's easy to imagine things that will trip on false
positives, so we must first get the system in place in the kernel and
improve it until we get to the point where we can set it on by default
(this may take years, after all the distros are using it, etc etc).
Security feature addition requires a fair bit of patience. :)

If you can spin up a version with sysctls and Kconfig stuff, I think
that'd be the best next step.

-Kees

-- 
Kees Cook
Chrome OS Security
