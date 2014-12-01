Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbaLAOOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:14:12 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:49908 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbaLAOOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:14:09 -0500
Date: Mon, 1 Dec 2014 15:14:02 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 07/30] cputime: Convert kcpustat to nsecs
Message-ID: <20141201151402.31a6cc9a@mschwide>
In-Reply-To: <1417199040-21044-8-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
	<1417199040-21044-8-git-send-email-fweisbec@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120114-0021-0000-0000-000001F9B057
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2014 19:23:37 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Kernel cpu stats are stored in cputime_t which is an architecture
> defined type, and hence a bit opaque and requiring accessors and mutators
> for any operation.
> 
> Converting them to nsecs simplifies the code a little bit.

Quite honestly I do not see much of an improvement here, on set of
functions (cputime_to_xxx) gets replaced by another (nsecs_to_xxx).

On the contrary for s390 I see a degradation, consider a hunk like
this:

> @@ -128,9 +128,9 @@ static inline u64 get_cpu_idle_time_jiffy(unsigned int cpu, u64 *wall)
> 
>  	idle_time = cur_wall_time - busy_time;
>  	if (wall)
> -		*wall = cputime_to_usecs(cur_wall_time);
> +		*wall = div_u64(cur_wall_time, NSEC_PER_USEC);
> 
> -	return cputime_to_usecs(idle_time);
> +	return div_u64(idle_time, NSEC_PER_USEC);
>  }
> 
>  u64 get_cpu_idle_time(unsigned int cpu, u64 *wall, int io_busy)

For s390 cputime_to_usecs is a shift, with the new code we now have a division.
Fortunately this is in a piece of code that s390 does not use..

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

