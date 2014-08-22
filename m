Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661AbaHVROG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 13:14:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932297AbaHVROE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 13:14:04 -0400
Date: Fri, 22 Aug 2014 19:11:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bean Anderson <bean@azulsystems.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] x86, fpu: shift drop_init_fpu() from save_xstate_sig()
	to handle_signal()
Message-ID: <20140822171142.GA14812@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al, Linus, could you take a look?

Looks simple, but I have to admit that every time I read FPU code
I feel that I never read it before. And I never really understood
it in details.

See the changelog, but in short drop_init_fpu() in save_xstate_sig()
looks wrong. This assumes that we are going to call the handler and
thus we need the new FPU state. But this is only true if setup_frame()
won't fail after that. If it fails, we simply lose the FPU state.

Many thanks to Bean Anderson for the detailed report, let me quote it:

	(1) A real-time signal is being delivered to a thread.
	(2) There is not enough room to push the ucontext on the
	    stack so a SIGSEGV is generated
	(3) The segv handler is running on the sigaltstack.
	(4) The ucontext received by the segv handler does not contain
	    the FP registers. And on return from the segv handler, the
	    existing FP registers appear to be zero'd out.

Oleg.

