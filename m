Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab3AWXCq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 18:02:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14479 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3AWXCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 18:02:40 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=d9aeljUNHtYA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=hZ6iKA16joIA:10 a=8ZBe9AXj63V5KYisf3UA:9 a=CjuIK1q_8ugA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Wed, 23 Jan 2013 18:02:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tracepoint] cargo-culting considered harmful...
Message-ID: <20130123230235.GC5434@home.goodmis.org>
References: <20130123225523.GY4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130123225523.GY4939@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 10:55:24PM +0000, Al Viro wrote:
> In samples/tracepoints/tracepoint-probe-sample.c:
> /*
>  * Here the caller only guarantees locking for struct file and struct inode.
>  * Locking must therefore be done in the probe to use the dentry.
>  */
> static void probe_subsys_event(void *ignore,   
>                                struct inode *inode, struct file *file)
> {
>         path_get(&file->f_path);
>         dget(file->f_path.dentry);
>         printk(KERN_INFO "Event is encountered with filename %s\n",
>                 file->f_path.dentry->d_name.name);
>         dput(file->f_path.dentry);
>         path_put(&file->f_path);
> }
> 
> note that
> 	* file->f_path is already pinned down by open(), path_get() does not
> provide anything extra.
> 	* file->f_path.dentry is already pinned by open() *and* path_get()
> just above that dget().
> 	* ->d_name.name *IS* *NOT* *PROTECTED* by pinning dentry down,
> whether it's done once or thrice.
> 
> I do realize that it's just an example, but perhaps we should rename that
> file to match the contents?  The only question is whether it should be
> git mv samples/tracepoints/{tracepoint-probe-sample,cargo-cult}.c
> or git mv samples cargo-cult...

I wonder if we should just remove the samples/tracepoints/ all together.
The tracepoint code is now only used internally by the trace_event code,
and there should not be any users of tracepoints directly.

-- Steve

