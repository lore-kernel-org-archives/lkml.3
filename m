Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbaFWTXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 15:23:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215AbaFWTXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 15:23:42 -0400
Message-ID: <53A87E74.5090702@redhat.com>
Date: Mon, 23 Jun 2014 15:22:28 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] sched: Fast idling of CPU when system is partially
 loaded
References: <1403551009.2970.613.camel@schen9-DESK>
In-Reply-To: <1403551009.2970.613.camel@schen9-DESK>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/23/2014 03:16 PM, Tim Chen wrote:
> Thanks to the review from Jason, Andi and Peter. I've updated the
> code as Peter suggested with simplified logic.
> 
> When a system is lightly loaded (i.e. no more than 1 job per cpu), 
> attempt to pull job to a cpu before putting it to idle is
> unnecessary and can be skipped.  This patch adds an indicator so
> the scheduler can know when there's no more than 1 active job is on
> any CPU in the system to skip needless job pulls.
> 
> On a 4 socket machine with a request/response kind of workload
> from clients, we saw about 0.13 msec delay when we go through a
> full load balance to try pull job from all the other cpus.  While
> 0.1 msec was spent on processing the request and generating a
> response, the 0.13 msec load balance overhead was actually more
> than the actual work being done. This overhead can be skipped much
> of the time for lightly loaded systems.
> 
> With this patch, we tested with a netperf request/response workload
> that has the server busy with half the cpus in a 4 socket system.
> We found the patch eliminated 75% of the load balance attempts
> before idling a cpu.
> 
> The overhead of setting/clearing the indicator is low as we already
> gather the necessary info while we call add_nr_running and
> update_sd_lb_stats. We switch to full load balance load immediately
> if any cpu got more than one job on its run queue in
> add_nr_running.  We'll clear the indicator to avoid load balance
> when we detect no cpu's have more than one job when we scan the
> work queues in update_sg_lb_stats.  We are aggressive in turning on
> the load balance and opportunistic in skipping the load balance.
> 
> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com> Acked-by:
> Jason Low <jason.low2@hp.com>

Acked-by: Rik van Riel <riel@redhat.com>


- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTqH50AAoJEM553pKExN6DYj4H/17YlyWg0QDoNrkNbhEi8SfD
I0BsklbbDIpcq9hKpwiJOCiQNeVLjMwhTniKOOXj1LgbtSsHYz7Scac/vt9sJRsy
PLJKoQt43lSv7Ff3mJFbUZG5u2RWoLs8TLuSFhPd39J8XupJX9jVe3GejBsp8lN4
Mpmo2DD6FvjvF2mpIP+CpEDFQZNeEZBb9UMvAJCjAU4JwdodwFkLRgxTWyOUSFpS
eOhDj99nRgyCz0LwLaVD2mfi29B/C5giIk70G+1II9BjTDGlFJC9X5FairZ3bM+K
6//BDq1baNnVu7pKKtQe8bLhNFQ1z1WNtgDr8L9c6dw9rLI+5AGjZb+KK5mMnG8=
=goKD
-----END PGP SIGNATURE-----
