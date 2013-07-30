Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab3G3MxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:53:13 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64819 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3G3MxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:53:10 -0400
Date: Tue, 30 Jul 2013 08:53:06 -0400
From: Tejun Heo <tj@kernel.org>
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
        djbw@fb.com
Subject: Re: [patch 1/3] raid5: offload stripe handle to workqueue
Message-ID: <20130730125306.GC2599@htj.dyndns.org>
References: <20130730055207.698660010@kernel.org>
 <20130730055257.527231772@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730055257.527231772@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 30, 2013 at 01:52:08PM +0800, shli@kernel.org wrote:
> +static void raid5_wakeup_stripe_thread(struct stripe_head *sh)
> +{
> +	struct r5conf *conf = sh->raid_conf;
> +	struct r5worker_group *group;
> +	int i;
> +
> +	if (conf->worker_cnt_per_group == 0) {
> +		md_wakeup_thread(conf->mddev->thread);
> +		return;
> +	}
> +
> +	group = conf->worker_groups + cpu_to_group(sh->cpu);
> +
> +	for (i = 0; i < conf->worker_cnt_per_group; i++)
> +		queue_work_on(sh->cpu, raid5_wq, &group->workers[i].work);
> +}

Another general suggestion.  Using workqueue mechanism simply as
thread dispatching mechanism like above and then buliding your own
work dispatching code on top is usually a poor form.  It usually is
much better to assign a single unit of work to a single work item as
it allows things like per work unit flushing and much easier
implementation of freezing.  It's possible that you have some
overriding constraints here but if so it'd be nice if you can explain
it.

Thanks.

-- 
tejun
