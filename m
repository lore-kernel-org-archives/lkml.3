Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934468Ab3JPM7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:59:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:19080 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934389Ab3JPM7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:59:30 -0400
Date: Wed, 16 Oct 2013 08:59:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Liu Chuansheng <chuansheng.liu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/3] core: Convert printk_once to use DO_ONCE
Message-ID: <20131016085928.5b8f9d95@gandalf.local.home>
In-Reply-To: <20131016115354.GC12773@localhost.localdomain>
References: <1381870252-5430-1-git-send-email-fweisbec@gmail.com>
	<1381870252-5430-3-git-send-email-fweisbec@gmail.com>
	<1381870805.22110.37.camel@joe-AO722>
	<20131015211251.GE3269@localhost.localdomain>
	<1381872280.22110.41.camel@joe-AO722>
	<20131016115354.GC12773@localhost.localdomain>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct 2013 13:53:56 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

 
> static int done;
> 
> if (!done) {
>     trace_printk(something);
>     trace_printk(something else);
>     trace_dump_stack();
>     done = 1;
> }
> 
> Having a DO_ONCE() would help a lot I think.
> 
> Now we can rename it to __DO_ONCE() and put a big fat comment to avoid it
> to be misused.

I wonder if we should make it just ONCE(), with no arguments that
should go into an if statement.


if (ONCE())
	do_this_function_once();


Where ONCE() is:

({
	static int __once;
	int __old_once = __once;

	__once = 1;
	__old_once;
})

Or the xchg version:

({
	static int __once;

	if (!__once)
		xchg(&__once, 1);
	else
		1;
})

-- Steve
