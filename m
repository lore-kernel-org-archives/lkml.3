Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbaAJUKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 15:10:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40384 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbaAJUK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 15:10:27 -0500
Date: Fri, 10 Jan 2014 21:10:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: SIGSEGV when using "perf record -g" with 3.13-rc* kernel
Message-ID: <20140110201020.GK7572@laptop.programming.kicks-ass.net>
References: <52D011C9.7000209@hp.com>
 <20140110165822.GI7572@laptop.programming.kicks-ass.net>
 <20140110170223.GD8224@laptop.programming.kicks-ass.net>
 <52D04BE6.9050907@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D04BE6.9050907@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 02:37:10PM -0500, Waiman Long wrote:
> >@@ -641,7 +641,7 @@ no_context(struct pt_regs *regs, unsigned long error_code,
> >
> >  	/* Are we prepared to handle this kernel fault? */
> >  	if (fixup_exception(regs)) {
> >-		if (current_thread_info()->sig_on_uaccess_error&&  signal) {
> >+		if (!in_nmi()&&  current_thread_info()->sig_on_uaccess_error&&  signal) {
> >  			tsk->thread.trap_nr = X86_TRAP_PF;
> >  			tsk->thread.error_code = error_code | PF_USER;
> >  			tsk->thread.cr2 = address;
> 
> Yes, this change fixed the error that I got. I no longer see SIGSEGV when I
> run the test.

Awesome, just send a more elaborate version that should have the same
effect.

> I did tried to back out your "perf: Fix arch_perf_out_copy_user default"
> patch, but it didn't fix the problem.

The culprit was: e00b12e64be9 ("perf/x86: Further optimize
copy_from_user_nmi()")


