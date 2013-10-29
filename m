Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab3J2WmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:42:11 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:47421 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3J2WmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:42:09 -0400
MIME-Version: 1.0
In-Reply-To: <20131029221324.GC12814@quack.suse.cz>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
	<CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
	<1814253454.3449.1382689853825.JavaMail.mail@webmail07>
	<20131025091842.GA28681@thunk.org>
	<20131025022937.12623dcd.akpm@linux-foundation.org>
	<CA+55aFzq4-wsErRO56gW6gj3Q91QtvvaGQPdUV2JkSs-B1PCAQ@mail.gmail.com>
	<20131029205756.GH9568@quack.suse.cz>
	<CA+55aFyS1oTF2LKSgmm_TnnKm18CfVZEaue8-EnPQWOikAUWOA@mail.gmail.com>
	<20131029221324.GC12814@quack.suse.cz>
Date: Tue, 29 Oct 2013 15:42:08 -0700
X-Google-Sender-Auth: Eci0rvjNkDc35AtshZfxGjRHvl8
Message-ID: <CA+55aFw_jjB687nJKuVdjPM6BicF-+0da-wSYHLBqdx0ZfVrGw@mail.gmail.com>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>, Maxim Patlasov <mpatlasov@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 3:13 PM, Jan Kara <jack@suse.cz> wrote:
>
>   So I think we both realize this is only about what the default should be.

Yes. Most people will use the defaults, but there will always be
people who tune things for particular loads.

In fact, I think we have gone much too far in saying "all policy in
user space", because the fact is, user space isn't very good at
policy. Especially not at reacting to complex situations with
different devices. From what I've seen, "policy in user space" has
resulted in exactly two modes:

 - user space does something stupid and wrong (example: "nice -19 X"
to work around some scheduler oddities)

 - user space does nothing at all, and the kernel people say "hey,
user space _could_ set this value Xyz, so it's not our problem, and
it's policy, so we shouldn't touch it".

I think we in the kernel should say "our defaults should be what
everybody sane can use, and they should work fine on average". With
"policy in user space" being for crazy people that do really odd
things and can really spare the time to tune for their particular
issue.

So the "policy in user space" should be about *overriding* kernel
policy choices, not about the kernel never having them.

And this kind of "you can have many different devices and they act
quite differently" is a good example of something complicated that
user space really doesn't have a great model for. And we actually have
much better possible information in the kernel than user space ever is
likely to have.

> Also I'm not sure capping dirty limits at 200MB is the best spot. It may be
> but I think we should experiment with numbers a bit to check whether we
> didn't miss something.

Sure. That said, the patch I suggested basically makes the numbers be
at least roughly comparable across different architectures. So it's
been at least somewhat tested, even if 16GB x86-32 machines are
hopefully pretty rare (but I hear about people installing 32-bit on
modern machines much too often).

>>  - temp-files may not be written out at all.
>>
>>    Quite frankly, if you have multi-hundred-megabyte temptiles, you've
>> got issues
>   Actually people do stuff like this e.g. when generating ISO images before
> burning them.

Yes, but then the temp-file is long-lived enough that it *will* hit
the disk anyway. So it's only the "create temporary file and pretty
much immediately delete it" case that changes behavior (ie compiler
assembly files etc).

If the temp-file is for something like burning an ISO image, the
burning part is slow enough that the temp-file will hit the disk
regardless of when we start writing it.

>   There is one more aspect:
> - transforming random writes into mostly sequential writes

Sure. And I think that if you have a big database, that's when you do
end up tweaking the dirty limits.

That said, I'd certainly like it even *more* if the limits really were
per-BDI, and the global limit was in addition to the per-bdi ones.
Because when you have a USB device that gets maybe 10MB/s on
contiguous writes, and 100kB/s on random 4k writes, I think it would
make more sense to make the "start writeout" limits be 1MB/2MB, not
100MB/200MB. So my patch doesn't even take it far enough, it's just a
"let's not be ridiculous". The per-BDI limits don't seem quite ready
for prime time yet, though. Even the new "strict" limits seems to be
more about "trusted filesystems" than about really sane writeback
limits.

Fengguang, comments?

(And I added Maxim to the cc, since he's the author of the strict
mode, and while it is currently limited to FUSE, he did mention USB
storage in the commit message..).

                  Linus
