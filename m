Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249Ab3GZOyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 10:54:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759207Ab3GZOyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:54:32 -0400
Date: Fri, 26 Jul 2013 16:49:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
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
Subject: Re: Re: PATCH? debugfs_remove_recursive() must not rely on
	list_empty(d_subdirs)
Message-ID: <20130726144900.GA18876@redhat.com>
References: <20130723205854.GA9036@redhat.com> <20130724184640.GA21322@redhat.com> <20130725192742.GA14060@redhat.com> <20130725200423.GA22274@redhat.com> <51F24E4A.3080803@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F24E4A.3080803@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26, Masami Hiramatsu wrote:
>
> (2013/07/26 5:04), Oleg Nesterov wrote:
> >
> > 	parent = dentry;
> >  down:
> > 	mutex_lock(&parent->d_inode->i_mutex);
> > 	list_for_each_entry_safe(child, next, &parent->d_subdirs, d_u.d_child) {
>
> Perhaps, you can use list_for_each_entry_safe_continue() here, as below.
>
> 	parent = dentry;
> down:
> 	child = list_first_entry_or_null(&parent->d_subdirs,
> 					 typeof(*child), d_u.d_child);
> 	mutex_lock(&parent->d_inode->i_mutex);
>
> restart:
> 	list_for_each_entry_safe_continue(child, next, &parent->d_subdirs, d_u.d_child) {
>
> > 		if (!debugfs_positive(child))
> > 			continue;
> >
> > 		/* XXX: simple_empty(child) instead ? */
> > 		if (!list_empty(&child->d_subdirs)) {
> > 			mutex_unlock(&parent->d_inode->i_mutex);
> > 			parent = child;
> > 			goto down;
> > 		}
> >  up:
> > 		__debugfs_remove(child, parent);
> > 	}
>
> Then, you can avoid jumping into the loop, just restart it from
> parent as below.

Yes, but I'd prefer to jump into the loop. This is subjective, but looks
a bit more understandable to me.

Because "goto down/up" are actually "call/return", and "jump up" looks
like return-after-recursive-debugfs_remove_recursive-call.

However,

> 	if (child != dentry)
> 		goto restart;
>
> > 	mutex_unlock(&parent->d_inode->i_mutex);

Yes, I realized this right after I sent the email ;)

We can factor out the final ->d_parent/mutex_lock if we check
"child != dentry" instead of "parent != dentry".

I'll send the patch in a minute. Thanks.

Oleg.

