Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3AWEHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:07:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:57388 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848Ab3AWEHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:07:20 -0500
Date: Tue, 22 Jan 2013 20:08:46 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Hack to use mkdir/rmdir in debugfs
Message-ID: <20130123040846.GA2638@kroah.com>
References: <1358910114.21576.86.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358910114.21576.86.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:01:54PM -0500, Steven Rostedt wrote:
> Let me explain the situation.
> 
> I'm adding the ability to create multiple ftrace instances (buffers). I
> have a directory: /debug/tracing/instances that will hold sub
> directories that have the control files for these buffers. Basically,
> each directory in the instances directory will be a duplicate of
> the /debug/tracing directory, and will act agnostic from each other.
> 
> I original had:
> 
> # ls /debug/tracing/instances
> new	free
> 
> Where to create an instance you had to echo the name of the instance
> into the "new" file and it would be created:
> 
> # cd /debug/tracing/instances
> # echo foo > new
> 
> # ls
> new	foo	free
> 
> # ls foo
> buffer_size_kb        free_buffer  trace_clock    trace_pipe
> buffer_total_size_kb  set_event    trace_marker   tracing_on
> events                trace        trace_options
> 
> 
> And to remove it you would echo the name into the "free" file.
> 
> I find this interface rather awkward. A more elegant interface would be
> to use mkdir and rmdir to create and remove these instances:
> 
> # cd /debug/traces/instances
> 
> # ls
> 
> # mkdir foo
> 
> # ls
> foo
> 
> 
> Unfortunately, the debugfs dir_inode_operations does not include a
> mkdir. I decided to hijack the dir operations and install my own. But as
> the mkdir needs to created debugfs directories with the instances
> directory, they too will grab the i_node->i_mutex that is held by the
> mkdir system call.
> 
> I finally did the following hack that works in my tests. But I'm a bit
> uncomfortable and decided to call upon the VFS overlords to say this is
> fine, or that I've must have stumbled upon a new kind of crack. Or maybe
> this new crack is just fine.
> 
> I release the inode->i_mutex as the new_instance_create() has its own
> locking to synchronize things and does the debugfs_create_dir() and
> friends . Also, the instances directory is created at boot up and is
> never destroyed, so I'm hoping that it's OK to release its i_mutex. I
> even added a paranoid check to make sure it is the "instances"
> directory. Note, the instances d_entry is saved as a static variable and
> isn't needed to be recovered.
> 
> Is doing something as silly as the following fine, or is there a better
> way?

Yes, why not create your own fs for ftrace?  :)

> ----
> static int instance_mkdir (struct inode *inode, struct dentry *dentry, umode_t mode)
> {
> 	struct dentry *parent;
> 	int ret;
> 
> 	/* Paranoid: Make sure the parent is the "instances" directory */
> 	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_alias);
> 	if (WARN_ON_ONCE(parent != trace_instance_dir))
> 		return -ENOENT;
> 
> 	/*
> 	 * The inode mutex is locked, but debugfs_create_dir() will also
> 	 * take the mutex. As the instances directory can not be destroyed
> 	 * or changed in any other way, it is safe to unlock it, and
> 	 * let the dentry try. If two users try to make the same dir at
> 	 * the same time, then the new_instance_create() determine the
> 	 * winner.
> 	 */
> 	mutex_unlock(&inode->i_mutex);
> 
> 	ret = new_instance_create(dentry->d_iname);
> 
> 	mutex_lock(&inode->i_mutex);
> 
> 	return ret;
> }
> 
> static const struct inode_operations instance_dir_inode_operations = {
> 	.lookup		= simple_lookup,
> 	.mkdir		= instance_mkdir,
> };
> 
> static __init void create_trace_instances(struct dentry *d_tracer)
> {
> 	trace_instance_dir = debugfs_create_dir("instances", d_tracer);
> 	if (WARN_ON(!trace_instance_dir))
> 		return;
> 
> 	/* Hijack the dir inode operations, to allow mkdir */
> 	trace_instance_dir->d_inode->i_op = &instance_dir_inode_operations;
> }
> ----

But how can you callback to your code to let it know that something was
created in it?

Don't you need that for both mkdir and rmdir?

But again, I'd really not want to do this in debugfs, how about your own
filesystem?

greg k-h
