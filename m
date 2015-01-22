Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbbAVOzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:55:55 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:58991 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbbAVOzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:55:51 -0500
Date: Thu, 22 Jan 2015 09:55:47 -0500
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/5] tracing: Add new file system tracefs
Message-ID: <20150122145547.GB4507@htj.dyndns.org>
References: <20150121171953.823177070@goodmis.org>
 <20150121230007.GA10389@kroah.com>
 <20150121204725.71933044@grimm.local.home>
 <20150121220701.22231849@grimm.local.home>
 <20150122031819.GA16561@kroah.com>
 <20150121225109.6b27b555@grimm.local.home>
 <20150122123212.GB25645@htj.dyndns.org>
 <20150122093249.6f4041a8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122093249.6f4041a8@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Steven.

On Thu, Jan 22, 2015 at 09:32:49AM -0500, Steven Rostedt wrote:
> The problem is that these do not return dentry. They return kernfs_node.

Yeap, that's what represents a file or directory in kernfs.

> I see a kernfs_node_from_dentry() call but not the other way around.

Because dentries / inodes may or may not exist for a given kernfs
node.  kernfs_nodes are the backing information in a similar way to an
actual filesystem.

> Yes, the interface for tracefs is just these four functions, but then
> the interaction of the kernfs versions use a completely different API.
> 
> Each of the created files expects to attach their own open, read,
> write, and release functions. And yes, some even use the seq functions,
> and they use it the vfs way. I do not intend on rewriting the users of
> the debugfs file system. To use kernfs, it seems that I would need to
> do that, and I don't have the time to make such a dramatic change to
> the system. It will fall down on my TODO list and I probably wont get
> to it for another decade.

kernfs provides two sets of file operations.  One is seq_file based
and the other is direct read/write.  In both cases, bouncing data
between userland and kernel is handled by kernfs.  If you already have
existing read write ops implemented doing custom buffer handling and
direct userland memory access, it'll take some adaptation but for a
lot of cases this would consolidate duplicate code paths.

> I created tracefs with 700 lines of code and two files (inode.c and
> tracefs.h), and for the users of tracefs, I just did
> s/debugfs/tracefs/. If I can't make that substitution for the users,
> that is a show stopper.
> 
> I don't see how I can use kernfs without it causing a lot of invasive
> changes to the ftrace subsystem.

Converting an existing vfs based pseudo fs implementation over to
kernfs isn't trivial.  I mean, if that were trivial, why would kernfs
even exist?  kernfs is a layer which abstracts a large part of pseudo
filesystem which provides extra features like significantly lower
memory footprint with large number of nodes and revocation support in
a way that its users, for the most part, hopefully, only have to worry
about the content to provide to userland.

I frankly have no idea whether tracefs would be a good candidate for
kernfs usage but if you're looking for a mechanical one-to-one
conversion from vfs based implementation, that's not gonna work.

Thanks.

-- 
tejun
