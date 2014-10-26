Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbaJZS4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 14:56:11 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:44440 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJZS4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 14:56:09 -0400
MIME-Version: 1.0
In-Reply-To: <20141026035705.GP7996@ZenIV.linux.org.uk>
References: <544C50CB.4090408@oracle.com>
	<87siibttyi.fsf@x220.int.ebiederm.org>
	<20141026030608.GN7996@ZenIV.linux.org.uk>
	<20141026035100.GO7996@ZenIV.linux.org.uk>
	<20141026035705.GP7996@ZenIV.linux.org.uk>
Date: Sun, 26 Oct 2014 11:56:08 -0700
X-Google-Sender-Auth: Ug1OvrsTCMT0EFFaEyL3U0F6zAk
Message-ID: <CA+55aFzcRyA0kcXN28OHjPQfR-BP442+tz6Rti7Fbc0VXuawww@mail.gmail.com>
Subject: Re: fs: lockup on rename_mutex in fs/dcache.c:1035
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 8:57 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> [context for Linus]
>
> Fuzzer has triggered deadlock in d_walk() with rename_lock taken twice.
> AFAICS, the plausible scenario is
>                          (child->d_flags & DCACHE_DENTRY_KILLED) ||
> triggering while ascending to parent, on the pass with rename_lock already
> held exclusive.  In that case we go to rename_retry and either return without
> unlocking rename_lock, or try to take in exclusive one more time, again
> without unlocking it first.

Your patch looks fine, and I don't think we can livelock - because we
always set 'seq' to 1 if we retry, and that causes us to get the
exclusive lock, so we'd better not then enter the retry loop again.
Although I guess not only renames cause it - looks like we get to that
mis-named "rename_retry" for a deletion too according to the comment.
Although I'm not sure that comment is correct - I don't think we
change d_parent for deletes, do we?

So at a quick glance, the one-liner patch looks fine. That said, I
really detest how that code is written. Especially if the rename_retry
really can only happen once, I get the feeling that we would be *much*
better off doing this explicitly with a wrapper function, and do
something like

   void d_walk(,..)
   {
       /* Try non-exclusive first */
       seq = read_seqbegin(lock);
       retry = __d_walk(.. seq);
       if (retry) {
              read_seqlock_excl(lock);
              // lock->seqcount is now guaranteed stable
              retry = __d_walk(.. lock->seqcount);
              read_sequnlock_excl(lock);
              WARN_ON_ONCE(retry, "Really?");
       }
   }

or whatever. But maybe I'm missing some reason why the above is just
crazy, and I'm a moron. Entirely possible.

                     Linus
