Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab3EYQ5O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 12:57:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51412 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab3EYQ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 12:57:12 -0400
Date: Sat, 25 May 2013 17:57:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: Stupid VFS name lookup interface..
Message-ID: <20130525165710.GC25399@ZenIV.linux.org.uk>
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com>
 <CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 08:21:08PM -0700, Linus Torvalds wrote:
> On Tue, May 21, 2013 at 3:22 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Untested patch attached. It compiles cleanly, looks sane, and most of
> > it is just making the function prototypes look much nicer. I think it
> > works.
> 
> Ok, here's another patch in the "let's make the VFS go faster series".
> This one, sadly, is not a cleanup.
> 
> The concept is simple: right now the inode->i_security pointer chasing
> kills us on inode security checking with selinux. So let's move two of
> the fields from the selinux security fields directly into the inode.
> So instead of doing "inode->i_security->{sid,sclass}", we can just do
> "inode->{i_sid,i_sclass}" directly.
> 
> It's a very mechanical transform, so it should all be good, but the
> reason I don't much like it is that I think other security models
> might want to do something like this too, and right now it's
> selinux-specific. I could imagine making it just an anonymous union of
> size 64 bits or something, and just making one of the union entries be
> an (anonymous) struct with those two fields. So it's not conceptually
> selinux-specific, but right now it's pretty much a selinux hack.
> 
> But it's a selinux-specific hack that really does matter. The
> inode_has_perm() and selinux_inode_permission() functions show up
> pretty high on kernel profiles that do a lot of filename lookup, and
> it's pretty much all just that i_security pointer chasing and extra
> cache miss.
> 
> With this, inode->i_security is not very hot any more, and we could
> move the i_security pointer elsewhere in the inode.
> 
> Comments? I don't think this is *pretty* (and I do want to repeat that
> it's not even tested yet), but I think it's worth it. We've been very
> good at avoiding extra pointer dereferences in the path lookup, this
> is one of the few remaining ones.

Well...   The problem I see here is not even selinux per se - it's that
"LSM stacking" insanity.  How would your anon union deal with that?  Which
LSM gets to play with it when we have more than one of those turds around?
