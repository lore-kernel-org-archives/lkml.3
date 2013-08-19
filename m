Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab3HSXCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:02:45 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:64882 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab3HSXCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:02:44 -0400
Date: Mon, 19 Aug 2013 19:02:40 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Wu <lekensteyn@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] writeback: fix NULL dereference when device is gone
Message-ID: <20130819230240.GA6869@mtj.dyndns.org>
References: <Pine.LNX.4.44L0.1308172104070.7744-100000@netrider.rowland.org>
 <5177367.3UXkd1Z6lS@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5177367.3UXkd1Z6lS@al>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 12:45:53AM +0200, Peter Wu wrote:
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 68851ff..6e38a8b 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1007,7 +1007,8 @@ void bdi_writeback_workfn(struct work_struct *work)
>  	struct backing_dev_info *bdi = wb->bdi;
>  	long pages_written;
>  
> -	set_worker_desc("flush-%s", dev_name(bdi->dev));
> +	if (bdi->dev)
> +		set_worker_desc("flush-%s", dev_name(bdi->dev));

Hmmm... bdi->dev is cleared after bdi_wb_shutdown() so the work item
should no longer be running.  It seems like something is queueing the
work item after shutdown and the proper fix would be finding out which
and fixing it.  Can you please verify whether adding
WARN_ON(!bdi->dev) in bdi_wakeup_thread_delayed() trigger anything?

Thanks.

-- 
tejun
