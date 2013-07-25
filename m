Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab3GYULJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 16:11:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408Ab3GYULE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 16:11:04 -0400
Date: Thu, 25 Jul 2013 22:04:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: PATCH? debugfs_remove_recursive() must not rely on
	list_empty(d_subdirs)
Message-ID: <20130725200423.GA22274@redhat.com>
References: <20130723205854.GA9036@redhat.com> <20130724184640.GA21322@redhat.com> <20130725192742.GA14060@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725192742.GA14060@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25, Oleg Nesterov wrote:
>
> To simplify the review, this is how it looks with the patch applied:

v2. We can use simply use list_for_each_entry_safe() and
list_next_entry() should be calles under ->i_mutex. Although
debugfs_remove_recursive() can race with itself anyway, but
still.

And the code looks much simpler. But I do not know what did
I miss.

Oleg.

void debugfs_remove_recursive(struct dentry *dentry)
{
	struct dentry *child, *next, *parent;

	if (IS_ERR_OR_NULL(dentry))
		return;

	parent = dentry->d_parent;
	if (!parent || !parent->d_inode)
		return;

	parent = dentry;
 down:
	mutex_lock(&parent->d_inode->i_mutex);
	list_for_each_entry_safe(child, next, &parent->d_subdirs, d_u.d_child) {
		if (!debugfs_positive(child))
			continue;

		/* XXX: simple_empty(child) instead ? */
		if (!list_empty(&child->d_subdirs)) {
			mutex_unlock(&parent->d_inode->i_mutex);
			parent = child;
			goto down;
		}
 up:
		__debugfs_remove(child, parent);
	}

	mutex_unlock(&parent->d_inode->i_mutex);
	if (parent != dentry) {
		child = parent;
		parent = parent->d_parent;
		mutex_lock(&parent->d_inode->i_mutex);
		next = list_next_entry(child, d_u.d_child);
		goto up;
	}

	parent = dentry->d_parent;
	mutex_lock(&parent->d_inode->i_mutex);
	__debugfs_remove(dentry, parent);
	mutex_unlock(&parent->d_inode->i_mutex);
	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
}

