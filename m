Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbaAJSOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:14:47 -0500
Received: from relay2.sgi.com ([192.48.179.30]:60086 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751449AbaAJSOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:14:40 -0500
Date: Fri, 10 Jan 2014 12:14:34 -0600
From: Ben Myers <bpm@sgi.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, "Theodore Ts'o" <tytso@mit.edu>,
        Paul Moore <paul@paul-moore.com>, Matthew Wilcox <matthew@wil.cx>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, xfs@oss.sgi.com,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in
 inode_permission()
Message-ID: <20140110181434.GH1935@sgi.com>
References: <20140109214239.GD29910@parisc-linux.org>
 <20140109165012.391db81e@gandalf.local.home>
 <20140109223127.GM10323@ZenIV.linux.org.uk>
 <CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
 <20140109182523.5b50131f@gandalf.local.home>
 <20140109182756.17abaaa8@gandalf.local.home>
 <1389310626.15209.92.camel@localhost>
 <CA+55aFzd2nw=JU4s0u=PJbATK0bwhm0kot3zRH=anLLT6THRFQ@mail.gmail.com>
 <20140110000642.GN10323@ZenIV.linux.org.uk>
 <20140110093148.GA26159@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110093148.GA26159@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

On Fri, Jan 10, 2014 at 01:31:48AM -0800, Christoph Hellwig wrote:
> On Fri, Jan 10, 2014 at 12:06:42AM +0000, Al Viro wrote:
> > Check what XFS is doing ;-/  That's where those call_rcu() have come from.
> > Sure, we can separate the simple "just do call_rcu(...->free_inode)" case
> > and hit it whenever full ->free_inode is there and ->destroy_inode isn't.
> > Not too pretty, but removal of tons of boilerplate might be worth doing
> > that anyway.  But ->destroy_inode() is still needed for cases where fs
> > has its own idea of inode lifetime rules.  Again, check what XFS is doing
> > in that area...
> 
> Btw, I'd really love to get rid of the XFS ->destroy_inode abuse, it's
> been a long time thorn in the flesh.

I believe this behavior is related to freeing of an inode cluster.

> What's really needed there to make XFS behave more similar to everyone
> else is a way for the filesystem to say: "I can't actually free this
> inode right now, but I'll come back to you later".

This test might read something like:  "If my link count has gone to zero, and I
am the last inode in my cluster to be freed, and there are other inodes from my
cluster incore, I cannot be freed."

Should be doable.  Maybe there are other reasons.

-Ben
