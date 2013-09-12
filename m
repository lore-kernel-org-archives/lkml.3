Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3ILSjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:39:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab3ILSja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:39:30 -0400
Date: Thu, 12 Sep 2013 14:38:49 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: trinity finds ftrace/perf bug. Film at 11.
Message-ID: <20130912183849.GA16674@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@kernel.org>
References: <20130911135434.GA678@redhat.com>
 <20130912141913.2ffc7077@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912141913.2ffc7077@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 02:19:13PM -0400, Steven Rostedt wrote:
 > 
 > This is something that either Peter or Frederic need to look at.

I spent yesterday trying to bisect this, but kept running into other perf/ftrace traces,
which makes it pretty much impossible.

The current one I'm staring at is this from LIST_DEBUG..

list_del corruption. next->prev should be prev (ffff88000fb812b0), but was ffff88000fb812b0. (next=ffff88009df8b7b0).

The sharp eyed will notice that those first two addresses are actually the same.
So we matched the next->prev != prev test, but at the time we got to the printk that follows
in the WARN, the inverse was true. Smells like a race of some kind.

[ 2481.228418] Call Trace:
[ 2481.232705]  [<ffffffff8171f5dd>] dump_stack+0x54/0x74
[ 2481.237025]  [<ffffffff810540bd>] warn_slowpath_common+0x7d/0xa0
[ 2481.241357]  [<ffffffff8105412c>] warn_slowpath_fmt+0x4c/0x50
[ 2481.245637]  [<ffffffff810540e5>] ? warn_slowpath_fmt+0x5/0x50
[ 2481.249890]  [<ffffffff8132c222>] __list_del_entry+0x62/0xf0
[ 2481.254109]  [<ffffffff81143a88>] list_del_event+0xc8/0xe0
[ 2481.258310]  [<ffffffff81143b2b>] perf_remove_from_context+0x8b/0xf0
[ 2481.262497]  [<ffffffff81145444>] perf_event_release_kernel+0x54/0x90
[ 2481.266688]  [<ffffffff811464d3>] put_event+0x133/0x1c0
[ 2481.270866]  [<ffffffff811463d0>] ? put_event+0x30/0x1c0
[ 2481.275066]  [<ffffffff81146570>] perf_release+0x10/0x20
[ 2481.279277]  [<ffffffff811bf2ca>] __fput+0xfa/0x2e0
[ 2481.283488]  [<ffffffff811bf4fe>] ____fput+0xe/0x10
[ 2481.287713]  [<ffffffff8107c11c>] task_work_run+0xac/0xe0
[ 2481.291958]  [<ffffffff810559bc>] do_exit+0x2cc/0xcc0
[ 2481.296194]  [<ffffffff81732880>] ? ftrace_call+0x5/0x2f
[ 2481.300435]  [<ffffffff810577cc>] do_group_exit+0x4c/0xc0
[ 2481.304654]  [<ffffffff81057854>] SyS_exit_group+0x14/0x20
[ 2481.308857]  [<ffffffff81732e54>] tracesys+0xdd/0xe2
[ 2481.313051] ---[ end trace fa3e551eb20e0c0f ]---

	Dave

