Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3AWEbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 23:31:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18207 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab3AWEbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 23:31:37 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1lp5RE5RrrwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=CpGQe48J6BUA:10 a=8blSGue7upUJ5Vfm0HUA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358915495.21576.102.camel@gandalf.local.home>
Subject: Re: [RFC] Hack to use mkdir/rmdir in debugfs
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 22 Jan 2013 23:31:35 -0500
In-Reply-To: <20130123040846.GA2638@kroah.com>
References: <1358910114.21576.86.camel@gandalf.local.home>
	 <20130123040846.GA2638@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 20:08 -0800, Greg Kroah-Hartman wrote:

> > Is doing something as silly as the following fine, or is there a better
> > way?
> 
> Yes, why not create your own fs for ftrace?  :)

But but but...

debugfs is soooo convenient!

Do you think it would be worth doing that though? I only need the mkdir
and rmdir for this one instance. Nothing more.

> >	mutex_unlock(&inode->i_mutex);
> > 
> > 	ret = new_instance_create(dentry->d_iname);
> > 
> > 	mutex_lock(&inode->i_mutex);
> > 

> But how can you callback to your code to let it know that something was
> created in it?

I pass the dentry->d_iname to create a directory.

> 
> Don't you need that for both mkdir and rmdir?

It's a global list. It's very specific and doesn't need to be robust. It
all deals with modifying one global parameter. Not that hard. And I've
already implemented this. It works quite well :-)

> 
> But again, I'd really not want to do this in debugfs, how about your own
> filesystem?

I will note that this never modifies the debugfs code. But it does
circumvent it. That is, all this code lives in kernel/trace/trace.c. I
don't modify any of the debugfs code. I just replace the debugfs
dentry->d_inode->i_op with my own ops.

I can create my own fs, but that just seems to be overkill. The only
difference is that I need mkdir and rmdir for this one instance.

That said, perhaps it wouldn't be too hard to create a ftracefs. Where
should it go? fs/ftrace or perhaps kernel/trace/fs ?

I notice that I only use:

debugfs_create_file()
debugfs_remove();
debugfs_create_dir();
debugfs_remove_recursive();
debugfs_initialized()

so maybe it wouldn't be such a far fetch thing to implement.

But then would I be able to still mount it in /debug/tracing ? As this
is where everything currently uses it? But then we need to teach admins
to add it there, or someplace else. /sys/kernel/ftrace?

Tools like trace-cmd and perf already expect it to be in the debugfs
tracing directory, and will automate mounting it to /sys/kernel/debug/
if not found. This may break userspace if I make another fs.

-- Steve



