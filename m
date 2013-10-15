Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933797Ab3JOUgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:36:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:3499 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933733Ab3JOUgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:36:01 -0400
Date: Tue, 15 Oct 2013 16:35:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] bug: Use xchg() to update WARN_ON_ONCE() static
 variable
Message-ID: <20131015163559.2a25b8d9@gandalf.local.home>
In-Reply-To: <20131015131259.3051743890ce9b1b9dae9763@linux-foundation.org>
References: <20131015155806.04e2613f@gandalf.local.home>
	<20131015131259.3051743890ce9b1b9dae9763@linux-foundation.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 13:12:59 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

 
> Also, we're now incurring an atomic op for every "call".  Presumably
> these calls are rare, but not necessarily - one can envisage uses of a
> generic ONCE() which are called at high frequency.  Should we avoid
> that with
> 
> #define ONCE() ({
> 	static int state;
> 	int ret;
> 
> 	if (likely(state))
> 		ret = 0;
> 	else
> 		ret = !xchg(&state, 1);
> 	ret;
> })

I was talking with Boris on IRC about having a shortcut if "state" is
already true. I argued against it, but that was just for the WARN()
operations because I rather add a LOCK xchg, then more branches to hot
paths.

But for a generic ONCE() function, I guess we would want the shortcut
as it may be used by something that gets hit all the time with a normal
kernel.

-- Steve
