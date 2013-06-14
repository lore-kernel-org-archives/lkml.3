Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977Ab3FNNX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:23:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776Ab3FNNX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:23:57 -0400
Date: Fri, 14 Jun 2013 15:19:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Vagin <avagin@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/1] move exit_task_namespaces() outside of
	exit_notify()
Message-ID: <20130614131948.GA28507@redhat.com>
References: <1365794853-23912-1-git-send-email-avagin@openvz.org> <20130413142246.GA864@redhat.com> <20130413155457.GA6533@redhat.com> <20130413155521.GB6533@redhat.com> <20130613092442.GA32730@paralelels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613092442.GA32730@paralelels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13, Andrew Vagin wrote:
>
> On Sat, Apr 13, 2013 at 05:55:21PM +0200, Oleg Nesterov wrote:
> > exit_notify() does exit_task_namespaces() after
> > forget_original_parent(). This was needed to ensure that ->nsproxy
> > can't be cleared prematurely, an exiting child we are going to
> > reparent can do do_notify_parent() and use the parent's (ours) pid_ns.
> >
> > However, after 32084504 "pidns: use task_active_pid_ns in
> > do_notify_parent" ->nsproxy != NULL is no longer needed, we rely
> > on task_active_pid_ns().
> >
> > Move exit_task_namespaces() from exit_notify() to do_exit(), after
> > exit_fs() and before exit_task_work().
> >
> > This solves the problem reported by Andrey, free_ipc_ns()->shm_destroy()
> > does fput() which needs task_work_add(). And this allows us do simplify
> > exit_notify(), we can avoid unlock/lock(tasklist) and we can change
> > ->exit_state instead of PF_EXITING in forget_original_parent().
> >
>
> It looks good for me. kmemleak doesn't report any leaks. CRIU test
> cases, which use namespaces, work without any errors.

OK, thanks.

I guess I need to resend this patch with your and Eric's acks.

But in fact I am going to send the 2nd change as well, it should
fix the same problem too and imho it makes sense anyway. And to
me the 2nd one looks like 3.10 material, it is much more simple
and straightforward.

Oleg.

