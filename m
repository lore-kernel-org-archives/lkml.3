Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3AWXwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 18:52:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3AWXwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 18:52:05 -0500
Date: Wed, 23 Jan 2013 15:51:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tracepoint] cargo-culting considered harmful...
Message-Id: <20130123155147.25fe49a2.akpm@linux-foundation.org>
In-Reply-To: <20130123225523.GY4939@ZenIV.linux.org.uk>
References: <20130123225523.GY4939@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jan 2013 22:55:24 +0000
Al Viro <viro@ZenIV.linux.org.uk> wrote:

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

I guess the first two are obvious (or at least, expected).  But the
third isn't.

Where should a kernel developer go to learn these things? 
include/linux/dcache.h doesn't mention d_name locking rules, nor does
Documentation/filesystems/vfs.txt.

