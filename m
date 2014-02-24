Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaBXRlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:41:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45275 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaBXRlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:41:03 -0500
Date: Mon, 24 Feb 2014 18:40:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140224174051.GE9987@twins.programming.kicks-ass.net>
References: <e0bf16ca-011f-400d-b938-94e4de2fb1a6@email.android.com>
 <alpine.DEB.2.10.1402230859560.18653@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402232151280.19337@vincent-weaver-1.um.maine.edu>
 <530AD71E.50800@zytor.com>
 <alpine.DEB.2.10.1402241030500.19768@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>
 <18f0cea3-7e3b-4477-b433-0269f3de976b@email.android.com>
 <alpine.DEB.2.10.1402241204070.20170@vincent-weaver-1.um.maine.edu>
 <20140224172536.GD9987@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402241230440.20170@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 12:32:39PM -0500, Vince Weaver wrote:
> I do note that 
> 	perf_callchain_user();
> 
> Does
> 	fp = (void __user *)regs->bp;
> 	
> 	...
> 
> 	bytes = copy_from_user_nmi(&frame, fp, sizeof(frame));
> 
> 
> And in my particular executable RBP has nothing to do with a frame 
> pointer, but is instead being used as a general purpose register.
> 
> Am I missing something here?  Though in that case I'm not sure why this 
> wouldn't be easier to trigger.

Ah, in case the frame doesn't actually exist we would expect to fault
and get the fixup treatment, returning a short copy (the return value
being bytes _NOT_ copied).

When that happens;

  if (bytes != 0)
  	break;

At which point we'll terminate the stack frame iteration.

This is where we rely on being able to take a fault from NMI context,
the fault iret will re-enable NMIs, necessitating all the magic Steve
did.
