Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaHRJFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:05:35 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:50193 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbaHRJFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:05:34 -0400
Date: Mon, 18 Aug 2014 11:05:29 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: akpm@linux-foundation.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Ulrich Obergfell <uobergfe@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 3/5] watchdog: fix print-once on enable
Message-ID: <20140818090529.GB25495@gmail.com>
References: <1407768567-171794-1-git-send-email-dzickus@redhat.com>
 <1407768567-171794-4-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407768567-171794-4-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> From: Ulrich Obergfell <uobergfe@redhat.com>
> 
> This patch avoids printing the message 'enabled on all CPUs, ...'
> multiple times. For example, the issue can occur in the following
> scenario:
> 
> 1) watchdog_nmi_enable() fails to enable PMU counters and sets
>    cpu0_err.
> 
> 2) 'echo [0|1] > /proc/sys/kernel/nmi_watchdog' is executed to
>    disable and re-enable the watchdog mechanism 'on the fly'.
> 
> 3) If watchdog_nmi_enable() succeeds to enable PMU counters, each
>    CPU will print the message because step1 left behind a non-zero
>    cpu0_err.
> 
>    if (!IS_ERR(event)) {
>        if (cpu == 0 || cpu0_err)
>        pr_info("enabled on all CPUs, ...")
> 
> The patch avoids this by clearing cpu0_err in watchdog_nmi_disable().
> 
> Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  kernel/watchdog.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 6d0a891..0838685 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -522,6 +522,9 @@ static void watchdog_nmi_disable(unsigned int cpu)
>  		/* should be in cleanup, but blocks oprofile */
>  		perf_event_release_kernel(event);
>  	}
> +	if (cpu == 0)
> +		/* watchdog_nmi_enable() expects this to be zero initially. */
> +		cpu0_err = 0;

Looks good except a small detail: two-line blocks need curly 
braces too, even if it's just a single C statement. I've fixed 
this up in the commit.

thanks,

	Ingo

