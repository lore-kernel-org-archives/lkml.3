Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab3EQIBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:01:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57190 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab3EQIBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:01:09 -0400
Date: Fri, 17 May 2013 10:01:00 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH] blkpm: avoid sleep when holding queue lock
Message-ID: <20130517080100.GT697@kernel.dk>
References: <1368776840-4877-1-git-send-email-aaron.lu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368776840-4877-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 17 2013, Aaron Lu wrote:
> In blk_post_runtime_resume, an autosuspend request will be initiated for
> the device. Since we are holding the queue lock, we can't sleep and thus
> we should use the async version to initiate an autosuspend, i.e.
> pm_request_suspend instead of pm_runtime_suspend, which might sleep.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
> I didn't turn on the lock debugging config options while doing test so
> this issue didn't show up until recently I have all those lock debugging
> options turned on, a warning instantly showed up. While it is correctly
> using pm_request_autosuspend in pre-v7 series, and is brought by me
> mistakenly, sorry for this.
> 
>  block/blk-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 33c33bc..d5745b5 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -3164,7 +3164,7 @@ void blk_post_runtime_resume(struct request_queue *q, int err)
>  		q->rpm_status = RPM_ACTIVE;
>  		__blk_run_queue(q);
>  		pm_runtime_mark_last_busy(q->dev);
> -		pm_runtime_autosuspend(q->dev);
> +		pm_request_autosuspend(q->dev);
>  	} else {
>  		q->rpm_status = RPM_SUSPENDED;
>  	}
> -- 
> 1.8.3.rc2

Thanks applied, obviously right.

-- 
Jens Axboe

