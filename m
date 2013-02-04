Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab3BDPUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 10:20:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab3BDPUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 10:20:01 -0500
Date: Mon, 4 Feb 2013 16:18:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] uprobes/perf: Always increment trace_uprobe->nhit
Message-ID: <20130204151850.GA6641@redhat.com>
References: <20130131191752.GA30410@redhat.com> <20130131191832.GA30457@redhat.com> <20130204111711.GB12900@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204111711.GB12900@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2013-01-31 20:18:32]:
>
> > Move tu->nhit++ from uprobe_trace_func() to uprobe_dispatcher().
> >
> > ->nhit counts how many time we hit the breakpoint inserted by this
> > uprobe, we do not want to loose this info if uprobe was enabled by
> > sys_perf_event_open().
> >
>
> Though I dont see a problem with this change, It seems unnecessary for
> me.
>
> Info from nhits is mostly for /sys/kernel/debug/tracing/uprobe_profile

It is only for uprobe_profile, yes, and it is useful. Why should we hide
this info if this uprobe is used by perf?

> I am not sure how sys_perf_event_open() is making use of this?

I hope I'll send the final series today. From the changelog of the patch
which actually turns the filtering on:

	Testing:

		# perf probe -x /lib/libc.so.6 syscall

		# perl -e 'syscall -1 while 1' &
		[1] 530

		# perf record -e probe_libc:syscall perl -e 'syscall -1 for 1..10; sleep 1'

		# perf report --show-total-period
			100.00%            10     perl  libc-2.8.so    [.] syscall

	Before this patch:

		# cat /sys/kernel/debug/tracing/uprobe_profile
			/lib/libc.so.6 syscall				79291

	A huge ->nrhit == 79291 reflects the fact that the background process
	530 constantly hits this breakpoint too, even if doesn't contribute to
	the output.

	After the patch:

		# cat /sys/kernel/debug/tracing/uprobe_profile
			/lib/libc.so.6 syscall				10

	This shows that only the target process was punished by int3.

Oleg.

