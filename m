Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbbA0QQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:16:13 -0500
Received: from smtprelay0164.hostedemail.com ([216.40.44.164]:48428 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755395AbbA0QQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:16:10 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2912:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3873:3874:4605:5007:6119:6261:7514:7875:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12050:12296:12438:12517:12519:12555:12740:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: trade61_35728666d093a
X-Filterd-Recvd-Size: 4021
Date: Tue, 27 Jan 2015 11:16:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Tina Ruchandani <ruchandani.tina@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3] trace: Use 64-bit timekeeping
Message-ID: <20150127111606.195ac188@gandalf.local.home>
In-Reply-To: <20150127155538.GA5132@tinar>
References: <20150127155538.GA5132@tinar>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015 21:25:38 +0530
Tina Ruchandani <ruchandani.tina@gmail.com> wrote:

> The ring_buffer_producer uses 'struct timeval' to measure
> its start and end times. 'struct timeval' on 32-bit systems
> will have its tv_sec value overflow in year 2038 and beyond.
> This patch replaces struct timeval with 'ktime_t' which uses
> 64-bit representation for seconds

Doesn't ktime_t actually use 64-bit representation for nanoseconds?

> 
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>
> ---
> Changes in v3:
> 	- Use a more efficient way to compute condition for exiting
> 	  loop.
> 	- Fix variable naming - all caps is only for macros.
> Changes in v2:
> 	- Use ktime_t instead of timespec64 for efficiency reasons.
> ---
>  kernel/trace/ring_buffer_benchmark.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
> index 3f9e328..0a50abb 100644
> --- a/kernel/trace/ring_buffer_benchmark.c
> +++ b/kernel/trace/ring_buffer_benchmark.c
> @@ -7,7 +7,7 @@
>  #include <linux/completion.h>
>  #include <linux/kthread.h>
>  #include <linux/module.h>
> -#include <linux/time.h>
> +#include <linux/ktime.h>
>  #include <asm/local.h>
>  
>  struct rb_page {
> @@ -212,8 +212,7 @@ static void ring_buffer_consumer(void)
>  
>  static void ring_buffer_producer(void)
>  {
> -	struct timeval start_tv;
> -	struct timeval end_tv;
> +	ktime_t start_time, end_time, timeout;
>  	unsigned long long time;
>  	unsigned long long entries;
>  	unsigned long long overruns;
> @@ -227,7 +226,9 @@ static void ring_buffer_producer(void)
>  	 * make the system stall)
>  	 */
>  	trace_printk("Starting ring buffer hammer\n");
> -	do_gettimeofday(&start_tv);
> +	start_time = ktime_get();
> +	timeout = ktime_add_ns(start_time,
> +			       ((long long) RUN_TIME) * NSEC_PER_SEC);

Instead of the (long long) typecast, could you define RUN_TIME as 10ULL.

Makes the code a bit cleaner, and we can put that on one line.

Rest looks fine.

-- Steve

>  	do {
>  		struct ring_buffer_event *event;
>  		int *entry;
> @@ -244,7 +245,7 @@ static void ring_buffer_producer(void)
>  				ring_buffer_unlock_commit(buffer, event);
>  			}
>  		}
> -		do_gettimeofday(&end_tv);
> +		end_time = ktime_get();
>  
>  		cnt++;
>  		if (consumer && !(cnt % wakeup_interval))
> @@ -264,7 +265,7 @@ static void ring_buffer_producer(void)
>  			cond_resched();
>  #endif
>  
> -	} while (end_tv.tv_sec < (start_tv.tv_sec + RUN_TIME) && !kill_test);
> +	} while (ktime_before(end_time, timeout) && !kill_test);
>  	trace_printk("End ring buffer hammer\n");
>  
>  	if (consumer) {
> @@ -280,9 +281,7 @@ static void ring_buffer_producer(void)
>  		wait_for_completion(&read_done);
>  	}
>  
> -	time = end_tv.tv_sec - start_tv.tv_sec;
> -	time *= USEC_PER_SEC;
> -	time += (long long)((long)end_tv.tv_usec - (long)start_tv.tv_usec);
> +	time = ktime_us_delta(end_time, start_time);
>  
>  	entries = ring_buffer_entries(buffer);
>  	overruns = ring_buffer_overruns(buffer);

