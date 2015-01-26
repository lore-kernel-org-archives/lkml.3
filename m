Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbbAZVk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:40:26 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41788 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbAZVkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:40:24 -0500
Date: Mon, 26 Jan 2015 21:40:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150126214020.GO29656@ZenIV.linux.org.uk>
References: <20150126150913.653681560@goodmis.org>
 <20150126193049.GN29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126193049.GN29656@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 07:30:49PM +0000, Al Viro wrote:
> On Mon, Jan 26, 2015 at 10:09:13AM -0500, Steven Rostedt wrote:
> > There has been complaints that tracing is tied too much to debugfs,
> > as there are systems that would like to perform tracing, but do
> > not mount debugfs for security reasons. That is because any subsystem
> > may use debugfs for debugging, and these interfaces are not always
> > tested for security.
> > 
> > Creating a new tracefs that the tracing directory will now be attached
> > to allows system admins the ability to access the tracing directory
> > without the need to mount debugfs.
> > 
> > Another advantage is that debugfs does not support the system calls
> > for mkdir and rmdir. Tracing uses these system calls to create new
> > instances for sub buffers. This was done by a hack that hijacked the
> > dentry ops from the "instances" debugfs dentry, and replacing it with
> > one that could work.
> > 
> > Instead of using this hack, tracefs can provide a proper interface to
> > allow the tracing system to have a mkdir and rmdir feature.
> > 
> > To maintain backward compatibility with older tools that expect that
> > the tracing directory is mounted with debugfs, the tracing directory
> > is still created under debugfs and tracefs is automatically mounted
> > there.
> > 
> > Finally, a new directory is created when tracefs is enabled called
> > /sys/kernel/tracing. This will be the new location that system admins
> > may mount tracefs if they are not using debugfs.
> 
> You are still fighting an inconvenient API, but now it's not debugfs one -
> it's your copy thereof.  Why not give your instances/ an inode_operations
> of its own?  One with ->mkdir() and ->rmdir(), leaving all other directories
> as-is.  That way you don't need the secondary methods at all.  And sure,
> debugfs_create_dir() grabs ->i_mutex on parent, making you drop that in
> your ->mkdir() if you want to call it.  But now you are not talking to it -
> just to your own code, where you are free to change the calling conventions,
> making it caller's responsibility to get that ->i_mutex.  The same goes for
> the rmdir side...

Is the following correct?
	* only one directory in the entire tree (/instances) allows mkdir/rmdir.
	* ftrace_trace_arrays always starts with global_trace and the rest
is in 1-to-1 correspondence with subdirectories of /instances.
	* tr->name is NULL for global_trace and non-NULL for everything
else.
	* all modifications of that list are happening from mkdir/rmdir
	* in the end of ->mkdir tr->dir set to the dentry of our subdirectory,
and it's non-NULL (or trace_array creation simply fails)
	* global_array.dir is set to magical value ((struct dentry *)1) upon
the first call of tracing_init_dentry().  Prior to that it's NULL.  BTW, may
I politely inquire what the fuck are those contortions in
tracing_init_dentry_tr() about?  Looks like a stunningly convoluted way
to trigger that automount point creation early in tracer_init_tracefs().
Why not do that right there explicitly?

What are mount options doing?  I mean, sure, you set the mode/uid/gid
of root.  Which is not modifiable anyway...  And AFAICS that's all those
options are affecting.

AFAICS, nothing ever removes files in debugfs root.  Right?  If so, you don't
need the games with simple_pin_fs() - they are pointless in such situation
anyway.  Just do tracefs_mount = kern_mount(&trace_fs_type); in tracefs_init()
and be done with that; lose the tracefs_mount_count and all calls of
simple_{pin,release}_fs().

While we are at it, what the hell is tracefs_file_operations about?  Looks
like some bastard offspring of /dev/null, but I don't see anything that would
use it...
