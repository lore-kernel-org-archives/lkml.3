Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778AbaJZXmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 19:42:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43139 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaJZXmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 19:42:36 -0400
Date: Sun, 26 Oct 2014 23:42:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: fs: lockup on rename_mutex in fs/dcache.c:1035
Message-ID: <20141026234230.GU7996@ZenIV.linux.org.uk>
References: <544C50CB.4090408@oracle.com>
 <87siibttyi.fsf@x220.int.ebiederm.org>
 <20141026030608.GN7996@ZenIV.linux.org.uk>
 <20141026035100.GO7996@ZenIV.linux.org.uk>
 <20141026035705.GP7996@ZenIV.linux.org.uk>
 <CA+55aFzcRyA0kcXN28OHjPQfR-BP442+tz6Rti7Fbc0VXuawww@mail.gmail.com>
 <20141026191332.GS7996@ZenIV.linux.org.uk>
 <20141026215742.GT7996@ZenIV.linux.org.uk>
 <CA+55aFxfDgYsp9SAxWTy2sS0KLrErPUd06bEYJf=siCmaBu52w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxfDgYsp9SAxWTy2sS0KLrErPUd06bEYJf=siCmaBu52w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 04:33:11PM -0700, Linus Torvalds wrote:
> On Sun, Oct 26, 2014 at 2:57 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >  .. snip ..
> > in d_walk(), __list_del() instead of list_del() in __dentry_kill(), d_u.d_child
> > turning into d_child everywhere, while d_alias turns into d_u.d_alias...
> >
> > It looks like that way we would get no retries on the second pass.  Comments?
> 
> Since I missed the whole issue with d_child.next, I'm not sure any
> comments from me would be helpful.
> 
> It does sound like trying to be more careful with d_child and using
> d_alias instead is a good idea. d_alias is only used under the dentry
> lock, and not in any horribly subtle situations, right? So that sounds
> like a good change regardless of this particular fix - making the
> union happen in a less nasty place..

OK...  See vfs.git#experimental-d_walk - the first commit there moves
d_rcu from d_child to d_alias, the second is basically "skip the killed
siblings rather than restarting the tree walk".
