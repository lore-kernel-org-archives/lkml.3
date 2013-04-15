Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934919Ab3DOXg7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 19:36:59 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:64633 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab3DOXg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 19:36:58 -0400
Date: Tue, 16 Apr 2013 01:36:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Maneesh Soni <maneesh@linux.vnet.ibm.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] ptrace/x86: simplify ptrace_write_dr7()
Message-ID: <20130415233652.GE17561@somewhere.redhat.com>
References: <20130414191205.GA28791@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414191205.GA28791@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 14, 2013 at 09:12:05PM +0200, Oleg Nesterov wrote:
> Hello.
> 
> On top of "[PATCH 0/5] kill ptrace_{get,put}_breakpoints()".
> Cleanup and preparation for the potential fix, see below.
> 
> ------------------------------------------------------------------------------
> Now the question. Initially I was going to make more patches
> and fix the regression introduced by 24f1e32c (although I am
> not 100% sure which exactly patch should be blamed).
> 
> See https://bugzilla.redhat.com/show_bug.cgi?id=660204 for
> details.

Oh I missed that.

> 
> ptrace_write_dr7() does not create bp if it is zero, the comment
> says:
> 
> 	/*
> 	 * We should have at least an inactive breakpoint at
> 	 * this slot. It means the user is writing dr7 without
> 	 * having written the address register first.
> 	 */
>                                                                                                     
> and this looks logical. However, at least until 72f674d2
> ptrace_set_debugreg(n => 7) worked even if addr wasn't set
> by ptrace_set_debugreg(n => 0|1|2|3) before.
> 
> And note that ptrace_get_debugreg() does not fail if !ptrace_bps[n],
> it just returns zero as if the address register was written. And
> there is no way to know if address was actually set, not good and
> not consistent.

Indeed.

Looking at the bug report, it seems they only reproduced with a homemade
test. No real app has reported that issue?

Now I guess this is irrelevant. It indeed seems to me saner to be
consistent with regs read like you are pointing out. And that ABI
breakage makes me uncomfortable, even though we haven't heard about
real breakage yet.

> 
> Jan, Frederic, et all. What do you think we should do?
> 
> 	1. Change ptrace_write_dr7() to do register_user_hw_breakpoint()
> 	   if necessary.
> 
> 	   This is what I was going to do, but I am no longer sure
> 	   we want this. For what? Unlikely it is very useful to use
> 	   the "default" addr == 0 for debugging.

So you mean assume that the addr is 0 in dr[0-3] if we write dr7 before writing
the addr register?

Yes, I'm convinced that's the right direction!

> 
> 	2. Change ptrace_get_debugreg(0-4) to return -ESOMETHING if
> 	   ptrace_bps[n] == NULL.
> 
> 	   This will match ptrace_set_debugreg(), but this can break
> 	   something else...

Yeah that would be worse, and I'm sure that breaks existing apps :)

Thanks!
