Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3LSRHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:07:49 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:44937 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab3LSRHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:07:46 -0500
Date: Thu, 19 Dec 2013 18:07:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Len Brown <lenb@kernel.org>,
        x86@kernel.org, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86 idle: repair large-server 50-watt idle-power
 regression
Message-ID: <20131219170741.GB30382@gmail.com>
References: <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com>
 <20131219122257.GC11279@gmail.com>
 <52B316FF.50906@zytor.com>
 <20131219160210.GA28426@gmail.com>
 <52B31B21.6010901@zytor.com>
 <20131219162136.GM16438@laptop.programming.kicks-ass.net>
 <52B323BE.7090108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52B323BE.7090108@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 12/19/2013 08:21 AM, Peter Zijlstra wrote:
> > 
> > What's that mb for?
> > 
> 
> It already exists in mwait_idle_with_hints(); I just moved it into 
> this common function.  It is a bit odd, I have to admit; it seems 
> like it should be *before* the monitor (and possibly we should have 
> one after the CLFLUSH as well?)

Yes, I think we need a barrier before the CLFLUSH, because according 
to my reading of the Intel documentation CLFLUSH has no implicit 
ordering so it might get reordered with the store to ->flags in 
current_set_polling_and_test(), which might result in spurious wakeup 
problems again.

(And CLFLUSH is a store in a sense, so special in that the regular 
ordering for stores does not apply.)

Likewise, having a barrier before the MONITOR looks sensible as well. 
Having it _after_ monitor looks weird and is probably wrong. [It might 
have been the effects of someone seeing the spurious wakeup problems 
with realizing the true source, or so.]

Thanks,

	Ingo
