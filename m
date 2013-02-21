Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3BUSSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:18:14 -0500
Received: from relay1.sgi.com ([192.48.179.29]:55511 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab3BUSSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:18:12 -0500
Date: Thu, 21 Feb 2013 12:18:11 -0600
From: Nathan Zimmer <nzimmer@sgi.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Nathan Zimmer <nzimmer@sgi.com>
Subject: Re: mmotm 2013-02-19-17-20 uploaded
Message-ID: <20130221181811.GA27097@gulag1.americas.sgi.com>
References: <20130220012122.870BB31C11E@corp2gmr1-1.hot.corp.google.com> <5125E809.4060407@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5125E809.4060407@codeaurora.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 01:25:29AM -0800, Stephen Boyd wrote:
> On 2/19/2013 5:21 PM, akpm@linux-foundation.org wrote:
> > * timer_list-split-timer_list_show_tickdevices.patch
> > * timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
> > * timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
> > * timer_list-convert-timer-list-to-be-a-proper-seq_file-v2.patch
> > * timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
> > * timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
> 
> These commits seem to break the timer list on devices with maxcpus !=
> nr_cpu_ids, which is possible if you specify maxcpus on the kernel
> command line. I no longer see the percpu devices that I normally have
> after the broadcast device.
Interesting.
However I can't seem to boot at the moment with maxcpus set to less then the actual
number of cpus so I am not having much luck investigating right now. 

> 
> I also notice what looks like an extra newline inserted in the output
> between the percpu devices and the broadcast device, which may not be
> intentional. There are also some more spelling mistakes in the comments.
> Can we fold in this fix on top of the others (hopefully not white-space
> damaged)?
> 
The extra newline was not intentional.

> diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
> index 9904e48..e3cb935 100644
> --- a/kernel/time/timer_list.c
> +++ b/kernel/time/timer_list.c
> @@ -244,7 +244,6 @@ static void timer_list_show_tickdevices_header(struct seq_file *m)
>  #endif
>  	SEQ_printf(m, "\n");
>  #endif
> -	SEQ_printf(m, "\n");
>  }
>  #endif
>  
> @@ -275,7 +274,7 @@ static int timer_list_show(struct seq_file *m, void *v)
>  }
>  
>  /*
> - * This itererator really needs some explnation since it is offset and has
> + * This iterator really needs some explanation since it is offset and has
>   * two passes, one of which is controlled by a config option.
>   * In a hotplugged system some cpus, including cpu 0, may be missing so we have
>   * to use cpumask_* to iterate over the cpus.
> @@ -283,7 +282,7 @@ static int timer_list_show(struct seq_file *m, void *v)
>   * It returns 1 for the header position.
>   * For cpu 0 it returns 2 and the final possible cpu would be nr_cpu_ids + 1.
>   * On the second pass:
> - * It returnes nr_cpu_ids + 1 for the second header position.
> + * It returns nr_cpu_ids + 1 for the second header position.
>   * For cpu 0 it returns nr_cpu_ids + 2
>   * The final possible cpu would be nr_cpu_ids + nr_cpu_ids + 2.
>   */
> @@ -300,8 +299,12 @@ static void *timer_list_start(struct seq_file *file, loff_t *offset)
>  			n = cpumask_next(n - 1, cpu_online_mask);
>  		else
>  			n = cpumask_first(cpu_online_mask);
> -		*offset = n + 1;
> -		return (void *)(unsigned long)(n + 2);
> +		if (n < nr_cpu_ids) {
> +			*offset = n + 1;
> +			return (void *)(unsigned long)(n + 2);
> +		} else {
> +			*offset = n = nr_cpu_ids + 1;
> +		}
>  	}
>  
>  #ifdef CONFIG_GENERIC_CLOCKEVENTS
> @@ -314,8 +317,10 @@ static void *timer_list_start(struct seq_file *file, loff_t *offset)
>  			n = cpumask_next(n - 1, cpu_online_mask);
>  		else
>  			n = cpumask_first(cpu_online_mask);
> -		*offset = n + 2 + nr_cpu_ids;
> -		return (void *)(unsigned long)(n + 3 + nr_cpu_ids);
> +		if (n < nr_cpu_ids) {
> +			*offset = n + 2 + nr_cpu_ids;
> +			return (void *)(unsigned long)(n + 3 + nr_cpu_ids);
> +		}
>  	}
>  #endif
>  
> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 
