Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab3GQOti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 10:49:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab3GQOtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 10:49:36 -0400
Date: Wed, 17 Jul 2013 16:43:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] tracing: fix open/delete fixes
Message-ID: <20130717144357.GA7358@redhat.com>
References: <20130716185658.GA21167@redhat.com> <51E6032B.7070907@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E6032B.7070907@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17, Masami Hiramatsu wrote:
>
> At a glance, you're trying to change which operation will be
> failed. Currently, user can not remove an event while someone
> opens files which related to the event. And this approach
> changes that the someone can remove the event even if the
> files are opened (and read/write operation will be failed).
> Am I understand correctly?

Yes.

Once again, I am still not sure and I am asking for your review.

But to me this looks much better. To simplify the discussion, lets
consider ftrace_enable_fops in particular.

	- Why should .open() block rmdir or unregister_uprobe_event?

	- Why do we need .open() at all? Whatever it can do to
	  validate file/call/etc, .read/write can do the same.

	- If we kill .open/release, we do not need the nontrivial
	  refcounting. Everything becomes simple, no need to keep
	  the state "in between".

	  We need event_mutex anyway (and note that other f_op's can
	  also rely on other locks taken by trace_remove_event_call),
	  the validation degrades to the trivial != NULL check.

	- This also simplifies trace_remove_event_call() paths, we
	  know that once it takes event_mutex nobody can play with
	  ftrace_event_file/ftrace_event_call we are going to free.

Oleg.

