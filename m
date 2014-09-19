Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637AbaISRdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:33:17 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:49590 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbaISRdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:33:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140919104204.3b0bb762@lwn.net>
References: <cover.1410810247.git.milosz@adfin.com>
	<cover.1410983998.git.milosz@adfin.com>
	<20140919104204.3b0bb762@lwn.net>
Date: Fri, 19 Sep 2014 13:33:14 -0400
Message-ID: <CANP1eJEhHyA93kDUCz_=0vDjdPXz7g0x1SmW+q060fntQAbrYA@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Non-blockling buffered fs read (page cache only)
From: Milosz Tanski <milosz@adfin.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 10:42 AM, Jonathan Corbet <corbet@lwn.net> wrote:
> On Wed, 17 Sep 2014 22:20:45 +0000
> Milosz Tanski <milosz@adfin.com> wrote:
>
>> This patcheset introduces an ability to perform a non-blocking read from
>> regular files in buffered IO mode. This works by only for those filesystems
>> that have data in the page cache.
>>
>> It does this by introducing new syscalls new syscalls readv2/writev2 and
>> preadv2/pwritev2. These new syscalls behave like the network sendmsg, recvmsg
>> syscalls that accept an extra flag argument (O_NONBLOCK).
>
> So I'm trying to understand the reasoning behind this approach so I can
> explain it to others.  When you decided to add these syscalls, you
> ruled out some other approaches that have been out there for a while.
> I assume that, before these syscalls can be merged, people will want to
> understand why you did that.  So I'll ask the dumb questions:
>
>  - Non-blocking I/O has long been supported with a well-understood set
>    of operations - O_NONBLOCK and fcntl().  Why do we need a different
>    mechanism here - one that's only understood in the context of
>    buffered file I/O?  I assume you didn't want to implement support
>    for poll() and all that, but is that a good enough reason to add a
>    new Linux-specific non-blocking I/O technique?

I realized that I didn't answer this question well in my other long
email. O_NONBLOCK doesn't work on files under any commonly used OS,
and people have gotten use to this behavior so I doubt we could change
that without breaking a lot of folks applications. If you want to
ignore my other long email, what I realized that I could solve a lot
of problems if I had a syscall like recvmsg that takes a MSG_NONBLOCK
argument that worked on regular files (not sockets) and thus
readv2/preadv2 was born.

>
>  - Patches adding fincore() have been around since at least 2010; see,
>    for example, https://lwn.net/Articles/371538/ or
>    https://lwn.net/Articles/604640/.  It seems this could be used in
>    favor of four new read() syscalls; is there a reason it's not
>    suitable for your use case?
>
>  - Patches adding buffered support for AIO have been around since at
>    least 2003 - https://lwn.net/Articles/24422/, for example.  I guess
>    I don't really have to ask why you don't want to take that
>    approach! :)
>
> Apologies for my ignorance here; that's what I get for hanging around
> with the MM folks at LSFMM, I guess.  Anyway, I suspect I'm not the
> only one who would appreciate any background you could give here.
>
> Thanks,
>
> jon



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
