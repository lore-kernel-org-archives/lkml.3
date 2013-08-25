Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab3HYREi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 13:04:38 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:41457 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513Ab3HYREh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 13:04:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130825142307.GA27005@ZenIV.linux.org.uk>
References: <CA+55aFw3AM2Xe2aNUKk0x8ZrZHbY4QnaRZbZdAqf1trT+dGDmQ@mail.gmail.com>
 <CALCETrU2xBykonV2N8bSysdycfZkCq_P5bUnrN5SjZo2_5dNrg@mail.gmail.com>
 <20130822201530.GL31117@1wt.eu> <CALCETrXX--FWeoDMOTYNDOWkTKcWk=LcGs2oY7CQ9GU63CMLRg@mail.gmail.com>
 <CA+55aFzR71kJOOVzHKKaXW2Ph7wb6ivtVHPeR49PPcqpiCfPsA@mail.gmail.com>
 <CALCETrXXxRksU-YTY8WFJzeET9cWsPKo_=6e9RD=F+TS7xVMyQ@mail.gmail.com>
 <CA+55aFxqdV6CQ8UWkB1Z7HUB9GmRH4Jpw_UmmFqDqG01_DmsWw@mail.gmail.com>
 <20130823010726.GP27005@ZenIV.linux.org.uk> <20130825033741.GX27005@ZenIV.linux.org.uk>
 <CALCETrViJ8i3ty8xAECC0nqRuepVeKsW9r2W51tTCDUuB3V25g@mail.gmail.com> <20130825142307.GA27005@ZenIV.linux.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 25 Aug 2013 10:04:16 -0700
Message-ID: <CALCETrXpPrQgmHoejy_nV0CBSDNSeVfMRdyAz8aVP2FihHG8Vw@mail.gmail.com>
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

On Sun, Aug 25, 2013 at 7:23 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Aug 25, 2013 at 12:26:34AM -0700, Andy Lutomirski wrote:
>
>> I think this is more screwed up than just flink and open.  For example:
>>
>> $ echo 'WTF' >test
>> $ truncate -s 1 /proc/self/fd/3 3<test
>> $ cat test
>> W$
>>
>> IMO that should have failed.
>
> Why?  truncate() always follows links, so what's the problem with that
> one?  That you get checks of truncate() and not ftruncate()?

The same as the issue with all these other things: the fd might have
survived a privilege drop or been passed through exec or SCM_RIGHTS,
and the holder of the fd might not be able to see the inode.

For example, suppose a daemon creates a file with O_TMPFILE | O_RDWR.
Then it does open("/proc/self/fd/N", O_RDONLY) to get a read-only fd
for the same temporary file.  It passes that fd to something else.
It's rather surprising that the recipient would be able to truncate it
using /proc/self/fd when it couldn't ftruncate it due to its being
O_RDONLY.

(Of course, this can be worked around by setting the mode to 0644, but
I doubt that everyone will get that right.)

>
>> In an ideal world (I think) ffrob(N), frobat(N, "", AT_EMPTY_PATH),
>> and frobat(AT_FDCWD, "/proc/self/fd/N) should generally do the same
>> thing.
>
> What about the cases where frob() and ffrob() check for different things?

I'll go out on a limb and say that every single case where ffrob has a
check that frob("/proc/self/fd/N") doesn't is wrong.  Maybe we're
stuck with them for backwards compatibility, but that doesn't mean
they're good ideas.

--Andy
