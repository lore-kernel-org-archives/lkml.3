Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaJZTNj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 15:13:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42859 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaJZTNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 15:13:38 -0400
Date: Sun, 26 Oct 2014 19:13:32 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: fs: lockup on rename_mutex in fs/dcache.c:1035
Message-ID: <20141026191332.GS7996@ZenIV.linux.org.uk>
References: <544C50CB.4090408@oracle.com>
 <87siibttyi.fsf@x220.int.ebiederm.org>
 <20141026030608.GN7996@ZenIV.linux.org.uk>
 <20141026035100.GO7996@ZenIV.linux.org.uk>
 <20141026035705.GP7996@ZenIV.linux.org.uk>
 <CA+55aFzcRyA0kcXN28OHjPQfR-BP442+tz6Rti7Fbc0VXuawww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzcRyA0kcXN28OHjPQfR-BP442+tz6Rti7Fbc0VXuawww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 11:56:08AM -0700, Linus Torvalds wrote:
> On Sat, Oct 25, 2014 at 8:57 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Your patch looks fine, and I don't think we can livelock - because we
> always set 'seq' to 1 if we retry, and that causes us to get the
> exclusive lock, so we'd better not then enter the retry loop again.
> Although I guess not only renames cause it - looks like we get to that
> mis-named "rename_retry" for a deletion too according to the comment.
> Although I'm not sure that comment is correct - I don't think we
> change d_parent for deletes, do we?

The comment is not correct.  dentry_kill() won't screw the pointer to
parent; it will, however, screw the pointer to next sibling.

It used to screw the pointer to parent (which is what the first part of
condition was about).  After Nick's series back in January 2011 that
has stopped being true.  However, dentry_kill() does
list_del(&dentry->d_u.d_child).  Which means that we can't continue
past that point if it has happened.  Trond has noticed the breakage
a bit later and added explicit check for ->d_flags, but the damage
was more extensive - Nick had missed the restarts-on-killed logics
hidden in the check for changed ->d_parent and assumed that it's
all about renames, meaning that once rename_lock has been taken exclusive
we won't have restarts at all.  With restart-on-killed restored that
wasn't true anymore, invalidating the assumption that we only get to
rename_retry without rename_lock held exclusive.  With deadlocks happening
if we ever get there on such pass.

We used to have several copies of that logics, before it all got consolidated
into d_walk(), which probably contributed to the mess...

BTW, the first part of condition (->d_parent hasn't changed since before the
"unlock child, lock parent" sequence) is really pointless these days - check
for rename_lock will fail if ->d_parent has changed...
