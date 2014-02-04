Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbaBDTyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:54:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325AbaBDTyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:54:06 -0500
Date: Tue, 4 Feb 2014 20:00:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, David Smith <dsmith@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Igor Zhbanov <i.zhbanov@samsung.com>,
        Christoph Hellwig <hch@infradead.org>, Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH] exec: Fix use after free of tracepoint
	trace_sched_process_exec
Message-ID: <20140204190007.GA8996@redhat.com>
References: <20140204120500.041b5175@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140204120500.041b5175@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Steven Rostedt wrote:
>
> Now to fix this we need to save the filename before calling
> search_binary_handler(). But we don't want to save it if we are not
> tracing. Why slow everyone else down?

Yes, but it would be much simpler to dup filename unconditionally.

Note also that in this case we can kill linux_binprm->tcomm[] and
simplify filename_to_taskname().

> This works, but is rather ugly.

Yes ;)

> Looking for any other suggestions here.

Perhaps we can change flush_old_exec() to do

	if (!current->mm) {
		bprm->filename = kstrdup(bprm->filename);
		if (bprm->filename)
			bprm->filename_was_dupped = true; // for free_bprm()
		else
			bprm->filename = "//enomem";
	}

This won't penalize the normal exec, and this should fix the problem
afaics.

Perhaps, instead of "//enomem" flush_old_exec() should simply fail,
in this case we can kill bprm->tcomm[] too.

Oleg.

