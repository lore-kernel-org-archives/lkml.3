Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964870AbaH0RTr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:19:47 -0400
Received: from relay.parallels.com ([195.214.232.42]:52826 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964849AbaH0RTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:19:45 -0400
Message-ID: <53FE1328.2040607@parallels.com>
Date: Wed, 27 Aug 2014 21:19:36 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@kernel.dk>,
        "Christoph Hellwig" <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        "Kent Overstreet" <kmo@daterainc.com>,
        open list:
	AIO <linux-aio@kvack.org>,
        "Linux FS Devel" <linux-fsdevel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>, ;
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	;
			^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH v1 5/9] block: loop: convert to blk-mq
References: <20140815163111.GA16652@infradead.org> <53EE370D.1060106@kernel.dk> <53EE3966.60609@kernel.dk> <CACVXFVO+3SHy0=zESJqG3ZB68AZaeK5_QK2CVmZWzZ7oBWDGwg@mail.gmail.com> <53F0EAEC.9040505@kernel.dk> <CACVXFVO3CrD2CoHiBOZ8GNMXrT2pJ=t2BzmAHksqRTmgrpsaaQ@mail.gmail.com> <CACVXFVN6W-AAQ6g4LXHOyvMzU+EAmj_YYBEuYRnoSB+VqCJg8A@mail.gmail.com> <53F3B89D.6070703@kernel.dk> <CACVXFVOR0mzMWo+iPtU8jUvYgH+non=hQ0XaP0Z1Fu0qiSbJNA@mail.gmail.com> <53FE029B.1030200@parallels.com> <20140827162955.GF4827@kvack.org>
In-Reply-To: <20140827162955.GF4827@kvack.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.200]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2014 08:29 PM, Benjamin LaHaise wrote:
> On Wed, Aug 27, 2014 at 08:08:59PM +0400, Maxim Patlasov wrote:
> ...
>> 1) /dev/loop0 of 3.17.0-rc1 with Ming's patches applied -- 11K iops
>> 2) the same as above, but call loop_queue_work() directly from
>> loop_queue_rq() -- 270K iops
>> 3) /dev/nullb0 of 3.17.0-rc1 -- 380K iops
>>
>> Taking into account so big difference (11K vs. 270K), would it be worthy
>> to implement pure non-blocking version of aio_kernel_submit() returning
>> error if blocking needed? Then loop driver (or any other in-kernel user)
>> might firstly try that non-blocking submit as fast-path, and, only if
>> it's failed, fall back to queueing.
> What filesystem is the backing file for loop0 on?  O_DIRECT access as
> Ming's patches use should be non-blocking, and if not, that's something
> to fix.

I used loop0 directly on top of null_blk driver (because my goal was to 
measure the overhead of processing requests in a separate thread).

In case of real-life filesystems, e.g. ext4, aio_kernel_submit() may 
easily block on something like bh_submit_read(), when fs reads file 
metadata to calculate the offset on block device by position in the file.

Thanks,
Maxim
