Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965124AbaH1CKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:10:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaH1CKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:10:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140827175605.GE12827@lenny.home.zabbo.net>
References: <53EE3966.60609@kernel.dk>
	<CACVXFVO+3SHy0=zESJqG3ZB68AZaeK5_QK2CVmZWzZ7oBWDGwg@mail.gmail.com>
	<53F0EAEC.9040505@kernel.dk>
	<CACVXFVO3CrD2CoHiBOZ8GNMXrT2pJ=t2BzmAHksqRTmgrpsaaQ@mail.gmail.com>
	<CACVXFVN6W-AAQ6g4LXHOyvMzU+EAmj_YYBEuYRnoSB+VqCJg8A@mail.gmail.com>
	<53F3B89D.6070703@kernel.dk>
	<CACVXFVOR0mzMWo+iPtU8jUvYgH+non=hQ0XaP0Z1Fu0qiSbJNA@mail.gmail.com>
	<53FE029B.1030200@parallels.com>
	<20140827162955.GF4827@kvack.org>
	<53FE1328.2040607@parallels.com>
	<20140827175605.GE12827@lenny.home.zabbo.net>
Date: Thu, 28 Aug 2014 10:10:02 +0800
Message-ID: <CACVXFVNTcpjai=2UGTfY6LF1n2AOARX2orMmzKxQrunf-F8fxA@mail.gmail.com>
Subject: Re: [PATCH v1 5/9] block: loop: convert to blk-mq
From: Ming Lei <ming.lei@canonical.com>
To: Zach Brown <zab@zabbo.net>
Cc: Maxim Patlasov <mpatlasov@parallels.com>,
        Benjamin LaHaise <bcrl@kvack.org>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Kent Overstreet <kmo@daterainc.com>, AIO <linux-aio@kvack.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/14, Zach Brown <zab@zabbo.net> wrote:
> On Wed, Aug 27, 2014 at 09:19:36PM +0400, Maxim Patlasov wrote:
>> On 08/27/2014 08:29 PM, Benjamin LaHaise wrote:
>> >On Wed, Aug 27, 2014 at 08:08:59PM +0400, Maxim Patlasov wrote:
>> >...
>> >>1) /dev/loop0 of 3.17.0-rc1 with Ming's patches applied -- 11K iops
>> >>2) the same as above, but call loop_queue_work() directly from
>> >>loop_queue_rq() -- 270K iops
>> >>3) /dev/nullb0 of 3.17.0-rc1 -- 380K iops
>> >>
>> >>Taking into account so big difference (11K vs. 270K), would it be
>> >> worthy
>> >>to implement pure non-blocking version of aio_kernel_submit() returning
>> >>error if blocking needed? Then loop driver (or any other in-kernel
>> >> user)
>> >>might firstly try that non-blocking submit as fast-path, and, only if
>> >>it's failed, fall back to queueing.
>> >What filesystem is the backing file for loop0 on?  O_DIRECT access as
>> >Ming's patches use should be non-blocking, and if not, that's something
>> >to fix.
>>
>> I used loop0 directly on top of null_blk driver (because my goal was to
>> measure the overhead of processing requests in a separate thread).
>
> The relative overhead while doing nothing else.  While zooming way down
> in to micro benchmarks is fun and all, testing on an fs on brd might be
> more representitive and so more compelling.
>
> (And you might start to stumble into the terrifying territory of
> stacking fs write paths under fs write paths.. turn on lockdep! :))
>
>> In case of real-life filesystems, e.g. ext4, aio_kernel_submit() may
>> easily
>> block on something like bh_submit_read(), when fs reads file metadata to
>> calculate the offset on block device by position in the file.
>
> Yeah, there are a lot of rare potential blocking points throughout the
> fs aio submission paths.   In practice (aio+dio+block fs), I think
> submission tends to block waiting for congested block queues most often.

In case of null_blk, it shouldn't have blocked here since the defaul tag size
is enough for the single job test if Maxim didn't change the default parameter
of null_blk.


Thanks,
-- 
Ming Lei
