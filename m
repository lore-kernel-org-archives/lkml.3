Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab3HYH05 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 03:26:57 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:38442 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756109Ab3HYH0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 03:26:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130825033741.GX27005@ZenIV.linux.org.uk>
References: <20130822185317.GI31117@1wt.eu> <CALCETrWYeNXhEDY7S9XLD6L0wOZu8iPVO6LN3A_797hLHfBzAw@mail.gmail.com>
 <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
 <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
 <20130822201530.GL31117@1wt.eu> <CALCETrXX--FWeoDMOTYNDOWkTKcWk=LcGs2oY7CQ9GU63CMLRg@mail.gmail.com>
 <CA+55aFzR71kJOOVzHKKaXW2Ph7wb6ivtVHPeR49PPcqpiCfPsA@mail.gmail.com>
 <CALCETrXXxRksU-YTY8WFJzeET9cWsPKo_=6e9RD=F+TS7xVMyQ@mail.gmail.com>
 <CA+55aFxqdV6CQ8UWkB1Z7HUB9GmRH4Jpw_UmmFqDqG01_DmsWw@mail.gmail.com>
 <20130823010726.GP27005@ZenIV.linux.org.uk> <20130825033741.GX27005@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 25 Aug 2013 00:26:34 -0700
Message-ID: <CALCETrViJ8i3ty8xAECC0nqRuepVeKsW9r2W51tTCDUuB3V25g@mail.gmail.com>
Subject: Re: [PATCH v2] vfs: Tighten up linkat(..., AT_EMPTY_PATH)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        "security@kernel.org" <security@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 8:37 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Aug 23, 2013 at 02:07:26AM +0100, Al Viro wrote:
>> On Thu, Aug 22, 2013 at 01:54:15PM -0700, Linus Torvalds wrote:
>> > On Thu, Aug 22, 2013 at 1:48 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> > >
>> > > Sure.  But aren't they always last?
>> >
>> > What do you mean? I'd say that the /proc lookup is always *innermost*.
>> > Which means that it certainly cannot bail out, since there are many
>> > levels of nesting outside of it.
>> >
>> > > With the current code structure, trying to enforce some kind of
>> > > security restriction in the middle of lookup seems really unpleasant.
>> >
>> > If it's conditional (ie "linkat behaves differently from openat"), it
>> > certainly means that we'd have to pass in that info in annoying ways.
>>
>> Nope.  All we need to pass is one more LOOKUP_...  Add
>>       if (unlikely(nd->last_type == LAST_BIND)) {
>>               if ((nd->flags & LOOKUP_BLAH) && !may_flink(...)) {
>>                       terminate_walk(nd);
>>                       return -EINVAL;
>>               }
>>       }
>> in the beginning of lookup_last() and pass LOOKUP_BLAH in flags when
>> linkat() calls user_path_at().  That will affect *only* the terminal
>> symlinks and cost nothing in all normal cases.  The same check can
>> bloody well go into path_init() - take
>>                 if (*name) {
>>                         if (!can_lookup(dentry->d_inode)) {
>>                                 fdput(f);
>>                                 return -ENOTDIR;
>>                         }
>>                 }
>> in there and slap
>>               else {
>>                       if ((flags & LOOKUP_BLAH) && !may_flink(...)) {
>>                                 fdput(f);
>>                               return -EINVAL;
>>                       }
>>               }
>> after it.
>
> OK, let me summarize these threads so far:
>         * restrictions for flink() are needed and they'd better be
> consistent for AT_SYMLINK_FOLLOW + /proc/<pid>/fd/<n> and simply
> passing the descriptor as dfd.
>         * CAP_DAC_OVERRIDE is sufficient; so should be O_TMPFILE used
> to open that sucker.
>         * lookup_last() is the natural place for catching the case
> of following a trailing procfs symlink - it can be done very cheaply
> there.
>
> FWIW, I'm tempted to try the following trick:
>         * introduce FMODE_FLINK in file->f_mode; O_TMPFILE would set it,
> unless O_EXCL is present.
>         * introduce LOOKUP_LINK, to be passed by sys_linkat() when
> resolving the target.
>         * have path_init() called with empty pathname and LOOKUP_LINK in
> flags do checks for FMODE_FLINK or CAP_DAC_OVERRIDE
>         * have ->proc_get_link() report whether the target is linkable
> (either as bool * or by returning 1 instead of 0).  After the call of
> ->proc_get_link() check that and set nd->last_type to LAST_BIND_LINKABLE.
> Note that *all* places looking at ->last_type treat LAST_BIND as "none
> of the above" - we never compare with it, so splitting it in two wouldn't
> break anything.
>         * have lookup_last() check if LOOKUP_LINK is present and ->last_type
> is LAST_BIND; fail unless we have CAP_DAC_OVERRIDE.
>
> AFAICS, it gets more or less sane behaviour; additionally, it makes possible
> to introduce explicit "I want that descriptor to be suitable for flink()"
> open(2) flag - that would require teaching do_last() about LOOKUP_LINK,
> making it check for CAP_DAC_OVERRIDE if it sees LAST_BIND / LOOKUP_LINK,
> same as lookup_last() above (we obviously want to avoid the possibility
> to take a non-flinkable descriptor and use it to reopen the sucker in
> flinkable way).
>
> Alternatively we can revert "fs: Allow unprivileged linkat(..., AT_EMPTY_PATH)
> aka flink" for the time being.  flink() is certainly an awful mess and I
> seriously regret touching it ;-/
>
> Comments?  Hell, maybe somebody even has printable ones - stranger things
> have happened...

I think this is more screwed up than just flink and open.  For example:

$ echo 'WTF' >test
$ truncate -s 1 /proc/self/fd/3 3<test
$ cat test
W$

IMO that should have failed.

In an ideal world (I think) ffrob(N), frobat(N, "", AT_EMPTY_PATH),
and frobat(AT_FDCWD, "/proc/self/fd/N) should generally do the same
thing.  This includes flink (even though the flink variant doesn't
exist).  open is a bit special.

Of course, we're rather inconsistent with AT_EMPTY_PATH.  utimensat
accepts a null filename instead of a blank filename, and it doesn't
appear to check the file mode at all.

Sigh.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
