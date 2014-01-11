Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaAKKcq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 05:32:46 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:44030 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbaAKKco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 05:32:44 -0500
Date: Sat, 11 Jan 2014 02:32:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ben Myers <bpm@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Paul Moore <paul@paul-moore.com>,
        Matthew Wilcox <matthew@wil.cx>, Stephen Smalley <sds@tycho.nsa.gov>,
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
Message-ID: <20140111103234.GC22098@infradead.org>
References: <20140109165012.391db81e@gandalf.local.home>
 <20140109223127.GM10323@ZenIV.linux.org.uk>
 <CA+55aFzCTPYEQCPnLBi1CwmMTocVqCFiCuJ391HkVx1CMw61ug@mail.gmail.com>
 <20140109182523.5b50131f@gandalf.local.home>
 <20140109182756.17abaaa8@gandalf.local.home>
 <1389310626.15209.92.camel@localhost>
 <CA+55aFzd2nw=JU4s0u=PJbATK0bwhm0kot3zRH=anLLT6THRFQ@mail.gmail.com>
 <20140110000642.GN10323@ZenIV.linux.org.uk>
 <20140110093148.GA26159@infradead.org>
 <20140110181434.GH1935@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110181434.GH1935@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 12:14:34PM -0600, Ben Myers wrote:
> > What's really needed there to make XFS behave more similar to everyone
> > else is a way for the filesystem to say: "I can't actually free this
> > inode right now, but I'll come back to you later".
> 
> This test might read something like:  "If my link count has gone to zero, and I
> am the last inode in my cluster to be freed, and there are other inodes from my
> cluster incore, I cannot be freed."

It's more complicated than that.  In theory we would free the inode
easily as soon as the VFS wants it, but performance would be horrible
as we would have to synchronously write back the inode.  Note that it
really matters for the interface, that just needs to be an:  I won't
free this right now, but I'll call you back later when I can.
