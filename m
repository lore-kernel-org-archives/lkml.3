Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759217Ab3GZPR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:17:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489Ab3GZPRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:17:25 -0400
Date: Fri, 26 Jul 2013 17:11:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] debugfs: debugfs_remove_recursive() must not rely on
	list_empty(d_subdirs)
Message-ID: <20130726151151.GA19472@redhat.com>
References: <20130723205854.GA9036@redhat.com> <20130724184640.GA21322@redhat.com> <20130725192742.GA14060@redhat.com> <20130725200423.GA22274@redhat.com> <20130725234357.GA14958@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130725234357.GA14958@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25, Greg Kroah-Hartman wrote:
>
> Anyway, your changes below look good in this version, I don't see
> anything obviously wrong with it, but maybe others do?

Please see 1/1.

Changes:

	- s/list_next_entry/list_entry/. It would be nice to move
	  list_next_entry() from kernel/events/core.c to list.h
	  but this needs another patch

	- Do "parent = parent->d_parent" before "!= dentry" check,
	  this factors out the common code in "goto up" and final
	  __debugfs_remove(dentry)

	- Add simple_release_fs() back.

The patch is hardly readable, so I attached the code below again.



Note!!! The changelog contains the simple test-case. However, this
test-case can actually reveal more problems because kernel/trace/
is buggy too. (hopefully we already have the necessary fixes).

Steven, Greg. Assuming that nobody objects and the patch is fine.
Perhaps this patch can be routed via rostedt/linux-trace tree?

This connects to other problems we are working on, it would be
nice to have this patch in the same tree to simplify the testing.

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

		/* perhaps simple_empty(child) makes more sense */
		if (!list_empty(&child->d_subdirs)) {
			mutex_unlock(&parent->d_inode->i_mutex);
			parent = child;
			goto down;
		}
 up:
		if (!__debugfs_remove(child, parent))
			simple_release_fs(&debugfs_mount, &debugfs_mount_count);
	}

	mutex_unlock(&parent->d_inode->i_mutex);
	child = parent;
	parent = parent->d_parent;
	mutex_lock(&parent->d_inode->i_mutex);

	if (child != dentry) {
		next = list_entry(child->d_u.d_child.next, struct dentry,
					d_u.d_child);
		goto up;
	}

	if (!__debugfs_remove(child, parent))
		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
	mutex_unlock(&parent->d_inode->i_mutex);
}


