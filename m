Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaEZUY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:24:58 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:51233 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaEZUYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:24:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140526182644.GP18016@ZenIV.linux.org.uk>
References: <20140526093741.GA1765@lahna.fi.intel.com>
	<20140526135746.GM18016@ZenIV.linux.org.uk>
	<20140526142948.GA1685@lahna.fi.intel.com>
	<20140526152703.GN18016@ZenIV.linux.org.uk>
	<CA+55aFyz1oQQ+uz9DPSEmYBBby1VKTRFz81mTt3mVSLN+tMK+A@mail.gmail.com>
	<20140526182644.GP18016@ZenIV.linux.org.uk>
Date: Mon, 26 May 2014 13:24:52 -0700
X-Google-Sender-Auth: p9dQ7kp7k2qcTylRpz_KfXo9XeA
Message-ID: <CA+55aFxq-=xyNOLKQhS5kwy5FKZ=Jp2XSRnyZLU9e8neBLk_2A@mail.gmail.com>
Subject: Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for 22s! [systemd-udevd:1667]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 11:26 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, May 26, 2014 at 11:17:42AM -0700, Linus Torvalds wrote:
>> On Mon, May 26, 2014 at 8:27 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> >
>> > That's the livelock.  OK.
>>
>> Hmm. Is there any reason we don't have some exclusion around
>> "check_submounts_and_drop()"?
>>
>> That would seem to be the simplest way to avoid any livelock: just
>> don't allow concurrent calls (we could make the lock per-filesystem or
>> whatever). This whole case should all be for just exceptional cases
>> anyway.
>>
>> We already sleep in that thing (well, "cond_resched()"), so taking a
>> mutex should be fine.
>
> What makes you think that it's another check_submounts_and_drop()?

Two things.

(1) The facts.

Just check the callchains on every single CPU in Mika's original email.

It *is* another check_submounts_and_drop() (in Mika's case, always
through kernfs_dop_revalidate()). It's not me "thinking" so. You can
see it for yourself.

This seems to be triggered by systemd-udevd doing (in every single thread):

readlink():
  SyS_readlink ->
    user_path_at_empty ->
      filename_lookup ->
        path_lookupat ->
          link_path_walk ->
            lookup_fast ->
              kernfs_dop_revalidate ->
                check_submounts_and_drop

and I suspect it's the "kernfs_active()" check that basically causes
that storm of revalidate failures that leads to lots of
check_submounts_and_drop() cases.

(2) The code.

Yes, the whole looping over the dentry tree happens in other places
too, but shrink_dcache_parents() is already called under s_umount, and
the out-of-memory pruning isn't done in a for-loop.

So if it's a livelock, check_submounts_and_drop() really is pretty
special. I agree that it's not necessarily unique from a race
standpoint, but it does seem to be in a class of its own when it comes
to be able to *trigger* any potential livelock. In particular, the
fact that kernfs can generate that sudden storm of
check_submounts_and_drop() calls when something goes away.

> I really, really wonder WTF is causing that - we have spent 20-odd
> seconds spinning while dentries in there were being evicted by
> something.  That - on sysfs, where dentry_kill() should be non-blocking
> and very fast.  Something very fishy is going on and I'd really like
> to understand the use pattern we are seeing there.

I think it literally is just a livelock. Just look at the NMI
backtraces for each stuck CPU: most of them are waiting for the dentry
lock in d_walk(). They have probably all a few dentries on their own
list. One of the CPU is actually _in_ shrink_dentry_list().

Now, the way our ticket spinlocks work, they are actually fair: which
means that I can easily imagine us getting into a pattern, where if
you have the right insane starting conditions, each CPU will basically
get their own dentry list.

That said, the only way I can see that nobody ever makes any progress
is if somebody as the inode locked, and then dentry_kill() turns into
a no-op. Otherwise one of those threads should always kill one or more
dentries, afaik. We do have that "trylock on i_lock, then trylock on
parent->d_lock", and if either of those fails, drop and re-try loop. I
wonder if we can get into a situation where lots of people hold each
others dentries locks sufficiently that dentry_kill() just ends up
failing and looping..

Anyway, I'd like Mika to test the stupid "let's serialize the dentry
shrinking in check_submounts_and_drop()" to see if his problem goes
away. I agree that it's not the _proper_ fix, but we're damn late in
the rc series..

               Linus
