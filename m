Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3H1Gmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:42:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:39870 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab3H1Gmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:42:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,974,1367996400"; 
   d="scan'208";a="352616042"
Date: Wed, 28 Aug 2013 11:27:38 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dan Williams <djbw@fb.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] dma: pl330: Fix handling of TERMINATE_ALL while
 processing completed descriptors
Message-ID: <20130828055738.GB11414@intel.com>
References: <1377628445-16231-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377628445-16231-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 08:34:05PM +0200, Lars-Peter Clausen wrote:
> The pl330 DMA driver is broken in regard to handling a terminate all request
> while it is processing the list of completed descriptors. This is most visible
> when calling dmaengine_terminate_all() from within the descriptors callback for
> cyclic transfers. In this case the TERMINATE_ALL transfer will clear the
> work_list and stop the transfer. But after all callbacks for all completed
> descriptors have been handled the descriptors will be re-enqueued into the (now
> empty) work_list. So the next time dma_async_issue_pending() is called for the
> channel these descriptors will be transferred again which will cause data
> corruption. Similar issues can occur if dmaengine_terminate_all() is not called
> from within the descriptor callback but runs on a different CPU at the same time
> as the completed descriptor list is processed.
> 
> This patch introduces a new per channel list which will hold the completed
> descriptors. While processing the list the channel's lock will be held to avoid
> racing against dmaengine_terminate_all(). The lock will be released when calling
> the descriptors callback though. Since the list of completed descriptors might
> be modified (e.g. by calling dmaengine_terminate_all() from the callback) we can
> not use the normal list iterator macros. Instead we'll need to check for each
> loop iteration again if there are still items in the list. The drivers
> TERMINATE_ALL implementation is updated to move descriptors from both the
> work_list as well the new completed_list back to the descriptor pool. This makes
> sure that none of the descripts finds its way back into the work list and also
> that we do not call any futher complete callbacks after
> dmaengine_terminate_all() has been called.

Applied, thanks

~Vinod
