Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbbAETiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:38:06 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:64490 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbbAETiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:38:04 -0500
Message-ID: <54AAE81C.2080402@kernel.dk>
Date: Mon, 05 Jan 2015 12:38:04 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Sasha Levin <sasha.levin@oracle.com>, bvanassche@acm.org, hare@suse.de,
        JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: scsi: non atomic allocation in mempool_alloc in atomic context
References: <54A43CFB.2080705@oracle.com> <20150105091516.GA22226@lst.de> <54AADF6A.6090100@kernel.dk> <20150105193213.GA31955@lst.de>
In-Reply-To: <20150105193213.GA31955@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 12:32 PM, Christoph Hellwig wrote:
> On Mon, Jan 05, 2015 at 12:00:58PM -0700, Jens Axboe wrote:
>> That's not quite true, the only guarantee is that it WILL execute on the
>> CPU (or CPUs) that are set in the mask. So unless it ends up offloading
>> the run to a specific workqueue, we'll disable preempt in the current
>> path before ->queue_rq() is called.
> 
> Oops.  Indeed, with those recent changes ->queue_rq can't safely block
> for memory allocatios anymore.
> 
> The patch below should fix it:
> 
> ---
> From: Christoph Hellwig <hch@lst.de>
> Subject: scsi: ->queue_rq can't sleep
> 
> Since Linux 3.19 blk-mq may disable preemption before calling into
> ->queue_rq, so we can't actually sleep anymore.

That was true in earlier kernels as well, going back a few versions at
least, preempt was disabled on calling __blk_mq_run_hw_queue(). Just
checked, and 3.16 and later have that as the behaviour. The only change
in 3.19 some shuffling around to avoid double preempt_disable in some
cases, it's now using get_cpu() and friends.

So we probably want do mark that as stable so we reach back to when
scsi-mq was added, unless the originally referenced patch getting rid of
the gfp_t mask didn't have the issue.


-- 
Jens Axboe

