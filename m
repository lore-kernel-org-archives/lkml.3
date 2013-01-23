Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3AWDB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 22:01:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5988 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3AWDB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 22:01:56 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=ENlZYjM52N8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=uO7z_-oXTzUA:10 a=WXF80q6SyxWjp7Z4_8cA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358910114.21576.86.camel@gandalf.local.home>
Subject: [RFC] Hack to use mkdir/rmdir in debugfs
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 22 Jan 2013 22:01:54 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me explain the situation.

I'm adding the ability to create multiple ftrace instances (buffers). I
have a directory: /debug/tracing/instances that will hold sub
directories that have the control files for these buffers. Basically,
each directory in the instances directory will be a duplicate of
the /debug/tracing directory, and will act agnostic from each other.

I original had:

# ls /debug/tracing/instances
new	free

Where to create an instance you had to echo the name of the instance
into the "new" file and it would be created:

# cd /debug/tracing/instances
# echo foo > new

# ls
new	foo	free

# ls foo
buffer_size_kb        free_buffer  trace_clock    trace_pipe
buffer_total_size_kb  set_event    trace_marker   tracing_on
events                trace        trace_options


And to remove it you would echo the name into the "free" file.

I find this interface rather awkward. A more elegant interface would be
to use mkdir and rmdir to create and remove these instances:

# cd /debug/traces/instances

# ls

# mkdir foo

# ls
foo


Unfortunately, the debugfs dir_inode_operations does not include a
mkdir. I decided to hijack the dir operations and install my own. But as
the mkdir needs to created debugfs directories with the instances
directory, they too will grab the i_node->i_mutex that is held by the
mkdir system call.

I finally did the following hack that works in my tests. But I'm a bit
uncomfortable and decided to call upon the VFS overlords to say this is
fine, or that I've must have stumbled upon a new kind of crack. Or maybe
this new crack is just fine.

I release the inode->i_mutex as the new_instance_create() has its own
locking to synchronize things and does the debugfs_create_dir() and
friends . Also, the instances directory is created at boot up and is
never destroyed, so I'm hoping that it's OK to release its i_mutex. I
even added a paranoid check to make sure it is the "instances"
directory. Note, the instances d_entry is saved as a static variable and
isn't needed to be recovered.

Is doing something as silly as the following fine, or is there a better
way?

----
static int instance_mkdir (struct inode *inode, struct dentry *dentry, umode_t mode)
{
	struct dentry *parent;
	int ret;

	/* Paranoid: Make sure the parent is the "instances" directory */
	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_alias);
	if (WARN_ON_ONCE(parent != trace_instance_dir))
		return -ENOENT;

	/*
	 * The inode mutex is locked, but debugfs_create_dir() will also
	 * take the mutex. As the instances directory can not be destroyed
	 * or changed in any other way, it is safe to unlock it, and
	 * let the dentry try. If two users try to make the same dir at
	 * the same time, then the new_instance_create() determine the
	 * winner.
	 */
	mutex_unlock(&inode->i_mutex);

	ret = new_instance_create(dentry->d_iname);

	mutex_lock(&inode->i_mutex);

	return ret;
}

static const struct inode_operations instance_dir_inode_operations = {
	.lookup		= simple_lookup,
	.mkdir		= instance_mkdir,
};

static __init void create_trace_instances(struct dentry *d_tracer)
{
	trace_instance_dir = debugfs_create_dir("instances", d_tracer);
	if (WARN_ON(!trace_instance_dir))
		return;

	/* Hijack the dir inode operations, to allow mkdir */
	trace_instance_dir->d_inode->i_op = &instance_dir_inode_operations;
}
----

As you can see, I haven't implemented the rmdir yet.

Thanks,

-- Steve


