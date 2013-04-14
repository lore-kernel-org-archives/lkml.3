Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3DNTRx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 15:17:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab3DNTRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 15:17:52 -0400
Date: Sun, 14 Apr 2013 21:12:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Maneesh Soni <maneesh@linux.vnet.ibm.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ptrace/x86: simplify ptrace_write_dr7()
Message-ID: <20130414191205.GA28791@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On top of "[PATCH 0/5] kill ptrace_{get,put}_breakpoints()".
Cleanup and preparation for the potential fix, see below.

------------------------------------------------------------------------------
Now the question. Initially I was going to make more patches
and fix the regression introduced by 24f1e32c (although I am
not 100% sure which exactly patch should be blamed).

See https://bugzilla.redhat.com/show_bug.cgi?id=660204 for
details.

ptrace_write_dr7() does not create bp if it is zero, the comment
says:

	/*
	 * We should have at least an inactive breakpoint at
	 * this slot. It means the user is writing dr7 without
	 * having written the address register first.
	 */
                                                                                                    
and this looks logical. However, at least until 72f674d2
ptrace_set_debugreg(n => 7) worked even if addr wasn't set
by ptrace_set_debugreg(n => 0|1|2|3) before.

And note that ptrace_get_debugreg() does not fail if !ptrace_bps[n],
it just returns zero as if the address register was written. And
there is no way to know if address was actually set, not good and
not consistent.

Jan, Frederic, et all. What do you think we should do?

	1. Change ptrace_write_dr7() to do register_user_hw_breakpoint()
	   if necessary.

	   This is what I was going to do, but I am no longer sure
	   we want this. For what? Unlikely it is very useful to use
	   the "default" addr == 0 for debugging.

	2. Change ptrace_get_debugreg(0-4) to return -ESOMETHING if
	   ptrace_bps[n] == NULL.

	   This will match ptrace_set_debugreg(), but this can break
	   something else...

	3. Do nothing.

I am inclined to do "1", but please comment.

Oleg.

