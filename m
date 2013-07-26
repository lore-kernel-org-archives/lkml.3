Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab3GZKYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 06:24:21 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41251 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758528Ab3GZKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 06:24:14 -0400
Message-ID: <51F24E4A.3080803@hitachi.com>
Date: Fri, 26 Jul 2013 19:24:10 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Z Lam <azl@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Re: PATCH? debugfs_remove_recursive() must not rely on list_empty(d_subdirs)
References: <20130723205854.GA9036@redhat.com> <20130724184640.GA21322@redhat.com> <20130725192742.GA14060@redhat.com> <20130725200423.GA22274@redhat.com>
In-Reply-To: <20130725200423.GA22274@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/26 5:04), Oleg Nesterov wrote:
> On 07/25, Oleg Nesterov wrote:
>>
>> To simplify the review, this is how it looks with the patch applied:
> 
> v2. We can use simply use list_for_each_entry_safe() and
> list_next_entry() should be calles under ->i_mutex. Although
> debugfs_remove_recursive() can race with itself anyway, but
> still.
> 
> And the code looks much simpler. But I do not know what did
> I miss.
> 
> Oleg.
> 
> void debugfs_remove_recursive(struct dentry *dentry)
> {
> 	struct dentry *child, *next, *parent;
> 
> 	if (IS_ERR_OR_NULL(dentry))
> 		return;
> 
> 	parent = dentry->d_parent;
> 	if (!parent || !parent->d_inode)
> 		return;
> 
> 	parent = dentry;
>  down:
> 	mutex_lock(&parent->d_inode->i_mutex);
> 	list_for_each_entry_safe(child, next, &parent->d_subdirs, d_u.d_child) {

Perhaps, you can use list_for_each_entry_safe_continue() here, as below.

	parent = dentry;
down:
	child = list_first_entry_or_null(&parent->d_subdirs,
					 typeof(*child), d_u.d_child);
	mutex_lock(&parent->d_inode->i_mutex);

restart:
	list_for_each_entry_safe_continue(child, next, &parent->d_subdirs, d_u.d_child) {

> 		if (!debugfs_positive(child))
> 			continue;
> 
> 		/* XXX: simple_empty(child) instead ? */
> 		if (!list_empty(&child->d_subdirs)) {
> 			mutex_unlock(&parent->d_inode->i_mutex);
> 			parent = child;
> 			goto down;
> 		}
>  up:
> 		__debugfs_remove(child, parent);
> 	}

Then, you can avoid jumping into the loop, just restart it from
parent as below.

	mutex_unlock(&parent->d_inode->i_mutex);

	child = parent;
	parent = parent->d_parent;
	mutex_lock(&parent->d_inode->i_mutex);
	__debugfs_remove(child, parent);

	if (child != dentry)
		goto restart;

> 	mutex_unlock(&parent->d_inode->i_mutex);
> 	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
> }

It's just an idea, which came up to my mind. :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


