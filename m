Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab3JXMsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:48:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:36152 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3JXMsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:48:06 -0400
Date: Thu, 24 Oct 2013 14:47:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: zhang.yi20@zte.com.cn
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] futex: Remove the owner check when waking task in
 handle_futex_death
In-Reply-To: <OFCEFEC0A7.CD482CBA-ON48257BF2.000535D1-48257BF2.00066AD1@zte.com.cn>
Message-ID: <alpine.DEB.2.02.1310241231350.4983@ionos.tec.linutronix.de>
References: <OFCEFEC0A7.CD482CBA-ON48257BF2.000535D1-48257BF2.00066AD1@zte.com.cn>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1906511654-1382613053=:4983"
Content-ID: <alpine.DEB.2.02.1310241445340.14242@ionos.tec.linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1906511654-1382613053=:4983
Content-Type: TEXT/PLAIN; CHARSET=ISO-2022-JP
Content-ID: <alpine.DEB.2.02.1310241445341.14242@ionos.tec.linutronix.de>

On Thu, 26 Sep 2013, zhang.yi20@zte.com.cn wrote:
> Task processes all its owned robust futex when it is exiting,
> to ensure the futexes can be taken by other tasks.
> 
> Though this can not work good in sometimes.
> Think about this scene：
> 1. A robust mutex is shared for two processes, each process has
>    multi threads to lock the mutex.
> 2. One of the threads locks the mutex, and the others are waiting
>    and sorted in order of priority.
> 3. The process to which the mutex owner thread belongs is dying
>    without unlocking the mutex，and handle_futex_death is invoked
>    to wake the first waiter.
> 4. If the first waiter belongs to the same process，it has no chance
>    to return to the userspace to lock the mutex, and it won't wake
>    the next waiter because it is not the owner of the mutex.
> 5. The rest waiters of the other process may block forever.

Fair enough.
 
> This patch remove the owner check when waking task in handle_futex_death.
> If above occured, The dying task can wake the next waiter by processing its list_op_pending.
> The waked task could return to userspace and try to lock the mutex again.
> 

The owner check needs to stay. The robust list is a user space managed
list on which the kernel operates. We do not trust it at all and we
really want as many sanity checks as possible and definitely not
removing one.

The simplest solution is just to wake all waiters and let them sort it
out. We could do a more complex one by checking whether this is a
group exit and not wake any threads belonging to the same process, but
that's not really worth the trouble.

Thanks,

	tglx
--8323329-1906511654-1382613053=:4983--
