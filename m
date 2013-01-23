Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab3AWWze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 17:55:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48964 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3AWWz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 17:55:26 -0500
Date: Wed, 23 Jan 2013 22:55:24 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [tracepoint] cargo-culting considered harmful...
Message-ID: <20130123225523.GY4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In samples/tracepoints/tracepoint-probe-sample.c:
/*
 * Here the caller only guarantees locking for struct file and struct inode.
 * Locking must therefore be done in the probe to use the dentry.
 */
static void probe_subsys_event(void *ignore,   
                               struct inode *inode, struct file *file)
{
        path_get(&file->f_path);
        dget(file->f_path.dentry);
        printk(KERN_INFO "Event is encountered with filename %s\n",
                file->f_path.dentry->d_name.name);
        dput(file->f_path.dentry);
        path_put(&file->f_path);
}

note that
	* file->f_path is already pinned down by open(), path_get() does not
provide anything extra.
	* file->f_path.dentry is already pinned by open() *and* path_get()
just above that dget().
	* ->d_name.name *IS* *NOT* *PROTECTED* by pinning dentry down,
whether it's done once or thrice.

I do realize that it's just an example, but perhaps we should rename that
file to match the contents?  The only question is whether it should be
git mv samples/tracepoints/{tracepoint-probe-sample,cargo-cult}.c
or git mv samples cargo-cult...

					Al, seriously peeved.
