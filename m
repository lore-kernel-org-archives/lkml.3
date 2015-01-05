Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbbAETBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:01:01 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53316 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbbAETA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:00:59 -0500
Message-ID: <54AADF6A.6090100@kernel.dk>
Date: Mon, 05 Jan 2015 12:00:58 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, Sasha Levin <sasha.levin@oracle.com>
CC: bvanassche@acm.org, hare@suse.de, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: scsi: non atomic allocation in mempool_alloc in atomic context
References: <54A43CFB.2080705@oracle.com> <20150105091516.GA22226@lst.de>
In-Reply-To: <20150105091516.GA22226@lst.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 02:15 AM, Christoph Hellwig wrote:
> On Wed, Dec 31, 2014 at 01:14:19PM -0500, Sasha Levin wrote:
>> Hi Christoph,
>>
>> I'm seeing an issue which was bisected down to 3c356bde1 ("scsi: stop passing
>> a gfp_mask argument down the command setup path"):
> 
> ->queue_rq in blk-mq context is designed to be able to sleep and be called
> from process context without any spinlocks held or irqs disabled, so we
> really should fix the
> caller instead.

That's not quite true, the only guarantee is that it WILL execute on the
CPU (or CPUs) that are set in the mask. So unless it ends up offloading
the run to a specific workqueue, we'll disable preempt in the current
path before ->queue_rq() is called.

-- 
Jens Axboe

