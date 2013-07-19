Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761175Ab3GSTFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:05:24 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58802 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753334Ab3GSTFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:05:22 -0400
Message-ID: <51E98DF2.3050608@sgi.com>
Date: Fri, 19 Jul 2013 14:05:22 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Holger Hans Peter Freyther <holger@freyther.de>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: /proc/timer_list and weird behavior with dropbear
References: <20130719152800.GA20792@xiaoyu.lan> <51E95F0B.6080703@sgi.com> <20130719170354.GE5902@xiaoyu.lan>
In-Reply-To: <20130719170354.GE5902@xiaoyu.lan>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.140]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 12:03 PM, Holger Hans Peter Freyther wrote:
> On Fri, Jul 19, 2013 at 10:45:15AM -0500, Nathan Zimmer wrote:
>
>> I hadn't noticed anything.
>> Let me try your program and see what I may have missed.
> Hi,
>
> I neither know the semantics of the timer_list nor how to use
> seq_file correctly. What happens is that timer_list_next will only
> be called once. This means that iter->cpu will never be increased.
>
> This just moves to the next CPU when stop is called (e.g. nothing
> was added once the print_tickdevice was printed). Do you think
> this could be correct?
>
>
>
> diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
> index 3bdf283..8d36a3d 100644
> --- a/kernel/time/timer_list.c
> +++ b/kernel/time/timer_list.c
> @@ -327,8 +327,10 @@ static void *timer_list_next(struct seq_file *file, void *v, loff_t *offset)
>   	return timer_list_start(file, offset);
>   }
>   
> -static void timer_list_stop(struct seq_file *seq, void *v)
> +static void timer_list_stop(struct seq_file *file, void *v)
>   {
> +	struct timer_list_iter *iter = file->private;
> +	iter->cpu = cpumask_next(iter->cpu, cpu_online_mask);
>   }
>   
>   static const struct seq_operations timer_list_sops = {

That certainly does make the issue go away.
I think a better solution would be to have an increment in the 
timer_list_start.

