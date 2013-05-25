Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3EYR0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 13:26:31 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:63046 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390Ab3EYR0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 13:26:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130525165710.GC25399@ZenIV.linux.org.uk>
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com>
	<CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com>
	<20130525165710.GC25399@ZenIV.linux.org.uk>
Date: Sat, 25 May 2013 10:26:29 -0700
X-Google-Sender-Auth: DnFaN7KUDSGo8efIbSkuOHIQAH4
Message-ID: <CA+55aFz0QZzjvv0v4MWvm=_pp082Yu=G6PgW6N_=aMFMHLpm=g@mail.gmail.com>
Subject: Re: Stupid VFS name lookup interface..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 9:57 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Well...   The problem I see here is not even selinux per se - it's that
> "LSM stacking" insanity.  How would your anon union deal with that?  Which
> LSM gets to play with it when we have more than one of those turds around?

We don't support stacking anyway. And if we ever do, that will require
some really *major* changes, since right now i_security is owned by
the security module. It's not a list, it's a direct pointer to opaque
per-LSM data.

Of course, if you don't use i_security (only selinux and smack do
right now according to my quick grep), then you could live together
with somebody who does. And that wouldn't change with the new fields,
the same rules would apply. If you can make your security decisions
purely based on standard inode/dentry information (like the common
capabilities code), you'd be ok, and in that sense stacking has
obviously existed for a long while (ie some of the standard unix
capabilities are checked regardless of any LSM ones).

Side note: avoiding the i_security dereference helps, and testing
shows that it drops inode_has_perm and selinux_inode_permission down
the profile list. The bulk of the cost of pathname intensive loads is
now very much the actual path walking itself (__d_lookup_rcu,
path_lookupat, link_path_walk). The security checks are still quite
visible on my "git parallel stat" test-case, with avc_has_perm_noaudit
being 3.5% and the inode_has_perm() and selinux_inode_permission at
around 2.5% each, but I don't really see anything fixable going on any
more. The inode_has_perm() cost is simply because it's one of the
first things that touched the inode itself, so we get the -
unavoidable - cache miss on the second line of the inode.

So the patch is tested, and improves at least profiles. It's probably
not that noticeable in real life, but I like how it makes me go: "I
really don't see any low-hanging fruit any more" on the path lookup.

             Linus
