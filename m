Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbbAXDAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 22:00:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbbAXDAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 22:00:44 -0500
Date: Sat, 24 Jan 2015 11:00:41 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/5 v2] tracing: Automatically mount tracefs on
 debugfs/tracing
Message-ID: <20150124030041.GB5009@kroah.com>
References: <20150123155525.795129339@goodmis.org>
 <20150123162414.580817092@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150123162414.580817092@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 10:55:28AM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> As tools currently rely on the tracing directory in debugfs, we can not
> just created a tracefs infrastructure and expect sysadmins to mount
> the new tracefs to have their old tools work.
> 
> Instead, the debugfs tracing directory is still created and the tracefs
> file system is mounted there when the debugfs filesystem is mounted.
> 
> No longer does the tracing infrastructure update the debugfs file system,
> but instead interacts with the tracefs file system. But now, it still
> appears to the user like nothing changed, except you also have the feature
> of mounting just the tracing system without needing all of debugfs!
> 
> Note, because debugfs_create_dir() happens to end up setting the
> dentry->d_op, we can not use d_set_d_op() but must manually assign the
> new op, that has automount set, to the dentry returned. This can be
> racy, but since this happens during the initcall sequence on boot up,
> there should be nothing that races with it.
> 
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index fb577a2a60ea..4fb557917d39 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -32,6 +32,7 @@
>  #include <linux/splice.h>
>  #include <linux/kdebug.h>
>  #include <linux/string.h>
> +#include <linux/mount.h>
>  #include <linux/rwsem.h>
>  #include <linux/slab.h>
>  #include <linux/ctype.h>
> @@ -5815,10 +5816,35 @@ static __init int register_snapshot_cmd(void)
>  static inline __init int register_snapshot_cmd(void) { return 0; }
>  #endif /* defined(CONFIG_TRACER_SNAPSHOT) && defined(CONFIG_DYNAMIC_FTRACE) */
>  
> +static struct vfsmount *trace_automount(struct path *path)
> +{
> +	struct vfsmount *mnt;
> +	struct file_system_type *type;
> +
> +	/*
> +	 * To maintain backward compatibility for tools that mount
> +	 * debugfs to get to the tracing facility, tracefs is automatically
> +	 * mounted to the debugfs/tracing directory.
> +	 */
> +	type = get_fs_type("tracefs");
> +	if (!type)
> +		return NULL;
> +	mnt = vfs_kern_mount(type, 0, "tracefs", NULL);
> +	put_filesystem(type);
> +	if (IS_ERR(mnt))
> +		return NULL;
> +	mntget(mnt);
> +
> +	return mnt;
> +}
> +
>  #define TRACE_TOP_DIR_ENTRY		((struct dentry *)1)
>  
>  struct dentry *tracing_init_dentry_tr(struct trace_array *tr)
>  {
> +	static struct dentry_operations trace_ops;
> +	struct dentry *traced;
> +
>  	/* Top entry does not have a descriptor */
>  	if (tr->dir == TRACE_TOP_DIR_ENTRY)
>  		return NULL;
> @@ -5831,7 +5857,30 @@ struct dentry *tracing_init_dentry_tr(struct trace_array *tr)
>  		return ERR_PTR(-ENODEV);
>  
>  	if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
> -		tr->dir = debugfs_create_dir("tracing", NULL);
> +		traced = debugfs_create_dir("tracing", NULL);
> +		if (!traced)
> +			return ERR_PTR(-ENOMEM);
> +		/* copy the dentry ops and add an automount to it */
> +		if (traced->d_op) {
> +			/*
> +			 * FIXME:
> +			 * Currently debugfs sets the d_op by a side-effect
> +			 * of calling simple_lookup(). Normally, we should
> +			 * never change d_op of a dentry, but as this is
> +			 * happening at boot up and shouldn't be racing with
> +			 * any other users, this should be OK. But it is still
> +			 * a hack, and needs to be properly done.
> +			 */
> +			trace_ops = *traced->d_op;
> +			trace_ops.d_automount = trace_automount;
> +			traced->d_flags |= DCACHE_NEED_AUTOMOUNT;
> +			traced->d_op = &trace_ops;
> +		} else {
> +			/* Ideally, this is what should happen */
> +			trace_ops = simple_dentry_operations;
> +			trace_ops.d_automount = trace_automount;
> +			d_set_d_op(traced, &trace_ops);

How will this else block run if debugfs is setting d_op in the
debugfs_create_dir() call?

What really do you want to do here, just automount a filesystem on
debugfs?  If so, can't we just add a new debugfs call to do that?

thanks,

greg k-h
