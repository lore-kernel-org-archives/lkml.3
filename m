Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaBYWni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:43:38 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:57817 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaBYWne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:43:34 -0500
Date: Tue, 25 Feb 2014 17:43:30 -0500
From: Tejun Heo <tj@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Derek Basehore <dbasehore@chromium.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] bdi: Fix hung task on sync
Message-ID: <20140225224330.GB8568@mtj.dyndns.org>
References: <1393367354-5172-1-git-send-email-jack@suse.cz>
 <1393367354-5172-2-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393367354-5172-2-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 11:29:13PM +0100, Jan Kara wrote:
> From: Derek Basehore <dbasehore@chromium.org>
> 
> bdi_wakeup_thread_delayed() used the mod_delayed_work() function to
> schedule work to writeback dirty inodes. The problem with this is that
> it can delay work that is scheduled for immediate execution, such as the
> work from sync_inodes_sb().  This can happen since mod_delayed_work()
> can now steal work from a work_queue.  This fixes the problem by using
> queue_delayed_work() instead. This is a regression caused by
> 839a8e8660b6 "writeback: replace custom worker pool implementation with
> unbound workqueue".
> 
> The reason that this causes a problem is that laptop-mode will change
> the delay, dirty_writeback_centisecs, to 60000 (10 minutes) by default.
> In the case that bdi_wakeup_thread_delayed() races with
> sync_inodes_sb(), sync will be stopped for 10 minutes and trigger a hung
> task. Even if dirty_writeback_centisecs is not long enough to cause a
> hung task, we still don't want to delay sync for that long.
> 
> We fix the problem by using queue_delayed_work() when we want to
> schedule writeback sometime in future. This function doesn't change the
> timer if it is already armed.
> 
> For the same reason, we also change bdi_writeback_workfn() to
> immediately queue the work again in the case that the work_list is not
> empty. The same problem can happen if the sync work is run on the rescue
> worker.
> 
> Fixes: 839a8e8660b6777e7fe4e80af1a048aebe2b5977
> CC: stable@vger.kernel.org
> Signed-off-by: Derek Basehore <dbasehore@chromium.org>
> Signed-off-by: Jan Kara <jack@suse.cz>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
