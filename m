Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab3GSUd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 16:33:26 -0400
Received: from relay1.sgi.com ([192.48.179.29]:44547 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3GSUdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 16:33:25 -0400
Date: Fri, 19 Jul 2013 15:33:24 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: Holger Hans Peter Freyther <holger@freyther.de>
Cc: Nathan Zimmer <nzimmer@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: /proc/timer_list and weird behavior with dropbear
Message-ID: <20130719203323.GA129438@asylum.americas.sgi.com>
References: <20130719152800.GA20792@xiaoyu.lan> <51E95F0B.6080703@sgi.com> <20130719170354.GE5902@xiaoyu.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719170354.GE5902@xiaoyu.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 07:03:54PM +0200, Holger Hans Peter Freyther wrote:
> On Fri, Jul 19, 2013 at 10:45:15AM -0500, Nathan Zimmer wrote:
> 
> > I hadn't noticed anything.
> > Let me try your program and see what I may have missed.
> 
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
>  	return timer_list_start(file, offset);
>  }
>  
> -static void timer_list_stop(struct seq_file *seq, void *v)
> +static void timer_list_stop(struct seq_file *file, void *v)
>  {
> +	struct timer_list_iter *iter = file->private;
> +	iter->cpu = cpumask_next(iter->cpu, cpu_online_mask);
>  }
>  
>  static const struct seq_operations timer_list_sops = {


I think this would be an acceptable fix.
It work file locally.  Could you check it out to see if it behaves?

Nate
