Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3LPPz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:55:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649Ab3LPPz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:55:26 -0500
Date: Mon, 16 Dec 2013 10:55:22 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ben Zhang <benzh@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] watchdog: touch_nmi_watchdog should only touch local cpu
 not every one
Message-ID: <20131216155522.GO35219@redhat.com>
References: <20131205031218.GO35219@redhat.com>
 <1386276144-9241-1-git-send-email-benzh@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386276144-9241-1-git-send-email-benzh@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 12:42:24PM -0800, Ben Zhang wrote:
> I ran into a scenario where while one cpu was stuck and should have panic'd
> because of the NMI watchdog, it didn't.  The reason was another cpu was spewing
> stack dumps on to the console.  Upon investigation, I noticed that when writing
> to the console and also when dumping the stack, the watchdog is touched.
> 
> This causes all the cpus to reset their NMI watchdog flags and the 'stuck' cpu
> just spins forever.
> 
> This change causes the semantics of touch_nmi_watchdog to be changed slightly.
> Previously, I accidentally changed the semantics and we noticed there was a
> codepath in which touch_nmi_watchdog could be touched from a preemtible area.
> That caused a BUG() to happen when CONFIG_DEBUG_PREEMPT was enabled.  I believe
> it was the acpi code.
> 
> My attempt here re-introduces the change to have the touch_nmi_watchdog() code
> only touch the local cpu instead of all of the cpus.  But instead of using
> __get_cpu_var(), I use the __raw_get_cpu_var() version.
> 
> This avoids the preemption problem.  However my reasoning wasn't because I was
> trying to be lazy.  Instead I rationalized it as, well if preemption is enabled
> then interrupts should be enabled to and the NMI watchdog will have no reason
> to trigger.  So it won't matter if the wrong cpu is touched because the percpu
> interrupt counters the NMI watchdog uses should still be incrementing.

Hi Andrew,

I'm ok with this patch, though it does alter the behaviour of how
touch_nmi_watchdog works.  For the most part I don't think most callers
need to touch all of the watchdogs (on each cpu).  Perhaps a corner case
will pop up (the scheduler?? to mimic touch_all_softlockup_watchdogs() ).

But this does address an issue where if a system is locked up and one cpu
is spewing out useful debug messages (or error messages), the hard lockup
will fail to go off.  We have seen this on RHEL also.

I wouldn't mind see this get soaked in linux-next if possible.  And see
what falls out.

Cheers,
Don

> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> Signed-off-by: Ben Zhang <benzh@chromium.org>
> ---
>  kernel/watchdog.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 4431610..613f611 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -158,14 +158,14 @@ void touch_all_softlockup_watchdogs(void)
>  #ifdef CONFIG_HARDLOCKUP_DETECTOR
>  void touch_nmi_watchdog(void)
>  {
> -	if (watchdog_user_enabled) {
> -		unsigned cpu;
> -
> -		for_each_present_cpu(cpu) {
> -			if (per_cpu(watchdog_nmi_touch, cpu) != true)
> -				per_cpu(watchdog_nmi_touch, cpu) = true;
> -		}
> -	}
> +	/*
> +	 * Using __raw here because some code paths have
> +	 * preemption enabled.  If preemption is enabled
> +	 * then interrupts should be enabled too, in which
> +	 * case we shouldn't have to worry about the watchdog
> +	 * going off.
> +	 */
> +	__raw_get_cpu_var(watchdog_nmi_touch) = true;
>  	touch_softlockup_watchdog();
>  }
>  EXPORT_SYMBOL(touch_nmi_watchdog);
> -- 
> 1.8.5.1
> 
