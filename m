Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbaAJAt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:49:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930AbaAJAtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:49:53 -0500
Date: Thu, 9 Jan 2014 19:49:30 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-fsdevel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 13/14] locks: skip deadlock detection on FL_FILE_PVT
 locks
Message-ID: <20140109194930.1692fbbe@tlielax.poochiereds.net>
In-Reply-To: <52CF05B5.5080700@amacapital.net>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
	<1389277187-18211-14-git-send-email-jlayton@redhat.com>
	<52CF05B5.5080700@amacapital.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jan 2014 12:25:25 -0800
Andy Lutomirski <luto@amacapital.net> wrote:

> On 01/09/2014 06:19 AM, Jeff Layton wrote:
> > It's not really feasible to do deadlock detection with FL_FILE_PVT
> > locks since they aren't owned by a single task, per-se. Deadlock
> > detection also tends to be rather expensive so just skip it for
> > these sorts of locks.
> 
> I just looked at the existing deadlock detector, and... eww.
> 

Actually, I find it to be pretty clever, but it's only useful in some
very limited cases. Also, the performance penalty it imposes on a
lock-heavy workload is pretty significant (I had some numbers when I
did the overhaul of the spinlocking around that code, but don't have
them handy).

> When I think of deadlocks caused by r/w locks (which these are), I think
> of two kinds.  First is what the current code tries to detect: two
> processes that are each waiting for each other.  I don't know whether
> POSIX enshrines the idea of detecting that, but I wouldn't be surprised,
> considering how awful the old POSIX locks are.
> 

It can walk down a chain of dependencies (which is the cool part), so
the two processes don't even need to be working on the same inode at
all in order for it to detect a deadlock. The catch is that there is no
real way to deal with stuff like threads with this mechanism.

In any case, the spec is here:

    http://pubs.opengroup.org/onlinepubs/009696899/functions/fcntl.html

...and it just says: "A potential for deadlock occurs if a process
controlling a locked region is put to sleep by attempting to lock
another process' locked region. If the system detects that sleeping
until a locked region is unlocked would cause a deadlock, fcntl() shall
fail with an [EDEADLK] error."

Since it just says "if the system detects", I take it to mean that all
of this deadlock detection stuff is entirely optional.

> The sensible kind of detectable deadlock involves just one lock, and it
> happens when two processes both hold read locks and try to upgrade to
> write locks.  This should be efficiently detectable and makes upgrading
> locks safe(r).
> 
> I think I'd be happier if it's at least documented that the new fcntl
> calls might (some day) detect that kind of deadlock.
> 
> 

Sure, I can toss a comment in to that effect.

Personally, I'm rather keen to avoid dealing with deadlock detection
here since it's a rather large pain to deal with. Deadlock detection is
the only reason we have a global spinlock in this code anymore. I
seriously considered ripping it all out when I was overhauling this a
few months ago.

I was able to get it to perform more reasonably by turning the global
list into a hash table, but I'd have preferred to remove it altogether.

> All that being said, this patch series is awesome.  I've lost count of
> the number of explosions I've seen to due POSIX lock crap.  Thanks!
> 

Thanks for having a look!

-- 
Jeff Layton <jlayton@redhat.com>
