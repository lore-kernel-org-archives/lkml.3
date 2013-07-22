Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab3GVVci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:32:38 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61478 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab3GVVch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:32:37 -0400
Date: Mon, 22 Jul 2013 17:32:31 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, bhelgaas@google.com
Subject: Re: workqueue, pci: INFO: possible recursive locking detected
Message-ID: <20130722213231.GC16776@mtj.dyndns.org>
References: <51E55B7D.2040209@linux.vnet.ibm.com>
 <51E66CCC.9010600@cn.fujitsu.com>
 <51E84EDC.5090502@linux.vnet.ibm.com>
 <51E89ABB.20808@cn.fujitsu.com>
 <51E8FF76.5030706@linux.vnet.ibm.com>
 <51ED1D02.80205@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ED1D02.80205@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 07:52:34PM +0800, Lai Jiangshan wrote:
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index f02c4a4..b021a45 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4731,6 +4731,7 @@ struct work_for_cpu {
>  	long (*fn)(void *);
>  	void *arg;
>  	long ret;
> +	struct completion done;
>  };
>  
>  static void work_for_cpu_fn(struct work_struct *work)
> @@ -4738,6 +4739,7 @@ static void work_for_cpu_fn(struct work_struct *work)
>  	struct work_for_cpu *wfc = container_of(work, struct work_for_cpu, work);
>  
>  	wfc->ret = wfc->fn(wfc->arg);
> +	complete(&wfc->done);
>  }
>  
>  /**
> @@ -4755,8 +4757,9 @@ long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
>  	struct work_for_cpu wfc = { .fn = fn, .arg = arg };
>  
>  	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
> +	init_completion(&wfc.done);
>  	schedule_work_on(cpu, &wfc.work);
> -	flush_work(&wfc.work);
> +	wait_for_completion(&wfc.done);

Hmmm... it's kinda nasty.  Given how infrequently work_on_cpu() users
nest, I think it'd be cleaner to have work_on_cpu_nested() which takes
@subclass.  It requires extra work on the caller's part but I think
that actually is useful as nested work_on_cpu()s are pretty weird
things.

Thanks.

-- 
tejun
