Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3FQPXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:23:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab3FQPXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:23:12 -0400
Date: Mon, 17 Jun 2013 17:18:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH 2/3] tracing/kprobes: Kill probe_enable_lock
Message-ID: <20130617151841.GA32267@redhat.com>
References: <20130616172149.GA8540@redhat.com> <51BE97C0.1070203@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BE97C0.1070203@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Masami Hiramatsu wrote:
>
> (2013/06/17 2:21), Oleg Nesterov wrote:
> > enable_trace_probe() and disable_trace_probe() should not worry about
> > serialization, the caller (perf_trace_init or __ftrace_set_clr_event)
> > holds event_mutex.
> >
> > They are also called by kprobe_trace_self_tests_init(), but this __init
> > function can't race with itself or trace_events.c
>
> Right,
> For safety, we should comment this at the caller side,

Which caller do you mean?

The patch adds

	/*
	 * This and enable_trace_probe/disable_trace_probe rely on event_mutex
	 * held by the caller, __ftrace_set_clr_event().
	 */

above trace_probe_nr_files() but the next patch removes this function
with the comment...

Will you agree with this patch if I add something like

	/*
	 * called by perf_trace_init() or __ftrace_set_clr_event() under event_mutex
	 */

above kprobe_register() ? Perhaps it makes sense to add
lockdep_assert_held(&event_mutex) into the body?

And:

> because
> those calls are the reason why I have introduced this lock.

Please do not hesitate to nack this patch if you think that we should
keep probe_enable_lock for safety even if it is not currently needed.
In this case I'd suggest to move lock/unlock into kprobe_register()
but this is minor.

Oleg.

