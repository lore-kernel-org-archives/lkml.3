Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaASTC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 14:02:29 -0500
Received: from aurora.thatsmathematics.com ([162.209.10.89]:41149 "EHLO
	aurora.thatsmathematics.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751760AbaASTCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 14:02:24 -0500
Date: Sun, 19 Jan 2014 12:02:22 -0700 (MST)
From: Nate Eldredge <nate@thatsmathematics.com>
X-X-Sender: nate@minerva.lan
To: George Spelvin <linux@horizon.com>
cc: adilger@dilger.ca, jack@suse.cz, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Maarten Baert <maarten-baert@hotmail.com>
Subject: Re: math_state_restore and kernel_fpu_end disable interrupts?
In-Reply-To: <20140119113555.30961.qmail@science.horizon.com>
Message-ID: <alpine.DEB.2.10.1401191150520.2663@minerva.lan>
References: <20140119113555.30961.qmail@science.horizon.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Here's my original message, since George's reply didn't quote or 
reference it: https://lkml.org/lkml/2014/1/18/3.  Summary: 
math_state_restore() always leaves interrupts disabled, and I think this 
is a bug.]

On Sun, 19 Jan 2014, George Spelvin wrote:

> THANK YOU!
>
> I've been having a problem with ext4 metadata checksums, which use SSE
> for large blocks, and traced it to kernel_fpu_end() disabling interrupts,
> but had paused to debug this (I assumed well-tested) piece of kernel
> code before pushing it harder.

Interesting.  I guess it's not surprising this has other effects.

Here's the commit that added the code in question (about 6 years ago): 
https://github.com/torvalds/linux/commit/aa283f49276e7d840a40fb01eee6de97eaa7e012

It's credited to Suresh Siddha, whom I've cc'ed (along with others who 
signed off).  Suresh, if you're still around, could you comment on why 
math_state_restore always leaves interrupts disabled, regardless of their 
state on entry?  Is there a deep reason or is it a bug?

Assuming it's a bug, here's the obvious patch:

--- linux-source-3.11.0/arch/x86/kernel/traps.c	2013-09-02 14:46:10.000000000 -0600
+++ linux-source-3.11.0-nate/arch/x86/kernel/traps.c	2014-01-19 11:25:32.977221476 -0700
@@ -624,6 +624,9 @@
  	struct task_struct *tsk = current;

  	if (!tsk_used_math(tsk)) {
+		unsigned long flags;
+
+		local_save_flags(flags);
  		local_irq_enable();
  		/*
  		 * does a slab alloc which can sleep
@@ -635,7 +638,7 @@
  			do_group_exit(SIGKILL);
  			return;
  		}
-		local_irq_disable();
+		local_irq_restore(flags);
  	}

  	__thread_fpu_begin(tsk);

I tested it briefly: the kernel still boots fine, and it fixes the problem 
I was seeing (BUG() when core dumping on ecryptfs).  George, does it help 
your problem?

Thanks everyone!

> (Search October-December LKML archives for "3.11.4: kernel BUG at
> fs/buffer.c:1268".")

-- 
Nate Eldredge
nate@thatsmathematics.com

