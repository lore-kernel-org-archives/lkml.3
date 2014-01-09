Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaAIWbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:31:40 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39659 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaAIWbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:31:32 -0500
Date: Thu, 9 Jan 2014 22:31:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@parisplace.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>,
        James Morris <james.l.morris@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] vfs: Fix possible NULL pointer dereference in
 inode_permission()
Message-ID: <20140109223127.GM10323@ZenIV.linux.org.uk>
References: <20140109162731.12500986@gandalf.local.home>
 <20140109214239.GD29910@parisc-linux.org>
 <20140109165012.391db81e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109165012.391db81e@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 04:50:12PM -0500, Steven Rostedt wrote:

> > We'd then have to get rid of all the call_rcu() invocations in individual
> > filesystems' destroy_inode methods, but that doesn't sound like a bad
> > thing to me.

Check what e.g. XFS is doing...

> Which is another reason that I didn't do it, as I didn't know all the
> happenings inside the ->destroy_inode() calls. But yeah, I agree with
> this.
> 
> Also, can iput() sleep? If not then we are OK. Otherwise, we need to be
> careful about any mutex being grabbed in those call backs, as the
> rcu_callback can't sleep either.

iput() definitely can sleep (that's when actual truncation and inode
freeing is done for opened-and-unlinked files - on the final iput() after
close()), but that' irrelevant here - fsnotify_delete_inode() grabs
a bunch of mutexes, which makes calling it from rcu callback no-go.
