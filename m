Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbaELU6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:58:05 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64529 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402AbaELU6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:58:03 -0400
Date: Mon, 12 May 2014 16:57:57 -0400
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, fweisbec@gmail.com,
        hch@infradead.org, mgorman@suse.de, riel@redhat.com, bp@suse.de,
        rostedt@goodmis.org, mgalbraith@suse.de, ego@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] CPU hotplug, stop-machine: Plug race-window that
 leads to "IPI-to-offline-CPU"
Message-ID: <20140512205757.GA18959@mtj.dyndns.org>
References: <20140511203617.17152.21133.stgit@srivatsabhat.in.ibm.com>
 <20140511203657.17152.79234.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140511203657.17152.79234.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 12, 2014 at 02:07:04AM +0530, Srivatsa S. Bhat wrote:
> @@ -189,10 +191,27 @@ static int multi_cpu_stop(void *data)
>  	do {
>  		/* Chill out and ensure we re-read multi_stop_state. */
>  		cpu_relax();
> +
> +		/*
> +		 * In the case of CPU offline, we don't want the other CPUs to
> +		 * send IPIs to the active_cpu (the one going offline) after it
> +		 * has disabled interrupts in the _DISABLE_IRQ state (because,
> +		 * then it will notice the IPIs only after it goes offline). So
> +		 * we split this state into _INACTIVE and _ACTIVE, and thereby
> +		 * ensure that the active_cpu disables interrupts only after
> +		 * the other CPUs do the same thing.
> +		 */

It probably would be clearer to first describe what's going on and
then provide rationale for that.  IOW, state that inactive cpus
disable irqs first and then explain why that's done.  The above
paragraph looks somewhat out of place as is.

> +
>  		if (msdata->state != curstate) {
>  			curstate = msdata->state;
>  			switch (curstate) {
> -			case MULTI_STOP_DISABLE_IRQ:
> +			case MULTI_STOP_DISABLE_IRQ_INACTIVE:
> +				if (is_active)
> +					break;
> +
> +				/* Else, fall-through */
> +
> +			case MULTI_STOP_DISABLE_IRQ_ACTIVE:

Wouldn't it be cleaner to do the following?

	case MULTI_STOP_DISABLE_IRQ_INACTIVE:
		if (!is_active) {
			disable;
		}
		break;
	case MULTI_STOP_DISABLE_IRQ_ACTIVE:
		if (is_active) {
			disable;
		}
		break;

The duplicated amount is trivial and what's going on would be far
clearer.

Thanks.

-- 
tejun
