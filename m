Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaHONAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:00:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54432 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaHOM77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 08:59:59 -0400
MIME-Version: 1.0
In-Reply-To: <53ECE998.8070407@kernel.dk>
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
	<53ECE998.8070407@kernel.dk>
Date: Fri, 15 Aug 2014 20:59:56 +0800
Message-ID: <CACVXFVNGaZ0C1cA5fq0UnEBDPPMpBDqF2PxNk4TAOOCGL3jh5g@mail.gmail.com>
Subject: Re: [PATCH v1 0/9] block & aio: kernel aio and loop mq conversion
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>,
        "open list:AIO" <linux-aio@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 12:53 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/14/2014 09:50 AM, Ming Lei wrote:
>> Hi,
>>
>> The 1st two patches introduce kernel AIO support, most of
>> is borrowed from Dave's work last year, and thanks to ITER_BVEC,
>> it is much simper to implement kernel AIO now. AIO model
>> is quite suitable for implementing kernel stuff, and can
>> help improve both throughput and CPU utilization. Lots of
>> kernel components should benefit from it, such as:
>>       - loop driver,
>>       - all kinds of kernel I/O target driver(SCSI, USB storage
>>       or UAS, ...)
>>       - kernel socket users might benefit from it too if socket
>>       AIO is mature
>>
>> The following 6 patches convert current loop driver into blk-mq:
>>       - loop's scalability gets improved much
>>       - loop driver gets quite simplified, and the conversion can
>>       be throught as cleanup too
>>
>> The 9th patch uses kernel AIO with O_DIRECT to improve loop's
>> performance in single job situation, and avoid double cache
>> issue for loop driver too.
>>
>> With the change, loop block's performance can be doubled in my
>> fio test(randread, single job, libaio). If more fio jobs are used,
>> the throughput can be improved much more because of blk-mq.
>>
>> Given loop is used quite widely, especially in VM environment,
>> also the change is quite small, hope it can be merged finally.
>
> Looks pretty damn good to me, even the kernel aio bits are nice and
> simple. Do you have any numbers on loop performance before and after the
> blk-mq conversion? Just curious.

Your concern is right, previous I thought that mq conversion wouldn't improve
throughput, but I did ignore workqueue's concurrency management, it
turns out blk-mq conversion can improvment throughput close to 10 times in
my test(loop over virtio-blk which is backed by one image on SSD).  It is like
POSIX style AIO after mq conversion thanks to workqueue, and I need to
update the performance data in V2.

Actually kernel AIO needn't such high concurrency.

Thanks,
--
Ming Lei
