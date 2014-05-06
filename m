Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaEFUk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:40:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40607 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442AbaEFUkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:40:55 -0400
Date: Tue, 6 May 2014 13:40:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, fweisbec@gmail.com, hch@infradead.org,
        mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        oleg@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] CPU hotplug, stop-machine: Plug race-window that
 leads to "IPI-to-offline-CPU"
Message-Id: <20140506134054.8cd531296c8aa5d9c3eff958@linux-foundation.org>
In-Reply-To: <20140506180258.14375.20181.stgit@srivatsabhat.in.ibm.com>
References: <20140506180213.14375.5904.stgit@srivatsabhat.in.ibm.com>
	<20140506180258.14375.20181.stgit@srivatsabhat.in.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2014 23:33:03 +0530 "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:

> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -165,12 +165,21 @@ static void ack_state(struct multi_stop_data *msdata)
>  		set_state(msdata, msdata->state + 1);
>  }
>  
> +/* Holding area for active CPUs, to let all the non-active CPUs go first */
> +static void hold_active_cpus(struct multi_stop_data *msdata,
> +			     int num_active_cpus)
> +{
> +	/* Wait until all the non-active threads ack the state */
> +	while (atomic_read(&msdata->thread_ack) > num_active_cpus)
> +		cpu_relax();
> +}

The code comments are a bit lame.  Can we do a better job of explaining
the overall dynamic behaviour?  Help readers to understand the problem
which hold_active_cpus() is solving and how it solves it?


