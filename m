Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbaLAMZD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 07:25:03 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:58578 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044AbaLAMZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 07:25:00 -0500
Date: Mon, 1 Dec 2014 13:24:52 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC PATCH 06/30] s390: Introduce cputime64_to_nsecs()
Message-ID: <20141201122452.GE4074@osiris>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
 <1417199040-21044-7-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417199040-21044-7-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120112-0009-0000-0000-000002355DE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 07:23:36PM +0100, Frederic Weisbecker wrote:
> This will be needed for the conversion of kernel stat to nsecs.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/s390/include/asm/cputime.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
> index 820b38a..75ba96f 100644
> --- a/arch/s390/include/asm/cputime.h
> +++ b/arch/s390/include/asm/cputime.h
> @@ -59,6 +59,11 @@ static inline cputime64_t jiffies64_to_cputime64(const u64 jif)
>  	return (__force cputime64_t)(jif * (CPUTIME_PER_SEC / HZ));
>  }
> 
> +static inline u64 cputime64_to_nsecs(cputime64_t cputime)
> +{
> +	return (__force u64)cputime * CPUTIME_PER_USEC * NSEC_PER_USEC;
> +}
> +

This is incorrect. You probably wanted to write something like

	return (__force u64)cputime / CPUTIME_PER_USEC * NSEC_PER_USEC; ?

However we would still lose a lot of precision.
The correct algorithm to convert from cputime to nanoseconds can be found in
tod_to_ns() - see arch/s390/include/asm/timex.h

And if you see that rather complex algorithm, I doubt we want to have the
changes you propose. We need to have that calculation three times for each
irq (user, system and steal time) and would still have worse precision than
we have right now. Not talking about the additional wasted cpu cycles...

But I guess Martin wanted to comment on your patches anyway ;)

