Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbaFYHOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 03:14:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47755 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaFYHO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 03:14:29 -0400
Date: Wed, 25 Jun 2014 09:14:16 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linuxppc-dev@lists.ozlabs.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] sched: Fix compiler warnings
Message-ID: <20140625071416.GM14781@pengutronix.de>
References: <1403658329-13196-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403658329-13196-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 06:05:29PM -0700, Guenter Roeck wrote:
> Commit 143e1e28cb (sched: Rework sched_domain topology definition)
> introduced a number of functions with a return value of 'const int'.
> gcc doesn't know what to do with that and, if the kernel is compiled
> with W=1, complains with the following warnings whenever sched.h
> is included.
> 
> include/linux/sched.h:875:25: warning:
> 	type qualifiers ignored on function return type
> include/linux/sched.h:882:25: warning:
> 	type qualifiers ignored on function return type
> include/linux/sched.h:889:25: warning:
> 	type qualifiers ignored on function return type
> include/linux/sched.h:1002:21: warning:
> 	type qualifiers ignored on function return type
> 
> Commits fb2aa855 (sched, ARM: Create a dedicated scheduler topology table)
> and 607b45e9a (sched, powerpc: Create a dedicated topology table) introduce
> the same warning in the arm and powerpc code.
> 
> Drop 'const' from the function declarations to fix the problem.
> 
> The fix for all three patches has to be applied together to avoid
> compilation failures for the affected architectures.
> 
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> v2: Fix problem in all affected architectures with a single patch
>     to avoid compilation errors.
> 
>  arch/arm/kernel/topology.c | 2 +-
>  arch/powerpc/kernel/smp.c  | 2 +-
>  include/linux/sched.h      | 8 ++++----
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index 9d85318..e35d880 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -275,7 +275,7 @@ void store_cpu_topology(unsigned int cpuid)
>  		cpu_topology[cpuid].socket_id, mpidr);
>  }
>  
> -static inline const int cpu_corepower_flags(void)
> +static inline int cpu_corepower_flags(void)
>  {
>  	return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
>  }
Maybe the author's intention was:

	static inline int cpu_corepower_flags(void) __attribute__((const));

?
This specifies that the function has no side effects and the return value
only depends on the (here non-existing) function arguments.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
