Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3AWEkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:40:22 -0500
Received: from mail.kernel.org ([198.145.19.201]:57921 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab3AWEkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:40:21 -0500
Date: Tue, 22 Jan 2013 20:41:46 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] Hack to use mkdir/rmdir in debugfs
Message-ID: <20130123044146.GA3079@kroah.com>
References: <1358910114.21576.86.camel@gandalf.local.home>
 <20130123040846.GA2638@kroah.com>
 <1358915495.21576.102.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358915495.21576.102.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 11:31:35PM -0500, Steven Rostedt wrote:
> On Tue, 2013-01-22 at 20:08 -0800, Greg Kroah-Hartman wrote:
> 
> > > Is doing something as silly as the following fine, or is there a better
> > > way?
> > 
> > Yes, why not create your own fs for ftrace?  :)
> 
> But but but...
> 
> debugfs is soooo convenient!
> 
> Do you think it would be worth doing that though? I only need the mkdir
> and rmdir for this one instance. Nothing more.
> 
> > >	mutex_unlock(&inode->i_mutex);
> > > 
> > > 	ret = new_instance_create(dentry->d_iname);
> > > 
> > > 	mutex_lock(&inode->i_mutex);
> > > 
> 
> > But how can you callback to your code to let it know that something was
> > created in it?
> 
> I pass the dentry->d_iname to create a directory.
> 
> > 
> > Don't you need that for both mkdir and rmdir?
> 
> It's a global list. It's very specific and doesn't need to be robust. It
> all deals with modifying one global parameter. Not that hard. And I've
> already implemented this. It works quite well :-)
> 
> > 
> > But again, I'd really not want to do this in debugfs, how about your own
> > filesystem?
> 
> I will note that this never modifies the debugfs code. But it does
> circumvent it.

Ah, I like circumventing debugfs, it kind of fits right into its mission :)

> That is, all this code lives in kernel/trace/trace.c. I don't modify
> any of the debugfs code. I just replace the debugfs
> dentry->d_inode->i_op with my own ops.

Oh, ok, I thought you were talking about modifying the debugfs core.

> I can create my own fs, but that just seems to be overkill. The only
> difference is that I need mkdir and rmdir for this one instance.
> 
> That said, perhaps it wouldn't be too hard to create a ftracefs. Where
> should it go? fs/ftrace or perhaps kernel/trace/fs ?

Sure, it only takes 300 lines to write a fs so it's not hard to do your
own.

> I notice that I only use:
> 
> debugfs_create_file()
> debugfs_remove();
> debugfs_create_dir();
> debugfs_remove_recursive();
> debugfs_initialized()
> 
> so maybe it wouldn't be such a far fetch thing to implement.
> 
> But then would I be able to still mount it in /debug/tracing ? As this
> is where everything currently uses it? But then we need to teach admins
> to add it there, or someplace else. /sys/kernel/ftrace?
> 
> Tools like trace-cmd and perf already expect it to be in the debugfs
> tracing directory, and will automate mounting it to /sys/kernel/debug/
> if not found. This may break userspace if I make another fs.

Yes, you would need to require distros to mount it in the proper place,
which is a pain, but not impossible.  It's up to you, as I thought you
needed to modify debugfs, I didn't like it, but if you can do it in your
own code, I really don't care anymore :)

greg k-h
