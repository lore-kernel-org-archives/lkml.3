Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaEAUTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:19:00 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:35293 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751786AbaEAUS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:18:59 -0400
Message-ID: <5362AC24.9050508@hurleysoftware.com>
Date: Thu, 01 May 2014 16:18:44 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rwsem: Comments to explain the meaning of the rwsem's
 count field
References: <1398966637.2970.129.camel@schen9-DESK>
In-Reply-To: <1398966637.2970.129.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 01:50 PM, Tim Chen wrote:
> It takes me a while to understand how rwsem's count field mainifest
> itself in different scenarios.  I'm adding comments to provide a quick
> reference on the the rwsem's count field for each scenario where readers
> and writers are contending/holding the lock.  Hopefully it will be useful
> for future maintenance of the code and for people to get up to speed on
> how the logic in the code works.

Except there are a lot of transition states for the count that look like
stable states for some other condition, and vice versa.

For example, 0xffff000X could be:
1. stable state as described below.
2. 1 or more (but not X) readers active,
    1 writer which failed to acquire and has not yet backed out the adjustment
    0 or more readers which failed to acquire because of the waiting writer
        and have not yet backed out
3. 1 writer active,
    1 or more readers which failed to acquire because of the active writer and
        have not yet backed out
4. maybe more states where a owning writer has just dropped the lock

Because of this, it's hazardous to infer lock state except for the specific
existing tests (eg., the count observed by a failed reader after it has
acquired the wait_lock).

Regards,
Peter Hurley

> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>   kernel/locking/rwsem-xadd.c | 22 ++++++++++++++++++++++
>   1 file changed, 22 insertions(+)
>
> diff --git a/kernel/locking/rwsem-xadd.c b/kernel/locking/rwsem-xadd.c
> index 1d66e08..305c15f 100644
> --- a/kernel/locking/rwsem-xadd.c
> +++ b/kernel/locking/rwsem-xadd.c
> @@ -12,6 +12,28 @@
>   #include <linux/export.h>
>
>   /*
> + * Meaning of the rw_semaphore's count field:
> + * (32 bit case illustrated, similar for 64 bit)
> + *
> + * (listed in decreasing order)
> + * 0x0000000X  X readers active, no writer waiting (X*ACTIVE_BIAS)
> + * 0x00000000  rwsem is unlocked, and no one is waiting for the lock
> + * 0xffff000X  X readers active, writer and/or reader waiting.
> + *	       (X*ACTIVE_BIAS + WAITING_BIAS)
> + * 0xffff0001  (1) one writer active, nobody queued. (ACTIVE_WRITE_BIAS)
> + *	       or
> + *	       (2) one reader active, writer(s) queued.
> + *		   (WAITING_BIAS + ACTIVE_BIAS)
> + * 0xffff0000  There are writers or readers queued but none active
> + *	       (WAITING_BIAS), a writer can try to grab the lock and
> + *	       take itself off wait list if awake.  Writer who has just
> + *	       completed its task seeing this count will try to
> + *	       wake people up from wait list.
> + * 0xfffe0001  Writer active, readers/writer queued
> + *	       (ACTIVE_WRITE_BIAS + WAITING_BIAS)
> + */
> +
> +/*
>    * Initialize an rwsem:
>    */
>   void __init_rwsem(struct rw_semaphore *sem, const char *name,
>

