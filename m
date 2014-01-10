Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbaAJAG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:06:56 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40141 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaAJAGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:06:51 -0500
Date: Fri, 10 Jan 2014 00:06:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, "Theodore Ts'o" <tytso@mit.edu>,
        stable <stable@vger.kernel.org>, Paul Moore <paul@paul-moore.com>,
        LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in
 inode_permission()
Message-ID: <20140110000642.GN10323@ZenIV.linux.org.uk>
References: <20140109162731.12500986@gandalf.local.home>
 <20140109214239.GD29910@parisc-linux.org>
 <20140109165012.391db81e@gandalf.local.home>
 <20140109223127.GM10323@ZenIV.linux.org.uk>
 <CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
 <20140109182523.5b50131f@gandalf.local.home>
 <20140109182756.17abaaa8@gandalf.local.home>
 <1389310626.15209.92.camel@localhost>
 <CA+55aFzd2nw=JU4s0u=PJbATK0bwhm0kot3zRH=anLLT6THRFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzd2nw=JU4s0u=PJbATK0bwhm0kot3zRH=anLLT6THRFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 07:53:41AM +0800, Linus Torvalds wrote:
> On Fri, Jan 10, 2014 at 7:37 AM, Eric Paris <eparis@redhat.com> wrote:
> >
> > but at least from an SELinux PoV, I think it's quick and easy, but wrong
> > for maintainability...
> 
> Yeah, it's a hack, and it's wrong, and we should figure out how to do
> it right. Likely we should just tie the lifetime of the i_security
> member directly to the lifetime of the inode itself, and just make the
> rule be that security_inode_free() gets called from whatever frees the
> inode itself, and *not* have an extra rcu callback etc. But that
> sounds like a bigger change than I'm comfy with right now, so the
> hacky one might be the band-aid to do for stable..
> 
> The problem, of course, is that all the different filesystems have
> their own inode allocations/freeing. Of course, they all tend to share
> the same pattern ("call_rcu xyz_i_callback"), so maybe we could try to
> make that a more generic thing? Like have a "free_inode" vfs callback,
> and do the call_rcu delaying at the VFS level..
> 
> And maybe, just maybe, we could just say that that is what
> "destroy_inode()" is, and that we will just call it from rcu context.
> All the IO has hopefully been done earlier  Yes/no?

Check what XFS is doing ;-/  That's where those call_rcu() have come from.
Sure, we can separate the simple "just do call_rcu(...->free_inode)" case
and hit it whenever full ->free_inode is there and ->destroy_inode isn't.
Not too pretty, but removal of tons of boilerplate might be worth doing
that anyway.  But ->destroy_inode() is still needed for cases where fs
has its own idea of inode lifetime rules.  Again, check what XFS is doing
in that area...

There's an extra source of headache, BTW - what about the "LSM stacking"
crowd and their plans?
