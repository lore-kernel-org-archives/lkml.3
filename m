Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbaBDUKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 15:10:32 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:51748 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932088AbaBDUK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 15:10:28 -0500
Date: Tue, 4 Feb 2014 15:10:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, David Smith <dsmith@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Igor Zhbanov <i.zhbanov@samsung.com>,
        Christoph Hellwig <hch@infradead.org>, Paul Menage <menage@google.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH] exec: Fix use after free of tracepoint
 trace_sched_process_exec
Message-ID: <20140204151025.691b4378@gandalf.local.home>
In-Reply-To: <20140204190007.GA8996@redhat.com>
References: <20140204120500.041b5175@gandalf.local.home>
	<20140204190007.GA8996@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Feb 2014 20:00:07 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> On 02/04, Steven Rostedt wrote:
> >
> > Now to fix this we need to save the filename before calling
> > search_binary_handler(). But we don't want to save it if we are not
> > tracing. Why slow everyone else down?
> 
> Yes, but it would be much simpler to dup filename unconditionally.

I was hoping not to add more work to exec, for the purpose if tracing
is enabled.

> 
> Note also that in this case we can kill linux_binprm->tcomm[] and
> simplify filename_to_taskname().
> 
> > This works, but is rather ugly.
> 
> Yes ;)
> 
> > Looking for any other suggestions here.
> 
> Perhaps we can change flush_old_exec() to do
> 
> 	if (!current->mm) {
> 		bprm->filename = kstrdup(bprm->filename);
> 		if (bprm->filename)
> 			bprm->filename_was_dupped = true; // for free_bprm()
> 		else
> 			bprm->filename = "//enomem";
> 	}
> 
> This won't penalize the normal exec, and this should fix the problem
> afaics.

Don't forget to add the free. And in any case, we added a branch
conditional. Yes, I'm that anal.

> 
> Perhaps, instead of "//enomem" flush_old_exec() should simply fail,
> in this case we can kill bprm->tcomm[] too.

We could just add "//enomem" to the tracepoint too, and not use tcomm.

Also, I'm working on a patch that gets rid of all the setup of the
static_key and reuses the tracepoint static key instead (suggested by
Peter Zijlstra).

Thus, the change in exec.c would just look like this:


	if (tracepoint_enabled(sched_process_exec)) {
		[...]
	} else
		ret = search_binary_handler(bprm);


That is, we can get rid of the sched_process_exec_key_reg and unreg
functions, and just use this and it would become the same thing.

This will be helpful in other places too (David, I'm talking to you ;-)


-- Steve
