Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3AWDrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 22:47:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30364 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3AWDrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 22:47:03 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=1lp5RE5RrrwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=CpGQe48J6BUA:10 a=iQ-_c1YIavPIFMmZoSgA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358912821.21576.89.camel@gandalf.local.home>
Subject: Re: [RFC] Hack to use mkdir/rmdir in debugfs
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 22 Jan 2013 22:47:01 -0500
In-Reply-To: <1358910114.21576.86.camel@gandalf.local.home>
References: <1358910114.21576.86.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-22 at 22:01 -0500, Steven Rostedt wrote:

> As you can see, I haven't implemented the rmdir yet.

I decided to implement this too :-)

static int instance_rmdir(struct inode *inode, struct dentry *dentry)
{
	struct dentry *parent;
	int ret;

	/* Paranoid: Make sure the parent is the "instances" directory */
	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_alias);
	if (WARN_ON_ONCE(parent != trace_instance_dir))
		return -ENOENT;

	/* The caller did a dget() on dentry */
	mutex_unlock(&dentry->d_inode->i_mutex);

	/*
	 * The inode mutex is locked, but debugfs_create_dir() will also
	 * take the mutex. As the instances directory can not be destroyed
	 * or changed in any other way, it is safe to unlock it, and
	 * let the dentry try. If two users try to make the same dir at
	 * the same time, then the instance_delete() will determine the
	 * winner.
	 */
	mutex_unlock(&inode->i_mutex);

	ret = instance_delete(dentry->d_iname);

	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
	mutex_lock(&dentry->d_inode->i_mutex);

	return ret;
}

static const struct inode_operations instance_dir_inode_operations = {
	.lookup		= simple_lookup,
	.mkdir		= instance_mkdir,
	.rmdir		= instance_rmdir,
};


I ran it under lockdep and it didn't complain.

-- Steve



