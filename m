Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129Ab3IGRwG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 13:52:06 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:34505 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3IGRwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 13:52:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130907030110.GY13318@ZenIV.linux.org.uk>
References: <1378483738-10129-1-git-send-email-Waiman.Long@hp.com>
	<1378483738-10129-2-git-send-email-Waiman.Long@hp.com>
	<CA+55aFw8UuEmKsSdGZPUmcekZheNimEt4U81i7Bz0LipGzsFmg@mail.gmail.com>
	<20130906210546.GW13318@ZenIV.linux.org.uk>
	<CA+55aFzf-reQNSQt_fhHfUe_tB19n2qEa=Rd=wFEBJEVALmezA@mail.gmail.com>
	<20130907000044.GX13318@ZenIV.linux.org.uk>
	<CA+55aFwy_x65HaLOgKuK7AyQayraU4M6q78L_hnAvLg1NSgTpw@mail.gmail.com>
	<CA+55aFzwederWB135Ch+PjijjrN-kz9UKw+obC4+M_+xq648PA@mail.gmail.com>
	<20130907030110.GY13318@ZenIV.linux.org.uk>
Date: Sat, 7 Sep 2013 10:52:02 -0700
X-Google-Sender-Auth: t2ZlH-Haj6h-VL2Gl50vbrrNuUE
Message-ID: <CA+55aFyJ8CvfYzh8LFRY_6tx+GgzVfps1hSwJeSUz=G=FrsgkQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 8:01 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
>         * plain seqretry loop (d_lookup(), is_subdir(), autofs4_getpath(),
> ceph_misc_build_path(), [cifs] build_path_from_dentry(), nfs_path(),
> [audit] handle_path())
>         * try seqretry once, then switch to write_seqlock() (the things
> that got unified into d_walk())
>         * try seqretry three times, then switch to write_seqlock() (d_path()
> and friends)
>         * several pure write_seqlock() users (d_move(), d_set_mounted(),
> d_materialize_unique())
>
> The last class is not a problem - these we want as writers.  I really don't
> like the way the rest is distributed - if nothing else, nfs_path() and
> friends are in exactly the same situation as d_path().  Moreover, why
> the distinction between "try once" and "try thrice"?
>
> _If_ we fold the second and the third groups together (and probably have
> a bunch from the first one join that), we at least get something
> understandable, but the I really wonder if seqlock has the right calling
> conventions for that (and at least I'd like to fold the "already got writelock"
> flag into seq - we do have a spare bit there).
>
> Comments?

So I think we could make a more complicated data structure that looks
something like this:

   struct seqlock_retry {
      unsigned int seq_no;
      int state;
   };

and pass that around. Gcc should do pretty well, especially if we
inline things (but even if not, small structures that fit in 64 bytes
generate reasonable code even on 32-bit targets, because gcc knows
about using two registers for passing data around)..

Then you can make "state" have a retry counter in it, and have a
negative value mean "I hold the lock for writing". Add a couple of
helper functions, and you can fairly easily handle the mixed "try for
reading first, then fall back to writing".

That said, __d_lookup() still shows up as very performance-critical on
some loads (symlinks in particular cause us to fall out of the RCU
cases) so I'd like to keep that using the simple pure read case. I
don't believe you can livelock it, as mentioned. But the other ones
might well be worth moving to a "fall back to write-locking after <n>
tries" model. They might all traverse user-specified paths of fairly
arbitrary depth, no?

So this "seqlock_retry" thing wouldn't _replace_ bare seqlocks, it
would just be a helper thing for this kind of behavior where we want
to normally do things with just the read-lock, but want to guarantee
that we don't live-lock.

Sounds reasonable?

                 Linus
