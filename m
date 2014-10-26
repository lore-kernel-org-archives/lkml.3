Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbaJZV5r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 17:57:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43035 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaJZV5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 17:57:45 -0400
Date: Sun, 26 Oct 2014 21:57:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: fs: lockup on rename_mutex in fs/dcache.c:1035
Message-ID: <20141026215742.GT7996@ZenIV.linux.org.uk>
References: <544C50CB.4090408@oracle.com>
 <87siibttyi.fsf@x220.int.ebiederm.org>
 <20141026030608.GN7996@ZenIV.linux.org.uk>
 <20141026035100.GO7996@ZenIV.linux.org.uk>
 <20141026035705.GP7996@ZenIV.linux.org.uk>
 <CA+55aFzcRyA0kcXN28OHjPQfR-BP442+tz6Rti7Fbc0VXuawww@mail.gmail.com>
 <20141026191332.GS7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141026191332.GS7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 07:13:32PM +0000, Al Viro wrote:
> The comment is not correct.  dentry_kill() won't screw the pointer to
> parent; it will, however, screw the pointer to next sibling.
> 
> It used to screw the pointer to parent (which is what the first part of
> condition was about).  After Nick's series back in January 2011 that
> has stopped being true.  However, dentry_kill() does
> list_del(&dentry->d_u.d_child).  Which means that we can't continue
> past that point if it has happened.  Trond has noticed the breakage
> a bit later and added explicit check for ->d_flags, but the damage
> was more extensive - Nick had missed the restarts-on-killed logics
> hidden in the check for changed ->d_parent and assumed that it's
> all about renames, meaning that once rename_lock has been taken exclusive
> we won't have restarts at all.  With restart-on-killed restored that
> wasn't true anymore, invalidating the assumption that we only get to
> rename_retry without rename_lock held exclusive.  With deadlocks happening
> if we ever get there on such pass.

Actually, it's even worse than just list_del() possibly screwing .next -
that could be worked around by use of __list_del() (and skipping them
until we come to one that isn't marked DCACHE_DENTRY_KILLED).  Note that
d_child shares memory with d_rcu, and _that_ is really nasty - if
__dentry_kill() has progressed to dentry_free(), we have ->d_u.d_child.next
hopelessly trashed.

OTOH, we could make d_rcu share memory with d_alias instead.  Hrm...
OK, then we'd have
	rcu_read_lock();
ascend:
	if (this_parent != parent) {
		struct dentry *child = this_parent;
		this_parent = child->d_parent;

                spin_unlock(&child->d_lock);
                spin_lock(&this_parent->d_lock);

		if (need_seqretry(&rename_lock, seq)) {
			spin_unlock(&this_parent->d_lock);
			rcu_read_unlock();
			goto rename_retry;
		}
		next = child->d_child.next;
		while (unlikely(child->d_flags & DCACHE_DENTRY_KILLED)) {
			if (next == &this_parent.d_subdirs)
				goto ascend;
			child = list_entry(next, struct dentry, d_child);
			next = next->next;
		}
		rcu_read_unlock();
		goto resume;
	}
	rcu_read_unlock();
	if (need_seqretry(&rename_lock, seq)) {
		spin_unlock(&this_parent->d_lock);
		goto rename_retry;
	}
in d_walk(), __list_del() instead of list_del() in __dentry_kill(), d_u.d_child
turning into d_child everywhere, while d_alias turns into d_u.d_alias...

It looks like that way we would get no retries on the second pass.  Comments?
