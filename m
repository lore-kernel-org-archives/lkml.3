Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3ANDC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 22:02:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:54440 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab3ANDCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 22:02:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,465,1355126400"; 
   d="scan'208";a="190749951"
Date: Mon, 14 Jan 2013 11:03:02 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>,
        Shane Huang <shane.huang@amd.com>
Subject: Re: [PATCH v6 3/4] block: implement runtime pm strategy
Message-ID: <20130114030302.GA15280@aaronlu.sh.intel.com>
References: <50EBCC93.5000203@intel.com>
 <Pine.LNX.4.44L0.1301081016310.1535-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301081016310.1535-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 10:22:45AM -0500, Alan Stern wrote:
> Just as importantly, all of the public routines added in patch 2/4 to
> blk-core.c should have kerneldoc explaining how and where to use them.  
> In particular, the kerneldoc for blk_pm_runtime_init() has to mention
> that the block runtime PM implementation works only for drivers that
> use request structures for their I/O; it doesn't work for drivers that
> use bio's directly.

How about the following description for them?

/**
 * blk_pm_runtime_init - Block layer runtime PM initialization routine
 * @q: the queue of the device
 * @dev: the device the queue belongs to
 *
 * Description:
 *    Initialize runtime PM related fields for @q and start auto suspend
 *    for @dev. Drivers that want to take advantage of request based runtime
 *    PM should call this function after @dev has been initialized, and its
 *    request queue @q has been allocated, and runtime PM for it is not
 *    ready yet(either disabled/forbidden or its usage count >= 0).
 *
 *    The block layer runtime PM is request based, so only works for drivers
 *    that use request as their IO unit instead of those directly use bio's.
 */

/**
 * blk_pre_runtime_suspend - Pre runtime suspend check
 * @q: the queue of the device
 *
 * Description:
 *    This function will check if runtime suspend is allowed for the device
 *    by examining if there are any requests pending in the queue. If there
 *    are requests pending, the device can not be runtime suspended; otherwise,
 *    the queue's status will be updated to SUSPENDING and the driver can
 *    proceed to suspend the device.
 *
 *    For the not allowed case, we mark last busy for the device so that
 *    runtime PM core will try to autosuspend it some time later.
 *
 *    This function should be called in the device's runtime suspend callback,
 *    before its runtime suspend function is called.
 *
 * Return:
 *    0		- OK to runtime suspend the device
 *    -EBUSY	- Device should not be runtime suspended
 */

/**
 * blk_post_runtime_suspend - Post runtime suspend processing
 * @q: the queue of the device
 * @err: return value of the device's runtime suspend function
 *
 * Description:
 *    Update the queue's runtime status according to the return value of the
 *    device's runtime suspend function.
 *
 *    This function should be called in the device's runtime suspend callback,
 *    after its runtime suspend function is called.
 */

/**
 * blk_pre_runtime_resume - Pre runtime resume processing
 * @q: the queue of the device
 *
 * Description:
 *    Update the queue's runtime status to RESUMING in preparation for the
 *    runtime resume of the device.
 *
 *    This function should be called in the device's runtime resume callback,
 *    before its runtime resume function is called.
 */

/**
 * blk_post_runtime_resume - Post runtime resume processing
 * @q: the queue of the device
 * @err: return value of the device's runtime resume function
 *
 * Description:
 *    Update the queue's runtime status according to the return value of the
 *    device's runtime resume function. If it is successfully resumed, process
 *    the requests that are queued into the device's queue when it is resuming
 *    and then mark last busy and initiate autosuspend for it.
 *
 *    This function should be called in the device's runtime resume callback,
 *    after its runtime resume function is called.
 */

Please feel free to suggest, thanks.

-Aaron

