Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581Ab3DDOP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:15:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:35214 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761471Ab3DDOPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:15:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,409,1363158000"; 
   d="scan'208";a="280777009"
Message-ID: <515D8B47.7060504@intel.com>
Date: Thu, 04 Apr 2013 22:16:39 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] blk: start bypass mode in blk_unregister_queue
References: <1364308501-1640-1-git-send-email-aaron.lu@intel.com> <515D87AA.4050604@intel.com> <20130404140327.GC9425@htj.dyndns.org>
In-Reply-To: <20130404140327.GC9425@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 10:03 PM, Tejun Heo wrote:
> On Thu, Apr 04, 2013 at 10:01:14PM +0800, Aaron Lu wrote:
>> In blk_register_queue, we will end bypass mode for the queue; but in
>> blk_unregister_queue, we didn't start bypass mode for it. This would
>> cause the WARN_ON_ONCE(q->bypass_depth < 0) to trigger if the queue gets
>> registered, unregistered and then again registered, e.g. unload scsi
>> cdrom module driver sr_mod and then reload it will trigger such a
>> warning.
>>
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> 
> Is this something which actually happens?  Why would an unregistered
> queue registered again?  Do we even support that?

It probably wouldn't happen for normal user, only for some SCSI driver
developers like me, e.g. the sr_mod will normally load during boot, and
when I made some changes to the code, I'll unload the driver and reload
it. This is found when I was developing ZPODD code and I just found some
time to see what happened.

The queue for the scsi device will always be there, the queue(and the
device) will not go away on driver unregistration. So it will be left in
normal mode, and on next blk_register_queue call, the warning will show
up.

> 
> Starting a bypass mode can be very expensive and some drivers create
> and destroy a lot of queues during probing.  We don't want a call to
> blk_queue_bypass_start() on every queue creation / destruction cycle.

By expensive, do you mean the drain of the queue? Since the queue is to
be unregistered, I suppose the queue has to be drained somewhere?

Thanks,
Aaron

