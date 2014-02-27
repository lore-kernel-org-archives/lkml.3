Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaB0UH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:07:56 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:63331 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaB0UHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:07:52 -0500
Date: Thu, 27 Feb 2014 15:07:48 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] bdi: Avoid oops on device removal
Message-ID: <20140227200748.GA466@htj.dyndns.org>
References: <1393367354-5172-1-git-send-email-jack@suse.cz>
 <1393367354-5172-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393367354-5172-3-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 25, 2014 at 11:29:14PM +0100, Jan Kara wrote:
> +static void bdi_wakeup_thread(struct backing_dev_info *bdi)
> +{
> +	spin_lock_bh(&bdi->wb_lock);
> +	if (test_bit(BDI_registered, &bdi->state))
> +		mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
> +	spin_unlock_bh(&bdi->wb_lock);
> +}

I wonder whether this can be smarter without requiring wb_lock each
timer but this probably is the simplest for -stable backports.

>  static void bdi_queue_work(struct backing_dev_info *bdi,
>  			   struct wb_writeback_work *work)
>  {
>  	trace_writeback_queue(bdi, work);
>  
>  	spin_lock_bh(&bdi->wb_lock);
> +	if (!test_bit(BDI_registered, &bdi->state)) {
> +		if (work->done)
> +			complete(work->done);
> +		goto out_unlock;
> +	}
>  	list_add_tail(&work->list, &bdi->work_list);
> -	spin_unlock_bh(&bdi->wb_lock);
> -
>  	mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
> +out_unlock:
> +	spin_unlock_bh(&bdi->wb_lock);
>  }
>  
> +
> +

Why three blank lines?

Other than that,

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
