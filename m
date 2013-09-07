Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750847Ab3IGDBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 23:01:21 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38573 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3IGDBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 23:01:19 -0400
Date: Sat, 7 Sep 2013 04:01:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        George Spelvin <linux@horizon.com>, John Stoffel <john@stoffel.org>
Subject: Re: [PATCH v3 1/1] dcache: Translating dentry into pathname without
 taking rename_lock
Message-ID: <20130907030110.GY13318@ZenIV.linux.org.uk>
References: <1378483738-10129-1-git-send-email-Waiman.Long@hp.com>
 <1378483738-10129-2-git-send-email-Waiman.Long@hp.com>
 <CA+55aFw8UuEmKsSdGZPUmcekZheNimEt4U81i7Bz0LipGzsFmg@mail.gmail.com>
 <20130906210546.GW13318@ZenIV.linux.org.uk>
 <CA+55aFzf-reQNSQt_fhHfUe_tB19n2qEa=Rd=wFEBJEVALmezA@mail.gmail.com>
 <20130907000044.GX13318@ZenIV.linux.org.uk>
 <CA+55aFwy_x65HaLOgKuK7AyQayraU4M6q78L_hnAvLg1NSgTpw@mail.gmail.com>
 <CA+55aFzwederWB135Ch+PjijjrN-kz9UKw+obC4+M_+xq648PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzwederWB135Ch+PjijjrN-kz9UKw+obC4+M_+xq648PA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 05:58:51PM -0700, Linus Torvalds wrote:
> On Fri, Sep 6, 2013 at 5:19 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > (We're bounded in practice by PATH_MAX, so you can't make getcwd()
> > traverse more than about 2000 parents (single character filename plus
> > the slash for each level), and for all I know filesystems might cap it
> > before that, so it's not unbounded, but the difference between "1" and
> > "2000" is pretty damn big)
> 
> .. in particular, it's big enough that one is pretty much guaranteed
> to fit in any reasonable L1 cache (if we have dentry hash chains so
> long that that becomes a problem for traversing a single chain, we're
> screwed anyway), while the other can most likely be a case of "not a
> single L1 cache hit because by the time you fail and go back to the
> start, you've flushed the L1 cache".
> 
> Now, whether 2000 L2 cache misses is long enough to give people a
> chance to run the whole rename system call path in a loop a few times,
> I don't know, but it sure as heck sounds likely.
> 
> Of course, you might still ask "why should we even care?" At least
> without preemption, you might be able to trigger some really excessive
> latencies and possibly a watchdog screaming at you as a result. But
> that said, maybe we wouldn't care. I just think that the solution is
> so simple (what, five extra lines or so) that it's worth avoiding even
> the worry.

We already have that kind of logics - see select_parent() et.al. in
mainline or d_walk() in vfs.git#for-linus (pull request will go in
a few minutes).  With this patch we get

	* plain seqretry loop (d_lookup(), is_subdir(), autofs4_getpath(),
ceph_misc_build_path(), [cifs] build_path_from_dentry(), nfs_path(),
[audit] handle_path())
	* try seqretry once, then switch to write_seqlock() (the things
that got unified into d_walk())
	* try seqretry three times, then switch to write_seqlock() (d_path()
and friends)
	* several pure write_seqlock() users (d_move(), d_set_mounted(),
d_materialize_unique())

The last class is not a problem - these we want as writers.  I really don't
like the way the rest is distributed - if nothing else, nfs_path() and
friends are in exactly the same situation as d_path().  Moreover, why
the distinction between "try once" and "try thrice"?

_If_ we fold the second and the third groups together (and probably have
a bunch from the first one join that), we at least get something
understandable, but the I really wonder if seqlock has the right calling
conventions for that (and at least I'd like to fold the "already got writelock"
flag into seq - we do have a spare bit there).

Comments?
