Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab3GWPat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 11:30:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757467Ab3GWPar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 11:30:47 -0400
Date: Tue, 23 Jul 2013 17:25:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexander Z Lam <azl@google.com>, David Sharp <dhsharp@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] tracing: Kill the buggy trace_cpu
Message-ID: <20130723152531.GA23688@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This series kills tracing_open_generic_tc/trace_cpu/etc.

trace_array_get(inode->i_private) is mostly fine, we do not
dereference this pointer untill trace_array_get() succeeds.
But trace_array_get(tc->tr) is wrong by the same reason why
tracing_open_generic_file/etc are wrong, see 1/7.

(Steven, I think you are right and we can also remove the
 list_for_each_entry() loop from trace_array_get() later,
 and avoid the (harmless but still) race with rmdir + mkdir.
 Lets discuss this after we fix the problems with file/call).

Changes:

	1/7: Fix the whitespace problems.

	     Add the comment above tracing_get_cpu() and update
	     the changelog. tracing_get_cpu() is always safe but
	     the code like

		cpu = tracing_get_cpu(inode);
		if (trace_array_get(tr) == 0)
			do_something(tr, cpu);

	     is racy, it can wrongly use RING_BUFFER_ALL_CPUS.
	     IOW, tracing_get_cpu() should be used only after
	     trace_array_get() or something else which takes
	     trace_types_lock at least once.

	5/7: No changes. checkpatch.pl complains, but that
	     "line over 80 characters" in tracing_entries_read()
	     was not added by this patch and I do not know how
	     can I make checkpatch.pl happy without adding a
	     helper for per_cpu_ptr(tr->trace_buffer.data).

	6/7: Incorporated the fix from Steven (thanks!).

Oleg.

 kernel/trace/trace.c |  194 +++++++++++++++++++++-----------------------------
 kernel/trace/trace.h |    8 --
 2 files changed, 80 insertions(+), 122 deletions(-)

