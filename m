Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaAJJcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:32:04 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:39830 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaAJJcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:32:00 -0500
Date: Fri, 10 Jan 2014 01:31:48 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, "Theodore Ts'o" <tytso@mit.edu>,
        stable <stable@vger.kernel.org>, Paul Moore <paul@paul-moore.com>,
        LKML <linux-kernel@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
        xfs@oss.sgi.com
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in
 inode_permission()
Message-ID: <20140110093148.GA26159@infradead.org>
References: <20140109162731.12500986@gandalf.local.home>
 <20140109214239.GD29910@parisc-linux.org>
 <20140109165012.391db81e@gandalf.local.home>
 <20140109223127.GM10323@ZenIV.linux.org.uk>
 <CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
 <20140109182523.5b50131f@gandalf.local.home>
 <20140109182756.17abaaa8@gandalf.local.home>
 <1389310626.15209.92.camel@localhost>
 <CA+55aFzd2nw=JU4s0u=PJbATK0bwhm0kot3zRH=anLLT6THRFQ@mail.gmail.com>
 <20140110000642.GN10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110000642.GN10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 12:06:42AM +0000, Al Viro wrote:
> Check what XFS is doing ;-/  That's where those call_rcu() have come from.
> Sure, we can separate the simple "just do call_rcu(...->free_inode)" case
> and hit it whenever full ->free_inode is there and ->destroy_inode isn't.
> Not too pretty, but removal of tons of boilerplate might be worth doing
> that anyway.  But ->destroy_inode() is still needed for cases where fs
> has its own idea of inode lifetime rules.  Again, check what XFS is doing
> in that area...

Btw, I'd really love to get rid of the XFS ->destroy_inode abuse, it's
been a long time thorn in the flesh.

What's really needed there to make XFS behave more similar to everyone
else is a way for the filesystem to say: "I can't actually free this
inode right now, but I'll come back to you later".  That's what we
actually do right now, except we pretend that the VFS inode gets freed,
while its memory lives on (punt intended).

